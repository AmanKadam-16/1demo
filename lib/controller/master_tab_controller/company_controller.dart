// company_controller.dart

import 'package:get/get.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLogin.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLoginInfoDetails.dart';
import 'package:time_attendance/General/MTAResult.dart';
import 'package:time_attendance/model/Masters/branch.dart';
import 'package:time_attendance/model/Masters/branchDetails.dart';
import 'package:time_attendance/model/master_tab_model/company_model.dart';
import 'package:time_attendance/widgets/mtaToast.dart';
import 'package:time_attendance/model/TALogin/session_manager.dart'
    if (dart.library.html) 'package:time_attendance/model/TALogin/session_manager_web.dart'
    if (dart.library.io) 'package:time_attendance/model/TALogin/session_manager_mobile.dart';

class BranchController extends GetxController {
  final isLoading = false.obs;
  final branches = <BranchModel>[].obs;
  final filteredBranches = <BranchModel>[].obs;
  final searchQuery = ''.obs;
  final sortColumn = Rx<String?>(null);
  final isSortAscending = true.obs;

  AuthLogin? _authLogin;

  @override
  void onInit() {
    super.onInit();
    initializeAuthBranch();
  }

  Future<void> initializeAuthBranch() async {
    try {
      MTAResult objResult = MTAResult();
      final userInfo = await PlatformSessionManager.getUserInfo();
      if (userInfo != null) {
        String companyCode = userInfo['CompanyCode'];
        String loginID = userInfo['LoginID'];
        String password = userInfo['Password'];
        _authLogin = await AuthLoginDetails()
            .LoginInformationForFirstLogin(companyCode, loginID, password);
        fetchBranches();
      }
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    }
  }

  Future<void> fetchBranches() async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }

      isLoading.value = true;

      MTAResult result = MTAResult();
      List<Branch> apiBranches =
          await BranchDetails().GetAllBranches(_authLogin!, result);

      branches.value = apiBranches
          .map((b) => BranchModel(
                branchId: b.BranchID,
                branchName: b.BranchName,
                address: b.Address,
                contact: b.ContactNo,
                website: b.Website,
                masterBranchId: b.MastBranchID,
                masterBranch: b.MastBranchName,
              ))
          .toList();

      updateSearchQuery(searchQuery.value);
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveBranch(BranchModel branch) async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }

      isLoading.value = true;
      MTAResult result = MTAResult();

      Branch apiBranch = Branch()
        ..BranchID = branch.branchId ?? ''
        ..BranchName = branch.branchName ?? ''
        ..Address = branch.address ?? ''
        ..ContactNo = branch.contact ?? ''
        ..Website = branch.website ?? ''
        ..MastBranchID = branch.masterBranchId ?? ''
        ..MastBranchName = branch.masterBranch ?? '';

      bool success;
      if (branch.branchId == null || branch.branchId!.isEmpty) {
        success = await BranchDetails().Save(_authLogin!, apiBranch, result);
      } else {
        success = await BranchDetails().Update(_authLogin!, apiBranch, result);
      }

      if (success) {
        MTAToast().ShowToast(result.ResultMessage);
        await fetchBranches();
      } else {
        MTAToast().ShowToast(result.ResultMessage);
        throw Exception(result.ErrorMessage);
      }
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> deleteBranch(String branchId) async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }

      isLoading.value = true;
      MTAResult result = MTAResult();

      bool success =
          await BranchDetails().Delete(_authLogin!, branchId, result);

      if (success) {
        MTAToast().ShowToast(result.ResultMessage);
        await fetchBranches();
      } else {
        MTAToast().ShowToast(result.ResultMessage);
        throw Exception(result.ErrorMessage);
      }
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredBranches.assignAll(branches);
    } else {
      filteredBranches.assignAll(
        branches.where((branch) =>
            (branch.branchName?.toLowerCase().contains(query.toLowerCase()) ??
                false) ||
            (branch.address?.toLowerCase().contains(query.toLowerCase()) ??
                false) ||
            (branch.contact?.toLowerCase().contains(query.toLowerCase()) ??
                false) ||
            (branch.website?.toLowerCase().contains(query.toLowerCase()) ??
                false) ||
            (branch.masterBranch?.toLowerCase().contains(query.toLowerCase()) ??
                false)),
      );
    }
  }

  void sortBranches(String columnName, bool? ascending) {
    if (ascending != null) {
      isSortAscending.value = ascending;
    } else if (sortColumn.value == columnName) {
      isSortAscending.value = !isSortAscending.value;
    } else {
      isSortAscending.value = true;
    }

    sortColumn.value = columnName;

    filteredBranches.sort((a, b) {
      int comparison;
      switch (columnName) {
        case 'Branch Name':
          comparison = (a.branchName ?? '').compareTo(b.branchName ?? '');
          break;
        case 'Address':
          comparison = (a.address ?? '').compareTo(b.address ?? '');
          break;
        case 'Contact':
          comparison = (a.contact ?? '').compareTo(b.contact ?? '');
          break;
        case 'Website':
          comparison = (a.website ?? '').compareTo(b.website ?? '');
          break;
        case 'Master Branch':
          comparison = (a.masterBranch ?? '').compareTo(b.masterBranch ?? '');
          break;
        default:
          comparison = 0;
      }
      return isSortAscending.value ? comparison : -comparison;
    });
  }
}

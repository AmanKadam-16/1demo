// designation_controller.dart
import 'package:get/get.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLogin.dart';
import 'package:time_attendance/Data/LoginInformation/AuthLoginInfoDetails.dart';
import 'package:time_attendance/General/MTAResult.dart';
import 'package:time_attendance/model/Masters/designation.dart';
import 'package:time_attendance/model/Masters/designationDetails.dart';
import 'package:time_attendance/model/master_tab_model/designation_model.dart';
import 'package:time_attendance/widgets/mtaToast.dart';
import 'package:time_attendance/model/TALogin/session_manager.dart'
    if (dart.library.html) 'package:time_attendance/model/TALogin/session_manager_web.dart'
    if (dart.library.io) 'package:time_attendance/model/TALogin/session_manager_mobile.dart';

class DesignationController extends GetxController {
  // Lists for designations
  final designations = <DesignationModel>[].obs;
  final filteredDesignations = <DesignationModel>[].obs;
  final searchQuery = ''.obs;
  final isLoading = false.obs;
  
  // Sorting variables
  final sortColumn = RxString('DesignationName');
  final isSortAscending = RxBool(true);

  // Authentication instance
  AuthLogin? _authLogin;

  @override
  void onInit() {
    super.onInit();
    initializeAuthDesignation();
  }
    Future<void> initializeAuthDesignation() async {
      try {
        MTAResult objResult = MTAResult();
        final userInfo = await PlatformSessionManager.getUserInfo();
        if (userInfo != null) {
          String companyCode = userInfo['CompanyCode'];
          String loginID = userInfo['LoginID'];
          String password = userInfo['Password'];
          _authLogin = await AuthLoginDetails().LoginInformationForFirstLogin(companyCode, loginID, password);
          fetchDesignations();
        }
      } catch (e) {
        MTAToast().ShowToast(e.toString());
      }
    }

  Future<void> fetchDesignations() async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }
      
      isLoading.value = true;
      
      MTAResult result = MTAResult();
      print('_authLogin: $_authLogin');
      List<Designation> apiDesignations = await DesignationDetails().GetAllDesignationes(
        _authLogin!,
        result
      );
      
      // Convert API designations to our model
      designations.value = apiDesignations.map((d) => DesignationModel(
        designationId: d.DesignationID,
        designationName: d.DesignationName,
        masterDesignationId: d.MasterDesignationID,
        masterDesignationName: d.MasterDesignationName,
        isDataRetrieved: d.IsDataRetrieved,
      )).toList();
      // Initialize filtered list
      updateSearchQuery('');
      
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> saveDesignation(DesignationModel designation) async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }

      MTAResult result = MTAResult();
      Designation apiDesignation = Designation()
        ..DesignationName = designation.designationName
        ..MasterDesignationID = designation.masterDesignationId;
      
      bool success;
      if (designation.designationId.isEmpty) {
        // Add new designation
        success = await DesignationDetails().Save(_authLogin!, apiDesignation, result);
      } else {
        // Update existing designation
        apiDesignation.DesignationID = designation.designationId;
        success = await DesignationDetails().Update(_authLogin!, apiDesignation, result);
      }

      if (success) {
       MTAToast().ShowToast(result.ResultMessage);
        await fetchDesignations(); // Refresh the list
      } else if (!result.IsResultPass) {
        MTAToast().ShowToast(result.ResultMessage);
        throw Exception(result.ErrorMessage);
      }
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    }
  }

  Future<void> deleteDesignation(String designationId) async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }
      
      MTAResult result = MTAResult();
      bool success = await DesignationDetails().Delete(_authLogin!, designationId, result);
      
      if (success) {
           MTAToast().ShowToast(result.ResultMessage);
        await fetchDesignations(); // Refresh the list
      } else if (!result.IsResultPass) {
        MTAToast().ShowToast(result.ResultMessage);
        throw Exception(result.ErrorMessage);
      }
    } catch (e) {
      print(e.toString());
    }
  }

  // Gets a designation by ID
  Future<DesignationModel?> getDesignationById(String id) async {
    try {
      if (_authLogin == null) {
        throw Exception('Authentication not initialized');
      }

      MTAResult result = MTAResult();
      Designation designation = await DesignationDetails().GetDesignationByDesignationID(
        _authLogin!,
        id,
        result
      );

      if (designation.IsDataRetrieved) {
        return DesignationModel(
          designationId: designation.DesignationID,
          designationName: designation.DesignationName,
          masterDesignationId: designation.MasterDesignationID,
          masterDesignationName: designation.MasterDesignationName,
          isDataRetrieved: designation.IsDataRetrieved,
        );
      }
    } catch (e) {
      MTAToast().ShowToast(e.toString());
    }
    return null;
  }

  void updateSearchQuery(String query) {
    searchQuery.value = query;
    if (query.isEmpty) {
      filteredDesignations.assignAll(designations);
    } else {
      filteredDesignations.assignAll(
        designations.where((d) => 
          d.designationName.toLowerCase().contains(query.toLowerCase()) ||
          d.masterDesignationName.toLowerCase().contains(query.toLowerCase())
        )
      );
    }
  }

  void sortDesignations(String columnName, bool? ascending) {
    // If ascending is provided, use it; otherwise toggle current value
    if (ascending != null) {
      isSortAscending.value = ascending;
    } else if (sortColumn.value == columnName) {
      isSortAscending.value = !isSortAscending.value;
    } else {
      isSortAscending.value = true;
    }
    
    sortColumn.value = columnName;

    filteredDesignations.sort((a, b) {
      int comparison;
      switch (columnName) {
        case 'Designation':
          comparison = a.designationName.compareTo(b.designationName);
          break;
        case 'Master Designation':
          comparison = a.masterDesignationName.compareTo(b.masterDesignationName);
          break;
        default:
          comparison = 0;
      }
      return isSortAscending.value ? comparison : -comparison;
    });
  }
}
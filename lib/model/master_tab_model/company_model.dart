// company_model.dart

class BranchModel {
  String? branchId;
  String? branchName;
  String? address;
  String? contact;
  String? website;
  String? masterBranchId;
  String? masterBranch;

  BranchModel({
    this.branchId = '', 
    this.branchName ='', 
    this.address = '', 
    this.contact = '', 
    this.website = '', 
    this.masterBranchId = '',
    this.masterBranch ='',
  });

  BranchModel copyWith({
    String? branchId,
    String? branchName,
    String? address,
    String? contact,
    String? website,
    String? masterBranchId,
    String? masterBranch,
  }) {
    return BranchModel(
      branchId: branchId ?? this.branchId,
      branchName: branchName ?? this.branchName,
      address: address ?? this.address,
      contact: contact ?? this.contact,
      website: website ?? this.website,
      masterBranchId: masterBranchId ?? this.masterBranchId,
      masterBranch: masterBranch ?? this.masterBranch,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'branchId': branchId,
      'branchName': branchName,
      'address': address,
      'contact': contact,
      'website': website,
      'masterBranchId': masterBranchId,
      'masterBranch': masterBranch,
    };
  }

  factory BranchModel.fromJson(Map<String, dynamic> json) {
    return BranchModel(
      branchId: json['branchId'],
      branchName: json['branchName'],
      address: json['address'],
      contact: json['contact'],
      website: json['website'],
      masterBranchId: json['masterBranchId'],
      masterBranch: json['masterBranch'],
    );
  }
}
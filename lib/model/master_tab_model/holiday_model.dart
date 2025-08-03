class HolidayModel {
  String? _holidayID;
  String? _holidayName;
  String? _holidayDate;
  String? _holidayYear;
  List<ListOfCompany>? _listOfCompany;

  HolidayModel(
      {String? holidayID,
      String? holidayName,
      String? holidayDate,
      String? holidayYear,
      List<ListOfCompany>? listOfCompany}) {
    if (holidayID != null) {
      this._holidayID = holidayID;
    }
    if (holidayName != null) {
      this._holidayName = holidayName;
    }
    if (holidayDate != null) {
      this._holidayDate = holidayDate;
    }
    if (holidayYear != null) {
      this._holidayYear = holidayYear;
    }
    if (listOfCompany != null) {
      this._listOfCompany = listOfCompany;
    }
  }

  String? get holidayID => _holidayID;
  set holidayID(String? holidayID) => _holidayID = holidayID;
  String? get holidayName => _holidayName;
  set holidayName(String? holidayName) => _holidayName = holidayName;
  String? get holidayDate => _holidayDate;
  set holidayDate(String? holidayDate) => _holidayDate = holidayDate;
  String? get holidayYear => _holidayYear;
  set holidayYear(String? holidayYear) => _holidayYear = holidayYear;
  List<ListOfCompany>? get listOfCompany => _listOfCompany;
  set listOfCompany(List<ListOfCompany>? listOfCompany) =>
      _listOfCompany = listOfCompany;

  HolidayModel.fromJson(Map<String, dynamic> json) {
    _holidayID = json['HolidayID'];
    _holidayName = json['HolidayName'];
    _holidayDate = json['HolidayDate'];
    _holidayYear = json['HolidayYear'];
    if (json['ListOfCompany'] != null) {
      _listOfCompany = <ListOfCompany>[];
      json['ListOfCompany'].forEach((v) {
        _listOfCompany!.add(new ListOfCompany.fromJson(v));
      });
    }
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['HolidayID'] = this._holidayID;
    data['HolidayName'] = this._holidayName;
    data['HolidayDate'] = this._holidayDate;
    data['HolidayYear'] = this._holidayYear;
    if (this._listOfCompany != null) {
      data['ListOfCompany'] =
          this._listOfCompany!.map((v) => v.toJson()).toList();
    }
    return data;
  }
}

class ListOfCompany {
  String? _companyID;
  String? _companyName;
  String? _address;
  String? _contactNo;
  String? _faxNo;
  String? _emailID;
  String? _website;
  String? _mastCompanyID;
  String? _mastCompanyName;

  ListOfCompany(
      {String? companyID,
      String? companyName,
      String? address,
      String? contactNo,
      String? faxNo,
      String? emailID,
      String? website,
      String? mastCompanyID,
      String? mastCompanyName}) {
    if (companyID != null) {
      this._companyID = companyID;
    }
    if (companyName != null) {
      this._companyName = companyName;
    }
    if (address != null) {
      this._address = address;
    }
    if (contactNo != null) {
      this._contactNo = contactNo;
    }
    if (faxNo != null) {
      this._faxNo = faxNo;
    }
    if (emailID != null) {
      this._emailID = emailID;
    }
    if (website != null) {
      this._website = website;
    }
    if (mastCompanyID != null) {
      this._mastCompanyID = mastCompanyID;
    }
    if (mastCompanyName != null) {
      this._mastCompanyName = mastCompanyName;
    }
  }

  String? get companyID => _companyID;
  set companyID(String? companyID) => _companyID = companyID;
  String? get companyName => _companyName;
  set companyName(String? companyName) => _companyName = companyName;
  String? get address => _address;
  set address(String? address) => _address = address;
  String? get contactNo => _contactNo;
  set contactNo(String? contactNo) => _contactNo = contactNo;
  String? get faxNo => _faxNo;
  set faxNo(String? faxNo) => _faxNo = faxNo;
  String? get emailID => _emailID;
  set emailID(String? emailID) => _emailID = emailID;
  String? get website => _website;
  set website(String? website) => _website = website;
  String? get mastCompanyID => _mastCompanyID;
  set mastCompanyID(String? mastCompanyID) => _mastCompanyID = mastCompanyID;
  String? get mastCompanyName => _mastCompanyName;
  set mastCompanyName(String? mastCompanyName) =>
      _mastCompanyName = mastCompanyName;

  ListOfCompany.fromJson(Map<String, dynamic> json) {
    _companyID = json['CompanyID'];
    _companyName = json['CompanyName'];
    _address = json['Address'];
    _contactNo = json['ContactNo'];
    _faxNo = json['FaxNo'];
    _emailID = json['EmailID'];
    _website = json['Website'];
    _mastCompanyID = json['MastCompanyID'];
    _mastCompanyName = json['MastCompanyName'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['CompanyID'] = this._companyID;
    data['CompanyName'] = this._companyName;
    data['Address'] = this._address;
    data['ContactNo'] = this._contactNo;
    data['FaxNo'] = this._faxNo;
    data['EmailID'] = this._emailID;
    data['Website'] = this._website;
    data['MastCompanyID'] = this._mastCompanyID;
    data['MastCompanyName'] = this._mastCompanyName;
    return data;
  }
}



class TALocation
{

  String _LocationID='';
  String _LocationName='';
  String _LocationCode='';
  String _Address="";
  String _City="";
  String _State="";
  String _Country="";
  String _PostalCode="";
  bool _bIsUseForGeoFencing=false;
  double _Latitude=0;
  double _Longitude=0;
  double _Distance=10;
  String _ErrorMessage='';//only for bulk upload from CSV
  bool _bIsErrorFound=false;//only for bulk upload from CSV

  TALocation()
  {
     _LocationID='';
     _LocationName='';
     _LocationCode='';
     _Address="";
     _City="";
     _State="";
     _Country="";
     _PostalCode="";
     _bIsUseForGeoFencing=false;
     _Latitude=0;
     _Longitude=0;
     _Distance=10;
     _ErrorMessage='';//only for bulk upload from CSV
     _bIsErrorFound=false;//only for bulk upload from CSV
     _IsDataRetrieved=false;
  }


  String get LocationID => _LocationID;
  set LocationID(strLocationID)
  {
    _LocationID=strLocationID; // Location ID for Get, Update and Delete only
  }
  String get LocationName => _LocationName;
  set LocationName(strLocationName)
  {
    _LocationName=strLocationName; // Location Name
  }
  String get LocationCode => _LocationCode;
  set LocationCode(strLocationCode)
  {
    _LocationCode=strLocationCode; // Location Code
  }

  String get Address => _Address;
  set Address(strAddress)
  {
    _Address=strAddress; // Location Address
  }
  String get City => _City;
  set City(strCity)
  {
    _City=strCity; // ss
  }
  String get State => _State;
  set State(strState)
  {
    _State=strState; //state
  }
  String get Country => _Country;
  set Country(strCountry)
  {
    _Country=strCountry; //
  }
  String get PostalCode => _PostalCode;
  set PostalCode(strPostalCode)
  {
    _PostalCode=strPostalCode; //
  }
  bool get IsUseForGeoFencing => _bIsUseForGeoFencing;
  set IsUseForGeoFencing(bIsUseForGeoFencing)
  {
    _bIsUseForGeoFencing=bIsUseForGeoFencing; // Is this location used for geo fencing
  }
  double get Longitude => _Longitude;
  set Longitude(strLongitude)
  {
    _Longitude=strLongitude; // Location Longitude
  }
  double get Latitude => _Latitude;
  set Latitude(strLatitude)
  {
    _Latitude=strLatitude; // Location Latitude
  }

  double get Distance => _Distance;
  set Distance(dDistance)
  {
    _Distance=dDistance; // Location Distance radius from geo co-ordinated
  }
  bool get IsErrorFound => _bIsErrorFound;
  set IsErrorFound(bIsErrorFound)
  {
    _bIsErrorFound=bIsErrorFound; // for bulk update using csv
  }
  String get ErrorMessage => _ErrorMessage;
  set ErrorMessage(bErrorMessage)
  {
    _ErrorMessage=bErrorMessage; // for bulk update using csv
  }
  bool _IsDataRetrieved=false;
  bool get IsDataRetrieved => _IsDataRetrieved;
  set  IsDataRetrieved(bool bIsDataRetrieved )
  {
    _IsDataRetrieved = _IsDataRetrieved;
  }


  TALocation.fromJson(dynamic json) {
    _LocationID=json['LocationID']  ;
    _LocationName=json['LocationName'];
    _LocationCode=json['LocationCode'];
    _Address=json['LocationAddress'];
    _City=json['LocationCity'];
    _State=json['LocationState'];
    _Country=json['LocationCountry'];
    _PostalCode=json['PostalCode'];
    _bIsUseForGeoFencing=json['IsUseForGeoFencing'];
    _Latitude= json['Latitude'];
    _Longitude=json['Longitude'];
    _Distance=json['Distance'];
    _ErrorMessage=json['ErrorMessage'];//only for bulk upload from CSV
    _bIsErrorFound=json['IsErrorFound'];//only for bulk upload from CSV
    _IsDataRetrieved=true;

  }
  Map<String, dynamic> toJson()
  {
    final map = <String, dynamic>{};

    map['LocationID'] =_LocationID ;
    map['LocationName']=_LocationName;
    map['LocationCode']=_LocationCode;
    map['LocationAddress']=_Address;
    map['LocationCity']=_City;
    map['LocationState']=_State;
    map['LocationCountry']=_Country;
    map['PostalCode']=_PostalCode;
    map['IsUseForGeoFencing']=_bIsUseForGeoFencing;
    map['Latitude']=_Latitude;
    map['Longitude']=_Longitude;
    map['Distance']=_Distance;
    map['ErrorMessage']=_ErrorMessage;//only for bulk upload from CSV
    map['IsErrorFound']=_bIsErrorFound;//only for bulk upload from CSV
    return map;
  }




}
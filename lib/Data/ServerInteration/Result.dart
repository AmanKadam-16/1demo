import '../../model/TALogin/login.dart';
class Result
{
   bool _IsResultPass = false;
   String _ResultMessage = "";
   bool _IsMultipleRecordsInJson = false;
   LoginMode _LoginMode = LoginMode.Unknown;
   String _ResultRecordJson = "";
   int _RecordCount = 0;
   int _TotalRecordCount = 0;

   bool get IsResultPass => _IsResultPass;
   set IsResultPass(bIsResultPass)
   {
      _IsResultPass=bIsResultPass; // Passed or fail
   }
   bool get IsMultipleRecordsInJson => _IsMultipleRecordsInJson;
   set IsMultipleRecordsInJson(bIsMultipleRecordsInJson)
   {
      _IsMultipleRecordsInJson=bIsMultipleRecordsInJson; // Is Json Contains multiple Records
   }

   String get ResultMessage => _ResultMessage;
   set ResultMessage(strResultMessage)
   {
      _ResultMessage=strResultMessage; // message
   }
   String get ResultRecordJson => _ResultRecordJson;
   set ResultRecordJson(strResultRecordJson)
   {
      _ResultRecordJson=strResultRecordJson; // message
   }

   LoginMode get Mode => _LoginMode;
   set Mode(eLoginMode)
   {
      _LoginMode=eLoginMode; // Login Mode: User or Employee
   }

   int get RecordCount => _RecordCount;
   set RecordCount(iRecordCount)
   {
      _RecordCount=iRecordCount; // Total number of records
   }
   int get TotalRecordCount => _TotalRecordCount;
   set TotalRecordCount(iTotalRecordCount)
   {
      _TotalRecordCount = iTotalRecordCount; // Total number of records across all pages
   }

   Result({   bool IsResultPass=false, bool IsMultipleRecordsInJson=false, String ResultMessage="",
      LoginMode  LoginMode=LoginMode.Unknown, String ResultRecordJson='', int RecordCount=0, int TotalRecordCount=0})
   {
      _IsResultPass = IsResultPass;
      _IsMultipleRecordsInJson = IsMultipleRecordsInJson;
      _ResultMessage = ResultMessage;
      _LoginMode = LoginMode;
      _ResultRecordJson = ResultRecordJson;
      _RecordCount = RecordCount;
      _TotalRecordCount = TotalRecordCount;
   }

   Result.fromJson(dynamic json) {
      _IsResultPass = json['IsResultPass'];
      _IsMultipleRecordsInJson = json['IsMultipleRecordsInJson'];
      _ResultMessage = json['ResultMessage'] ?? '';
      if(json['LoginMode'] == "UserForAPI" || json['LoginMode'] == 5) _LoginMode = LoginMode.UserForAPI;
      if(json['LoginMode'] == "Employee" || json['LoginMode'] == 1) _LoginMode = LoginMode.Employee;
      if(json['LoginMode'] == "Unknown" || json['LoginMode'] == 4) _LoginMode = LoginMode.Unknown;
      _ResultRecordJson = json['ResultRecordJson'] ?? '';
      _RecordCount = json['ResultRecordCount'] ?? 0; // Updated to match API field name
      _TotalRecordCount = json['TotalRecordCount'] ?? 0;
   }

   Map<String, dynamic> toJson()
   {
      final map = <String, dynamic>{};
      map['IsResultPass'] = _IsResultPass;
      map['IsMultipleRecordsInJson'] = _IsMultipleRecordsInJson;
      map['ResultMessage'] = _ResultMessage;
      map['LoginMode'] = _LoginMode.name;
      map['ResultRecordJson'] = _ResultRecordJson;
      map['ResultRecordCount'] = _RecordCount; // Updated to match API field name
      map['TotalRecordCount'] = _TotalRecordCount;
      return map;
   }
}
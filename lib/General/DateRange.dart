

class DateRange {

String _FromDate='';
String _ToDate='';

String? get FromDate => _FromDate;
set FromDate(dFromDate)
{
  _FromDate=dFromDate;
}

String? get ToDate => _ToDate;

set ToDate(dToDate)
{
  _ToDate=dToDate;
}
DateRange({ String FromDate='',String ToDate=''})
{
  _FromDate=FromDate  ;
  _ToDate=ToDate;
}

DateRange.fromJson(dynamic json) {
  _FromDate=json['FromDate']  ;
  _ToDate=json['ToDate'];

}
Map<String, dynamic> toJson()
{
  final map = <String, dynamic>{};
  map['FromDate']= _FromDate ;
  map['ToDate']=_ToDate;
  return map;
}

}
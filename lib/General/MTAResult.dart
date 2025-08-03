
class MTAResult
{
  bool _IsResultPass = false;
  String _ResultMessage = "";
  String _ErrorMessage = "";
  int _iResult = 0;
  double _dResult = 0;
  

  bool get IsResultPass => _IsResultPass;
  set IsResultPass(bIsResultPass)
  {
    _IsResultPass=bIsResultPass; // Passed or fail
  }
  String get ResultMessage => _ResultMessage;
  set ResultMessage(strResultMessage)
  {
    _ResultMessage=strResultMessage;
  }
  String get ErrorMessage => _ErrorMessage;
  set ErrorMessage(strErrorMessage)
  {
    _ErrorMessage=strErrorMessage;
  }
  int get iResult => _iResult;
  set iResult(intResult)
  {
    _iResult=intResult;
  }
  double get dResult => _dResult;
  set dResult(doubleResult)
  {
    _dResult=doubleResult;
  }


  Result({   bool IsResultPass=false, String ResultMessage="",String ErrortMessage="", int iResult=0,
    double dResult=0,})
  {
    _IsResultPass=IsResultPass  ;
    _ResultMessage=ResultMessage;
    _ErrorMessage=ErrortMessage;
    _iResult=iResult;
    _dResult=dResult;
  }








}

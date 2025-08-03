import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';

class MTAToast
{
  void ShowToast(String strMessage)
  {
    Fluttertoast.showToast(
        msg: strMessage,
        toastLength: Toast.LENGTH_LONG,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIosWeb: 3,
        backgroundColor: Colors.blueAccent,
        textColor: Colors.white,
        fontSize: 16.0
    );

  }

}
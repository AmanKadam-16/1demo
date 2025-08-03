
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;
import 'Result.dart';


class ApiInteraction
{

  Future<Result> GetCall(String strAuthentication, String strAPIUrl) async
  {
    Result objResult;
    try {
      final response = await http.get(
        Uri.parse(strAPIUrl),
        headers: {
          HttpHeaders.authorizationHeader: 'Basic $strAuthentication',
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
      );

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.accepted
          || response.statusCode == HttpStatus.notAcceptable ||
          response.statusCode == HttpStatus.forbidden
          || response.statusCode == HttpStatus.unauthorized ||
          response.statusCode == HttpStatus.notFound
      ||  response.statusCode == HttpStatus.conflict
      ||  response.statusCode == HttpStatus.expectationFailed) {
        objResult = Result.fromJson(jsonDecode(response.body));
      }
      else {
        objResult = Result();
        objResult.ResultMessage = "Unable to connect to server.";
        objResult.IsResultPass = false;
      }
    }on Exception catch(e)
    {
      objResult = Result();
      objResult.ResultMessage = e.toString();
      objResult.IsResultPass = false;
      print('error caught: $e');
    }

    return objResult;

  }
  Future<Result> GetCallParameter(String strAuthentication, String strAPIUrl ,String strData) async
  {
    Result objResult;
    try {
      final response = await http.get(
        Uri.parse(strAPIUrl+"/"+strData),
        headers:{
          HttpHeaders.authorizationHeader: 'Basic $strAuthentication',
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },


      );

      if (response.statusCode == HttpStatus.ok ||
          response.statusCode == HttpStatus.accepted
          || response.statusCode == HttpStatus.notAcceptable ||
          response.statusCode == HttpStatus.forbidden
          ||
          response.statusCode == HttpStatus.notFound
          ||  response.statusCode == HttpStatus.conflict
          ||  response.statusCode == HttpStatus.expectationFailed) {
        objResult = Result.fromJson(jsonDecode(response.body));
      }
      else if(response.statusCode == HttpStatus.unauthorized)
      {
        objResult = Result();
        objResult.ResultMessage = "Authorisation failed.";
        objResult.IsResultPass = false;
      }
      else {
        objResult = Result();
        objResult.ResultMessage = "Unable to connect to server.";
        objResult.IsResultPass = false;
      }
    }on Exception catch(e)
    {
      objResult = Result();
      objResult.ResultMessage = e.toString();
      objResult.IsResultPass = false;
      print('error caught: $e');
    }

    return objResult;

  }

    Future<Result> PostCall(String strAuthentication,String JsonDataString, String strAPIUrl) async
    {
      Result objResult;
      try
      {
      final response = await http.post(
        Uri.parse(strAPIUrl),
        headers:{
            HttpHeaders.authorizationHeader: 'Basic $strAuthentication',
            'Content-Type': 'application/json; charset=UTF-8',
            'Accept': 'application/json'
        },
        body:
          JsonDataString,
        );
        if (response.statusCode ==HttpStatus.ok || response.statusCode ==HttpStatus.accepted
          || response.statusCode ==HttpStatus.notAcceptable || response.statusCode ==HttpStatus.forbidden
          || response.statusCode ==HttpStatus.unauthorized || response.statusCode ==HttpStatus.notFound
          || response.statusCode == HttpStatus.conflict   ||  response.statusCode == HttpStatus.expectationFailed)
        {
           objResult=  Result.fromJson(jsonDecode(response.body));
        }
        else
        {
            objResult= Result();
            objResult.ResultMessage="Unable to connect to server.";
            objResult.IsResultPass=false;
        }
      }on Exception catch(e)
      {




        objResult = Result();
        objResult.ResultMessage = e.toString();
        objResult.IsResultPass = false;
        print('error caught: $e');
      }

        return objResult;

    }

  Future<Result> PutCall(String strAuthentication,String JsonDataString, String strAPIUrl) async
  {
    Result objResult;
    try
    {
      final response = await http.put(
        Uri.parse(strAPIUrl),
        headers:{
          HttpHeaders.authorizationHeader: 'Basic $strAuthentication',
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
        body:
        JsonDataString,
      );
      if (response.statusCode ==HttpStatus.ok || response.statusCode ==HttpStatus.accepted
          ||  response.statusCode ==HttpStatus.notAcceptable || response.statusCode ==HttpStatus.forbidden
          || response.statusCode ==HttpStatus.unauthorized || response.statusCode ==HttpStatus.notFound
          ||  response.statusCode == HttpStatus.conflict
          ||  response.statusCode == HttpStatus.expectationFailed
      )
      {
        objResult=  Result.fromJson(jsonDecode(response.body));
      }
      else
      {
        objResult= Result();
        objResult.ResultMessage="Unable to connect to server.";
        objResult.IsResultPass=false;
      }
    }on Exception catch(e)
    {
      objResult = Result();
      objResult.ResultMessage = e.toString();
      objResult.IsResultPass = false;
      print('error caught: $e');
    }

    return objResult;

  }
  Future<Result> DeleteCall(String strAuthentication,String JsonDataString, String strAPIUrl) async
  {
    Result objResult;
    try
    {
      final response = await http.delete(
        Uri.parse(strAPIUrl),
        headers:{
          HttpHeaders.authorizationHeader: 'Basic $strAuthentication',
          'Content-Type': 'application/json; charset=UTF-8',
          'Accept': 'application/json'
        },
        body:
        JsonDataString,
      );
      if (response.statusCode ==HttpStatus.ok || response.statusCode ==HttpStatus.accepted
          ||  response.statusCode ==HttpStatus.notAcceptable || response.statusCode ==HttpStatus.forbidden
          || response.statusCode ==HttpStatus.unauthorized || response.statusCode ==HttpStatus.notFound
          ||  response.statusCode == HttpStatus.conflict
          ||  response.statusCode == HttpStatus.expectationFailed
      )
      {
        objResult=  Result.fromJson(jsonDecode(response.body));
      }
      else
      {
        objResult= Result();
        objResult.ResultMessage="Unable to connect to server.";
        objResult.IsResultPass=false;
      }
    }on Exception catch(e)
    {
      objResult = Result();
      objResult.ResultMessage = e.toString();
      objResult.IsResultPass = false;
      print('error caught: $e');
    }

    return objResult;

  }
}
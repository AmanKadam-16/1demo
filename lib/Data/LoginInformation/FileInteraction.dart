
import 'dart:io';

import 'package:path_provider/path_provider.dart';

class FileInteraction
{
  static String MTAFileName = "MTA.txt";
  // getting file path
  Future<String> getFilePath(String strFileName) async
  {
    Directory appDocumentsDirectory = await getApplicationDocumentsDirectory(); // 1
    String appDocumentsPath = appDocumentsDirectory.path; // 2
    String filePath = '$appDocumentsPath/'+strFileName; // 3
    return filePath;
  }
  //save data in file
  Future<String> saveDataInFile(String strContent, String strFileName) async {
    final strFilePath=await getFilePath(strFileName);
    File file = File(strFilePath.toString()); // 1
    file.writeAsString(strContent); // 2
    print("data saved in file "+ strContent);
    return strContent;
  }

  // Get Data From File
  Future<String> getDataFromFile(String strFileName) async
  {

    String strFileData='';
    String strFilePath='';
    try {
      strFilePath = await getFilePath(strFileName); // 1
      File file=File(strFilePath);
      try
      {
          String fileContent = await file.readAsString(); // 2
          if (fileContent.length>0)
          {
            strFileData = fileContent;
          }
          else {
            strFileData='';
          }
        }
        on  Exception catch(e)
        {
          strFileData='';

          print('error caught: $e');
        }
    } on  Exception catch(e)
    {
      strFileData='';
      print('error caught: $e');
    }
    return strFileData;
  }



}
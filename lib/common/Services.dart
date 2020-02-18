import 'dart:async';
import 'package:dio/dio.dart';
import 'package:photoshare/common/ClassList.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:photoshare/common/Constants.dart' as cnst;

Dio dio = new Dio();

class Services {
  static Future<List> GetServiceForList(String APIName, List params) async {
    String Url = "";
    if (params.length > 0) {
      Url = APIName + "?";
      for (int i = 0; i < params.length; i++) {
        Url = Url + '${params[i]["key"]}=${params[i]["value"]}';
        if (i + 1 != params.length) Url = Url + "&";
      }
    } else
      Url = APIName;

    String url = cnst.api_url + '$Url';
    print("$APIName URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        List list = [];
        print("$APIName Response: " + response.data.toString());
        var responseData = response.data;
        if (responseData["IsSuccess"] == true) {
          list = responseData["Data"];
        } else {
          list = [];
        }
        return list;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("$APIName Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<SaveDataClass> PostServiceForSave(String APIName, body) async {
    print(body.toString());
    String url = cnst.api_url + '$APIName';
    print("$APIName : " + url);
    try {
      final response = await dio.post(url, data: body);
      if (response.statusCode == 200) {
        SaveDataClass saveData =
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: '0');
        var responseData = response.data;
        print("Response JSON : " + responseData.toString());

        print("$APIName Response: " + responseData.toString());

        saveData.Message = responseData["Message"].toString();
        saveData.IsSuccess =
            responseData["IsSuccess"].toString() == "true" ? true : false;
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        print("Server Error");
        throw Exception(response.data.toString());
      }
    } catch (e) {
      print("App Error ${e.toString()}");
      throw Exception(e.toString());
    }
  }

  static Future<SaveDataClass> GetServiceForSave(
      String APIName, List params) async {
    String Url = APIName + "?";
    for (int i = 0; i < params.length; i++) {
      Url = Url + '${params[i]["key"]}=${params[i]["value"]}';
      if (i + 1 != params.length) Url = Url + "&";
    }

    String url = cnst.api_url + '$Url';
    print("$APIName URL: " + url);
    try {
      Response response = await dio.get(url);

      if (response.statusCode == 200) {
        SaveDataClass saveData = new SaveDataClass(
            Message: 'No Data', IsSuccess: false, IsRecord: false, Data: "");
        print("$APIName Response: " + response.data.toString());
        var responseData = response.data;

        /*saveData.Message = responseData["Message"];
        saveData.IsSuccess = responseData["IsSuccess"];
        saveData.IsSuccess = responseData["IsSuccess"];
        saveData.Data = responseData["Data"].toString();*/
        print("$APIName Response: " + responseData.toString());

        saveData.Message = responseData["Message"].toString();
        saveData.IsSuccess =
        responseData["IsSuccess"].toString() == "true" ? true : false;
        saveData.Data = responseData["Data"].toString();

        return saveData;
      } else {
        throw Exception("Something Went Wrong");
      }
    } catch (e) {
      print("$APIName Erorr : " + e.toString());
      throw Exception(e);
    }
  }
}

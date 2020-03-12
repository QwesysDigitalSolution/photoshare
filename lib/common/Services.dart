import 'dart:async';
import 'dart:convert';
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
        var responseData = jsonDecode(response.data);
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
            new SaveDataClass(Message: 'No Data', IsSuccess: false, Data: "");
        var responseData = jsonDecode(response.data);
        print("Response JSON : " + responseData.toString());

        print("$APIName Response: " + responseData.toString());

        //responseData=responseData.toString().replaceAll("'\'", "");
        saveData.IsSuccess = responseData["IsSuccess"].toString() == "true" ? true : false;
        saveData.Data = responseData["Data"].toString();
        saveData.Message = responseData["Message"].toString();

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

  static Future<SaveDataClass> GetServiceForSave(String APIName, List params) async {
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

  //get category List
  static Future<List<categoryClass>> getCategorys() async {
    String url = cnst.api_url + 'GetBusinessCategory.php';
    print("GetCategory Url:" + url);

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        List<categoryClass> stateClassList = [];
        print("GetCategory Response" + response.data.toString());

        final jsonResponse = jsonDecode(response.data);
        categoryClassData data = new categoryClassData.fromJson(jsonResponse);

        stateClassList = data.Data;

        return stateClassList;
      } else {
        throw Exception("No Internet Connection");
      }
    } catch (e) {
      print("Check GetState Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<List<stateClass>> getStates() async {
    String url = cnst.api_url + 'GetState.php';
    print("GetState Url:" + url);

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        List<stateClass> stateClassList = [];
        print("GetState Response" + response.data.toString());

        final jsonResponse = jsonDecode(response.data);
        stateClassData data = new stateClassData.fromJson(jsonResponse);

        stateClassList = data.Data;

        return stateClassList;
      } else {
        throw Exception("No Internet Connection");
      }
    } catch (e) {
      print("Check GetState Erorr : " + e.toString());
      throw Exception(e);
    }
  }

  static Future<List<cityClass>> getCity(String stateId) async {
    String url = cnst.api_url + 'GetCity.php?Id=$stateId';
    print("getCity Url:" + url);

    try {
      final response = await dio.get(url);
      if (response.statusCode == 200) {
        List<cityClass> cityClassList = [];
        print("getCity Response" + response.data.toString());

        final jsonResponse = jsonDecode(response.data);
        cityClassData data = new cityClassData.fromJson(jsonResponse);

        cityClassList = data.Data;

        return cityClassList;
      } else {
        throw Exception("No Internet Connection");
      }
    } catch (e) {
      print("Check getCity Erorr : " + e.toString());
      throw Exception(e);
    }
  }

}

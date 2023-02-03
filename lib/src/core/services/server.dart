import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../../core/config/config.dart';

// The function take will take the user request and verfies it with the api. in this case it will authenticate the user
Future<dynamic> callAPI(datarequest, myurl, authToken) async {
  final url = URL + version + myurl;
  print("The my url: $myurl");
  print("this is api call $datarequest $url  $authToken");
  try {
    final response = await http.post(Uri.parse('$url'),
        headers: authToken != null
            ? {
                HttpHeaders.contentTypeHeader: 'application/json',
                HttpHeaders.authorizationHeader: "Bearer $authToken"
              }
            : {HttpHeaders.contentTypeHeader: 'application/json'},
        body: json.encode(datarequest));
    print("this is response of Api call ${json.decode(response.body)}");
    if (response.statusCode == 200) {
      print("${response.statusCode}");
      return json.decode(response.body);
    } else {
      return json.decode(response.body);
    }
  } catch (e) {
    print("The error$e");
    Map<String, dynamic> response = {
      "statusCode": 400,
      "message": "No internet connection"
    };
    return response;
  }
}

Future<dynamic> getAPI(myurl, authToken) async {
  final url = URL + version + myurl;
  print('this is url $url');
  //print("auth token is ")
  try {
    final response = await http.get(
      Uri.parse('$url'),
      headers: authToken != null
          ? {
              HttpHeaders.contentTypeHeader: 'application/json',
              HttpHeaders.authorizationHeader: "Bearer $authToken"
            }
          : {HttpHeaders.contentTypeHeader: 'application/json'},
    );
    print("this is response of Api call ${json.decode(response.body)}");
    if (response.statusCode == 200) {
      print("${response.statusCode}");
      return json.decode(response.body);
    } else {
      return json.decode(response.body);
    }
  } catch (e) {
    Map<String, dynamic> response = {
      "status": 400,
      "message": "No Internet Connection"
    };
    return response;
  }
}





Future<dynamic> loginPostPic(datarequest) async {
 final urlpic = "https://q-tenant.vdotok.dev/s3upload/";
  try {

    print("in dioooooooooo ${datarequest['auth_token']}");
    var dio = new Dio();
    var file = datarequest['uploadFile'];
    print("this is fileeee: $file");
    String fileName = datarequest['uploadFile'].path.split('/').last;
    FormData formData = FormData.fromMap({
      "type": datarequest['type'],
      "extension":datarequest["extension"],
      "uploadFile": await MultipartFile.fromFile(file.path, filename: fileName),
      "auth_token": datarequest['auth_token'],
    });
    print("this is form data ${formData}");
    var response = await dio.post(urlpic, data: formData);
    //return response.data['id'];
    print("this is repkl: $response");
    return response.data;
  } catch (e) {
    print(e);
  }
}


import 'dart:async';
import 'dart:io';
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

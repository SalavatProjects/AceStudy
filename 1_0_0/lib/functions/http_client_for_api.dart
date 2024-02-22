import 'dart:io';
import 'dart:convert';

import '../config/constants.dart';
import 'package:http/http.dart' as http;

class HttpClientApi {
  late Map _bodyMap;
  late String _parameters;
  String url;
  HttpClientApi({
    required this.url
  });

  set setBodyMap(Map map){
    _bodyMap = map;
  }

  set setParameters(String str){
    _parameters = str;
  }

  /* Future postWithReturnData() async{
    var client = HttpClient();
    var body = jsonEncode(_bodyMap);
      try {
        HttpClientRequest request = await client.postUrl(Uri(
        scheme:Constants.getScheme, 
        host:Constants.getAddress, 
        port: Constants.getPort, 
        path: "${Constants.getApi}${url}",));
        request.headers.add(HttpHeaders.contentTypeHeader, 'application/json');
        request.add(utf8.encode(body));

        HttpClientResponse response = await request.close();
        var responseBody = await response.transform(utf8.decoder).join();
        var jsonData = jsonDecode(responseBody);
        return jsonData;
      } catch(e) {
        print(e);
      } finally {
        client.close();
      }
  }

  Future<void> postWithoutReturnData() async {
    var client = HttpClient();
    var body = jsonEncode(_bodyMap);
      try {
        HttpClientRequest request = await client.postUrl(Uri(
        scheme:Constants.getScheme, 
        host:Constants.getAddress, 
        port: Constants.getPort, 
        path: "${Constants.getApi}${url}",));
        request.headers.add(HttpHeaders.contentTypeHeader, 'application/json');
        request.add(utf8.encode(body));
        await request.close();
      } catch(e) {
        print(e);
      } finally {
        client.close();
      }
  }
  
  Future getWithReturnData() async {
    var client = HttpClient();
    try {
      HttpClientRequest request = await client.getUrl(Uri(
        scheme: Constants.getScheme,
        host: Constants.getAddress,
        port: Constants.getPort,
        path: "${Constants.getApi}${url}",
        query: _parameters));
        request.headers.add(HttpHeaders.contentTypeHeader, 'application/json');

        HttpClientResponse response = await request.close();
        var responseBody = await response.transform(utf8.decoder).join();
        var jsonData = jsonDecode(responseBody);
        
        return jsonData;
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
  }

  Future<void> getWithoutReturnData() async {
    var client = HttpClient();
    try {
      HttpClientRequest request = await client.getUrl(Uri(
        scheme: Constants.getScheme,
        host: Constants.getAddress,
        port: Constants.getPort,
        path: "${Constants.getApi}${url}",
        query: _parameters));
        request.headers.add(HttpHeaders.contentTypeHeader, 'application/json');
        await request.close();
    } catch (e) {
      print(e);
    } finally {
      client.close();
    }
  } */

  Future postWithReturnData() async{
    var response = await http.post(Uri.parse('${Constants.getScheme}://${Constants.getAddress}/${Constants.getApi}${url}'),
    headers: {"Content-Type": "application/json"},
    body: json.encode(_bodyMap));
    /* print(url);
    print('${Constants.getScheme}://${Constants.getAddress}/${Constants.getApi}${url}');
    print(response.body); */
    if (response.statusCode == 200)
    {
      return jsonDecode(response.body);
    } else {
      throw Exception('Unable to load data for url: ${url}');
    }
  }

  Future<void> postWithoutReturnData() async {
    var response = await http.post(Uri.parse('${Constants.getScheme}://${Constants.getAddress}/${Constants.getApi}${url}'),
    headers: {"Content-Type": "application/json"},
    body: json.encode(_bodyMap));
    // print(url);
    // print(_bodyMap);
    // print(response.body);
    if(response.statusCode != 200)
    {
      print(response.body);
    }
  }

  Future getWithReturnData() async {
    var response = await http.get(Uri.parse('${Constants.getScheme}://${Constants.getAddress}/${Constants.getApi}${url}?${_parameters}'));
    // print(response.body);
    if (response.statusCode == 200)
    {
      return jsonDecode(response.body);
    } else {
      throw Exception('Unable to load data for url: ${url}');
    }
  }

  Future<void> getWithoutReturnData() async {
    var response = await http.get(Uri.parse('${Constants.getScheme}://${Constants.getAddress}/${Constants.getApi}${url}?${_parameters}'));
    if(response.statusCode != 200)
    {
      print(response.body);
    }
  }
}
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'as http;
import 'package:intership/core/enums.dart';
abstract class BaseAPI{



Future<http.Response> sendImage(File file,String numberPlate,int random);
Future<http.Response> sendInfo(String numberPlate,String address,String imageurl);
Future<http.Response> sendlocation(String address);



}

class API implements BaseAPI{
  final Map<String,String> headers = {'Accept': 'application/json',"Content-type": "application/json"};
  @override
  Future<http.Response>  sendImage(File file,String numberPlate,int random)async{
    var response;
    try {
     var data=file.readAsBytesSync();
     String base64=base64Encode(data);
     String format=file.path.split("/").last.split(".").last;
     
      var body={"image":base64,"plateno":numberPlate.toString(),"format":format,"random":random};
      response=http.post(localaddress+"/image",body:jsonEncode(body),headers: headers);

    } catch (e) {
      print(e);
    }
 
    return response;
  }

  
    @override
    Future<http.Response> sendInfo(String numberPlate, String address, String imageurl) {
        var response;
    try {
    
     
      var body={"PlateNo":numberPlate,"Imageurl":imageurl,"Address":address};
      response=http.post(localaddress+"/info",body:jsonEncode(body),headers: headers);

    } catch (e) {
      print(e);
    }
   return response;

  }

  @override
  Future<http.Response> sendlocation(String address) {
        var response;
    try {
    
     
      var body={"location":address};
      response=http.post(localaddress+"/localtion",body:jsonEncode(body),headers: headers);

    } catch (e) {
      print(e);
    }
   return response;
  }

}
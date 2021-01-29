import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart'as http;
abstract class BaseAPI{


Future<String> sendImageAndInfo(File file,int numberPlate);




}

class API implements BaseAPI{
  final Map<String,String> headers = {'Accept': 'application/json',"Content-type": "application/json"};
  @override
  Future<String>  sendImageAndInfo(File file,int numberPlate)async{
    var response;
    try {
     var data=file.readAsBytesSync();
     String base64=base64Encode(data);
     String format=file.path.split("/").last.split(".").last;
     
      var body={"image":base64,"name":numberPlate.toString(),"format":format};
      response=http.post("http://192.168.137.1:5000/info",body:jsonEncode(body),headers: headers);

    } catch (e) {
      print(e);
    }
   print(response);
    return "dd";
  }

}
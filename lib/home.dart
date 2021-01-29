import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:geocoder/geocoder.dart';
import 'package:geolocator/geolocator.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intership/models/api.dart';


class Home extends StatefulWidget{
  @override
  _HomeState createState() => _HomeState();
}

class _HomeState extends State<Home> {
BaseAPI api=new API();
int random;
File file;
String _addressline="";
bool _isloading=false;
  final picker = ImagePicker();
final _formKey = GlobalKey<FormState>();
String platenostring="";
 bool _isValidForm() {
    final FormState form = _formKey.currentState;
    if (form.validate()) {
      
      form.save();
      return true;
    }
    return false;
  }

void validForm(Size size){
  if(_isValidForm()){
   
      if(_addressline!=""&&file!=null){
   
      Random randomnum = new Random();
      random = randomnum.nextInt(10000);
      print(random);
      String format=file.path.split("/").last.split(".").last;
      String imageurl="http://localhost:5000/public/images/"+platenostring+random.toString()+"."+format;
      setState(() {
         _isloading=true;
      });
     
      api.sendImage(file, platenostring, random).then((value){
        if(value.statusCode==200){
          
          api.sendInfo(platenostring, _addressline, imageurl).then((value){
            if(value.statusCode==200){
               setState(() {
                _isloading=false;
              });
               showErrorDialog(context, size, "Fotoğraf gönderildi","Başarılı");
              print("");
            }
            else{
              showErrorDialog(context, size, "Hata oluştu","Hata");
            }
          });
        }
        else{
              showErrorDialog(context, size, "Hata oluştu","Hata");
            }
      });
      }
      else{
            showErrorDialog(context, size, "Lütfen fotoğraf ve ya konumu ekleyin","Hata");
      }
    }
  
  }


void getAddress(Position value)async{
    final coordinates = new Coordinates(value.latitude, value.longitude);
    var addresses = await Geocoder.local.findAddressesFromCoordinates(coordinates);
    print(value.toString());

    setState(() {
        _addressline=addresses.first.addressLine;
    });
  

   // print(addresses.first.addressLine);
    //print(addresses.first.adminArea);istanbul
    //print(addresses.first.sublocality);null
    //print(addresses.first.locality);fatih
    //print(addresses.first.subAdminArea);kucukcekmece

    //get full address and also district with city apart
    //fulladdress
    //city,district
}
  Future getImage(ImageSource source,Size size) async {
    final pickedFile = await picker.getImage(source: source);

    setState(() {
      if (pickedFile != null) {
        file = File(pickedFile.path);
        showAcceptDialog(context,size);
      } else {
        print('Bir resim seçilmemiş.');
      }
    });
  }

    void showErrorDialog(BuildContext context,Size size,String text,String type){
     showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) -   1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * size.height/3.687,0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(size.height/46.09)),
                title:  Text(type,style: TextStyle(fontWeight: FontWeight.w700,fontSize: size.height/52.67),),
                content:  Text(text,style: TextStyle(fontWeight: FontWeight.w700,fontSize: size.height/52.67),),
                actions: <Widget>[
                  new FlatButton(
                    child: Padding(
                      padding:  EdgeInsets.all( size.height/65),
                      child: new Text('Okay',style: TextStyle(fontWeight: FontWeight.w700,fontSize: size.height/52.67)),
                    ),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
              
                ],
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 500),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }


    void showAcceptDialog(BuildContext context,Size size){
     showGeneralDialog(
        barrierColor: Colors.black.withOpacity(0.5),
        transitionBuilder: (context, a1, a2, widget) {
          final curvedValue = Curves.easeInOutBack.transform(a1.value) -   1.0;
          return Transform(
            transform: Matrix4.translationValues(0.0, curvedValue * size.height/3.687,0.0),
            child: Opacity(
              opacity: a1.value,
              child: AlertDialog(
                shape: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(size.height/46.09)),
                title:  Text("Yükleniyor",style: TextStyle(fontWeight: FontWeight.w700,fontSize: size.height/52.67),),
                content:  Text("Bu fotoğrafı yüklemek istiyor musunuz",style: TextStyle(fontWeight: FontWeight.w700,fontSize: size.height/52.67),),
                actions: <Widget>[
                  new FlatButton(
                    child: Padding(
                      padding:  EdgeInsets.all( size.height/65),
                      child: new Text('Hayır',style: TextStyle(fontWeight: FontWeight.w700,fontSize: size.height/52.67)),
                    ),
                    onPressed: () {
                      setState(() {
                         file=null;
                      });
                     
                      Navigator.pop(context);
                    },
                  ),
                  new FlatButton(
                    child: Padding(
                      padding:  EdgeInsets.all(size.height/65),
                      child: new Text('Evet',style: TextStyle(fontWeight: FontWeight.w700,fontSize: size.height/52.67)),
                    ),
                    onPressed: () async {
                     
                      Navigator.pop(context);
                    },
                  )
                ],
              ),
            ),
          );
        },
        transitionDuration: Duration(milliseconds: 500),
        barrierDismissible: false,
        barrierLabel: '',
        context: context,
        pageBuilder: (context, animation1, animation2) {});
  }
    //api.sendImageAndInfo(_image,Random(44).nextInt(400));
              /*_getLocation().then((value) => {
                print(value.toString())
              });*/

 Future<Position> _getLocation() async {
  bool serviceEnabled;
  LocationPermission permission;

  serviceEnabled = await Geolocator.isLocationServiceEnabled();
  if (!serviceEnabled) {
    return Future.error('Location services are disabled.');
  }

  permission = await Geolocator.checkPermission();
  if (permission == LocationPermission.deniedForever) {
    return Future.error(
        'Location permissions are permantly denied, we cannot request permissions.');
  }

  if (permission == LocationPermission.denied) {
    permission = await Geolocator.requestPermission();
    if (permission != LocationPermission.whileInUse &&
        permission != LocationPermission.always) {
      return Future.error(
          'Location permissions are denied (actual value: $permission).');
    }
  }

  return await Geolocator.getCurrentPosition();
}
String plateno(String text){
if(text.isEmpty||text==null){
  return "Plakayı girin";
}
return null;
}

  @override
  Widget build(BuildContext context) {
   Size size=MediaQuery.of(context).size;
   return Scaffold(
     body: SingleChildScrollView(
            child: Center(
              child: Stack(
                children: [
                  _isloading?
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        
                            color: Colors.transparent,
                        child: Center(
                          child: Container(
                        
                            child: CircularProgressIndicator()),
                        ),
                      ),
                    ],
                  ):
                  Center(
         child: Form(
                  key:_formKey ,
                   child: Column(
                     mainAxisAlignment: MainAxisAlignment.start,
                   children: [
                                                 Container(
                           decoration: BoxDecoration(
                             border: Border.all(),
                         
                           ),
                           margin: EdgeInsets.only(top: size.height/20),
                           width: size.width/1.2,
                           height: size.height/11,
                           child: Center(
                             child: Text(
                               
                               file==null?"Fotoğraf seçin":file.path,
                                 style: TextStyle(fontSize: size.height/60,fontWeight: FontWeight.w600),
                             ),
                           ),
                     ),
                                   Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                       
                             GestureDetector(
                        
                        onTap: (){
                        getImage(ImageSource.gallery,size);
                                 },
                              
                      child: Container(
                             margin: EdgeInsets.only(top: size.height/15),
                              height: size.height/11,
                              width: size.width/3.5,
                              decoration: BoxDecoration(
                              color: Colors.yellowAccent,
                          
                              ),
                              child:Center(child: Text("Galeri",style: TextStyle(fontSize: size.height/45,color: Colors.black),)) ,
                              ),
                            ),
                            GestureDetector(
                        
                        onTap: (){
                                getImage(ImageSource.camera,size);
                              },
                              
                       child: Container(
                             margin: EdgeInsets.only(top: size.height/15),
                              height: size.height/11,
                              width: size.width/3.5,
                              decoration: BoxDecoration(
                                color: Colors.yellowAccent,
                             
                              
                        
                              ),
                                child:Center(child: Text("Kamera",style: TextStyle(fontSize: size.height/45,color: Colors.black),)) ,
                              ),
                            ),
                           /*  GestureDetector(
                                onTap: (){
                                setState(() {
                                   file=null;
                                });},
                       child: Container(
                              margin: EdgeInsets.only(top: size.height/15),
                              height: size.height/11,
                              width: size.width/5,
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(15)
                              ),
                                child:Center(child: Icon(Icons.delete,size: size.height/30,color: Colors.black,),)) ,
                              )*/
                            /*
                          */
                          ],
                        ),
                     Container(
                       margin: EdgeInsets.only(top: size.height/20),
                       width: size.width/1.2,
                       height: size.height/11,
                       child: TextFormField(
                          onSaved: (plateno)=>platenostring=plateno,
                      
                         style: TextStyle(fontSize: size.height/30),
                        
                         decoration: InputDecoration(
                          labelText: "Plakayı girin",
                          fillColor: Colors.black,
                       
                          focusedBorder: OutlineInputBorder(
                          
                      
                          borderSide: BorderSide(
                            color: Colors.yellow,
                          ),
                        ),
                          enabledBorder: OutlineInputBorder(
                          
                       
                          borderSide: BorderSide(
                          
                            width: 2.0,
                            
                          ),
                        ),
                         ),
                         validator: plateno,
                       ),
                     ),
                       Row(
                         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                         children: [
                           Container(
                           decoration: BoxDecoration(
                             border: Border.all(),
                        
                           ),
                           margin: EdgeInsets.only(top: size.height/20),
                           width: size.width/1.8,
                           height: size.height/11,
                           child: Center(
                             child: Text(
                               
                               _addressline==""?"Şimdiki adresi al":_addressline,
                                 style: TextStyle(fontSize: size.height/60,fontWeight: FontWeight.w600),
                             ),
                           ),
                     ),
                     InkWell(
                       onTap: (){
                        _getLocation().then((value)async{
                        getAddress(value);
                      });
                       },
                                    child: Container(
                           margin: EdgeInsets.only(top: size.height/20),
                          width: size.width/5,
                             height: size.height/11,
                         decoration: BoxDecoration(
                            color: Colors.yellowAccent,
                     
                         ),
                        
                         child: Icon(Icons.location_on,color: Colors.black,)),
                     )
                         ],
                       ),
                
                     
                     GestureDetector(
                       onTap: (){
                         validForm(size);
                       },
                                    child: Container(
                         margin: EdgeInsets.only(top: size.height/10),
                         width: size.width/3,
                         height: size.height/11,
                         decoration: BoxDecoration(
                           color: Colors.yellow,
                        
                     
                         ),
                         child: Center(child: Text("Gönder",style: TextStyle(color: Colors.black,fontSize: size.height/45),)),),
                     )
                       /* Row(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Container(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.red,width: 2),
                        color: Colors.blue,
                        
                        borderRadius: BorderRadius.circular(20)
                      ),
                       width: size.width/1.6,
                       height: size.height/11,
                       child: Center(
                         child: Text(
                           _addressline,
                               style: TextStyle(fontSize: size.height/50),
                              
                         
                         ),
                       ),
                     ),
                     GestureDetector(
                       onTap: (){
                      _getLocation().then((value)async{
                        getAddress(value);
                      });
                       },
                         child: Container(
                           width: 50,
                           height: 50,
                           child: Center(child: Icon(Icons.location_on,color: Colors.black,size: size.height/30,)),
                         decoration: BoxDecoration(
                           color: Colors.blueAccent,
                           borderRadius: BorderRadius.circular(25),
                          
                         ),
                       
                       ),
                     ),
                          ],
                        ),
           */
                     
                   /* RaisedButton(
                       child: Text("Send data"),
                       onPressed: (){
                     
                       
                     })*/
                   ],
           ),
         )
       ),
                ],
              ),
            ),
     ),
     /*floatingActionButton: FloatingActionButton(onPressed: (){
       getImage();
     }),*/
   );
   
  }
}
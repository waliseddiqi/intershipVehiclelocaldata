import 'package:flutter/material.dart';
import 'package:intership/home.dart';
import 'package:intership/models/connectivity_model.dart';
import 'package:provider/provider.dart';
import 'core/enums.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    
   return StreamProvider(
   create: (context)  => ConnectivityService().connectionStatusController.stream,
    child:MaterialApp(
      title: 'Intership project',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
          primarySwatch: Colors.blue,
          visualDensity: VisualDensity.adaptivePlatformDensity,
        
      ),
      home: MyHomePage(title: ''),
    ));
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {

  @override
  Widget build(BuildContext context) {
    var connectionStatus = Provider.of<ConnectivityStatus>(context);
    return Scaffold(
     
      body:connectionStatus==ConnectivityStatus.Offline?
      Center(
        child: Container(
          child: Text("Please connect to the internet"),
        ),

      ):Home()
   
    );
  }
}

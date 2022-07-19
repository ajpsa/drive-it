import 'package:flutter/material.dart';
import 'package:p1/screens/driverscreen/completedjobs.dart';
import 'package:p1/screens/driverscreen/driver_drawer.dart';
import 'package:p1/screens/driverscreen/pending.dart';
import 'package:p1/screens/driverscreen/takejobs.dart';
import 'package:p1/services/auth.dart';
import 'package:p1/authenticate/sign_in.dart';

class DriverHome extends StatefulWidget {

  @override
  State<DriverHome> createState() => _DriverHomeState();
}

class _DriverHomeState extends State<DriverHome> {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topCenter,
                end: Alignment.bottomCenter,
                colors: <Color>[Colors.cyan, Colors.blue]),
          ),
        ),
        backgroundColor: Colors.blue,
        elevation: 0.0,
        title: Text('Driver'),
      ),
      body: Container(
        height:MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [Colors.greenAccent, Colors.blue])),
                //colors: [Colors.deepOrangeAccent, Colors.purpleAccent])),
                //colors: [Colors.pink, Colors.deepOrangeAccent])),
        child: Center(
          child: Column(
              children: <Widget>[
                SizedBox(height: 40),
                InkWell(
                  child: Container(
                    width: 200,height: 180,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset("assets/images/takejob.gif",fit: BoxFit.cover)),
                  ),
                  onTap: (){
                    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>TakeJobs()));
                  },
                ),
                SizedBox(height: 20),
                InkWell(
                  child: Container(
                    width: 200,height: 180,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset("assets/images/pending.gif",fit: BoxFit.cover)),
                  ),
                  onTap: (){
                    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>Pending()));
                  },
                ),
                SizedBox(height: 20),
                InkWell(
                  child: Container(
                    width: 200,height: 180,
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset("assets/images/completed.gif",fit: BoxFit.cover)),
                  ),
                  onTap: (){
                    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>CompletedJobs()));
                  },
                ),
              ]
          ),
        ),
      ),
      drawer: DriverDrawer(),
    );
  }
}
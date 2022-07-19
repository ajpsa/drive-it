import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:url_launcher/url_launcher.dart';


class ViewpriceScreen extends StatefulWidget {
  @override
  _ViewpriceScreenState createState() => _ViewpriceScreenState();
}

class _ViewpriceScreenState extends State<ViewpriceScreen> {

  final _formkey = GlobalKey<FormState>();

  final auth = FirebaseAuth.instance;
  final Uri url = Uri.parse('https://car-pradeep.herokuapp.com/');

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      appBar: AppBar(
        elevation: 0.0,
        //backgroundColor: Colors.blue[400],
        title: Text('Check price'),),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.deepPurpleAccent, Colors.cyan])),
        child: SingleChildScrollView(
          child: Container(
            height:MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 40.0),
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              key: _formkey,
              child: Column(
                children: [
                  SizedBox(height: 30),
                  Image.asset("assets/images/cprice.gif"),
                  SizedBox(height: 40),
                  Text("You will be directed to Car price prediction ",
                      style: TextStyle(
                        color: Colors.greenAccent,
                        fontSize: 30,
                        fontWeight: FontWeight.bold,
                      )),

                  SizedBox(height: 40),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      ElevatedButton(
                        style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.green),
                        ),
                        child: Text('Click here'),
                        onPressed: _launchUrl,
                      ),
                    ],
                  ),
                ],),
            ),
          ),
        ),
      ),
    );
  }
  void _launchUrl() async {
    if (!await launchUrl(url)) throw 'Could not launch $url';
  }
}
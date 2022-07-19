import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:p1/screens/UserViewCar.dart';
import 'package:p1/screens/drawer.dart';
import 'package:reviews_slider/reviews_slider.dart';

import '../utils/utils.dart';


class Reviews extends StatefulWidget {
  @override
  _ReviewsState createState() => _ReviewsState();
}

class _ReviewsState extends State<Reviews> {
  final User? _user = FirebaseAuth.instance.currentUser;
  final _formkey = GlobalKey<FormState>();

  int? selectedValue1;
  int? selectedValue2;
  int? selectedValue3;
  String? userName;
  String? userPlace;
  String? userPhone;
  String? useremail;
  String? imageUrl;
  late String sg='';

  void onChange1(int value) {
    setState(() {
      selectedValue1 = value;

    });
  }

  void onChange2(int value) {
    setState(() {
      selectedValue2 = value;
    });
  }
  void onChange3(int value) {
    setState(() {
      selectedValue3 = value;
    });
  }

  @override

  void initState() {
    super.initState();
    // initialdate = DateTime.now();


    FirebaseFirestore.instance
        .collection('userDetails')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc['email'] == _user?.email) {
          setState(() {
            useremail = doc['email'];
            userName = doc['name'];
            userPlace = doc['address'];
            userPhone = doc['phone'];
            imageUrl = doc['profilepicURL'];
          });
        }
      });
    });
  }


  Widget build(BuildContext context) {
    TextEditingController ctrl = new TextEditingController();
    return Scaffold(
      backgroundColor: Colors.blueGrey[50],
      appBar: AppBar(
        backgroundColor: Colors.cyan,
        title: Text(" Reviews "),
        //automaticallyImplyLeading: false,
      ),
      body: Container(
        height:MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.cyan, Colors.indigoAccent])),
        child: SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.only(left:18.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  SizedBox(height: 15),
                  Text(
                    'Hello $userName ${_user?.email}',
                    style: TextStyle(color: Colors.black,
                        fontSize: 25),
                  ),
                  SizedBox(height: 25),
                  Text(
                    'How was the service you received?',
                    style: TextStyle(color: Colors.black,
                        fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  ReviewSlider(
                    optionStyle: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.bold,
                    ),
                    onChange: onChange1,
                  ),
                  Text(selectedValue1.toString(),style: TextStyle(color: Colors.red),),
                  SizedBox(height: 20),
                  Text(
                    'Price of our services?',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  ReviewSlider(
                    optionStyle: TextStyle(
                      color: Colors.orange,
                      fontWeight: FontWeight.bold,
                    ),
                    onChange: onChange2,
                    initialValue: 1,
                  ),
                  Text(selectedValue2.toString(),style: TextStyle(color: Colors.orange)),
                  SizedBox(height: 20),
                  Text(
                    'Overall Experience?',
                    style: TextStyle(color: Colors.black, fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  ReviewSlider(
                    optionStyle: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                    onChange: onChange3,
                    initialValue: 3,
                    //options: ['Terrible', 'Malo', 'Bien', 'Vale', 'Genial'],
                  ),
                  Text(selectedValue3.toString(),style: TextStyle(color: Colors.black)),
                  SizedBox(height: 10),
                  Form(
                    key: _formkey,
                    child: TextFormField(
                      autovalidateMode: AutovalidateMode.onUserInteraction,
                      decoration: textInputDecoration.copyWith(hintText: "Suggestions/comments"),
                      controller: ctrl,
                      onSaved: (value) {
                        sg = value!;
                      },
                      validator: (val){
                        if(val!.isEmpty)
                        {
                          return "Can't be empty.";
                        }
                        if(!(val.isEmpty) && !RegExp(r"(^[a-zA-Z][a-zA-Z\s]{0,50})").hasMatch(val)){
                          return "Enter a valid suggestion";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                        style: ButtonStyle(
                            backgroundColor: MaterialStateProperty.all(Colors.red)
                        ),
                        child: Text(
                          'Confirm',
                          style: TextStyle(color: Colors.white),
                        ),
                        onPressed: () async {
                          try{
                            if(_formkey.currentState!.validate()) {
                              _formkey.currentState!.save();
                              //print(date);
                              rev();
                            }
                            // print(date1);
                          }catch(e){
                            Fluttertoast.showToast(
                                msg: e.toString(),
                                toastLength: Toast.LENGTH_SHORT,
                                gravity: ToastGravity.CENTER,
                                timeInSecForIosWeb: 1,
                                backgroundColor: Colors.red,
                                textColor: Colors.white,
                                fontSize: 16.0
                            );
                          }
                        }
                    ),
                  ),
                ],
              ),
            ),
        ),
      ),
    );
  }
  void rev() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance.collection('Review').doc().set({
        "User Name": userName,
        "User email": _user!.email,
        "service_rating": selectedValue1,
        "price_rating": selectedValue2,
        "overall_rating": selectedValue3,
        'date': DateTime.now(),
        "suggestions": sg,
      });
      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>UserViewCar()));
      Fluttertoast.showToast(msg: "Review added");
    } catch(e){}
  }
}
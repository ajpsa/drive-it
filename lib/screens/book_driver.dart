import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:p1/screens/UserViewCar.dart';
import 'package:p1/utils/utils.dart';
import 'drawer.dart';

class BookDrivers extends StatefulWidget {
  const BookDrivers({Key? key}) : super(key: key);

  @override
  _BookDriversState createState() => _BookDriversState();
}

class _BookDriversState extends State<BookDrivers> {
  final User? _user = FirebaseAuth.instance.currentUser;
  String? userName;
  String? userPlace;
  String? userPhone;
  String? useremail;
  String imageUrl = 'https://www.flaticon.com/free-icon/user_149071';

  DateTime date = DateTime.now().add(Duration(days: 1));
  late DateTime finaldate = DateTime.now();
  final _formkey = GlobalKey<FormState>();
  late String address = '';
  late String sugg = '';
  // DateTime dateb = DateTime.now();
  String date1 =
      '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}';
  DateTime date2 = DateTime.now();
  late String fd;
  late String td;

  @override
  void initState() {
    super.initState();
    // initialdate = DateTime.now();
    finaldate = DateTime.now().add(Duration(days: 4));

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
    TextEditingController caddress = new TextEditingController();
    TextEditingController baddress = new TextEditingController();
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Page'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        height: MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.cyan, Colors.indigoAccent])),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 20),
                Container(
                  child: Text(" Enter your Details to Request driver",
                      style:
                          TextStyle(fontWeight: FontWeight.bold, fontSize: 20)),
                ),
                SizedBox(height: 10),
                Text('Enter the initial Date',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                Container(
                  height: 100,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    // initialDateTime: DateTime.now(),
                    maximumDate: DateTime.now().add(Duration(days: 7)),
                    minimumDate: DateTime.now().add(Duration(days: 0)),
                    // minimumYear: 2022,

                    onDateTimeChanged: (DateTime value) {
                      setState(() => date2 = value);
                      fd = '${date2.day}-${date2.month}-${date2.year}';
                    },
                  ),
                ),
                SizedBox(height: 25),
                Text('Enter the last Date',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                Container(
                  height: 100,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: DateTime.now().add(Duration(days: 1)),
                    maximumDate: DateTime.now().add(Duration(days: 365)),
                    minimumDate: DateTime.now().add(Duration(days: 0)),
                    // minimumYear: 2022,
                    onDateTimeChanged: (DateTime value) {
                      setState(() => date = value);
                      td = '${date.day}-${date.month}-${date.year}';
                    },
                  ),
                ),
                SizedBox(height: 25),
                Text('Enter Delivery Address',
                    style:
                        TextStyle(fontSize: 15, fontWeight: FontWeight.bold)),
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: Column(
                          children: [
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: textInputDecoration.copyWith(
                                  hintText: "Address"),
                              controller: baddress,
                              onSaved: (value) {
                                address = value!;
                              },
                              validator: (val) {
                                if (val!.isEmpty) {
                                  return "Can't be empty.";
                                }
                                if (!(val.isEmpty) &&
                                    !RegExp(r"(^[a-zA-Z][a-zA-Z\s]{0,20}[a-zA-Z]$)")
                                        .hasMatch(val)) {
                                  return "Enter a valid Address";
                                }
                                return null;
                              },
                            ),
                            SizedBox(height: 30),
                            Text('Enter any Suggestions or specifications',
                                style: TextStyle(
                                    fontSize: 15, fontWeight: FontWeight.bold)),
                            SizedBox(height: 20),
                            TextFormField(
                              autovalidateMode:
                                  AutovalidateMode.onUserInteraction,
                              decoration: textInputDecoration.copyWith(
                                  hintText: "Suggestions"),
                              controller: caddress,
                              onSaved: (value) {
                                sugg = value!;
                              },
                            )
                          ],
                        ),
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.all(Colors.red)),
                          child: Text(
                            'Confirm',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            try {
                              if (_formkey.currentState!.validate()) {
                                _formkey.currentState!.save();
                                //print(date);
                                bookCars();
                              }
                              // print(date1);
                            } catch (e) {
                              Fluttertoast.showToast(
                                  msg: e.toString(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0);
                            }
                          }),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void bookCars() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance.collection('driverReq').doc().set({
        "user name": userName,
        "user email": useremail,
        "user phone": userPhone,
        "location": address,
        "suggestions": sugg,
        "req date": date1,
        "fromdate": fd,
        "todate": td,
        "status": 'pending',
      });
      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => UserViewCar()));
      Fluttertoast.showToast(msg: "Request Sent");
    } catch (e) {}
  }
}

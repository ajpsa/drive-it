import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p1/screens/admin/admin_drawer.dart';
import 'package:p1/screens/admin/adviewcar.dart';
import 'dart:io';
import 'package:p1/utils/utils.dart';

class addcar extends StatefulWidget {
  const addcar({Key? key}) : super(key: key);

  @override
  _addcarState createState() => _addcarState();
}

class _addcarState extends State<addcar> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController title = new TextEditingController();
  TextEditingController brand = new TextEditingController();
  TextEditingController color = new TextEditingController();
  TextEditingController fuel = new TextEditingController();
  TextEditingController gear = new TextEditingController();
  TextEditingController price = new TextEditingController();

  late String txttitle,
      txtbrand,
      txtcolor,
      txtfuel,
      txtgear,
      txtprice;


  final _auth = FirebaseAuth.instance;
  double screenHeight = 0;
  double screenWidth = 0;
  Color primary = const Color(0xffeef444c);
  String path = "";
  DateTime date = DateTime.now();

  void pickUploadProfilePic() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 1024,
      maxWidth: 1024,
      imageQuality: 90,
    );
    final User? user = FirebaseAuth.instance.currentUser;

    Reference ref = FirebaseStorage.instance
        .ref().child('car${user?.uid}$date');

    await ref.putFile(File(image!.path));

    ref.getDownloadURL().then((value) async {
      setState(() {
        path = value;
        // final User? user = FirebaseAuth.instance.currentUser;
        // final fire = FirebaseFirestore.instance.collection('CarsD');
        // fire.doc().set({
        // });
      });
    });
  }

  void update() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance.collection('CarsD').doc().set({
        "name": txttitle,
        "brand": txtbrand,
        "color": txtcolor,
        "path": path,
        "fuel": txtfuel,
        "price": txtprice,
        "gear": txtgear,
        "coid" : user?.uid,
        "status": "Available"
      });

      Navigator.of(context).push(new MaterialPageRoute(
          builder: (BuildContext context) => Adviewcar()));
    } catch (e) {}
  }

  @override
  Widget build(BuildContext context) {
    screenHeight = MediaQuery
        .of(context)
        .size
        .height;
    screenWidth = MediaQuery
        .of(context)
        .size
        .width;
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Text("Add Car", textAlign: TextAlign.center),
      ),

      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/wp.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                GestureDetector(
                  onTap: () {
                    pickUploadProfilePic();
                  },
                  child: Container(
                    margin: const EdgeInsets.only(top: 50, bottom: 10),
                    height: 150,
                    width: 150,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100),
                      color: primary,
                    ),
                    child:
                    Center(
                      child:
                      path == " " ?
                      const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 80,
                      ) :
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(path),
                      ),
                    ),
                  ),
                ),

                Container(
                  // margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
                  // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  alignment: Alignment.center,
                  padding: EdgeInsets.symmetric(horizontal: 20.0),
                  child: Column(
                    children: [
                      Form(
                        //autovalidate: true,
                        autovalidateMode: AutovalidateMode.always,
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(height: 90,),
                            Container(
                              child: TextFormField(
                                controller: title,
                                decoration: Mytheme().textInputDecoration(
                                    'title', 'Name of the car'),
                                onSaved: (value) {
                                  txttitle = value!;
                                },
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Can't be empty.";
                                  }
                                  if ((val.isEmpty) && !RegExp(
                                      r"(^[a-zA-Z][a-zA-Z\s]{0,20}[a-zA-Z]$)")
                                      .hasMatch(val)) {
                                    return "Enter a valid Name";
                                  }
                                  return null;
                                },
                                keyboardType: TextInputType.text,
                              ),
                              decoration: ThemeHelper()
                                  .inputBoxDecorationShaddow(),
                            ),


                            SizedBox(height: 20.0),
                            Container(
                              child: TextFormField(
                                controller: brand,
                                decoration: Mytheme().textInputDecoration(
                                    'brand', 'Enter the brand'),
                                keyboardType: TextInputType.text,
                                onSaved: (value) {
                                  txtbrand = value!;
                                },
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Can't be empty.";
                                  }
                                  if ((val.isEmpty) && !RegExp(
                                      r"(^[a-zA-Z][a-zA-Z\s]{0,20}[a-zA-Z]$)")
                                      .hasMatch(val)) {
                                    return "Enter a valid Name";
                                  }
                                  return null;
                                },
                              ),
                              decoration: ThemeHelper()
                                  .inputBoxDecorationShaddow(),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              child: TextFormField(
                                controller: color,
                                decoration: Mytheme().textInputDecoration(
                                    "Color",
                                    "Enter the color"),
                                onSaved: (value) {
                                  txtcolor = value!;
                                },
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Can't be empty.";
                                  }
                                  if ((val.isEmpty) && !RegExp(
                                      r"(^[a-zA-Z][a-zA-Z\s]{0,20}[a-zA-Z]$)")
                                      .hasMatch(val)) {
                                    return "Enter a color";
                                  }
                                  return null;
                                },
                              ),
                              decoration: ThemeHelper()
                                  .inputBoxDecorationShaddow(),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              child: TextFormField(
                                controller: fuel,
                                decoration: Mytheme().textInputDecoration(
                                    "fuel",
                                    "Enter the fuel"),
                                //keyboardType: TextInputType.phone,
                                onSaved: (value) {
                                  txtfuel = value!;
                                },
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Can't be empty.";
                                  }
                                  if ((val.isEmpty) && !RegExp(
                                      r"(^[a-zA-Z][a-zA-Z\s]{0,20}[a-zA-Z]$)")
                                      .hasMatch(val)) {
                                    return "Enter a valid Name";
                                  }
                                  return null;
                                },
                              ),
                              decoration: ThemeHelper()
                                  .inputBoxDecorationShaddow(),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              child: TextFormField(
                                controller: gear,
                                decoration: Mytheme().textInputDecoration(
                                    "gear",
                                    "Enter the monthly car rent"),
                                keyboardType: TextInputType.phone,
                                onSaved: (value) {
                                  txtgear = value!;
                                },
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Can't be empty.";
                                  }
                                  return null;
                                },
                              ),
                              decoration: ThemeHelper()
                                  .inputBoxDecorationShaddow(),
                            ),
                            SizedBox(height: 20.0),
                            Container(
                              child: TextFormField(
                                controller: price,
                                decoration: Mytheme().textInputDecoration(
                                    "price",
                                    "Enter the monthly car rent"),
                                keyboardType: TextInputType.phone,
                                onSaved: (value) {
                                  txtprice = value!;
                                },
                                validator: (val) {
                                  if (val!.isEmpty) {
                                    return "Can't be empty.";
                                  }
                                  return null;
                                },
                              ),
                              decoration: ThemeHelper()
                                  .inputBoxDecorationShaddow(),
                            ),

                            SizedBox(height: 30.0),
                            Container(
                              decoration: ThemeHelper().buttonBoxDecoration(
                                  context),
                              child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle(),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        40, 10, 40, 10),
                                    child: Text(
                                      "Add Car".toUpperCase(),
                                      style: TextStyle(
                                        fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      update();
                                      //uploadData(txttitle);
                                      //register1();
                                    }
                                  }
                                // },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
      drawer: AdminDrawer(),
    );
  }
  // uploadData(String name) async {
  //   List<String> splitList = name.split('');
  //   List<String> indexList = [];
  //
  //   for (int i = 0;i < splitList.length; i++) {
  //     for (int j = 0;i < splitList[i].length + i; j++) {
  //       indexList.add(splitList[i].substring(0, j).toLowerCase());
  //     }
  //   }
  //   FirebaseFirestore.instance.collection('use').doc().set({'search index' : indexList});
  // }
}


import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:p1/authenticate/cpass.dart';
import 'package:p1/screens/admin/admin_drawer.dart';
import 'package:p1/screens/admin/admin_profile.dart';
import 'dart:io';
import 'package:p1/utils/utils.dart';

class AdprofileScreen extends StatefulWidget {
  const AdprofileScreen({Key? key}) : super(key: key);

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<AdprofileScreen> {
  final _formKey = GlobalKey<FormState>();

  TextEditingController fname = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController place = new TextEditingController();
  TextEditingController confirmpassword = new TextEditingController();

  late String txtname,
      txtphone,
      txtemail,
      txtpassword,
      txtplace,
      txtrole = '';


  CollectionReference collectionReference = FirebaseFirestore.instance
      .collection('userDetails');
  final _auth = FirebaseAuth.instance;
  double screenHeight = 0;
  double screenWidth = 0;
  Color primary = const Color(0xffeef444c);
  String profilePicLink = "";

  void pickUploadProfilePic() async {
    final image = await ImagePicker().pickImage(
      source: ImageSource.gallery,
      maxHeight: 1024,
      maxWidth: 1024,
      imageQuality: 90,
    );
    final User? user = FirebaseAuth.instance.currentUser;

    Reference ref = FirebaseStorage.instance
        .ref().child('profile${user?.uid}');

    await ref.putFile(File(image!.path));

    ref.getDownloadURL().then((value) async {
      setState(() {
        profilePicLink = value;
        final User? user = FirebaseAuth.instance.currentUser;
        final fire = FirebaseFirestore.instance.collection('userDetails');
        fire.doc(user!.uid).update({
          "profilepicURL": profilePicLink
        });
      });
    });
  }
  void update() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance.collection('userDetails').doc(user!.uid).update({
        "name" : txtname,
        "address" : txtplace,
      });
      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>AdprofileView()));
    } catch(e){}
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
        title: Text("Edit Profile",textAlign: TextAlign.center),
      ),

      body: Container(
        height:MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
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
                    margin: const EdgeInsets.only(top: 120, bottom: 24),
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
                      profilePicLink == " " ?
                      const Icon(
                        Icons.person,
                        color: Colors.white,
                        size: 80,
                      ) :
                      ClipRRect(
                        borderRadius: BorderRadius.circular(100),
                        child: Image.network(profilePicLink),
                      ),
                    ),
                  ),
                ),

                Container(
                  // margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
                  // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      Form(
                        //autovalidate: true,
                        autovalidateMode: AutovalidateMode.always,
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(height: 110,),
                            Container(
                              child: TextFormField(
                                controller: fname,
                                decoration: ThemeHelper().textInputDecoration(
                                    'Name', 'Enter your name'),
                                onSaved: (value) {
                                  txtname = value!;
                                },
                                keyboardType: TextInputType.text,
                                validator: (val) {
                                  if(val!.isEmpty)
                                  {
                                    return "Can't be empty.";
                                  }
                                  if (!(val.isEmpty) && !RegExp(
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
                                controller: place,
                                decoration: ThemeHelper().textInputDecoration(
                                    'Address', 'Enter your Address'),
                                keyboardType: TextInputType.text,
                                onSaved: (value) {
                                  txtplace = value!;
                                },
                                validator: (val) {
                                  if(val!.isEmpty)
                                  {
                                    return "Can't be empty.";
                                  }
                                  if (!(val.isEmpty) && !RegExp(
                                      r"(^[a-zA-Z][a-zA-Z\s]{0,20}[a-zA-Z]$)")
                                      .hasMatch(val)) {
                                    return "Enter a valid Address";
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
                                controller: phone,
                                decoration: ThemeHelper().textInputDecoration(
                                    "Mobile Number",
                                    "Enter your mobile number"),
                                keyboardType: TextInputType.phone,
                                onSaved: (value) {
                                  txtphone = value!;
                                },
                                validator: (val) {
                                  if(val!.isEmpty)
                                  {
                                    return "Can't be empty.";
                                  }
                                  if (!(val.isEmpty) &&
                                      !RegExp(r"^[0-9]{10}$").hasMatch(val)) {
                                    return "Enter a valid phone number";
                                  }
                                  return null;
                                },
                              ),
                              decoration: ThemeHelper()
                                  .inputBoxDecorationShaddow(),
                            ),
                            SizedBox(height: 15.0),
                            Container(
                              child: ElevatedButton(
                                style: ThemeHelper().buttonStyle(),
                                child: Padding(
                                  padding: EdgeInsets.all(3),
                                  child: Text('Change password'.toUpperCase(),
                                    style: TextStyle(fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white),),
                                ),
                                onPressed: () {
                                  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>ChangePassword()));
                                },
                              ),
                            ),

                            SizedBox(height: 20.0),
                            Container(
                              decoration: ThemeHelper().buttonBoxDecoration(
                                  context),
                              child: ElevatedButton(
                                  style: ThemeHelper().buttonStyle(),
                                  child: Padding(
                                    padding: const EdgeInsets.fromLTRB(
                                        40, 10, 40, 10),
                                    child: Text(
                                      "Update".toUpperCase(),
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
}


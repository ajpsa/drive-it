import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:p1/authenticate/sign_in.dart';
import 'package:p1/services/auth.dart';
import 'package:p1/utils/loading.dart';
import 'package:p1/utils/utils.dart';
import 'sign_in.dart';
class Register extends StatefulWidget {

  // final Function toggleView;
  // Register({ required this.toggleView });

  @override
  _RegisterState createState() => _RegisterState();
}

class _RegisterState extends State<Register> {

  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;
  bool checkedValue = false;
  bool register = false;


  TextEditingController fname = new TextEditingController();
  TextEditingController phone = new TextEditingController();
  TextEditingController email = new TextEditingController();
  TextEditingController password = new TextEditingController();
  TextEditingController address = new TextEditingController();
  TextEditingController confirmpassword = new TextEditingController();

  late String txtname, txtphone, txtemail, txtpassword, txtplace, txtrole='';

  @override
  Widget build(BuildContext context) {
    return loading? Loading() : Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0.0,
        title: Text('Sign up to Drive-it'),
        actions: <Widget>[
          ElevatedButton.icon(
            icon: Icon(Icons.person), label: Text('Sign in'),
            onPressed: () {
              //widget.toggleView();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  SignIn()), (Route<dynamic> route) => false);
            },
          )
        ],
      ),
      body: SingleChildScrollView(
        child: Container(
            height:MediaQuery.of(context).size.height,
            width: MediaQuery.of(context).size.width,
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage("assets/images/wp.jpg"),
                fit: BoxFit.cover,
              ),
            ),
            padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
            child: Form(
              autovalidateMode: AutovalidateMode.always,
              key: _formkey,
              child: Column(
                children: <Widget>[
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: "Name"),
                    controller: fname,
                    onSaved: (value) {
                      txtname = value!;
                    },
                    keyboardType: TextInputType.text,
                    validator: (val){
                      if(val!.isEmpty)
                      {
                        return "Can't be empty.";
                      }
                      if(!(val.isEmpty) && !RegExp(r"(^[a-zA-Z][a-zA-Z\s]{0,20}[a-zA-Z]$)").hasMatch(val)){
                        return "Enter a valid Name";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: "Email"),
                    controller: email,
                    onSaved: (value) {
                      txtemail = value!;
                    },
                    validator: (val) {
                      if(val!.isEmpty)
                      {
                        return "Can't be empty.";
                      }
                      if(!(val.isEmpty) && !RegExp(r"^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+.[a-z]").hasMatch(val)){
                        return "Enter a valid email address";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: "Address"),
                    controller: address,
                    onSaved: (value) {
                      txtplace = value!;
                    },
                    validator: (val){
                      if(val!.isEmpty)
                      {
                        return "Can't be empty.";
                      }
                      if(!(val.isEmpty) && !RegExp(r"(^[a-zA-Z][a-zA-Z\s]{0,20}[a-zA-Z]$)").hasMatch(val)){
                        return "Enter a valid Address";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: "Phone no"),
                    controller: phone,
                    keyboardType: TextInputType.phone,
                    onSaved: (value) {
                      txtphone = value!;
                    },
                    validator: (val) {
                      if(val!.isEmpty)
                      {
                        return "Can't be empty.";
                      }
                      if(!(val.isEmpty) && !RegExp(r"^[0-9]{10}$").hasMatch(val)){
                        return "Enter a valid phone number";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: "Password"),
                    controller: password,
                    obscureText: true,
                    onSaved: (value) {
                      txtpassword = value!;
                    },
                    validator: (val) {
                      if(val!.isEmpty)
                      {
                        return "Can't be empty.";
                      }
                      if(!(val.isEmpty) && !RegExp(r"^(?=.*[A-Za-z])(?=.*\d)(?=.*[@$!%*#?&])[A-Za-z\d@$!%*#?&]{6,}$").hasMatch(val)){
                        return "include special character and numbers ";
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  TextFormField(
                    decoration: textInputDecoration.copyWith(hintText: "Confirm Password"),
                    controller: confirmpassword,
                    obscureText: true,
                    validator: (val){
                      if(val!.isEmpty)
                      {
                        return 'Please re-enter password';
                      }
                      print(password.text);
                      print(confirmpassword.text);
                      if(password.text!=confirmpassword.text){
                        return "Password does not match";
                      }

                      return null;
                    },
                  ),
                  SizedBox(height: 20.0),
                  DropdownButtonFormField(
                    decoration: InputDecoration(
                      labelText: 'SignUp as',
                      fillColor: Colors.white,
                      filled: true,
                      contentPadding: EdgeInsets.fromLTRB(20, 10, 20, 10),
                      focusedBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.grey)),
                      enabledBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.grey.shade400)),
                      errorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
                      focusedErrorBorder: OutlineInputBorder(borderRadius: BorderRadius.circular(100.0), borderSide: BorderSide(color: Colors.red, width: 2.0)),
                    ),
                    validator: (value) {
                      if (value == null) {
                        return "Select One";
                      }
                      return null;
                    },
                    value: txtrole.isNotEmpty ? txtrole : null,
                    items: <String>['User', 'Driver','Car Owner']
                        .map<DropdownMenuItem<String>>((String value)
                    {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),);
                    }).toList(),
                    onChanged: (value){
                      setState(() {
                        txtrole = value.toString();
                      });
                    },
                  ),
                  //
                  // SizedBox(height: 20.0),
                  //
                  // Padding(
                  //   padding: EdgeInsets.all(10),
                  //   child: register
                  //   ? CheckboxListTile(
                  //     title: RichText(
                  //       textAlign: TextAlign.left,
                  //       text: TextSpan(
                  //         children: [
                  //           TextSpan(
                  //             text:
                  //           "By creating an account, you agree to our ",
                  //           style: TextStyle(
                  //             color: const Color(0xffADA4A5),
                  //           ),
                  //         ),
                  //         WidgetSpan(
                  //           child: InkWell(
                  //             onTap: () {},
                  //             child: Text(
                  //               "Terms of Use and Privacy Notice",
                  //               style: TextStyle(
                  //                 color: const Color(0xffADA4A5),
                  //                 decoration:
                  //                 TextDecoration.underline,
                  //               ),
                  //             ),
                  //            ),
                  //           ),
                  //         ],
                  //       ),
                  //     ),
                  //     activeColor: const Color(0xff7B6F72),
                  //     value: checkedValue,
                  //     onChanged: (newValue) {
                  //       setState(() {
                  //         checkedValue = newValue!;
                  //       });
                  //     },
                  //     controlAffinity:
                  //     ListTileControlAffinity.leading,
                  //   )
                  // ),


                  SizedBox(height: 20.0),
                  ElevatedButton(
                      style: ButtonStyle(
                          backgroundColor: MaterialStateProperty.all(Colors.red)
                      ),
                      child: Text(
                        'Register',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {
                        try{
                        if(_formkey.currentState!.validate()) {
                          _formkey.currentState!.save();
                          signUp();
                        }}catch(e){
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
                  SizedBox(height: 12.0),
                  Text.rich(
                      TextSpan(
                          children: [
                            TextSpan(text: "Already have an account? "),
                            TextSpan(
                              text: 'Sign in',
                              recognizer: TapGestureRecognizer()
                                ..onTap = (){
                                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                                      SignIn()), (Route<dynamic> route) => false);
                                },
                              style: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                            ),
                          ]
                      )
                  ),
                  // SizedBox(height: 12.0),
                  // Text(
                  //   error,
                  //   style: TextStyle(color: Colors.red,fontSize: 14.0),
                  // )
                ],
              ),
            )
        ),
      )
    );
  }

  void signUp() async {
    try{
      final auth = FirebaseAuth.instance;
      final result = await auth.createUserWithEmailAndPassword(email: txtemail, password: txtpassword).then((value) {
        FirebaseFirestore.instance.collection('userDetails').doc(value.user?.uid).set(
            {
              "email" : value.user?.email,
              "name" : txtname,
              "phone": txtphone,
              "address" : txtplace,
              "role" : txtrole,
              "profilepicURL": 'http://assets.stickpng.com/images/585e4bf3cb11b227491c339a.png',
              "status": 'online'
            });
      });
      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>SignIn()));
    } catch (e){
      print(e);
      Fluttertoast.showToast(msg: e.toString());
    }
  }
}

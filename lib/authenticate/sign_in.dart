import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:p1/authenticate/authenticate.dart';
import 'package:p1/authenticate/authpending.dart';
import 'package:p1/screens/admin/adviewcar.dart';
import 'package:p1/screens/cars_overview.dart';
import 'package:p1/screens/driverscreen/driverhome.dart';
import 'package:p1/screens/UserViewCar.dart';
import 'package:p1/services/auth.dart';
import 'package:p1/utils/loading.dart';
import 'package:p1/utils/utils.dart';
import '../screens/admin/topdeals.dart';
import '../screens/car_owner/car_owner_home.dart';
import 'register.dart';
import 'package:p1/authenticate/reset.dart';
class EmailFieldValidator {
  static String? validate(String value) {
    if (value!.length == 0) {
      return "Email cannot be empty";
    }
    if (!RegExp(
        r"^([A-Za-z0-9_\-\.])+\@([A-Za-z0-9_\-\.])+\.([A-Za-z]{2,4})$")
        .hasMatch(value)) {
      return ("Please enter a valid email");
    }else {
      return null;
    }
  }
}

class PasswordFieldValidator {
  static String? validate(String value) {
    RegExp regex = new RegExp(r'^.{6,}$');
    if (value!.isEmpty) {
      return "Password cannot be empty";
    }
    if (!regex.hasMatch(value)) {
      return ("please enter valid password min. 6 character");
    }else {
      return null;
    }
  }
}

class SignIn extends StatefulWidget {

  // final Function toggleView;
  // SignIn({ required this.toggleView });

  @override
  _SignInState createState() => _SignInState();
}

class _SignInState extends State<SignIn> {

  final AuthService _auth = AuthService();
  final _formkey = GlobalKey<FormState>();
  bool loading = false;

  //final dbRef = FirebaseDatabase.instance.ref().child('userDetails');
  final fire = FirebaseFirestore.instance.collection('userDetails');
  String role = '';
  String status = '';

  //text field state
  String email = '';
  String password = '';
  String error = '';

  @override
  Widget build(BuildContext context) {
    return loading ? Loading() : Scaffold(
      backgroundColor: Colors.blueAccent,
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        elevation: 0.0,
        title: Text('Sign in to Drive-it'),
        actions: <Widget>[
          ElevatedButton.icon(
            icon: Icon(Icons.person), label: Text('Register'),
            onPressed: () {
              //widget.toggleView();
              Navigator.of(context).push(new MaterialPageRoute(
                  builder: (BuildContext context) => Register()));
            },
          )
        ],
      ),
      body: SingleChildScrollView(
          child: Container(
              height:MediaQuery.of(context).size.height*0.897,
              width: MediaQuery.of(context).size.width,
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage("assets/images/wp.jpg"),
                  fit: BoxFit.cover,
                ),
              ),
              padding: EdgeInsets.symmetric(vertical: 20.0, horizontal: 50.0),
              child: Form(
                key: _formkey,
                autovalidateMode: AutovalidateMode.always,
                child: Column(
                  children: <Widget>[
                    SizedBox(height: 50),
                    Image.asset("assets/images/splash.png"),
                    SizedBox(height: 50.0),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: "Email"),
                      // validator: (val) =>
                      // val!.isEmpty
                      //     ? 'Enter an Email'
                      //     : null,
                      validator:(value)=> EmailFieldValidator.validate(value!),
                      onChanged: (val) {
                        setState(() => email = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    TextFormField(
                      decoration: textInputDecoration.copyWith(
                          hintText: "Password"),
                      obscureText: true,
                      // validator: (val) =>
                      // val!.length < 6
                      //     ? 'Enter a password 6+ characters long'
                      //     : null,
                      validator:(value)=> PasswordFieldValidator.validate(value!),
                      onChanged: (val) {
                        setState(() => password = val);
                      },
                    ),
                    SizedBox(height: 20.0),
                    ElevatedButton(
                      style: ButtonStyle(
                        backgroundColor: MaterialStateProperty.all(Colors.red),
                      ),
                      child: Text(
                        'Sign in',
                        style: TextStyle(color: Colors.white),
                      ),
                      onPressed: () async {

                        if (_formkey.currentState!.validate()) {
                          setState(() => loading = true);
                          try {
                            UserCredential userCredential = await FirebaseAuth.instance
                                .signInWithEmailAndPassword(email: email, password: password);
                            _checkRole();
                          } on FirebaseAuthException catch (e) {
                            setState(() {
                              loading = false;
                            });
                            Fluttertoast.showToast(msg: e.toString());
                            if (e.code == 'user-not-found') {
                              print("No user found with this email");

                              Fluttertoast.showToast(
                                msg: "No user found with this email",
                              );
                            } else if (e.code == 'wrong-password') {
                              print("You have entered the Wrong Password");

                              Fluttertoast.showToast(
                                msg: "You have entered the Wrong Password",
                              );
                            }
                          }
                        }
                        else
                          loading=false;
                      },
                    ),
                    SizedBox(height: 20.0),
                    Text.rich(
                        TextSpan(
                            children: [
                              TextSpan(
                                text: "Forgot password ? ",
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => ResetScreen()));
                                  },
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ]
                        )
                    ),
                    SizedBox(height: 20.0),
                    Text.rich(
                        TextSpan(
                            children: [
                              TextSpan(text: "Don\'t have an account? "),
                              TextSpan(
                                text: 'Register',
                                recognizer: TapGestureRecognizer()
                                  ..onTap = () {
                                    Navigator.push(context, MaterialPageRoute(
                                        builder: (context) => Register()));
                                  },
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, color: Colors.white),
                              ),
                            ]
                        )
                    ),
                  ],
                ),
              )
          )
      ),
    );
  }


  void _checkRole() async {
    User? user = FirebaseAuth.instance.currentUser;
    final DocumentSnapshot snap = await FirebaseFirestore.instance.collection(
        'userDetails').doc(user?.uid).get();

    setState(() {
      role = snap['role'];
      status = snap['status'];
    });
    if (status == 'Online') {
      if (role == 'User') {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) => UserViewCar()));
      } else if (role == 'Admin') {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) => Adviewcar()));
      } else if (role == 'Driver') {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) => DriverHome()));
      } else if (role == 'Car Owner') {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) => CarOwnerHome()));
      }
      }else if (
          status=='online'
        ){
      if (role == 'User') {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) => UserViewCar()));

      }  else if (role == 'Driver') {
        Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (BuildContext context) => auth()), (Route<dynamic> route) => false);
        Fluttertoast.showToast(msg: "verification pending");

      } else if (role == 'Car Owner') {
        Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (BuildContext context) => auth()), (Route<dynamic> route) => false);
        Fluttertoast.showToast(msg: "verification pending");
      }}
    else if (
    status=='pending'
    ){
      if (role == 'User') {
        Navigator.of(context).push(new MaterialPageRoute(
            builder: (BuildContext context) => UserViewCar()));

      }  else if (role == 'Driver') {
        Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (BuildContext context) => authPending()), (Route<dynamic> route) => false);
        Fluttertoast.showToast(msg: "verification pending");

      } else if (role == 'Car Owner') {
        Navigator.of(context).pushAndRemoveUntil(new MaterialPageRoute(builder: (BuildContext context) => authPending()), (Route<dynamic> route) => false);
        Fluttertoast.showToast(msg: "verification pending");
      }}
    else{
      loading = false;
      Fluttertoast.showToast(
        msg: "You are not authorized to login, please contact admin",
      );
    }
  }
}
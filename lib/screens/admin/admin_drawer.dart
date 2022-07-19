import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p1/screens/admin/View_ComplaintsComp.dart';
import 'package:p1/screens/admin/View_complaints.dart';
import 'package:p1/screens/admin/addcar.dart';
import 'package:p1/screens/admin/adviewcar.dart';
import 'package:p1/screens/admin/allorders.dart';
import 'package:p1/screens/admin/authmod.dart';
import 'package:p1/screens/admin/chatpage.dart';
import 'package:p1/screens/admin/topdeals.dart';
import 'package:p1/screens/admin/viewdriver.dart';
import 'package:p1/screens/admin/viewdriversblock.dart';
import 'package:p1/screens/admin/viewdriversonline.dart';
import 'package:p1/screens/admin/viewprice.dart';
import 'package:p1/screens/admin/viewuser.dart';
import 'package:p1/authenticate/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:p1/screens/admin/viewusersblock.dart';
import 'package:p1/screens/admin/viewusersonline.dart';
import 'admin_profile.dart';
import 'chatpage.dart';


class AdminDrawer extends StatefulWidget {
  @override
  _AdminDrawerState createState() => _AdminDrawerState();
}
class _AdminDrawerState extends State<AdminDrawer> {
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;
  String? userName;
  String? userPlace;
  String? userPhone;
  String? email;
  String imageUrl = 'https://www.flaticon.com/free-icon/user_149071';
  // final CollectionReference userref =
  // FirebaseFirestore.instance.collection('userDetails');

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('userDetails')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc['email'] == _user?.email) {
          setState(() {
            email = doc['email'];
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
    return Drawer(
      backgroundColor: Colors.blue[100],
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.tealAccent, Colors.lightBlueAccent])),
        child: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: Column(
            children: <Widget>[
              AppBar(
                title: Text('Drive-it '),
                automaticallyImplyLeading: false,
              ),
              // Container(
              //   child: Card(
              //
              //   ),
              // ),

              // Text("Admin",
              //     style: TextStyle(
              //       color: Colors.black,
              //       fontSize: 25,
              //       fontWeight: FontWeight.bold,
              //       backgroundColor: Colors.blue
              //     )),
              //SizedBox(height: 10,),
              ListTile(
                //tileColor: Colors.blue[200],
                // leading: Text(''),
                leading: CircleAvatar(
                  radius: 40,
                  backgroundColor: Colors.blue,
                  backgroundImage: NetworkImage(imageUrl),
                ),
                title: Text( "Admin\n" '$userName \n$email' , style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold),),

                onTap: () {
                },
                // trailing: IconButton(
                //   icon: Icon(Icons.person),
                //   onPressed: () {
                //     Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>ProfileView()));
                //   },
                // ),
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.home,color: Colors.blue),
                title: Text('Home'),
                onTap: () {
                  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>Adviewcar()));
                },
              ),
              Divider(),
              ExpansionTile(
                leading: Icon(Icons.groups,color: Colors.blue),
                title: Text('View Users'),
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.groups_outlined,color: Colors.blue),
                    title: Text('All Users'),
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>ViewUsers()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.done_outline,color: Colors.blue),
                    title: Text('Online'),
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>ViewUserson()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.block,color: Colors.blue),
                    title: Text('Blocked'),
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>ViewUsersblocked()));
                    },
                  ),
                ],
              ),
              Divider(),
              ExpansionTile(
                leading: Icon(Icons.groups,color: Colors.blue),
                title: Text('View Drivers'),
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.groups_outlined,color: Colors.blue),
                    title: Text('All Drivers'),
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>ViewDrivers()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.done_outline,color: Colors.blue),
                    title: Text('Online'),
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>Viewdriverson()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.block,color: Colors.blue),
                    title: Text('Blocked'),
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>Viewdriversblocked()));
                    },
                  ),
                ],
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.verified_user_outlined,color: Colors.blue),
                title: Text('Verify'),
                onTap: () {
                  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>Authmod()));
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.price_check,color: Colors.blue),
                title: Text('Check Car Price'),
                onTap: () {
                  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>ViewpriceScreen()));
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.bookmark_border,color: Colors.blue),
                title: Text('View orders'),
                onTap: () {
                  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>allOrders()));
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.chat,color: Colors.blue),
                title: Text('General Discussions'),
                onTap: () {
                  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>chatpage(email: email)));
                },
              ),
              Divider(),
              ExpansionTile(
                leading: Icon(Icons.warning_amber,color: Colors.blue),
                title: Text('Complaints'),
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.warning_amber_outlined,color: Colors.blue),
                    title: Text('View Complaints'),
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>ViewComplaints()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.done,color: Colors.blue),
                    title: Text('Completed Complaints'),
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>ViewCCs()));
                    },
                  ),
                ],
              ),
              // Divider(),
              // ListTile(
              //   leading: Icon(Icons.directions_car,color: Colors.blue),
              //   title: Text('Add Cars'),
              //   onTap: () {
              //     Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>addcar()));
              //   },
              // ),
              Divider(),
              ListTile(
                  leading: Icon(Icons.edit,color: Colors.blue),
                  title: Text('Profile'),
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                        AdprofileView()), (Route<dynamic> route) => false);
                    // Navigator.push(
                    //   context,
                    //   MaterialPageRoute(
                    //     builder: (context) =>  (),
                    //   ),
                    // );
                    // Navigator.of(context).pushNamed(EditProfile.routeName );
                    //Navigator.of(context).push(MaterialPageRoute(builder:(context)=>ProfileCard(authData.userId,authData.token)));
                  }
              ),


              Divider(),
              ListTile(
                leading: Icon(Icons.exit_to_app,color: Colors.blue),
                title: Text('LogOut'),
                onTap: () async {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      SignIn()), (Route<dynamic> route) => false);
                  ModalRoute.withName('/');
                },
              ),
              Divider(),
            ],
          ),
        ),
      ),
    );
  }
}
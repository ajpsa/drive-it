import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p1/screens/driverscreen/completedjobs.dart';
import 'package:p1/screens/driverscreen/driverhome.dart';
import 'package:p1/screens/driverscreen/Drprofile_view.dart';
import 'package:p1/authenticate/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:p1/screens/driverscreen/pending.dart';
import 'package:p1/screens/driverscreen/takejobs.dart';

class DriverDrawer extends StatefulWidget {
  @override
  _DriverDrawerState createState() => _DriverDrawerState();
}
class _DriverDrawerState extends State<DriverDrawer> {
  //final FirebaseAuth _auth = FirebaseAuth.instance;
  //final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;
  String? userName;
  String? userPlace;
  String? userPhone;
  String? email;
  String imageUrl = 'https://www.flaticon.com/free-icon/user_149071';

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
      backgroundColor: Colors.blue[200],
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                //colors: [Colors.pink, Colors.deepOrangeAccent])),
                colors: [Colors.greenAccent, Colors.blueAccent])),
        child: Column(
          children: <Widget>[
            AppBar(
              title: Text('Drive-it '),  //(+ name != null ? name : 'Friend'),
              automaticallyImplyLeading: false,
            ),
            //Divider(),
            Container(
              child: Card(

              ),
            ),
            ListTile(
              tileColor: Colors.transparent,
              // leading: Text(''),
              leading: CircleAvatar(
                radius: 40,
                backgroundColor: Colors.transparent,
                backgroundImage: NetworkImage(imageUrl),
              ),
              title: Text('$userName \n$email' , style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold),),

              onTap: () {
              },
              // trailing: IconButton(
              //   icon: Icon(Icons.person),
              //   onPressed: () {
              //     Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>ProfileView()));
              //   },
              // ),
            ),
            ListTile(
              leading: Icon(Icons.home,color: Colors.blue),
              title: Text('Home'),
              onTap: () {
                Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>DriverHome()));
              },
            ),
            Divider(),
            ExpansionTile(
              leading: Icon(Icons.work,color: Colors.blue),
              title: Text('Jobs'),
              children: <Widget>[
                ListTile(
                  leading: Icon(Icons.request_page,color: Colors.blue),
                  title: Text('Requests'),
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>TakeJobs()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.pending,color: Colors.blue),
                  title: Text('Pending'),
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>Pending()));
                  },
                ),
                ListTile(
                  leading: Icon(Icons.done,color: Colors.blue),
                  title: Text('Completed'),
                  onTap: () {
                    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>CompletedJobs()));
                  },
                ),
              ],
            ),
            Divider(),
            ListTile(
                leading: Icon(Icons.edit,color: Colors.blue),
                title: Text('Profile'),
                onTap: () {
                  Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                      DrprofileView()), (Route<dynamic> route) => false);
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
    );
  }
}
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p1/screens/BkDriverReq.dart';
import 'package:p1/screens/UserViewCar.dart';
import 'package:p1/screens/bkdriverpending.dart';
import 'package:p1/screens/book_driver.dart';
import 'package:p1/screens/cars_overview.dart';
import 'package:p1/screens/chatpage.dart';
import 'package:p1/screens/complaint.dart';
import 'package:p1/screens/orderspage.dart';
import 'package:p1/screens/paymentcar.dart';
import 'package:p1/screens/profile_view.dart';
import 'package:p1/screens/review.dart';
import 'package:p1/screens/reviewedit.dart';
import 'package:p1/screens/user_completedjobs.dart';
import 'package:p1/screens/viewreview.dart';
import '../authenticate/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';

import 'order_history.dart';

class AppDrawer extends StatefulWidget {
  @override
  _AppDrawerState createState() => _AppDrawerState();
}
  class _AppDrawerState extends State<AppDrawer> {
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
                colors: [Colors.tealAccent, Colors.lightBlueAccent])),
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              AppBar(
                title: Text('Drive-it '),  //(+ name != null ? name : 'Friend'),
                automaticallyImplyLeading: false,
              ),
              Divider(),
              Container(
                child: Card(

                ),
              ),
              ListTile(
                //tileColor: Colors.transparent,
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
                  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>UserViewCar()));
                },
              ),
              Divider(),
              ExpansionTile(
                leading: Icon(Icons.book,color: Colors.blue),
                title: Text('Bookings'),
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.book_online,color: Colors.blue),
                    title: Text('My Bookings'),
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>ordersPage()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.book_online,color: Colors.blue),
                    title: Text('payment'),
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>PaymentCarPage()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.done,color: Colors.blue),
                    title: Text('Order History'),
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>ordersHistoryPage()));
                    },
                  ),
                ],
              ),
              Divider(),
              ExpansionTile(
                leading: Icon(Icons.book,color: Colors.blue),
                title: Text('Book Drivers'),
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.request_page,color: Colors.blue),
                    title: Text('Request Driver'),
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>BookDrivers()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.request_page_outlined,color: Colors.blue),
                    title: Text('My Requests'),
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>BkDriverReq()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.pending,color: Colors.blue),
                    title: Text('Pending'),
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>BkDriverPending()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.done,color: Colors.blue),
                    title: Text('Completed'),
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>UserCompletedJobs()));
                    },
                  ),
                ],
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
                leading: Icon(Icons.reviews,color: Colors.blue),
                title: Text('Reviews'),
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.reviews_rounded,color: Colors.blue),
                    title: Text('View all Reviews'),
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>ViewReviews()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.pending,color: Colors.blue),
                    title: Text('Write a Review'),
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>Reviews()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.delete_forever,color: Colors.blue),
                    title: Text('Delete Review'),
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>reviewEdit()));
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
                        ProfileView()), (Route<dynamic> route) => false);
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
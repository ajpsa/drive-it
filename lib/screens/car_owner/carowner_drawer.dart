import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:p1/screens/admin/viewprice.dart';
import 'package:p1/authenticate/sign_in.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:p1/screens/car_owner/bill.dart';
import 'package:p1/screens/car_owner/car_owner_home.dart';
import 'package:p1/screens/car_owner/carowner_profle.dart';
import 'package:p1/screens/car_owner/chargebill.dart';
import 'package:p1/screens/car_owner/co_addcar.dart';
import 'package:p1/screens/car_owner/completedorders.dart';
import 'package:p1/screens/car_owner/viewcar.dart';


class CarownDrawer extends StatefulWidget {
  @override
  _CarownDrawerState createState() => _CarownDrawerState();
}
class _CarownDrawerState extends State<CarownDrawer> {
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
      backgroundColor: Colors.blue[100],
      child: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.lightBlueAccent, Colors.cyan])),
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
                title: Text( "Car owner\n" '$userName \n$email' , style: TextStyle( fontSize: 18, fontWeight: FontWeight.bold),),

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
                  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>CarOwnerHome()));
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.directions_car,color: Colors.blue),
                title: Text('Add Cars'),
                onTap: () {
                  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>coaddcar()));
                },
              ),
              Divider(),
              ListTile(
                leading: Icon(Icons.directions_car_filled_outlined,color: Colors.blue),
                title: Text('View Cars'),
                onTap: () {
                  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>Viewcar()));
                },
              ),
              Divider(),
              ExpansionTile(
                leading: Icon(Icons.work,color: Colors.blue),
                title: Text('My bookings'),
                children: <Widget>[
                  ListTile(
                    leading: Icon(Icons.book_rounded,color: Colors.blue),
                    title: Text('bookings'),
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>chargePage()));
                    },
                  ),
                  ListTile(
                    leading: Icon(Icons.done,color: Colors.blue),
                    title: Text('Completed'),
                    onTap: () {
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>CompletedOrders()));
                    },
                  ),
                ],
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
                  leading: Icon(Icons.edit,color: Colors.blue),
                  title: Text('Profile'),
                  onTap: () {
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                        CarownprofileView()), (Route<dynamic> route) => false);
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
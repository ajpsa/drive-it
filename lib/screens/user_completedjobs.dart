import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:p1/screens/drawer.dart';
import 'package:p1/screens/driverrating.dart';

class UserCompletedJobs extends StatefulWidget {
  const UserCompletedJobs({Key? key}) : super(key: key);

  @override
  _UserCompletedJobsState createState() => _UserCompletedJobsState();
}

class _UserCompletedJobsState extends State<UserCompletedJobs> {
  final CollectionReference dataref =
  FirebaseFirestore.instance.collection('driverReq');
  final User? _user = FirebaseAuth.instance.currentUser;
  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  // final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String? userName;
  String? userPlace;
  //String? userPhone = '';
  String? email;
  String? workk;
  String? docid;
  String imageUrl = 'assets/images/profile.jpg';

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('userDetails')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc['email'] == user?.email) {
          setState(() {
            email = doc['email'];
            userName = doc['name'];
            userPlace = doc['place'];
            //userPhone = doc['phone'];
            imageUrl = doc['profilepicURL'];
          });
        }
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Completed Jobs",textAlign: TextAlign.center),
      ),
      body: Container(
        height:MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [Colors.greenAccent, Colors.blue])),
        child: StreamBuilder(
          stream: dataref.where("status",isEqualTo:"completed").where('user email',isEqualTo: _user?.email).snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
                  final date = documentSnapshot['req date'];
                  final address = documentSnapshot['location'];
                  final instructions = documentSnapshot['suggestions'];
                  final drivername = documentSnapshot['driver_name'];
                  final fd = documentSnapshot['fromdate'];
                  final td = documentSnapshot['todate'];
                  final dphone = documentSnapshot['driver_phone'];
                  final id = _user?.uid;
                  final did = documentSnapshot['driver_id'];
                  final demail = documentSnapshot['driver_email'];
                  final cd = documentSnapshot['completed_date'];
                  final docid = documentSnapshot.id;
                  return Container(
                    child: Container(
                      width: 100,
                      child: Column(
                        children: [
                          ListView(
                            shrinkWrap: true,
                            children: <Widget>[
                              Padding(
                                padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
                                child: ListTile(
                                  tileColor: Colors.white,
                                  textColor: Colors.black,
                                  title: Text("Driver : $drivername \nEmail : $demail \nlocation : $address \nFrom: $fd \t To: $td \nDate : $date \nInstructions : $instructions \ncompleted date : $cd",
                                    style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                                  subtitle: Row(
                                    children: <Widget>[
                                    ],
                                  ),
                                ),

                              ),
                            ],
                          ),
                          ElevatedButton(
                              onPressed: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=>DriverRating(did)));
                          },
                              child: Text("Rating"))
                        ],
                      ),
                    ),
                  );
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
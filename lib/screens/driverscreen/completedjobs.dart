import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:p1/screens/driverscreen/driver_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class CompletedJobs extends StatefulWidget {
  const CompletedJobs({Key? key}) : super(key: key);

  @override
  _CompletedJobsState createState() => _CompletedJobsState();
}

class _CompletedJobsState extends State<CompletedJobs> {
  final CollectionReference dataref =
  FirebaseFirestore.instance.collection('driverReq');
  final User? _user = FirebaseAuth.instance.currentUser;
  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? userName;
  String? userPlace;
  //String? userPhone = '';
  String? email;
  String? docid;
  String imageUrl = 'assets/images/profile.jpg';
  String cd = '${DateTime.now().day}-${DateTime.now().month}-${DateTime.now().year}';

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
            userPlace = doc['address'];
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
        decoration: BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomCenter,
                colors: [Colors.greenAccent, Colors.blue])),
        child: StreamBuilder(
          stream: dataref.where("status",isEqualTo: "completed").where('driver_email',isEqualTo: _user?.email).snapshots(),
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
                  final username = documentSnapshot['user name'];
                  final fd = documentSnapshot['fromdate'];
                  final td = documentSnapshot['todate'];
                  final cd = documentSnapshot['completed_date'];
                  //final phone = documentSnapshot['user phone'];
                  final id = _user?.uid;
                  //final uemail = documentSnapshot['user email'];
                  //final docid = documentSnapshot.id;
                  return Container(
                    child: Container(
                      width: 100,
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
                            child: ListTile(
                              shape: Border.all(style: BorderStyle.solid),
                              tileColor: Colors.white,
                              textColor: Colors.black,
                              title: Text("User : $username \nAddress : $address \nFrom: $fd \t To: $td \nDate : $date \nInstructions : $instructions \ncompleted date: $cd",
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                            ),
                          ),
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
      drawer: DriverDrawer(),
    );
  }
}
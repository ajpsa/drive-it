import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:p1/screens/complaint.dart';
import 'package:p1/screens/drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class BkDriverPending extends StatefulWidget {
  const BkDriverPending({Key? key}) : super(key: key);

  @override
  _BkDriverPendingState createState() => _BkDriverPendingState();
}

class _BkDriverPendingState extends State<BkDriverPending> {
  final CollectionReference dataref =
  FirebaseFirestore.instance.collection('driverReq');
  final User? _user = FirebaseAuth.instance.currentUser;
  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? userName;
  String? userPlace;
  //String? userPhone = '';
  String? email;
  String? workk;
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
            userPlace = doc['place'];
            //userPhone = doc['phone'];
            imageUrl = doc['profilepicURL'];
            workk = doc['profession'];
          });
        }
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Ongoing",textAlign: TextAlign.center),
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
          stream: dataref.where("status",isEqualTo: "ongoing").where('user email',isEqualTo: _user?.email).snapshots(),
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
                  final demail = documentSnapshot['driver_email'];
                  docid = documentSnapshot.id;
                  return Container(
                    child: Container(
                      width: 100,
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
                            child: ListTile(
                              tileColor: Colors.white,
                              textColor: Colors.black,
                              title: Text("Driver : $drivername \nDriver Email: $demail \nLocation : $address \nFrom: $fd \t To: $td \nReq Date : $date \nInstructions : $instructions",
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                              subtitle: Row(
                                children: <Widget>[

                                  Expanded(
                                    child: Row(
                                      children: [
                                        FlatButton(
                                          minWidth: 150,
                                          color: Colors.blue,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4.0)),
                                          onPressed: () => launch("tel://$dphone"),
                                          child: Column(
                                            children: <Widget>[
                                              Icon(Icons.call),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 2.0),
                                              ),
                                              Text('Phone $drivername'),
                                            ],
                                          ),
                                        ),
                                        FlatButton(
                                          minWidth: 150,
                                          color: Colors.redAccent,
                                          shape: RoundedRectangleBorder(
                                              borderRadius: BorderRadius.circular(4.0)),
                                          onPressed: () {
                                            Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>Complaint(drivername,demail)));
                                          },
                                          child: Column(
                                            children: <Widget>[
                                              Icon(Icons.report_problem_outlined),
                                              Padding(
                                                padding: const EdgeInsets.symmetric(vertical: 2.0),
                                              ),
                                              Text('Complaint'),
                                            ],
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),),
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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

import 'admin_drawer.dart';

class Authmod extends StatefulWidget {
  const Authmod({Key? key}) : super(key: key);


  @override
  _AuthmodState createState() => _AuthmodState();
}

class _AuthmodState extends State<Authmod> {
  final CollectionReference userref =
  FirebaseFirestore.instance.collection('userDetails');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Text("Unverified Drivers",textAlign: TextAlign.center),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/wp.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder(
          stream: userref.where('status',isEqualTo: 'pending').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
                  final name = documentSnapshot['name'];
                  final address = documentSnapshot['address'];
                  final phone = documentSnapshot['phone'];
                  final email = documentSnapshot['email'];
                  final status = documentSnapshot['status'];
                  final license = documentSnapshot['license'];
                  final role = documentSnapshot['role'];
                  final aadhaar = documentSnapshot['aadhaar'];
                  final id = documentSnapshot.id;
                  return Card(
                      color: Colors.blue[200],
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),shadowColor: Colors.white,
                      margin: const EdgeInsets.all(20),
                      child:Column(
                          children: [
                            Container(
                              height: 160,
                              // width: 250,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.only(
                                  topRight: Radius.circular(25),
                                ),
                                // border: Border.all(color: Colors.black)
                              ),
                              child: Image.network(license),
                            ),
                            Container(
                              width: 350,decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(5)),
                              child: Center(
                                child: Text("Role : $role \naadhaar number: $aadhaar "
                                    "\nName : $name \nAddress : $address \nPhone number: $phone \nEmail : $email \nStatus: $status",
                                  style: TextStyle(fontSize: 16,color: Colors.black),),
                              ),
                            ),
                            ElevatedButton(
                                onPressed: (){
                                  auth(id);
                                },
                                child: Text("Verify")),
                            SizedBox(height: 15),
                          ]
                      )
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
      drawer: AdminDrawer(),
    );
  }
  void auth(id) async {
    try {
      FirebaseFirestore.instance.collection('userDetails').doc(id).update({
        "status" : 'Online',
      });
    } catch(e){}
  }
}
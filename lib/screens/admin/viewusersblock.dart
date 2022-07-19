import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'admin_drawer.dart';

class ViewUsersblocked extends StatefulWidget {
  const ViewUsersblocked({Key? key}) : super(key: key);


  @override
  _ViewUsersblockedState createState() => _ViewUsersblockedState();
}

class _ViewUsersblockedState extends State<ViewUsersblocked> {
  final CollectionReference userref =
  FirebaseFirestore.instance.collection('userDetails');
  final FirebaseAuth _auth = FirebaseAuth.instance;
  @override

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Text("Users Blocked",textAlign: TextAlign.center),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/wp.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder(
          stream: userref.where('role',isEqualTo: 'User').where('status',isEqualTo: 'Blocked').snapshots(),
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
                  final pic = documentSnapshot['profilepicURL'];
                  final id = documentSnapshot.id;
                  if(streamSnapshot.data!.docs.length == 0){
                    setState(() {
                      String blah = "No Data Found";
                    });
                  }
                  return Card(
                    margin: const EdgeInsets.all(10),
                    child: ListTile(
                      leading: FadeInImage.assetNetwork(placeholder: 'assets/images/profile.jpg', image: '$pic'),
                      title: Text("Name : $name \nAddress : $address \nPhone number: $phone \nEmail : $email \nStatus: $status"),
                      tileColor: Colors.blue[200],
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                        side: BorderSide(color: Colors.black),
                      ),


                      subtitle: Row(
                        children: <Widget>[

                          Expanded(
                              child: ElevatedButton(
                                  onPressed: () {
                                    unblock(id);
                                  },
                                  style: ButtonStyle(
                                    backgroundColor: MaterialStateProperty.all(Colors.green),
                                  ),
                                  child: Text("Unblock", style: TextStyle(color: Colors.white),)
                              )
                          ),

                        ],
                      ),
                    ),
                  );
                },
              );
            }
            else
              return Container(
                child: Text(
                  "No Users Blocked! \n No Bad Eggs in the world today.",
                  style: TextStyle(
                    color: Colors.black54,
                    fontSize: 40,
                  ),
                ),
              );
          },
        ),
      ),

      drawer: AdminDrawer(),
    );
  }

  void unblock(id) async {
    try {

      FirebaseFirestore.instance.collection('userDetails').doc(id).update({
        "status" : 'Online',
      });
    } catch(e){}
  }
}

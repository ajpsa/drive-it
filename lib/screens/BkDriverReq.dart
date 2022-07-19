import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:p1/screens/drawer.dart';

class BkDriverReq extends StatefulWidget {
  const BkDriverReq({Key? key}) : super(key: key);

  @override
  _BkDriverReqState createState() => _BkDriverReqState();
}

class _BkDriverReqState extends State<BkDriverReq> {
  final CollectionReference dataref =
  FirebaseFirestore.instance.collection('driverReq');
  final User? _user = FirebaseAuth.instance.currentUser;
  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? userName;
  String? userPlace;
  String? userPhone;
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
            userPhone = doc['phone'];
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
        title: Text("My Requests",textAlign: TextAlign.center),
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
          stream: dataref.where("status",isEqualTo: "pending").where('user email',isEqualTo: _user?.email).snapshots(),
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
                  final phone = documentSnapshot['user phone'];
                  final id = _user?.uid;
                  final uemail = documentSnapshot['user email'];
                  final docid = documentSnapshot.id;
                  return Container(
                    child: Container(
                      width: 100,
                      child: ListView(
                        shrinkWrap: true,
                        children: <Widget>[
                          SizedBox(height: 15),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
                            child: ListTile(
                              tileColor: Colors.red,
                              textColor: Colors.black,
                              title: Text("User : $username \nEmail: $uemail \nPhone : $phone \nAddress : $address \nFrom: $fd \t To: $td \nDate : $date \nInstructions : $instructions",
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                              subtitle: Row(
                                children: <Widget>[

                                  Expanded(
                                      child: ElevatedButton(
                                          onPressed: () {
                                            //delete(docid);
                                            showAlertDialog(context,docid);
                                          },
                                          style: ButtonStyle(
                                            backgroundColor: MaterialStateProperty.all(Colors.red),
                                          ),
                                          child: Text("Cancel Request", style: TextStyle(color: Colors.white),)
                                      )
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
  void delete(docid) async {
    try {
      FirebaseFirestore.instance.collection('driverReq').doc(docid).delete();
      Fluttertoast.showToast(msg: "Request succesfully deleted");
    } catch(e){}
  }
  showAlertDialog(BuildContext context,docid) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("Cancel"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Continue"),
      onPressed:  () {
        delete(docid);
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm"),
      content: Text("Are you sure that you want to delete the Request? "),
      actions: [
        cancelButton,
        continueButton,
      ],
    );

    // show the dialog
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }
}
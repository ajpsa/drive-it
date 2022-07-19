import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:p1/screens/driverscreen/driver_drawer.dart';
import 'package:url_launcher/url_launcher.dart';

class Pending extends StatefulWidget {
  const Pending({Key? key}) : super(key: key);

  @override
  _PendingState createState() => _PendingState();
}

class _PendingState extends State<Pending> {
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
        title: Text("Taken Jobs",textAlign: TextAlign.center),
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
          stream: dataref.where("status",isEqualTo: "ongoing").where('driver_email',isEqualTo: _user?.email).snapshots(),
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
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20.0,vertical: 20),
                            child: ListTile(
                              shape: Border.all(style: BorderStyle.solid),
                              tileColor: Colors.white,
                              textColor: Colors.black,
                              title: Text("User : $username \nAddress : $address \nFrom: $fd \t To: $td \nDate : $date \nInstructions : $instructions",
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                              subtitle: Row(
                                children: <Widget>[

                                  Expanded(
                                      child: Column(
                                        children: [
                                          FlatButton(
                                            minWidth: 150,
                                            color: Colors.green,
                                            shape: RoundedRectangleBorder(
                                                borderRadius: BorderRadius.circular(4.0)),
                                            onPressed: () => launch("tel://$phone"),
                                            child: Column(
                                              children: <Widget>[
                                                Icon(Icons.call),
                                                Padding(
                                                  padding: const EdgeInsets.symmetric(vertical: 2.0),
                                                ),
                                                Text('Phone $username'),
                                              ],
                                            ),
                                          ),
                                          // FlatButton(
                                          //   minWidth: 150,
                                          //   color: Colors.redAccent,
                                          //   shape: RoundedRectangleBorder(
                                          //       borderRadius: BorderRadius.circular(4.0)),
                                          //   onPressed: () {
                                          //     //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>Complaint(workername,workeremail,work)));
                                          //   },
                                          //   child: Column(
                                          //     children: <Widget>[
                                          //       Icon(Icons.report_problem_outlined),
                                          //       Padding(
                                          //         padding: const EdgeInsets.symmetric(vertical: 2.0),
                                          //       ),
                                          //       Text('Complaint'),
                                          //     ],
                                          //   ),
                                          // ),

                                          ElevatedButton(
                                              onPressed: () {
                                                //Complete(docid);
                                                showAlertDialog(context,docid);
                                              },
                                              style: ButtonStyle(
                                                backgroundColor: MaterialStateProperty.all(Colors.indigoAccent),
                                              ),
                                              child: Text("Done", style: TextStyle(color: Colors.white),)

                                          )

                                        ],
                                      ),
                                  ),
                                ],
                              ),
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

  // void Complete(docid) async {
  //   try {
  //
  //     FirebaseFirestore.instance.collection('driverReq').doc(docid).update({
  //       "completed date" : cd,
  //       "status" : "completed",
  //     });
  //     // Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>()));
  //   } catch(e){
  //     print(e.toString());
  //   }
  // }
  showAlertDialog(BuildContext context,docid) {

    // set up the buttons
    Widget cancelButton = TextButton(
      child: Text("No"),
      onPressed:  () {
        Navigator.of(context).pop();
      },
    );
    Widget continueButton = TextButton(
      child: Text("Yes"),
      onPressed:  () {
        //Complete(docid);
        try {
          FirebaseFirestore.instance.collection('driverReq').doc(docid).update({
            "completed_date" : cd,
            "status" : "completed",
          });
        } catch(e){
          print(e.toString());
        }
        Navigator.of(context).pop();
      },
    );

    // set up the AlertDialog
    AlertDialog alert = AlertDialog(
      title: Text("Confirm"),
      content: Text("Confirm job Completion? "),
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
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:p1/screens/driverscreen/driver_drawer.dart';

class TakeJobs extends StatefulWidget {
  const TakeJobs({Key? key}) : super(key: key);

  @override
  _TakeJobsState createState() => _TakeJobsState();
}

class _TakeJobsState extends State<TakeJobs> {
  final CollectionReference dataref =
  FirebaseFirestore.instance.collection('driverReq');
  final User? _user = FirebaseAuth.instance.currentUser;
  final User? user = FirebaseAuth.instance.currentUser;
  final FirebaseAuth _auth = FirebaseAuth.instance;
  String? driverName;
  //String? driverPlace;
  String? driverPhone;
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
            driverName = doc['name'];
            //userPlace = doc['place'];
            driverPhone = doc['phone'];
            //imageUrl = doc['profilepicURL'];
          });
        }
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Choose suitable Jobs",textAlign: TextAlign.center),
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
          stream: dataref.where("status",isEqualTo: "pending").snapshots(),
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
                  final uphone = documentSnapshot['user phone'];
                  final id = _user?.uid;
                  final uemail = documentSnapshot['user email'];
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
                              title: Text("User : $username \nUser Email: $uemail \nUser Phone : $uphone \nAddress : $address \nFrom: $fd \t To: $td \nDate : $date \nInstructions : $instructions",
                                style: TextStyle(fontWeight: FontWeight.bold,fontSize: 17),),
                              subtitle: Row(
                                  children: <Widget>[

                                  Expanded(
                                    child: ElevatedButton(
                                      onPressed: () {
                                        takeJob();

                                               },

                                        style: ButtonStyle(
                                          backgroundColor: MaterialStateProperty.all(Colors.indigoAccent),
                                        ),
                                        child: Text("Take job", style: TextStyle(color: Colors.white),)
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
      drawer: DriverDrawer(),
    );
  }

  void takeJob() async {
    try {
      FirebaseFirestore.instance.collection('driverReq').doc(docid).update({
        "driver_email" : _user?.email,
        "driver_id":_user?.uid,
        "driver_name" : driverName,
        "driver_phone" : driverPhone,
        "status" : "ongoing",
      });
      // Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>()));
    } catch(e){
      print(e.toString());
    }

  }
}
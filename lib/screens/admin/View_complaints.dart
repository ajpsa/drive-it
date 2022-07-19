import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'admin_drawer.dart';
class ViewComplaints extends StatefulWidget {
  const ViewComplaints({Key? key}) : super(key: key);

  @override
  _ViewComplaintsState createState() => _ViewComplaintsState();
}

class _ViewComplaintsState extends State<ViewComplaints> {
  final CollectionReference dataref =
  FirebaseFirestore.instance.collection('complaints');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Complaints",textAlign: TextAlign.center),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blueAccent, Colors.cyan])),
        child: StreamBuilder(
          stream: dataref.where('status',isEqualTo: 'pending').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
                  final useremail = documentSnapshot['useremail'];
                  final driver = documentSnapshot['Driver Name'];
                  Timestamp t = documentSnapshot['date']; // Timestamp(seconds=1624653319,nanoseconds=326000000)
                  DateTime d = t.toDate();
                  final date1= d.toString().substring(0,16);
                  final complaint = documentSnapshot['Complaint'];
                  final id = documentSnapshot.id;
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),

                    margin: const EdgeInsets.all(15),
                    child: ListTile(
                      //trailing: Icon(Icons.report_problem_outlined),
                      title: Text("Username : $useremail \nComplaint Against : $driver \nDate: $date1 \nComplaint: $complaint" ),
                        subtitle: Center(
                          child: ElevatedButton(
                            child: Text("Done"),
                            onPressed: (){
                              Change(id);
                            },
                      ),
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
      drawer: AdminDrawer(),
    );
  }
  void Change(id) async {
    try {
      FirebaseFirestore.instance.collection('complaints').doc(id).update({
        "status" : "completed",
      });
      // Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>()));
    } catch(e){
      print(e.toString());
    }

  }
}
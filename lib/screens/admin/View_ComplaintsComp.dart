import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'admin_drawer.dart';

class ViewCCs extends StatefulWidget {
  const ViewCCs({Key? key}) : super(key: key);

  @override
  _ViewCCsState createState() => _ViewCCsState();
}

class _ViewCCsState extends State<ViewCCs> {
  final CollectionReference dataref =
  FirebaseFirestore.instance.collection('complaints');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Completed Complaints",textAlign: TextAlign.center),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blueAccent, Colors.cyan])),
        child: StreamBuilder(
          stream: dataref.where('status',isEqualTo: 'completed').snapshots(),
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
}
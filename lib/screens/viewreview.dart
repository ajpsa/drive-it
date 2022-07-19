import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ViewReviews extends StatefulWidget {
  const ViewReviews({Key? key}) : super(key: key);

  @override
  _ViewReviewsState createState() => _ViewReviewsState();
}

class _ViewReviewsState extends State<ViewReviews> {
  final CollectionReference dataref =
  FirebaseFirestore.instance.collection('Review');
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Reviews",textAlign: TextAlign.center),
      ),
      body: Container(
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blueAccent, Colors.cyan])),
        child: StreamBuilder(
          stream: dataref.snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
                  final username = documentSnapshot['User Name'];
                  final useremail = documentSnapshot['User email'];
                  Timestamp t = documentSnapshot['date']; // Timestamp(seconds=1624653319,nanoseconds=326000000)
                  DateTime d = t.toDate();
                  final date1= d.toString().substring(0,16);
                  final suggestions = documentSnapshot['suggestions'];
                  final sr = documentSnapshot['service_rating'];
                  final pr = documentSnapshot['price_rating'];
                  final or = documentSnapshot['overall_rating'];
                  final id = documentSnapshot.id;
                  return Card(
                    shape: RoundedRectangleBorder(
                      side: BorderSide(color: Colors.black, width: 1),
                      borderRadius: BorderRadius.circular(10),
                    ),

                    margin: const EdgeInsets.all(15),
                    child: ListTile(
                      title: Text("$suggestions \n",style: TextStyle(fontSize: 20)),
                      subtitle: Text("- $username\n  $useremail \n  $date1 "
                          // "\n     service rating       price rating      overall rating\n "
                          // "            $sr/5                      $pr/5                        $or/5"
                          ,style: TextStyle(fontSize: 15)),
                      trailing: Text("\nrating\n  ${or+1}/5   "),
                      //   subtitle: GestureDetector(
                      //     onTap: () {}
                      // ),

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
    );
  }
}
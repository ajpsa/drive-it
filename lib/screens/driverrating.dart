
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:p1/screens/user_completedjobs.dart';


class DriverRating extends StatefulWidget {

  String did;
  DriverRating(this.did);

  @override
  State<DriverRating> createState() => _DriverRatingState();
}

class _DriverRatingState extends State<DriverRating> {
  double? _ratingValue =0.0;
  double? rating;
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('userDetails')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc.id == widget.did) {
          setState(() {
            rating = doc['rating'];
          });
        }
      });
    });
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,

        title:Text("Rating"),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),
        child: Column(
          children: [
            SizedBox(height: 220,),
            Container(
              child: Text("$_ratingValue",style: TextStyle(fontSize: 35,fontWeight: FontWeight.bold),
              ),
            ),
            SizedBox(height: 25,),
            Container(
              child: Center(
                child: RatingBar(
                    initialRating: 0,
                    direction: Axis.horizontal,
                    allowHalfRating: true,
                    itemCount: 5,
                    ratingWidget: RatingWidget(
                        full: const Icon(Icons.star, color: Colors.orange),
                        half: const Icon(
                          Icons.star_half,
                          color: Colors.orange,
                        ),
                        empty: const Icon(
                          Icons.star_outline,
                          color: Colors.orange,
                        )),
                    onRatingUpdate: (value) {
                      setState(() {
                        _ratingValue = value;

                      });
                    }),
              ),
            ),
            SizedBox(height: 15,),
            FlatButton(
              minWidth: 150,
              color: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(4.0)),
              onPressed: () {
                 String blah = _ratingValue.toString();
                 double b = double.parse(blah);
                 //double a = b+rating!;
                 double bc = (b+rating!)/2;
                FirebaseFirestore.instance.collection('userDetails').doc(widget.did).update({
                  "rating": bc
                });
                print(rating);
                Navigator.push(context, MaterialPageRoute(builder: (context)=>UserCompletedJobs()));

              },
              child: Column(
                children: <Widget>[

                  Text('Done'),
                ],
              ),
            ),
          ],
        ),
      ),

    );
  }
}

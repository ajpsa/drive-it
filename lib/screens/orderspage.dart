import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';


class ordersPage extends StatefulWidget {

  @override
  _ordersPageState createState() => _ordersPageState();
}

class _ordersPageState extends State<ordersPage> {

  final CollectionReference userref =
  FirebaseFirestore.instance.collection('bookedCars');
  final User? _user = FirebaseAuth.instance.currentUser;
  String? userName;
  String? userPlace;
  String? userPhone;
  String? useremail;
  String? cid;
  String? id;

  @override
  void initState() {
    super.initState();

    FirebaseFirestore.instance
        .collection('userDetails')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc['email'] == _user?.email) {
          setState(() {
            useremail = doc['email'];
            userName = doc['name'];
            userPlace = doc['address'];
            userPhone = doc['phone'];
            //imageUrl = doc['profilepicURL'];
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Orders'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/wp.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder(
          stream: userref.where('email',isEqualTo: _user?.email).where("status",isEqualTo: "onroad").snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                  streamSnapshot.data!.docs[index];
                  final car = documentSnapshot['car'];
                  final name = documentSnapshot['name'];
                  final address = documentSnapshot['address'];
                  final phone = documentSnapshot['phone'];
                  final email = documentSnapshot['email'];
                  final price = documentSnapshot['price_pd'];
                  final pic = documentSnapshot['path'];
                  final date = documentSnapshot['date'];
                  final fd = documentSnapshot['fromdate'];
                  final td = documentSnapshot['todate'];
                  final cid = documentSnapshot['car id'];
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
                          child: Image.network(pic),
                        ),
                        Container(
                          width: 350,decoration: BoxDecoration(border: Border.all(),borderRadius: BorderRadius.circular(5)),
                          child: Center(
                            child: Text("Car : $car \nName : $name \nAddress : $address \nPhone number: $phone "
                                "\nEmail : $email \nFrom: $fd \t To: $td \nOrdered at: $date  \nPrice per day : $price",
                              style: TextStyle(fontSize: 16,color: Colors.black),),
                          ),
                        ),
                        SizedBox(height: 15),
                        InkWell(
                          child: Container(
                            child: Center(child: Text('Complete Order')),
                            decoration: BoxDecoration(
                              border: Border.all(color: Colors.black),
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [Colors.blue, Colors.cyanAccent]),
                            ),
                            width: 150,height: 40,
                          ),onTap: (){
                          complete(id);
                          }
                        ),
                        SizedBox(height: 15),
                      ]
                    )
                    // ListTile(
                    //   leading: FadeInImage.assetNetwork(placeholder: 'assets/images/profile.jpg', image: '$pic'),
                    //   title: Text("Name : $name \nAddress : $address \nPhone number: $phone \nEmail : $email \nPrice: $price"),
                    //   tileColor: Colors.blue[200],
                    //   shape: RoundedRectangleBorder(
                    //     borderRadius: BorderRadius.circular(5),
                    //     side: BorderSide(color: Colors.black),
                    //   ),
                    // ),
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

  void complete(id) async {
    try {
      FirebaseFirestore.instance.collection('bookedCars').doc(id).update({
        "status": "paydue"
      });
    } catch(e){}
  }
}

import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:p1/screens/car_owner/car_info.dart';
import 'package:p1/screens/car_owner/carowner_drawer.dart';
import 'package:p1/utils/utils.dart';


class Viewcar extends StatefulWidget {
  const Viewcar({Key? key}) : super(key: key);

  @override
  _ViewcarState createState() => _ViewcarState();
}

class _ViewcarState extends State<Viewcar> {
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar: AppBar(
        title: AnimatedSearchBar(
          label: "Search",
          labelStyle: TextStyle(fontSize: 16),
          searchStyle: TextStyle(color: Colors.white),
          cursorColor: Colors.black,
          searchDecoration: InputDecoration(
            hintText: "Search",
            alignLabelWithHint: true,
            fillColor: Colors.white,
            focusColor: Colors.white,
            hintStyle: TextStyle(color: Colors.white70),
            border: InputBorder.none,
          ),
          onChanged: (value) {
            print("value on Change");
            setState(() {
               //searchText = value;
            });
          },
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/wp.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: new Padding(padding: const EdgeInsets.all(9.0),
          child: StreamBuilder(
            stream:  FirebaseFirestore.instance.collection('CarsD').snapshots(),
            builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
              if (streamSnapshot.hasData) {

                return GridView.builder(
                  //shrinkWrap: true,
                  physics: ScrollPhysics(),
                  itemCount: streamSnapshot.data!.docs.length,
                  itemBuilder: (BuildContext context,int index) {
                    DocumentSnapshot d = streamSnapshot.data!.docs[index];
                    final path = d['path'];
                    final name = d['name'];
                    final blah = d['price'];
                    final brand = d['brand'];
                    final gear = d['gear'];
                    final color = d['color'];
                    final fuel = d['fuel'];
                    final status = d['status'];
                    int price = int.parse(blah);

                    return SlideInDown(
                      child: Container(

                        //height: MediaQuery.of(context).size.height * 0.25,
                        //width: MediaQuery.of(context).size.width * 0.5,
                        child: InkWell(
                          onTap: () {
                            Navigator.push(context, MaterialPageRoute(builder: (context)=> CarInfo(path,name,price,brand,gear,color,fuel,status)));

                          },
                          child: Container(
                            decoration: const BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                      color: Colors.black26, blurRadius: 5, spreadRadius: 1)
                                ],
                                gradient: LinearGradient(
                                    begin: Alignment.topLeft,
                                    end: Alignment.bottomRight,
                                    colors: [Colors.lightBlueAccent, Colors.blueAccent])),
                            margin: EdgeInsets.only(
                                top: index.isEven ? 0 : 25, bottom: index.isEven ? 20 : 0),
                            child: Column(
                              children: [
                                Container(
                                  height: 100,
                                  decoration: BoxDecoration(
                                    //color: Colors.blue,
                                    image: DecorationImage(
                                      image: NetworkImage(
                                        // d['path'],
                                        path,
                                      ),
                                      fit: BoxFit.contain,
                                    ),
                                    borderRadius: BorderRadius.circular(14),
                                  ),
                                ),
                                Text(
                                  name,
                                  style: TextStyle(
                                      fontWeight: FontWeight.bold
                                  ),
                                ),
                                Text((price).toString(), style: SubHeading),
                                Text('per month')
                              ],
                            ),
                          ),
                        ),
                      ),);
                  },
                  gridDelegate:
                  SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 8),
                );
              }
              return const Center(
                child: CircularProgressIndicator(),
              );
            },
          ),
        ),
      ),
      drawer: CarownDrawer(),
    );
  }
}


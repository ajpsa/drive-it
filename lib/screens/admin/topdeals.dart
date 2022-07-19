import 'package:animate_do/animate_do.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:animated_search_bar/animated_search_bar.dart';
import 'package:p1/screens/admin/admin_drawer.dart';
import 'package:p1/screens/car_owner/car_info.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_grid_view.dart';
import 'package:staggered_grid_view_flutter/widgets/staggered_tile.dart';


class TopDeals extends StatefulWidget {
  const TopDeals({Key? key}) : super(key: key);

  @override
  _TopDealsState createState() => _TopDealsState();
}

class _TopDealsState extends State<TopDeals> {


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
              // searchText = value;
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
        child: new Padding(padding: const EdgeInsets.all(7.0),
        child: StreamBuilder(
          stream:  FirebaseFirestore.instance.collection('CarsD').snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {

              return StaggeredGridView.countBuilder(crossAxisCount: 4,
                        itemCount: streamSnapshot.data!.docs.length,
                        itemBuilder: (BuildContext context,int index) {
                          DocumentSnapshot d = streamSnapshot.data!.docs[index];
                          final path = d['path'];
                          final name = d['name'];
                          final price = d['price'];
                          final brand = d['brand'];
                          final gear = d['gear'];
                          final color = d['color'];
                          final fuel = d['fuel'];
                          final status = d['status'];


                         return SlideInDown(
                          child: Container(
                              //height: MediaQuery.of(context).size.height * 0.25,
                              //width: MediaQuery.of(context).size.width * 0.5,
                              child: InkWell(
                                onTap: () {
                                  Navigator.push(context, MaterialPageRoute(builder: (context)=> CarInfo(path,name,price,brand,gear,color,fuel,status)));


                                },

                                child: Card(
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(10.0),
                                  ),
                                  elevation: 3.0,
                                  child: Center(
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 200,
                                          height: 150,
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
                                        Container (child: Text("$name",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.black),),),
                                        Container (child: Text("$price INR \nper Month",style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: Colors.grey),),),
                                      ],
                                    ),
                                  ),
                                ),
                              ),

                            ),);

                        }, staggeredTileBuilder: (int index) =>
                          new StaggeredTile.count(2, index.isEven ? 2.7 : 2.7),
                          mainAxisSpacing: 1.0,
                          crossAxisSpacing: 1.0,

              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
        ),
      ),
      drawer: AdminDrawer(),
    );
  }
}

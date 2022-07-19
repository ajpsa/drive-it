// import 'package:animate_do/animate_do.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'package:animated_search_bar/animated_search_bar.dart';
// import 'package:flutter/services.dart';
// import 'package:p1/screens/car_detail.dart';
// import 'package:p1/screens/car_owner/car_info.dart';
// import 'package:p1/screens/drawer.dart';
// import 'package:p1/utils/utils.dart';
// import 'package:sliding_up_panel/sliding_up_panel.dart';
//
//
// class UserViewCar extends StatefulWidget {
//   const UserViewCar({Key? key}) : super(key: key);
//
//   @override
//   _UserViewCarState createState() => _UserViewCarState();
// }
//
// class _UserViewCarState extends State<UserViewCar> {
//
//   bool filiterenabled = false;
//   bool filitertype = false;
//   String searchText = "";
//   late String ftype;
//
//   @override
//   void initState() {
//     SystemChrome.setEnabledSystemUIMode(SystemUiMode.manual, overlays: [
//       SystemUiOverlay.top
//     ]);
//     super.initState();
//   }
//
//
//   @override
//   Widget build(BuildContext context) {
//     BorderRadiusGeometry radius = BorderRadius.only(
//       topLeft: Radius.circular(24.0),
//       topRight: Radius.circular(24.0),
//     );
//     return new Scaffold(
//       appBar: AppBar(
//         title: AnimatedSearchBar(
//           label: "Search",
//           labelStyle: TextStyle(fontSize: 16),
//           searchStyle: TextStyle(color: Colors.white),
//           cursorColor: Colors.black,
//           searchDecoration: InputDecoration(
//             hintText: "Search",
//             alignLabelWithHint: true,
//             fillColor: Colors.white,
//             focusColor: Colors.white,
//             hintStyle: TextStyle(color: Colors.white70),
//             border: InputBorder.none,
//           ),
//           onChanged: (value) {
//             print("value on Change");
//             setState(() {
//               //searchText = value;
//             });
//           },
//         ),
//       ),
//       body: SlidingUpPanel(
//         backdropEnabled: true,
//         panel: SingleChildScrollView(
//           child: Column(
//             mainAxisAlignment: MainAxisAlignment.center,
//             children: <Widget>[
//               SizedBox(height: 25),
//               Text(
//                 'User reviews',
//                 style: TextStyle(
//                     fontFamily: 'Pacifico',
//                     color: Colors.blueAccent,
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold),
//               ),
//               SizedBox(
//                 height: 20,
//                 width: 150,
//                 child: Divider(
//                   color: Colors.blueAccent,
//                 ),
//               ),
//               // Card(
//               //   margin: EdgeInsets.symmetric(vertical: 10,horizontal: 25),
//               //   child: ListTile(
//               //     leading: Icon(
//               //       Icons.phone,
//               //       color: Colors.blue,
//               //     ),
//               //     title: Text(
//               //       '+8138996936',
//               //       style: TextStyle(
//               //         fontFamily: 'SourceSansPro',
//               //         color: Colors.blueAccent,
//               //         fontSize: 20,
//               //       ),
//               //     ),
//               //   ),
//               //
//               // ),
//               // Card(
//               //   margin: EdgeInsets.symmetric(vertical: 2,horizontal: 25),
//               //   child: ListTile(
//               //     leading: Icon(
//               //       Icons.email,
//               //       color: Colors.blue,
//               //     ),
//               //     title: Text(
//               //       'pradeeptrader3@gmail.com',
//               //       style: TextStyle(
//               //         fontFamily: 'SourceSansPro',
//               //         color: Colors.blueAccent,
//               //         fontSize: 20,
//               //       ),
//               //     ),
//               //   ),
//               //
//               // ),
//
//             ],
//           ),
//         ),
//         collapsed: Container(
//           decoration: BoxDecoration(
//               color: Colors.blueGrey,
//               // changing radius that we define above
//               borderRadius:  radius
//           ),
//           // collapsed text
//           child: Center(
//             child: Text(
//               "User Reviews",
//               style: TextStyle(color: Colors.white),
//             ),
//           ),
//         ),
//
//         body: Container(
//           decoration: BoxDecoration(
//             image: DecorationImage(
//               image: AssetImage("assets/images/wp.jpg"),
//               fit: BoxFit.cover,
//             ),
//           ),
//           child: new Padding(padding: const EdgeInsets.all(9.0),
//             child: StreamBuilder(
//               stream:  FirebaseFirestore.instance.collection('CarsD').where('status',isEqualTo: 'Available').snapshots(),
//               builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
//                 if (streamSnapshot.hasData) {
//
//                   return GridView.builder(
//                     //shrinkWrap: true,
//                     physics: ScrollPhysics(),
//                     itemCount: streamSnapshot.data!.docs.length,
//                     itemBuilder: (BuildContext context,int index) {
//                       DocumentSnapshot d = streamSnapshot.data!.docs[index];
//                       final path = d['path'];
//                       final name = d['name'];
//                       final blah = d['price'];
//                       final brand = d['brand'];
//                       final gear = d['gear'];
//                       final color = d['color'];
//                       final fuel = d['fuel'];
//                       final id = d.id;
//                       int price = int.parse(blah);
//
//
//                       return SlideInDown(
//                         child: Container(
//                           //height: MediaQuery.of(context).size.height * 0.25,
//                           //width: MediaQuery.of(context).size.width * 0.5,
//                           child: InkWell(
//                             onTap: () {
//                               Navigator.push(context, MaterialPageRoute(builder: (context)=> CarDetail(path,name,price,brand,gear,color,fuel,id)));
//                             },
//                             child: Container(
//                               height: 180,
//                               decoration: const BoxDecoration(
//                                   boxShadow: [
//                                     BoxShadow(
//                                         color: Colors.black26, blurRadius: 5, spreadRadius: 1)
//                                   ],
//                                   gradient: LinearGradient(
//                                       begin: Alignment.topLeft,
//                                       end: Alignment.bottomRight,
//                                       colors: [Colors.lightBlueAccent, Colors.blueAccent])
//                               ),
//                               margin: EdgeInsets.only(
//                                   top: index.isEven ? 0 : 25, bottom: index.isEven ? 20 : 0),
//                               child: Column(
//                                 children: [
//                                   Container(
//                                     height: 100,
//                                     decoration: BoxDecoration(
//                                       color: Colors.white,
//                                       image: DecorationImage(
//                                         image: NetworkImage(
//                                           // d['path'],
//                                           path,
//                                         ),
//                                         fit: BoxFit.contain,
//                                       ),
//                                       borderRadius: BorderRadius.circular(1),
//                                     ),
//                                   ),
//                                   SizedBox(height: 3),
//                                   Text(
//                                     name,
//                                     style: TextStyle(
//                                         fontWeight: FontWeight.bold
//                                     ),
//                                   ),
//                                   Text((price).toString(), style: SubHeading),
//                                   Text('per month'),
//                                 ],
//                               ),
//                             ),
//                           ),
//                         ),);
//                     },
//                     gridDelegate:
//                     SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 2,crossAxisSpacing: 8),
//                   );
//                 }
//                 return const Center(
//                   child: CircularProgressIndicator(),
//                 );
//               },
//             ),
//           ),
//         ),
//         borderRadius: radius,
//       ),
//       drawer: AppDrawer(),
//     );
//   }
// }
//

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
//               CircleAvatar(
//                   radius: 70, backgroundImage: AssetImage('assets/images/psa.jpg')),
//               Text(
//                 'Pradeep Sojan',
//                 style: TextStyle(
//                     fontFamily: 'Pacifico',
//                     color: Colors.blueAccent,
//                     fontSize: 30,
//                     fontWeight: FontWeight.bold),
//               ),
//               Text(
//                 'Flutter Developer',
//                 style: TextStyle(
//                     fontFamily: 'SourceSansPro',
//                     letterSpacing: 2.5,
//                     color: Colors.blueAccent,
//                     fontSize: 20,
//                     fontWeight: FontWeight.bold
//                 ),
//               ),
//               SizedBox(
//                 height: 20,
//                 width: 150,
//                 child: Divider(
//                   color: Colors.blueAccent,
//                 ),
//               ),
//               Card(
//                 margin: EdgeInsets.symmetric(vertical: 10,horizontal: 25),
//                 child: ListTile(
//                   leading: Icon(
//                     Icons.phone,
//                     color: Colors.blue,
//                   ),
//                   title: Text(
//                     '+8138996936',
//                     style: TextStyle(
//                       fontFamily: 'SourceSansPro',
//                       color: Colors.blueAccent,
//                       fontSize: 20,
//                     ),
//                   ),
//                 ),
//
//               ),
//               Card(
//                 margin: EdgeInsets.symmetric(vertical: 2,horizontal: 25),
//                 child: ListTile(
//                   leading: Icon(
//                     Icons.email,
//                     color: Colors.blue,
//                   ),
//                   title: Text(
//                     'pradeeptrader3@gmail.com',
//                     style: TextStyle(
//                       fontFamily: 'SourceSansPro',
//                       color: Colors.blueAccent,
//                       fontSize: 20,
//                     ),
//                   ),
//                 ),
//
//               ),
//
//             ],
//           ),
//         ),

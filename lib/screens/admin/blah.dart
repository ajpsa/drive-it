// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
// import 'admin_drawer.dart';
//
// class ViewDrivers extends StatefulWidget {
//   const ViewDrivers({Key? key}) : super(key: key);
//
//   @override
//   _ViewUsersState createState() => _ViewUsersState();
// }
//
// class _ViewUsersState extends State<ViewDrivers> {
//   TextEditingController _searchController = TextEditingController();
//
//
//   final CollectionReference userref =
//   FirebaseFirestore.instance.collection('userDetails');
//   String name = '';
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.blue[50],
//       appBar: AppBar(
//         backgroundColor: Colors.blue[400],
//         //title: Text("All Drivers",textAlign: TextAlign.center),
//         title: Card(
//           child: TextField(
//             controller: _searchController,
//             decoration: InputDecoration(
//                 prefixIcon: Icon(Icons.search),hintText:'search...'
//             ),
//             onChanged: (val){
//               setState(() {
//                 name = val;
//               });
//             },
//           ),
//         ),
//
//       ),
//
//       body: StreamBuilder(
//         stream: userref.where('role',isEqualTo: 'Driver').snapshots(),
//         builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
//           if (streamSnapshot.hasData) {
//             return ListView.builder(
//               itemCount: streamSnapshot.data!.docs.length,
//               itemBuilder: (context, index) {
//                 final DocumentSnapshot documentSnapshot =
//                 streamSnapshot.data!.docs[index];
//                 final name = documentSnapshot['name'];
//                 final address = documentSnapshot['address'];
//                 final phone = documentSnapshot['phone'];
//                 final email = documentSnapshot['email'];
//                 final status = documentSnapshot['status'];
//                 final pic = documentSnapshot['profilepicURL'];
//                 final id = documentSnapshot.id;
//                 return Card(
//                   margin: const EdgeInsets.all(10),
//                   child: ListTile(
//                     leading: FadeInImage.assetNetwork(placeholder: 'assets/images/profile.jpg', image: '$pic'),
//                     title: Text("Name : $name \nAddress : $address \nPhone number: $phone \nEmail : $email \nStatus: $status"),
//                     tileColor: Colors.blue[200],
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(5),
//                       side: BorderSide(color: Colors.black),
//                     ),
//
//                     subtitle: Row(
//                       children: <Widget>[
//
//                         Expanded(
//                             child: ElevatedButton(
//                                 onPressed: () {
//                                   block(id);
//                                 },
//                                 style: ButtonStyle(
//                                   backgroundColor: MaterialStateProperty.all(Colors.red),
//                                 ),
//                                 child: Text("Block", style: TextStyle(color: Colors.white),)
//                             )
//                         ),
//                         Expanded(
//                             child: ElevatedButton(
//                                 onPressed: () {
//                                   unblock(id);
//                                 },
//                                 style: ButtonStyle(
//                                   backgroundColor: MaterialStateProperty.all(Colors.green),
//                                 ),
//                                 child: Text("UnBlock", style: TextStyle(color: Colors.white),)
//                             )
//                         ),
//
//                       ],
//                     ),
//                   ),
//                 );
//               },
//             );
//           }
//
//           return const Center(
//             child: CircularProgressIndicator(),
//           );
//         },
//       ),
//       drawer: AdminDrawer(),
//     );
//   }
//   void block(id) async {
//     try {
//
//       FirebaseFirestore.instance.collection('userDetails').doc(id).update({
//         "status" : 'Blocked',
//       });
//     } catch(e){}
//   }
//   void unblock(id) async {
//     try {
//
//       FirebaseFirestore.instance.collection('userDetails').doc(id).update({
//         "status" : 'Online',
//       });
//     } catch(e){}
//   }
// }
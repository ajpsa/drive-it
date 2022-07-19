// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:flutter/material.dart';
//
// void main() => runApp(MyApp());
//
// class MyApp extends StatelessWidget {
//   // This widget is the root of your application.
//   @override
//   Widget build(BuildContext context) {
//     return MaterialApp(
//       home: MyHomePage(),
//     );
//   }
// }
//
// class MyHomePage extends StatefulWidget {
//   @override
//   _MyHomePageState createState() => _MyHomePageState();
// }
//
// class _MyHomePageState extends State<MyHomePage> {
//   final Firestore firestore = FirebaseFirestore.instance;
//
//   void _create() async {
//     try {
//       await firestore.collection('users').document('testUser').setData({
//         'firstName': 'test',
//         'lastName': 'user',
//       });
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   void _read() async {
//     DocumentSnapshot documentSnapshot;
//     try {
//       documentSnapshot = await firestore.collection('users').document('testUser').get();
//       print(documentSnapshot.data);
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   void _update() async {
//     try {
//       firestore.collection('users').document('testUser').updateData({
//         'firstName': 'testUpdated',
//       });
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   void _delete() async {
//     try {
//       firestore.collection('users').document('testUser').delete();
//     } catch (e) {
//       print(e);
//     }
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: Text("Flutter Firebase"),
//       ),
//       body: Center(
//         child: Column(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
//           ElevatedButton(
//             child: Text("Create"),
//             onPressed: _create,
//           ),
//           ElevatedButton(
//             child: Text("Read"),
//             onPressed: _read,
//           ),
//           ElevatedButton(
//             child: Text("Update"),
//             onPressed: _update,
//           ),
//           ElevatedButton(
//             child: Text("Delete"),
//             onPressed: _delete,
//           ),
//         ]),
//       ),
//     );
//   }
// }

import 'package:p1/screens/admin/admin_drawer.dart';
import 'package:p1/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:p1/widgets/cars_grid.dart';
import 'package:p1/services/auth.dart';
import 'package:p1/authenticate/sign_in.dart';

class ACarsOverviewScreen extends StatelessWidget {
  final AuthService _auth = AuthService();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Theme.of(context).primaryColor,
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        // automaticallyImplyLeading: false,
        //centerTitle: true,
        elevation: 0.0,
        title: Text('Drive-it', style: SubHeading),
        backgroundColor: Colors.blue[400],
        actions: <Widget>[
          TextButton.icon(
            icon: Icon(Icons.exit_to_app),
            label: Text('logout'),
            onPressed: () async{
              await _auth.signOut();
              Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                  SignIn()), (Route<dynamic> route) => false);
            },
          )
        ],
      ),
      body: ListView(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              'Available Cars',
              style: MainHeading,
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: CarsGrid(),
          )
        ],
      ),
      drawer: AdminDrawer(),
    );
  }
}

import 'package:p1/screens/drawer.dart';
import 'package:p1/utils/utils.dart';
import 'package:flutter/material.dart';
import '../widgets/cars_grid.dart';
import 'package:p1/services/auth.dart';
import 'package:p1/authenticate/sign_in.dart';

class CarsOverviewScreen extends StatelessWidget {
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
      drawer: AppDrawer(),
    );
  }
}

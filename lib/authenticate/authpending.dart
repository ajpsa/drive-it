import 'package:flutter/material.dart';
import 'package:p1/authenticate/authenticate.dart';
import 'package:p1/authenticate/sign_in.dart';

class authPending extends StatefulWidget {
  const authPending({Key? key}) : super(key: key);

  @override
  _authPendingState createState() => _authPendingState();
}

class _authPendingState extends State<authPending> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Verification Pending"),
      ),
        body: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/images/wp.jpg"),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Column(
              children: [
                Padding(padding: EdgeInsets.fromLTRB(15,4,3,8)),
                SizedBox(height: 50),
                Text("Please Wait for Admin to approve your Account",style: TextStyle(fontSize: 30,color: Colors.white)),
                SizedBox(height: 40),
                ElevatedButton(
                  child: Text("Sign Out"),
                  onPressed: (){
                    Navigator.of(context).pushAndRemoveUntil(MaterialPageRoute(builder: (context) =>
                        SignIn()), (Route<dynamic> route) => false);
                  },
                ),
                SizedBox(height: 30),
                ElevatedButton(
                  child: Text("Edit Details"),
                  onPressed: (){
                    Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context) => auth()));
                  },
                ),
              ],
            ),
          ),
      )
    );
  }
}

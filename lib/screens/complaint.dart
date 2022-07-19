import 'package:p1/screens/bkdriverpending.dart';

import 'drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:p1/utils/utils.dart';

class Complaint extends StatefulWidget {

  String drivername,demail;
  Complaint(this.drivername,this.demail);

  @override
  _ComplaintState createState() => _ComplaintState();
}

class _ComplaintState extends State<Complaint> {
  final _formKey = GlobalKey<FormState>();
  final User? _user = FirebaseAuth.instance.currentUser;
  // DateTime? _chosenDateTime;
  DateTime date = DateTime(2016, 10, 26);
  DateTime time = DateTime(2016, 5, 10, 22, 35);
  DateTime dateTime = DateTime(2016, 8, 3, 17, 45);
  late String cdate = '';
  late String complaint;

  void submit() async {
    try {
      FirebaseFirestore.instance.collection('complaints').doc().set({
        "useremail" : _user?.email,
        "Driver Name" : widget.drivername,
        "Driver Email" : widget.demail,
        'date': DateTime.now(),
        "Complaint" : complaint,
        "status": "pending"
      });
    } catch(e){
      print(e.toString());
    }
  }
  @override
  Widget build(BuildContext context) {
    TextEditingController txtcomplaint = new TextEditingController();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
        title: Text("Register Complaint",textAlign: TextAlign.center),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/wp.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Column(
          children: <Widget>[
            SizedBox(height: 10),
            Flexible(
              child: Card(
                color: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                // elevation: 2.0,
                child: Container(
                  height: MediaQuery.of(context).size.height * 0.80,
                  //constraints: BoxConstraints(minHeight: 260),
                  width: double.infinity,
                  // padding: EdgeInsets.all(1.0),
                  child: Form(
                    autovalidateMode: AutovalidateMode.always,
                    key: _formKey,
                    child: SingleChildScrollView(
                      child: Column(

                        children: <Widget>[
                          SizedBox(height: 50.0),
                          Container(
                            child: Text("Complaint Against : ${widget.drivername} \n${widget.demail}",
                                style: TextStyle(
                                  fontSize: 25,
                                ) ),
                          ),
                          SizedBox(height: 20.0),
                          // Container(
                          //   height: 200,
                          //   child: CupertinoDatePicker(
                          //
                          //     mode: CupertinoDatePickerMode.dateAndTime,
                          //
                          //     initialDateTime: DateTime.now(),
                          //     use24hFormat: false,
                          //     // onDateTimeChanged: (date) {
                          //     //  setState(() {
                          //     //    // _chosenDateTime = "${date.day} / ${date.month} / ${date.year}" as DateTime?;
                          //     //  });
                          //     // },
                          //             onDateTimeChanged: (DateTime newDate) {
                          //               setState(() => date = newDate);
                          //              cdate = '${dateTime.month}-${dateTime.day}-${dateTime.year} ${dateTime.hour}:${dateTime.minute}';
                          //             }
                          //   ),
                          // ),
                          SizedBox(height: 20.0),
                          TextFormField(
                            controller: txtcomplaint,
                            decoration: InputDecoration(
                              filled: true,
                              fillColor: Colors.white,
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              labelText: 'Complaint',
                              hintText: 'Describe the Problem',

                            ),
                            onSaved: (value) {
                              complaint = value!;
                            },
                            validator: (val){
                              if(val!.isEmpty)
                              {
                                return "Can't be empty.";
                              }
                              if(!(val.isEmpty) && !RegExp(r"(^[a-zA-Z][a-zA-Z\s]{0,20}[a-zA-Z]$)").hasMatch(val)){
                                return "Enter valid content";
                              }
                              return null;
                            },
                            maxLines: 4,
                            keyboardType: TextInputType.multiline,

                          ),
                          SizedBox(
                            height: 30,
                          ),
                          Container(
                            decoration: ThemeHelper().buttonBoxDecoration(context),
                            child: ElevatedButton(
                              style: ThemeHelper().buttonStyle(),
                              child: Padding(
                                padding: EdgeInsets.fromLTRB(40, 10, 40, 10),
                                child: Text('Submit'.toUpperCase(), style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold, color: Colors.white),),
                              ),
                              onPressed: (){
                                if (_formKey.currentState!.validate()) {
                                  _formKey.currentState!.save();
                                  submit();
                                  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>BkDriverPending()));
                                }
                                print(cdate);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
      drawer: AppDrawer(),
    );
  }
}
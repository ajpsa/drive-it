import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:p1/screens/car_owner/car_owner_home.dart';
import 'package:p1/utils/utils.dart';
import 'dart:io';

class Bill extends StatefulWidget {


  String car,address,pic,phone,email,name,date,fd,td,cid,coid,id,d;
  int price;
  Bill( this.car,this.address,this.pic,this.phone,this.email,this.name,this.price,this.date,this.fd,this.td,this.cid,this.coid,this.id,this.d);



  @override
  State<Bill> createState() => _BillState();
}

class _BillState extends State<Bill> {

  late String date = '${DateTime.now().month}-${DateTime.now().day}-${DateTime.now().year}';
  TextEditingController worktime = new TextEditingController();
  TextEditingController othercosts = new TextEditingController();

  late int totalrate=0;
  late int totalcosts=0,drivrrate=0,admincost=0,overallcosts=0;
  var difference;
  //int? a;

  final _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,

        title:Text("Bill"),
      ),
      body: Container(
        height:MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.white, Colors.cyanAccent])),
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(20),
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 150),
                Container(
                  color: Colors.white,
                  width: 400,
                  // margin: EdgeInsets.fromLTRB(25, 50, 25, 10),
                  // padding: EdgeInsets.fromLTRB(10, 0, 10, 0),
                  alignment: Alignment.center,
                  child: Column(
                    children: [
                      SizedBox(height: 50.0,),
                      Center(
                        child: Container(
                          width: 170,
                          alignment: Alignment.topLeft,
                          child: Center(child: Text('Generate Bill \n ',style: TextStyle(fontSize: 25, fontWeight: FontWeight.bold),)),
                        ),
                      ),
                      SizedBox(height: 10,),

                      Form(
                        //autovalidate: true,
                        autovalidateMode: AutovalidateMode.always,
                        key: _formKey,
                        child: Column(
                          children: [
                            SizedBox(height: 20.0),
                            Container(
                              width: 280,
                              child: Column(
                                children: [
                                  TextFormField(
                                    controller: worktime,
                                    keyboardType: TextInputType.phone,
                                    // obscureText: true,
                                    decoration: ThemeHelper().textInputDecoration(
                                        "Total rent time(in days)", "No of days the car is rented"),
                                    onSaved: (value) {
                                      var rate = int.parse(value!);
                                      if(rate <= 1 ){
                                        totalrate = widget.price;
                                      }else if(rate > 1){
                                        int blah = rate * widget.price;

                                        totalrate=blah;
                                      }
                                    },
                                    validator: (val) {
                                      if (val!.length == 0) {
                                        return "cannot be empty";
                                      }
                                      if(!RegExp(r"^[0-9]{1,2}$").hasMatch(val)){
                                        return "enter valid number";
                                      }
                                      return null;
                                    },
                                  ),
                                  SizedBox(height: 20,),
                                  TextFormField(
                                    keyboardType: TextInputType.phone,
                                    controller: othercosts,
                                    // obscureText: true,
                                    decoration: ThemeHelper().textInputDecoration(
                                        "Extra Costs", "Other costs(0 if there is none)"),
                                    onSaved: (value) {
                                      drivrrate = int.parse(value!);
                                      int b = drivrrate+totalrate;
                                      totalcosts = b;
                                     if(totalcosts <= 5000){
                                       admincost = 50;
                                     }else if (totalcosts < 10000 && totalcosts >= 5000){
                                       admincost = 100 ;
                                     }else if (totalcosts < 25000 && totalcosts >= 10000){
                                       admincost = 250 ;
                                     }else if (totalcosts < 50000 && totalcosts >= 25000){
                                       admincost = 550 ;
                                     }else if (totalcosts > 50000){
                                       admincost = 1000 ;
                                     }
                                     int c = totalcosts + admincost;
                                     overallcosts = c;
                                    },
                                    validator: (val) {
                                      if (val!.length == 0) {
                                        return "cannot be empty";
                                      }
                                      if(!RegExp(r"^[0-9]{1,5}$").hasMatch(val)){
                                        return "enter valid costs";
                                      }
                                      return null;
                                    },
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(height: 15.0),

                            SizedBox(height: 20.0),
                            ButtonBar(
                              alignment: MainAxisAlignment.spaceAround,
                              buttonHeight: 52.0,
                              buttonMinWidth: 90.0,
                              children: <Widget>[
                                FlatButton(
                                  minWidth: 220,
                                  color: Colors.blueAccent,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(4.0)),
                                  onPressed: () {
                                    if (_formKey.currentState!.validate()) {
                                      _formKey.currentState!.save();
                                      generateBill();
                                       //print(overallcosts);
                                    // a = diff();
                                    // print(a);
                                     }
                                  },
                                  child: Column(
                                    children: <Widget>[
                                      Text('Generate', style: TextStyle(fontSize:16),),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 50),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  void generateBill() async {
    try {
      FirebaseFirestore.instance.collection('payment').doc(widget.id).set({
        "path":widget.pic,
        "car":widget.car,
        "car id":widget.cid,
        "coid": widget.coid,
        "name": widget.name,
        "address":widget.address,
        "email": widget.email,
        "phone":widget.phone,
        "price per day":widget.price,
        "carrate":totalrate,
        "additional_costs": drivrrate,
        "totalrate": totalcosts,
        "admincost":admincost,
        "overallcosts":overallcosts,
        "date": date,
        "fromdate" : widget.fd,
        "todate" : widget.td,
        "status":"pending"
      });
      FirebaseFirestore.instance.collection('bookedCars').doc(widget.id).update({
        "status":"paypending"
      });
      //Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>CarOwnerHome()));
      Fluttertoast.showToast(msg: "Bill is generated and sent to the user for payment");
    } catch(e){
      print(e.toString());
    }
  }
  // int diff() {
  //  final dateFormata= DateFormat("yyyy-MM-dd").format(DateTime.parse(widget.fd));
  //  final dateFormatb= DateFormat("yyyy-MM-dd").format(DateTime.parse(widget.td));
  //  DateTime dt1 = DateTime.parse(dateFormata);
  //  DateTime dt2 = DateTime.parse(dateFormatb);
  //  final difference = dt2.difference(dt1).inDays;
  //  return (difference);
  // }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:p1/screens/UserViewCar.dart';
import 'package:p1/screens/orderspage.dart';
import 'package:p1/utils/utils.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class CarBooking extends StatefulWidget {

  String path,name,brand,gear,color,fuel,coid,id;
  int price;
  CarBooking(this.path, this.name,this.price,this.brand, this.gear,this.color, this.fuel,this.coid,this.id);

  @override
  State<CarBooking> createState() => _CarBookingState();
}

class _CarBookingState extends State<CarBooking> {
  final User? _user = FirebaseAuth.instance.currentUser;
  String? userName;
  String? userPlace;
  String? userPhone;
  String? useremail;
  String imageUrl = 'https://www.flaticon.com/free-icon/user_149071';

  DateTime date = DateTime.now().add(Duration(days: 1));
  late DateTime  finaldate=DateTime.now();
  final _formkey = GlobalKey<FormState>();
  late String address='';
  // DateTime dateb = DateTime.now();
  String date1 = '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}';
  DateTime date2 = DateTime.now();
  late String fd;
  late String td;
  String dt = '${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}${DateTime.now().second}';

  late Razorpay _razorpay;



  late String rate = '200';


  bool isSwitched = false;
  var textValue = 'Driver not Required';

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);
    // initialdate = DateTime.now();
    finaldate = DateTime.now().add(Duration(days: 4));



    FirebaseFirestore.instance
        .collection('userDetails')
        .get()
        .then((QuerySnapshot querySnapshot) {
      querySnapshot.docs.forEach((doc) {
        if (doc['email'] == _user?.email) {
          setState(() {
            useremail = doc['email'];
            userName = doc['name'];
            userPlace = doc['address'];
            userPhone = doc['phone'];
            imageUrl = doc['profilepicURL'];
          });
        }
      });
    });
  }

  void toggleSwitch(bool value) {

    if(isSwitched == false)
    {
      setState(() {
        rate = '300';
        isSwitched = true;
        textValue = 'Driver Required';
      });
      print(rate);
    }
    else
    {
      setState(() {
        rate = '200';
        isSwitched = false;
        textValue = 'Driver not Required';
      });
      print(rate);
    }
  }

  Widget build(BuildContext context) {
    TextEditingController caddress = new TextEditingController();
    double pricepd= (widget.price/30) as double;
    return Scaffold(
      appBar: AppBar(
        title: Text('Booking Page'),
        backgroundColor: Colors.blueAccent,
      ),
      body: Container(
        height:MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.cyan, Colors.indigoAccent])),
        child: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                SizedBox(height: 20),
                Container(
                  child: Text(" Enter your Details to book the car",style: TextStyle(
                      fontWeight: FontWeight.bold,fontSize: 20)
                  ),
                ),
                SizedBox(height: 10),
                InkWell(
                  child: Container(
                    //color: Colors.white60,
                    child: Text('${widget.name} \nBrand : ${widget.brand} \nFuel type: ${widget.fuel} \nPrice for a day : INR ${pricepd.round()}',
                      style: TextStyle(fontSize: 18)),
                  ),onTap: (){
                    print(pricepd);
                },
                ),
                SizedBox(height: 25),
                Switch(
                  onChanged: toggleSwitch,
                  value: isSwitched,
                  activeColor: Colors.blue,
                  activeTrackColor: Colors.yellow,
                  inactiveThumbColor: Colors.redAccent,
                  inactiveTrackColor: Colors.orange,
                ),
                Text('$textValue', style: TextStyle(fontSize: 20),),
                SizedBox(height: 25,),
                Text('Enter the initial Date',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                Container(
                  height: 100,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    // initialDateTime: DateTime.now(),
                    maximumDate: DateTime.now().add(Duration(days: 7)),
                    minimumDate: DateTime.now().add(Duration(days: 0)),
                    // minimumYear: 2022,

                    onDateTimeChanged: (DateTime value) {
                      setState(()=> date2 = value);
                      fd = date2.toString();
                      // '${date2.year}-${date2.month}-${date2.day}';
                    },),
                ),
                SizedBox(height: 25),
                Text('Enter the last Date',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                Container(
                  height: 100,
                  child: CupertinoDatePicker(
                    mode: CupertinoDatePickerMode.date,
                    initialDateTime: DateTime.now().add(Duration(days: 1)),
                    maximumDate: DateTime.now().add(Duration(days: 365)),
                    minimumDate: DateTime.now().add(Duration(days: 0)),
                    // minimumYear: 2022,
                    onDateTimeChanged: (DateTime value) {
                      setState(()=> date = value);
                      td = date.toString();
                      // '${date.year}-${date.month}-${date.day}';
                    },),
                ),
                SizedBox(height: 25),
                Text('Enter Delivery Address',style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold)),
                Form(
                  key: _formkey,
                  child: Column(
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(20.0),
                        child: TextFormField(
                          autovalidateMode: AutovalidateMode.always,
                          decoration: textInputDecoration.copyWith(hintText: "Address"),
                          controller: caddress,
                          onSaved: (value) {
                            address = value!;
                          },
                          validator: (val){
                            if(val!.isEmpty)
                            {
                              return "Can't be empty.";
                            }
                            if(!(val.isEmpty) && !RegExp(r"(^[a-zA-Z][a-zA-Z\s]{0,20}[a-zA-Z]$)").hasMatch(val)){
                              return "Enter a valid Address";
                            }
                            return null;
                          },
                        ),
                      ),
                      ElevatedButton(
                          style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all(Colors.red)
                          ),
                          child: Text(
                            'Confirm',
                            style: TextStyle(color: Colors.white),
                          ),
                          onPressed: () async {
                            try{
                              if(_formkey.currentState!.validate()) {
                                _formkey.currentState!.save();
                                // print(dt);
                                 //bookCars();
                                FirebaseFirestore.instance.collection('bookedCars').doc(dt).set({
                                  "price_pd": pricepd.round(),
                                });
                                openCheckout();
                              }
                              //Navigator.push(context, MaterialPageRoute(builder: (context)=> PaymentPage()));
                              //print(date1);

                            }catch(e){
                              Fluttertoast.showToast(
                                  msg: e.toString(),
                                  toastLength: Toast.LENGTH_SHORT,
                                  gravity: ToastGravity.CENTER,
                                  timeInSecForIosWeb: 1,
                                  backgroundColor: Colors.red,
                                  textColor: Colors.white,
                                  fontSize: 16.0
                              );
                            }
                          }
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
  void bookCars() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance.collection('bookedCars').doc(dt).update({
        "name" : userName,
        "email": useremail,
        "phone" : userPhone,
        "address": address,
        "date": date1,
        "fromdate": fd,
        "todate" : td,
        "car": widget.name,
        "coid": widget.coid,
        "brand" : widget.brand,
        "color" : widget.color,
        "path" : widget.path,
        "fuel" : widget.fuel,
        //"price_pd" : {widget.price / 30},
        "gear" : widget.gear,
        "car id": widget.id,
        "status": "onroad"
        //"no of days": nd,
      });
      change();
      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>UserViewCar()));
      Fluttertoast.showToast(msg: "Car Booked");
    } catch(e){}
  }
  void change() async {
    try {
      final User? user = FirebaseAuth.instance.currentUser;
      FirebaseFirestore.instance.collection('CarsD').doc(widget.id).update({
        "status": "Booked"
      });
    } catch(e){}
  }

  // void payment() async {
  //   FirebaseFirestore.instance.collection('payment').doc(dt).set({
  //     "name" : userName,
  //     "email": useremail,
  //     "phone" : userPhone,
  //     "address": address,
  //     "car": widget.name,
  //     "car id": widget.id,
  //   });
  // }

  @override
  void dispose() {
    super.dispose();
    _razorpay.clear();
  }

  void openCheckout() async {
    var options = {
      'key': 'rzp_test_kccoEPRwEYhEy3',
      'amount': rate,
      'name': 'Drive-it',
      'description': 'Fee Payment',
      'retry': {'enabled': true, 'max_count': 1},
      'send_sms_hash': true,
      'prefill': {'contact': '$userPhone', 'email': '$useremail'},
      'external': {
        'wallets': ['paytm']
      }
    };

    try {
      _razorpay.open(options);
    } catch (e) {
      print(e.toString());
      debugPrint('Error: e');
    }
  }

  void _handlePaymentSuccess(PaymentSuccessResponse response) {
    bookCars();
    //payment();
    print('Success Response: $response');
    /*Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId!,
        toastLength: Toast.LENGTH_SHORT); */
  }

  void _handlePaymentError(PaymentFailureResponse response) {
    try {
      FirebaseFirestore.instance.collection('bookedCars').doc(dt).delete();
    } catch(e){}
    print('Error Response: $response');
    /* Fluttertoast.showToast(
        msg: "ERROR: " + response.code.toString() + " - " + response.message!,
        toastLength: Toast.LENGTH_SHORT); */
  }

  void _handleExternalWallet(ExternalWalletResponse response) {
    print('External SDK Response: $response');
    /* Fluttertoast.showToast(
        msg: "EXTERNAL_WALLET: " + response.walletName!,
        toastLength: Toast.LENGTH_SHORT); */
  }
}

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:razorpay_flutter/razorpay_flutter.dart';

class PaymentCarFinal extends StatefulWidget {
  String? did,cid;
  String pic, car, name, address, phone, email, fd, td, date;
  int ppd, admincost, overallcosts;
  PaymentCarFinal(
      this.pic,
      this.did,
      this.car,
      this.cid,
      this.name,
      this.address,
      this.phone,
      this.email,
      this.fd,
      this.td,
      this.date,
      this.ppd,
      this.admincost,
      this.overallcosts);


  @override
  _PaymentCarFinalState createState() => _PaymentCarFinalState();
}

class _PaymentCarFinalState extends State<PaymentCarFinal> {
  final CollectionReference userref =
      FirebaseFirestore.instance.collection('payment');
  final User? _user = FirebaseAuth.instance.currentUser;
  String? userName;
  String? userPlace;
  String? userPhone;
  String? useremail;
  String? cid;
  String? id;
  late String rate = '${widget.overallcosts}';

  late Razorpay _razorpay;

  @override
  void initState() {
    super.initState();

    _razorpay = Razorpay();
    _razorpay.on(Razorpay.EVENT_PAYMENT_SUCCESS, _handlePaymentSuccess);
    _razorpay.on(Razorpay.EVENT_PAYMENT_ERROR, _handlePaymentError);
    _razorpay.on(Razorpay.EVENT_EXTERNAL_WALLET, _handleExternalWallet);

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
            //imageUrl = doc['profilepicURL'];
          });
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Payment'),
          backgroundColor: Colors.blue,
        ),
        body: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.center,
              colors: [Colors.blue, Colors.cyanAccent],
            ),
          ),
          child: Card(
            color: Colors.transparent,
            shape: BeveledRectangleBorder(
              borderRadius: BorderRadius.circular(15),
            ),
            shadowColor: Colors.white,
            margin: const EdgeInsets.all(20),
            child: Column(children: [
              Container(
                height: 260,
                // width: 250,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.only(
                    topRight: Radius.circular(25),
                  ),
                  // border: Border.all(color: Colors.black)
                ),
                child: Image.network(widget.pic),
              ),
              Container(
                width: 350,
                decoration: BoxDecoration(
                    //border: Border.all(),
                    borderRadius: BorderRadius.circular(5)),
                child: Center(
                  child: Text(
                    "Car : ${widget.car} \nName : ${widget.name} \nAddress : ${widget.address} \nPhone number: ${widget.phone} "
                    "\nEmail : ${widget.email} \nFrom: ${widget.fd} \t To: ${widget.td} \nOrdered at: ${widget.date}  \nadmin costs: ${widget.admincost} \nOverall Price : ${widget.overallcosts}",
                    style: TextStyle(fontSize: 20, color: Colors.black),
                  ),
                ),
              ),
              SizedBox(height: 15),
              InkWell(
                  child: Container(
                    child: Center(child: Text('Pay')),
                    decoration: BoxDecoration(
                      border: Border.all(color: Colors.black),
                      gradient: LinearGradient(
                          begin: Alignment.topLeft,
                          end: Alignment.bottomRight,
                          colors: [Colors.blue, Colors.cyanAccent]),
                    ),
                    width: 150,
                    height: 40,
                  ),
                  onTap: () {
                    openCheckout();
                    //complete(id);
                  }),
              SizedBox(height: 15),
            ]),
          ),
        ));
  }

  // void complete(id) async {
  //   try {
  //     FirebaseFirestore.instance.collection('bookedCars').doc(id).update({
  //       "status": "completed"
  //     });
  //   } catch(e){}
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
    FirebaseFirestore.instance
        .collection('bookedCars')
        .doc(widget.did)
        .update({"status": "completed"});
    FirebaseFirestore.instance
        .collection('CarsD')
        .doc(widget.cid)
        .update({"status": "Available"});
    FirebaseFirestore.instance
        .collection('payment')
        .doc(widget.did)
        .update({"status": "completed"});

    print('Success Response: $response');
    /*Fluttertoast.showToast(
        msg: "SUCCESS: " + response.paymentId!,
        toastLength: Toast.LENGTH_SHORT); */
  }

  void _handlePaymentError(PaymentFailureResponse response) {
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

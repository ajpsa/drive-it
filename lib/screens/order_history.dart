import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';

class ordersHistoryPage extends StatefulWidget {
  const ordersHistoryPage({Key? key}) : super(key: key);

  @override
  _ordersHistoryPageState createState() => _ordersHistoryPageState();
}

class _ordersHistoryPageState extends State<ordersHistoryPage> {
  final CollectionReference userref =
      FirebaseFirestore.instance.collection('payment');
  final User? _user = FirebaseAuth.instance.currentUser;
  String? userName;
  String? userPlace;
  String? userPhone;
  String? useremail;
  String? cid;
  String? id;

  @override
  void initState() {
    super.initState();

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
        title: Text('Completed Rents'),
        backgroundColor: Colors.blue,
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/wp.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: StreamBuilder(
          stream: userref
              .where('email', isEqualTo: _user?.email)
              .where("status", isEqualTo: "completed")
              .snapshots(),
          builder: (context, AsyncSnapshot<QuerySnapshot> streamSnapshot) {
            if (streamSnapshot.hasData) {
              return ListView.builder(
                itemCount: streamSnapshot.data!.docs.length,
                itemBuilder: (context, index) {
                  final DocumentSnapshot documentSnapshot =
                      streamSnapshot.data!.docs[index];
                  final car = documentSnapshot['car'];
                  final name = documentSnapshot['name'];
                  final address = documentSnapshot['address'];
                  final phone = documentSnapshot['phone'];
                  final email = documentSnapshot['email'];
                  final carrt = documentSnapshot['carrate'];
                  final ppd = documentSnapshot['price per day'];
                  final ac = documentSnapshot['additional_costs'];
                  final admincost = documentSnapshot['admincost'];
                  final overallcosts = documentSnapshot['overallcosts'];
                  final pic = documentSnapshot['path'];
                  final date = documentSnapshot['date'];
                  final fd = documentSnapshot['fromdate'];
                  final td = documentSnapshot['todate'];
                  final cid = documentSnapshot['car id'];
                  final did = documentSnapshot.id;
                  var a = Image.asset('assets/images/logo.png');
                  var b = Image(image: AssetImage('assets/images/logo.png'));

                  return Card(
                      color: Colors.blue[200],
                      shape: BeveledRectangleBorder(
                        borderRadius: BorderRadius.circular(15),
                      ),
                      shadowColor: Colors.white,
                      margin: const EdgeInsets.all(20),
                      child: Column(children: [
                        Container(
                          height: 160,
                          // width: 250,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.only(
                              topRight: Radius.circular(25),
                            ),
                            // border: Border.all(color: Colors.black)
                          ),
                          child: Image.network(pic),
                        ),
                           Container(
                            width: 350,
                            decoration: BoxDecoration(
                                border: Border.all(),
                                borderRadius: BorderRadius.circular(5)),
                            child: Center(
                              child: Text(
                                "Car : $car \nName : $name \nAddress : $address \nPhone number: $phone "
                                "\nEmail : $email \nFrom: $fd \t To: $td \nOrdered at: $date \nrate per day: $ppd \nadmin costs: $admincost \nOverall Price : $overallcosts",
                                style: TextStyle(
                                    fontSize: 16, color: Colors.black),
                              ),
                            ),
                          ),
                        ElevatedButton(
                            onPressed: (){

                              final doc = pw.Document();
                              doc.addPage(pw.Page(
                                  pageFormat: PdfPageFormat.a4,
                                  build: (pw.Context context) {
                                    return pw.Center(
                                      child: pw.Text('Hello World'),
                                    ); // Center
                                  })); // Page

                              // Printing.layoutPdf(
                              //     onLayout: (PdfPageFormat format) async => doc.save());

                              Printing.layoutPdf(
                                  onLayout: (PdfPageFormat format) async =>
                                  await Printing.convertHtml(
                                    format: format,
                                    //html: '<html><body><p>Hello! ${pic}</p></body></html>',
                                    html:
                                    ' <html lang="en"><head><meta charset="utf-8" /><meta name="viewport" content="width=device-width, initial-scale=1" />'
                                        '<title>invoice template</title><!-- Favicon --><link rel="icon" href="./images/favicon.png" type="image/x-icon" />'
                                        '<style>body {font-family: '
                                        'Helvetica Neue'
                                        ', '
                                        'Helvetica'
                                        ', Helvetica, Arial, sans-serif;text-align: center;color: #777;}body h1 {font-weight: 300;margin-bottom: 0px;padding-bottom: 0px;color: #000;}'
                                        'body h3 {font-weight: 300;margin-top: 10px;margin-bottom: 20px;font-style: italic;color: #555;}'
                                        'body a {color: #06f;}'
                                        '.invoice-box {max-width: 800px;margin: auto;padding: 30px;border: 1px solid #eee;box-shadow: 0 0 10px rgba(0, 0, 0, 0.15);font-size: 16px;line-height: 24px;font-family: '
                                        'Helvetica Neue'
                                        ', '
                                        'Helvetica'
                                        ', Helvetica, Arial, sans-serif;color: #555;}'
                                        '.invoice-box table {width: 100%;line-height: inherit;text-align: left;border-collapse: collapse;}'
                                        '.invoice-box table td {padding: 5px;vertical-align: top;}'
                                        '.invoice-box table tr td:nth-child(2) {text-align: right;}'
                                        '.invoice-box table tr.top table td {padding-bottom: 20px;}'
                                        ' .invoice-box table tr.top table td.title {font-size: 45px;line-height: 45px;color: #333;}'
                                        ' .invoice-box table tr.information table td {padding-bottom: 40px;}'
                                        ' .invoice-box table tr.heading td {background: #eee;border-bottom: 1px solid #ddd;font-weight: bold;}'
                                        '.invoice-box table tr.details td {padding-bottom: 20px;}'
                                        '.invoice-box table tr.item td {border-bottom: 1px solid #eee;}'
                                        '.invoice-box table tr.item.last td {border-bottom: none;}'
                                        ' .invoice-box table tr.total td:nth-child(2) {border-top: 2px solid #eee;font-weight: bold;}'
                                        '.invoice-box table tr.information table td {width: 100%;display: block;text-align: center;}}</style>'
                                        '</head><body>'
                                        ' <br /><br /><h1>DRIVE -IT Car Rental </h1>'
                                        ' <h3>Our Mission, is your Destination.</h3>'
                                        '</a>.<br /><br />'
                                        ' <div class="invoice-box">'
                                        '<table>'
                                        ' <tr class="top">'
                                        '<td colspan="2">'
                                        '<table>'
                                        '<tr>'
                                        '<td class="title">'
                                        '<img src="file:///android_asset/flutter_assets/assets/images/car.png" alt="Drive-it  logo" style="width: 80%; max-width: 220px;margin-left:43%;" />'

                                        '</td>'
                                        '<td>Bill <br />${date}<br /></td></tr></table></td></tr>'
                                        ' <tr class="information"><td colspan="2"><table><tr><td>Drive-it, Car rental.<br />Cheruvandoor<br />Ettumanoor, Kottayam</td>'
                                        '<td>${name}<br />${address}<br />${email}</td></tr></table></td></tr>'
                                        ' <tr class="heading"><td>Payment Method</td>'
                                        ' <td></td></tr>'
                                        '<tr class="details"><td>Razor Pay </td>'
                                        '<td></td></tr>'
                                        '<tr class="heading"><td>Costs</td>'
                                        '<td>Price</td></tr>'
                                        '<tr class="item"><td>Car Rate Per day</td>'
                                        ' <td>${ppd}</td></tr>'
                                        ' <tr class="item"><td>Admin Costs</td>'
                                        ' <td>${admincost}</td></tr>'
                                        '<tr class="item last">'
                                        '<td>Overall Cost</td>'
                                        '<td>${overallcosts}</td>'
                                        '</tr>'
                                        '  <tr class="total">'
                                        '<td></td>'
                                        '<td>Total: ${overallcosts}</td>'
                                        '</tr>'
                                        '</table>'
                                        '</div>'
                                        ' </body>'
                                        ' </html>',
                                  ));

                              PdfPreview(
                                build: (format) => doc.save(),
                              );

                            },
                            child: Text("Generate PDF")),
                        SizedBox(height: 15),
                      ]));
                },
              );
            }

            return const Center(
              child: CircularProgressIndicator(),
            );
          },
        ),
      ),
    );
  }
}

import 'package:p1/screens/carbooking.dart';
import 'package:p1/utils/utils.dart';
import 'package:flutter/material.dart';
import 'package:share_plus/share_plus.dart';
import 'package:p1/widgets/specific_card.dart';

class CarInfo extends StatelessWidget {

String path,name,brand,gear,color,fuel,status;
int price;
CarInfo(this.path, this.name,this.price,this.brand, this.gear,this.color, this.fuel,this.status);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).primaryColorLight,
      appBar: AppBar(
        elevation: 0,
        actions: [
          // IconButton(
          //     onPressed: null,
          //     icon: Icon(Icons.bookmark,
          //         size: 30, color: Theme.of(context).secondaryHeaderColor)),
          IconButton(
              onPressed: (){
                Share.share('Check out this car $path \n just for $price for a month', subject: 'Look what I made!');
              },
              icon: Icon(Icons.share, size: 30)),
        ],
      ),
      body: Container(
        height:MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
            decoration: const BoxDecoration(
            gradient: LinearGradient(
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
                colors: [Colors.blueAccent, Colors.cyanAccent])),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(name, style: MainHeading),
              Text(
                brand,
                style: BasicHeading,
              ),
              Hero(tag: name, child: Image.network(path)),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SpecificsCard(
                    name: '12 Month',
                    price: price * 12,
                    name2: 'INR',
                  ),
                  SpecificsCard(
                    name: '6 Month',
                    price: price * 6,
                    name2: 'INR',
                  ),
                  SpecificsCard(
                    name: '1 Month',
                    price: price * 1,
                    name2: 'INR',
                  )
                ],
              ),
              SizedBox(height: 20),
              Text(
                'SPECIFICATIONS',
                style: TextStyle(
                    color: Colors.black, fontWeight: FontWeight.bold, fontSize: 20),
              ),
              SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SpecificsCard2(
                    name: 'Color',
                    name2: color,
                  ),
                  SpecificsCard2(
                    name: 'Gearbox',
                    name2: gear,
                  ),
                  SpecificsCard2(
                    name: 'Fuel',
                    name2: fuel,
                  )
                ],
              ),
              SizedBox(height: 10),
              Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  SpecificsCard3(name: 'status', name2: status)
                  // Container(
                  //   child: Text(status),
                  // )
                ],
              )
              // SizedBox(height: 30),
              // ElevatedButton(
              //   style: ButtonStyle(
              //       backgroundColor: MaterialStateProperty.all(Colors.blue)
              //   ),
              //   // RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
              //   // disabledColor: Theme.of(context).accentColor,
              //   onPressed: null,
              //   child: Text(
              //     'Book Now',
              //     style: TextStyle(fontSize: 20, color: Colors.white),
              //   ),
              // )
            ],
          ),
        ),
      ),
    );
  }
}
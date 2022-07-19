import 'package:flutter/material.dart';
import 'package:p1/screens/car_owner/carowner_drawer.dart';
import 'package:p1/screens/car_owner/co_addcar.dart';
import 'package:p1/screens/car_owner/viewcar.dart';
class CarOwnerHome extends StatefulWidget {
  const CarOwnerHome({Key? key}) : super(key: key);

  @override
  _CarOwnerHomeState createState() => _CarOwnerHomeState();
}

class _CarOwnerHomeState extends State<CarOwnerHome> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        elevation: 0.0,
        title: Text('Car Owner'),
      ),
      body: Container(
        height:MediaQuery.of(context).size.height,
        width: MediaQuery.of(context).size.width,
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/wp.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Center(
          child: Column(
            children: <Widget>[
              SizedBox(height: 110),
              InkWell(
                child: Container(
                  width: 330,height: 200,
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.black),
                    borderRadius: BorderRadius.circular(15),
                  ),
                  child: ClipRRect(
                      borderRadius: BorderRadius.circular(15),
                      child: Image.asset("assets/images/addcar.png",fit: BoxFit.cover)),
                ),
                onTap: (){
                  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>coaddcar()));
                },
              ),
              SizedBox(height: 20),
              InkWell(
                  child: Container(
                      width: 330,height: 200,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black),
                        borderRadius: BorderRadius.circular(15),
                      ),
                    child: ClipRRect(
                        borderRadius: BorderRadius.circular(15),
                        child: Image.asset("assets/images/vcar.png",fit: BoxFit.cover)),
                  ),
                onTap: (){
                  Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>Viewcar()));
                },
              ),
            ]
          ),
        ),
      ),
      drawer: CarownDrawer(),
    );
  }
}


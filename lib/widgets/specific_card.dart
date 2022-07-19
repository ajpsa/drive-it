import 'package:p1/utils/utils.dart';
import 'package:flutter/material.dart';

class SpecificsCard extends StatelessWidget {
  final double price;
  final String name;
  final String name2;

  SpecificsCard({required this.price, required this.name, required this.name2});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(6),
      height: price == null ? 80 : 100,
      width: 110,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(10)),
      child: price == null ? Column(
        children: [
          Text(
            name,
            style: BasicHeading,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            name2,
            style: SubHeading,
          ),
        ],
      ) : Column(
        children: [
          Text(
            name,
            style: BasicHeading,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            price == null ?'':(price).toString(),
            style: SubHeading,
          ),
          SizedBox(
            height: 5,
          ),
          Text(name2)
        ],
      ),
    );
  }
}


class SpecificsCard2 extends StatelessWidget {
  final String name;
  final String name2;

  SpecificsCard2({ required this.name, required this.name2});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.all(8),
      width: 100,
      decoration: BoxDecoration(
          border: Border.all(color: Colors.black, width: 1),
          borderRadius: BorderRadius.circular(10)),
      child: Column(
        children: [
          Text(
            name,
            style: BasicHeading,
          ),
          SizedBox(
            height: 5,
          ),
          Text(
            name2,
            style: SubHeading,
          ),
        ],
      )
    );
  }
}
class SpecificsCard3 extends StatelessWidget {
  final String name;
  final String name2;

  SpecificsCard3({ required this.name, required this.name2});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.center,
      child: Container(
          // padding: EdgeInsets.all(8),
          width: 150,
          decoration: BoxDecoration(
              border: Border.all(color: Colors.grey, width: 1),
              borderRadius: BorderRadius.circular(10)),

            child: Column(
              children: [

                  Text(
                    name,
                    style: BasicHeading,
                  ),

                SizedBox(
                  height: 5,
                ),
                Text(
                  name2,
                  style: SubHeading,
                ),
              ],
            ),
      ),
    );
  }
}


import 'package:flutter/cupertino.dart';

class CarItem {
  final String title;
  final double price;
  final String path;
  final String color;
  final String gearbox;
  final String fuel;
  final String brand;

  CarItem(
      {required this.title,
        required this.price,
        required this.path,
        required this.color,
        required this.gearbox,
        required this.fuel,
        required this.brand});
}

CarsList allCars = CarsList(cars: [
  CarItem(
      title: 'Honda Civic 2018',
      price: 10123,
      color: 'Grey',
      gearbox: '4',
      fuel: 'Diesel',
      brand: 'Honda',
      path: 'assets/images/car1.jpg'),
  CarItem(
      title: 'Land Rover Freelander',
      price: 21123,
      color: 'Blue',
      gearbox: '6',
      fuel: 'Diesel',
      brand: 'Land Rover',
      path: 'assets/images/car2.jpg'),
  CarItem(
      title: 'Mercedes Benz SLS 2019',
      price: 22303,
      color: 'Red',
      gearbox: '5',
      fuel: 'Diesel',
      brand: 'Mercedes',
      path: 'assets/images/car3.jpg'),
  CarItem(
      title: 'Audi A6 2018',
      price: 19560,
      color: 'Grey',
      gearbox: '5',
      fuel: 'Diesel',
      brand: 'Audi',
      path: 'assets/images/car4.jpg'),
  CarItem(
      title: 'Jaguar XF 2019',
      price: 25600,
      color: 'White',
      gearbox: '6',
      fuel: 'Diesel',
      brand: 'Jaguar',
      path: 'assets/images/car5.jpg'),
  CarItem(
      title: 'BMW E-1 2018',
      price: 12583,
      color: 'Dark blue',
      gearbox: '6',
      fuel: 'Diesel',
      brand: 'BMW',
      path: 'assets/images/car6.jpg'),
]);

class CarsList {
  List<CarItem> cars;

  CarsList({required this.cars});
}
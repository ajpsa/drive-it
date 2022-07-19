import 'package:p1/screens/admin/admin_drawer.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:get/get.dart';
import 'package:p1/utils/image_selector.dart';
import 'dart:async';
import 'package:image_picker/image_picker.dart';
import 'package:p1/utils/utils.dart';
import 'admin_editprofile.dart';


class AdprofileView extends StatefulWidget {
  const AdprofileView({Key? key}) : super(key: key);

  @override
  _ProfileViewState createState() => _ProfileViewState();
}

class _ProfileViewState extends State<AdprofileView> {
  final ImageSelectorState imageSelectorState = ImageSelectorState();
  XFile? image;
  var pickedImage;
  final imagePicker = ImagePicker();

  final FirebaseAuth _auth = FirebaseAuth.instance;
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  final User? _user = FirebaseAuth.instance.currentUser;
  String? userName;
  String? userPlace;
  String? userPhone;
  String imageUrl = '';
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
            userName = doc['name'];
            userPlace = doc['address'];
            userPhone = doc['phone'];
            imageUrl = doc['profilepicURL'];
          });
        }
      });
    });
  }

  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.blue[50],
      appBar: AppBar(
        backgroundColor: Colors.blue[400],
        title: Text("Admin Profile",textAlign: TextAlign.center),
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(
            image: AssetImage("assets/images/wp.jpg"),
            fit: BoxFit.cover,
          ),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 35, right: 35, top: 35),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Container(
                  height: 150,
                  width: 150,
                  child: Stack(
                    children: [
                      Container(
                        height: 200,
                        width: 200,
                        child: ClipRRect(
                            borderRadius: BorderRadius.circular(200),
                            //load user profile picture
                            //but first check if the user has a profile picture
                            //if not, load the default profile picture
                            //if yes, load the user's profile picture
                            // child: Image.network(
                            //   imageUrl,
                            //   fit: BoxFit.cover,
                            // ),
                            child: FadeInImage.assetNetwork(
                                placeholder: 'assets/images/profile.jpg',
                                image:imageUrl
                            )
                        ),
                      ),
                      // Align(
                      //   alignment: Alignment.bottomCenter,
                      //   child: Padding(
                      //     padding: const EdgeInsets.only(bottom: 20),
                      //     child: IconButton(
                      //         onPressed: () {
                      //           //open image selector
                      //           //getImage();
                      //         },
                      //         icon: const Icon(Icons.camera_alt_outlined)),
                      //   ),
                      // ),
                    ],
                  ),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                  ),
                ),
                const SizedBox(height: 20),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * .8,
                      child: Text("Name: $userName"),
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * .8,
                      child: Text("Email: ${_user?.email}"),
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * .8,
                      child: Text("Address: $userPlace"),
                    ),
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15, right: 15, top: 20),
                    child: Container(
                      height: 40,
                      width: MediaQuery.of(context).size.width * .8,
                      child: Text("Phone No: $userPhone"),
                    ),
                  ),
                ),
                SizedBox(height: 15.0),
                Container(
                  decoration: ThemeHelper().buttonBoxDecoration(context),
                  child: ElevatedButton(
                    style: ThemeHelper().buttonStyle(),
                    child: Padding(
                      padding: EdgeInsets.fromLTRB(
                          40, 10, 40, 10),
                      child: Text('Update'.toUpperCase(),
                        style: TextStyle(fontSize: 20,
                            fontWeight: FontWeight.bold,
                            color: Colors.white),),
                    ),
                    onPressed: () {
                      Navigator.of(context).push(new MaterialPageRoute(builder: (BuildContext context)=>AdprofileScreen()));
                    },
                  ),
                ),
              ],

            ),
          ),
        ),
      ),
      drawer: AdminDrawer(),
    );
  }

  Future getImage() async {
    image = await imagePicker.pickImage(
      source: ImageSource.gallery,
      imageQuality: 50,
      maxWidth: 250,
    );
    setState(() {
      pickedImage = XFile(image!.path);
      //push picked image into firestore
      _firestore.collection('userDetails').doc(_user?.email).update({
        'image': pickedImage.toString(),
      }).then((value) {
        print('image updated');
        //display a snackbar
        Get.snackbar(
          'Success',
          'Image Updated',
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.green,
          colorText: Colors.white,
          borderRadius: 10,
          snackStyle: SnackStyle.FLOATING,
        );

      }).catchError((err) {
        //show error message on snackbar
        Get.snackbar('Error', err.toString(),
            snackPosition: SnackPosition.BOTTOM,
            backgroundColor: Colors.red,
            colorText: Colors.white,
            borderRadius: 10,
            margin: EdgeInsets.all(10),
            snackStyle: SnackStyle.FLOATING,
            duration: Duration(seconds: 3));
      });
    });
    //print(" this is the path of the image " + imageFile);
  }
}
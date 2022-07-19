import 'package:firebase_auth/firebase_auth.dart';
import '../models/myuser.dart';

class AuthService {

  final FirebaseAuth _auth=FirebaseAuth.instance;

  //create user object based on firebaseuser(User)
  MyUser? _userfromFirebase(User? user) {

    return user!= null ? MyUser(uid: user.uid) : null;

  }

  // auth change user stream
  Stream<MyUser?> get user {
    return _auth.authStateChanges().map((User? user) => _userfromFirebase(user!));
  }


  //sign in anonymously

  Future signInAnon() async{
    try{
      UserCredential result = await _auth.signInAnonymously();
      User? user = result.user;
      return _userfromFirebase(user!);
    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign in email and password
  Future signInWithEmailAndPassword(String email,String password) async {
    try {
      UserCredential result = await _auth.signInWithEmailAndPassword(email: email, password: password);
      User? user = result.user;
      return _userfromFirebase(user);

    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //register with email and password
  Future signUP(String email,String password) async {
    try {


      

      // create a new document for the user with the uid
      // await DatabaseService(uid: user!.uid).updateUserData('name ', 8138996936, "address");
      // return _userfromFirebase(user);

    }catch(e){
      print(e.toString());
      return null;
    }
  }

  //sign out

  Future signOut() async{
    try{
      return await _auth.signOut();
    }catch(e){
      print(e.toString());
      return null;
    }
  }
}

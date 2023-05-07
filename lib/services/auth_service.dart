import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';

// Make Sign in with Google method
final GoogleSignIn googleSignIn = GoogleSignIn();

class AuthManager {

  signInWithGoogle() async {
    final GoogleSignInAccount? googleSignInAccount = await googleSignIn.signIn();

    if (googleSignInAccount.runtimeType == Null) {
      return;
    } 

    final GoogleSignInAuthentication googleSignInAuthentication =
        await googleSignInAccount!.authentication;

    final credential = GoogleAuthProvider.credential(
      accessToken: googleSignInAuthentication.accessToken,
      idToken: googleSignInAuthentication.idToken,
    );

    final UserCredential userCredential = await FirebaseAuth.instance.signInWithCredential(credential);

    final User? user = userCredential.user;
    if (user == null) {
      return;
    }

    saveUserToDatabase(user);

    await googleSignIn.disconnect();
  }

  signOut() async {
    await googleSignIn.signOut();

    await FirebaseAuth.instance.signOut();
  }

  static Future<void> saveUserToDatabase(User user) async {
    // Save the user to the database with the collection uid as the user uid
    await FirebaseFirestore.instance.collection("users").doc(user.uid).set({
      "uid": user.uid,
      "email": user.email,
      "displayName": user.displayName,
      "photoURL": user.photoURL,
      "emailVerified": user.emailVerified,
      "friends": [],
      "chats": [],
    });
  }
}

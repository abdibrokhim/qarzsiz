
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:qarzsiz/components/shared/custom_notification.dart';
import 'package:qarzsiz/components/shared/toast.dart';

class FirebaseAuthService {

  static Future<User> signInWithGoogle() async {
    final GoogleSignIn _googleSignIn = GoogleSignIn();
    try {
      // final FirebaseAuthService _auth = FirebaseAuthService();
      final FirebaseAuth _firebaseAuth = FirebaseAuth.instance;

      final GoogleSignInAccount? googleSignInAccount = await _googleSignIn.signIn();
      
      if(googleSignInAccount != null ) {
        final GoogleSignInAuthentication googleSignInAuthentication = await googleSignInAccount.authentication;

        final AuthCredential credential = GoogleAuthProvider.credential(
          idToken: googleSignInAuthentication.idToken,
          accessToken: googleSignInAuthentication.accessToken,
        );

        await _firebaseAuth.signInWithCredential(credential);
      }

      final User? user = _firebaseAuth.currentUser;

      if(user != null) {
        final idToken = await user.getIdToken();
        final accessToken = await user.getIdTokenResult();
        final refreshToken = await user.getIdTokenResult();
        final email = user.email;
        final displayName = user.displayName;
        final photoURL = user.photoURL;
        final phoneNumber = user.phoneNumber;
        final emailVerified = user.emailVerified;
        final refreshToken2 = user.refreshToken;

        print("FirebaseAuthService user id: ${user.uid}");

        print("idToken: $idToken");
        print("accessToken: $accessToken");
        print("refreshToken: $refreshToken");
        print("email: $email");
        print("displayName: $displayName");
        print("photoURL: $photoURL");
        print("phoneNumber: $phoneNumber");
        print("emailVerified: $emailVerified");
        print("refreshToken2: $refreshToken2");

        showToast(message: 'Error while signing in with google. Please try to sign in entering username and password', bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");

        bool isAlreadySaved = await isUserSavedToCollection(user.uid);

        if (isAlreadySaved) {
          showToast(message: 'User is already saved to collection', bgColor: getNotificationColor(NotificationColor.green), webBgColor: "green");
        } else {
          bool isSaved = await saveUserToCollection(user.uid, email ?? '',);
          
          if (isSaved) {
            showToast(message: 'Successfully saved user to collection', bgColor: getNotificationColor(NotificationColor.green), webBgColor: "green");
          } else {
            showToast(message: 'Error while saving user to collection', bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
          }
        }

        
        return user;

      } else {
        showToast(message: 'Error while signing in with google. Please try to sign in entering username and password', bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
        return Future.error('Error while signing in with google');
      }

    } catch (e) {
      print("error while signing in with google: $e");
      return Future.error('Error while signing in with google');
    }
  }

  static final FirebaseAuth _auth = FirebaseAuth.instance;


  static Future<User?> signUpWithEmailAndPassword(String email, String password) async {
  
    try {
      UserCredential credential =await _auth.createUserWithEmailAndPassword(email: email, password: password);
      print("FirebaseAuthService user id: ${credential.user!.uid}");
      showToast(message: 'Successfully signed up', bgColor: getNotificationColor(NotificationColor.green), webBgColor: "green");

      bool isSaved = await saveUserToCollection(credential.user!.uid, email);
      
      if (isSaved) {
        showToast(message: 'Successfully saved user to collection', bgColor: getNotificationColor(NotificationColor.green), webBgColor: "green");
      } else {
        showToast(message: 'Error while saving user to collection', bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
      }

      return credential.user;
    } on FirebaseAuthException catch (e) {

      if (e.code == 'email-already-in-use') {
        showToast(message: 'The email address is already in use.', bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
      } else {
        showToast(message: 'An error occurred: ${e.code}', bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
      }
    }
    return null;

  }


  static Future<bool> saveUserToCollection(String userId, String email) async {
    print('saveUserToCollection');
    try {
      final userCollection = FirebaseFirestore.instance.collection('user');
      await userCollection.doc(userId).set({
        'email': email,
      });
      
      return true;
    } catch (e) {
      print("error while saving user to collection: $e");
      return false;
    }
  }


  static Future<bool> isUserSavedToCollection(String userId) async {
    print('isUserSavedToCollection');
    try {
      final userCollection = FirebaseFirestore.instance.collection('user');
      final user = await userCollection.doc(userId).get();
      if (user.exists) {
        return true;
      }
      return false;
    } catch (e) {
      print("error while checking if user is saved to collection: $e");
      return false;
    }
  }

  static Future<User?> signInWithEmailAndPassword(String email, String password) async {
    print('signInWithEmailAndPassword');
    

    try {
      UserCredential credential =await _auth.signInWithEmailAndPassword(email: email, password: password);
      print("FirebaseAuthService user id: ${credential.user!.uid}");
      showToast(message: 'Successfully signed in', bgColor: getNotificationColor(NotificationColor.green), webBgColor: "green");
      return credential.user;
    } on FirebaseAuthException catch (e) {
      if (e.code == 'user-not-found' || e.code == 'wrong-password') {
        showToast(message: 'Invalid email or password.', bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
      } else {
        showToast(message: 'An error occurred: ${e.code}', bgColor: getNotificationColor(NotificationColor.red), webBgColor: "red");
      }

    }
    return null;

  }

  static Future<void> signOut() async {
    FirebaseAuth _auth = FirebaseAuth.instance;
    await _auth.signOut();
  }

}
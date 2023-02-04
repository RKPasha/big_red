import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
// import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
// import 'package:google_sign_in/google_sign_in.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

import '../utils/showOTPDialog.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  FirebaseAuthMethods(this._auth);

  // FOR EVERY FUNCTION HERE
  // POP THE ROUTE USING: Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);

  // GET USER DATA
  // using null check operator since this method should be called only
  // when the user is logged in
  User get user => _auth.currentUser!;

  // STATE PERSISTENCE STREAM
  Stream<User?> get authState => FirebaseAuth.instance.authStateChanges();
  // OTHER WAYS (depends on use case):
  // Stream get authState => FirebaseAuth.instance.userChanges();
  // Stream get authState => FirebaseAuth.instance.idTokenChanges();
  // KNOW MORE ABOUT THEM HERE: https://firebase.flutter.dev/docs/auth/start#auth-state

  // EMAIL SIGN UP
  Future<void> signUpWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.createUserWithEmailAndPassword(
        email: email,
        password: password,
      );
      await sendEmailVerification(context);
    } on FirebaseAuthException catch (e) {
      // if you want to display your own custom error message
      if (e.code == 'weak-password') {
        if (kDebugMode) {
          print('The password provided is too weak.');
        }
      } else if (e.code == 'email-already-in-use') {
        if (kDebugMode) {
          print('The account already exists for that email.');
        }
      }
      showTopSnackBar(
        Overlay.of(context)!,
        CustomSnackBar.error(
          message: e.message!,
        ),
      ); // Displaying the usual firebase error message
    }
  }

  // EMAIL LOGIN
  Future<void> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!user.emailVerified) {
        await sendEmailVerification(context);
        // restrict access to certain things using provider
        // transition to another page instead of home screen
      } else {
        // allow access to certain things using provider
        // transition to home screen
        showTopSnackBar(
          Overlay.of(context)!,
          CustomSnackBar.success(
            message: '${user.email} logged in successfully!',
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      showTopSnackBar(
        Overlay.of(context)!,
        CustomSnackBar.error(
          message: e.message!,
        ),
      ); // Displaying the error message
    }
  }

  // EMAIL VERIFICATION
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      showTopSnackBar(
        Overlay.of(context)!,
        const CustomSnackBar.info(
          message: 'Email verification sent!',
        ),
      );
    } on FirebaseAuthException catch (e) {
      showTopSnackBar(
        Overlay.of(context)!,
        CustomSnackBar.error(
          message: e.message!,
        ),
      ); // Display error message
    }
  }

  // GOOGLE SIGN IN
  // Future<void> signInWithGoogle(BuildContext context) async {
  //   try {
  //     if (kIsWeb) {
  //       GoogleAuthProvider googleProvider = GoogleAuthProvider();

  //       googleProvider
  //           .addScope('https://www.googleapis.com/auth/contacts.readonly');

  //       await _auth.signInWithPopup(googleProvider);
  //     } else {
  //       final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

  //       final GoogleSignInAuthentication? googleAuth =
  //           await googleUser?.authentication;

  //       if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
  //         // Create a new credential
  //         final credential = GoogleAuthProvider.credential(
  //           accessToken: googleAuth?.accessToken,
  //           idToken: googleAuth?.idToken,
  //         );
  //         UserCredential userCredential =
  //             await _auth.signInWithCredential(credential);

  //         // if you want to do specific task like storing information in firestore
  //         // only for new users using google sign in (since there are no two options
  //         // for google sign in and google sign up, only one as of now),
  //         // do the following:

  //         // if (userCredential.user != null) {
  //         //   if (userCredential.additionalUserInfo!.isNewUser) {}
  //         // }
  //       }
  //     }
  //   } on FirebaseAuthException catch (e) {
  //     showTopSnackBar(
  //       Overlay.of(context)!,
  //       CustomSnackBar.error(
  //         message: e.message!,
  //       ),
  //     ); // Displaying the error message
  //   }
  // }

  // ANONYMOUS SIGN IN
  // Future<void> signInAnonymously(BuildContext context) async {
  //   try {
  //     await _auth.signInAnonymously();
  //   } on FirebaseAuthException catch (e) {
  //     showTopSnackBar(
  //       Overlay.of(context)!,
  //       CustomSnackBar.error(
  //         message: e.message!,
  //       ),
  //     ); // Displaying the error message
  //   }
  // }

  // FACEBOOK SIGN IN
  // Future<void> signInWithFacebook(BuildContext context) async {
  //   try {
  //     final LoginResult loginResult = await FacebookAuth.instance.login();

  //     final OAuthCredential facebookAuthCredential =
  //         FacebookAuthProvider.credential(loginResult.accessToken!.token);

  //     await _auth.signInWithCredential(facebookAuthCredential);
  //   } on FirebaseAuthException catch (e) {
  //     showTopSnackBar(
  //       Overlay.of(context)!,
  //       CustomSnackBar.error(
  //         message: e.message!,
  //       ),
  //     ); // Displaying the error message
  //   }
  // }

  // SIGN OUT
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      showTopSnackBar(
        Overlay.of(context)!,
        CustomSnackBar.error(
          message: e.message!,
        ),
      ); // Displaying the error message
    }
  }

  // DELETE ACCOUNT
  Future<void> deleteAccount(BuildContext context) async {
    try {
      await _auth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      showTopSnackBar(
        Overlay.of(context)!,
        CustomSnackBar.error(
          message: e.message!,
        ),
      ); // Displaying the error message
      // if an error of requires-recent-login is thrown, make sure to log
      // in user again and then delete account.
    }
  }
}
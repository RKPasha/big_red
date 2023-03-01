// import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:intl/intl.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';

class FirebaseAuthMethods {
  final FirebaseAuth _auth;
  // final _auth = FirebaseAuth.instance;
  FirebaseAuthMethods(this._auth);

  // FOR EVERY FUNCTION HERE
  // POP THE ROUTE USING: Navigator.of(context).pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);

  // GET USER DATA
  // using null check operator since this method should be called only
  // when the user is logged in
  User get user => _auth.currentUser!;

  // STATE PERSISTENCE STREAM
  Stream<User?> authStream() => _auth.authStateChanges();
  // OTHER WAYS (depends on use case):
  // Stream get authState => FirebaseAuth.instance.userChanges();
  // Stream get authState => FirebaseAuth.instance.idTokenChanges();
  // KNOW MORE ABOUT THEM HERE: https://firebase.flutter.dev/docs/auth/start#auth-state

  // EMAIL SIGN UP
  Future<bool> signUpWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    try {
      await _auth
          .createUserWithEmailAndPassword(
        email: email,
        password: password,
      )
          .then((value) {
        FirebaseDatabase.instance
            .ref()
            .child('users')
            .child(value.user!.uid)
            .set({
          'uid': value.user!.uid,
          'email': value.user!.email,
          'createdOn': DateFormat.yMMMMd()
              .format(value.user!.metadata.creationTime!)
              .toString(),
        });
      });
      if (context.mounted) {
        await sendEmailVerification(context);
      }
      return true;
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
        Overlay.of(context),
        CustomSnackBar.error(
          message: e.message!,
        ),
      ); // Displaying the usual firebase error message
      return false;
    }
  }

  // EMAIL LOGIN
  Future<bool> loginWithEmail({
    required String email,
    required String password,
    required BuildContext context,
  }) async {
    Future<bool> val = Future.value(false);
    try {
      await _auth.signInWithEmailAndPassword(
        email: email,
        password: password,
      );
      if (!user.emailVerified) {
        if (context.mounted) {
          await sendEmailVerification(context);
        }
        await _auth.signOut();
        val = Future.value(false);
        // restrict access to certain things using provider
        // transition to another page instead of home screen
      } else {
        val = Future.value(true);
        // transition to home screen
        if (context.mounted) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        }
      }
    } on FirebaseAuthException catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: e.message!,
        ),
      ); // Displaying the error message
    }
    return val;
  }

  // EMAIL VERIFICATION
  Future<void> sendEmailVerification(BuildContext context) async {
    try {
      _auth.currentUser!.sendEmailVerification();
      showTopSnackBar(
        Overlay.of(context),
        const CustomSnackBar.info(
          message: 'Email verification sent!',
        ),
      );
    } on FirebaseAuthException catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: e.message!,
        ),
      ); // Display error message
    }
  }

  // GOOGLE SIGN IN
  Future<void> signInWithGoogle(BuildContext context) async {
    try {
      if (kIsWeb) {
        GoogleAuthProvider googleProvider = GoogleAuthProvider();

        googleProvider
            .addScope('https://www.googleapis.com/auth/contacts.readonly');

        await _auth.signInWithPopup(googleProvider).then((value) {
          if (value.user != null) {
            if (value.additionalUserInfo!.isNewUser) {
              saveGoogleLoginInfo(value);
            }
          }
        });
        if (context.mounted) {
          Navigator.of(context)
              .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
        }
      } else {
        final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();

        final GoogleSignInAuthentication? googleAuth =
            await googleUser?.authentication;

        if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
          // Create a new credential
          final credential = GoogleAuthProvider.credential(
            accessToken: googleAuth?.accessToken,
            idToken: googleAuth?.idToken,
          );
          await _auth.signInWithCredential(credential).then((value) {
            if (value.user != null) {
              if (value.additionalUserInfo!.isNewUser) {
                saveGoogleLoginInfo(value);
              }
            }
          });

          if (context.mounted) {
            Navigator.of(context)
                .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
          }
        }
      }
    } on FirebaseAuthException catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: e.message!,
        ),
      ); // Displaying the error message
    }
  }

  Future<void> saveGoogleLoginInfo(UserCredential user) async {
    await FirebaseDatabase.instance
        .ref()
        .child('users')
        .child(user.user!.uid)
        .set({
      'uid': user.user!.uid,
      'email': user.user!.email,
      'name': user.user!.displayName,
      'photo': user.user!.photoURL,
      'phone': user.user!.phoneNumber.toString(),
      'createdOn': DateFormat.yMMMMd()
          .format(user.user!.metadata.creationTime!)
          .toString(),
    });
  }
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
  Future<void> signInWithFacebook(BuildContext context) async {
    try {
      final LoginResult loginResult = await FacebookAuth.instance.login();

      final OAuthCredential facebookAuthCredential =
          FacebookAuthProvider.credential(loginResult.accessToken!.token);

      await _auth.signInWithCredential(facebookAuthCredential);
      if (context.mounted) {
        Navigator.of(context)
            .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
      }
    } on FirebaseAuthException catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: e.message!,
        ),
      ); // Displaying the error message
    }
  }

  // SIGN OUT
  Future<void> signOut(BuildContext context) async {
    try {
      await _auth.signOut();
    } on FirebaseAuthException catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: e.message!,
        ),
      ); // Displaying the error message
    }
  }

  //Forgot password
  Future<bool> resetPassword({
    required String email,
    required BuildContext context,
  }) async {
    Future<bool> val = Future.value(false);
    try {
      await _auth.sendPasswordResetEmail(email: email).then((value) {
        showTopSnackBar(
          Overlay.of(context),
          const CustomSnackBar.info(
            message: 'Password reset email sent!',
          ),
        );
        val = Future.value(true);
        Navigator.of(context).pop();
      });
    } on FirebaseAuthException catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: e.message!,
        ),
      );
      val = Future.value(false); // Displaying the error message
    }
    return val;
  }

  // DELETE ACCOUNT
  Future<void> deleteAccount(BuildContext context) async {
    try {
      //Delete user data from firebase storage first
      final dbRef = FirebaseDatabase.instance.ref();
      final user = dbRef.child('users/${_auth.currentUser!.uid}');
      final snapshot = await user.get();
      if (snapshot.exists) {
        await user.remove();
      }
      final stRef = FirebaseStorage.instance.ref();
      if (_auth.currentUser!.photoURL == null) {
        final userSt =
            stRef.child('user_avatars/${_auth.currentUser!.uid}.jpeg');
        final snapshotSt = await userSt.getDownloadURL();
        if (snapshotSt.isNotEmpty) {
          await userSt.delete();
        }
      }
      await _auth.currentUser!.delete();
    } on FirebaseAuthException catch (e) {
      showTopSnackBar(
        Overlay.of(context),
        CustomSnackBar.error(
          message: e.message!,
        ),
      ); // Displaying the error message
      // if an error of requires-recent-login is thrown, make sure to log
      // in user again and then delete account.
    }
  }
}

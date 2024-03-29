import 'package:big_red/pages/Admin/admin_home.dart';
import 'package:big_red/pages/User/user_home.dart';
import 'package:big_red/pages/forgot_password_screen.dart';
import 'package:big_red/pages/home_page.dart';
import 'package:big_red/pages/login_screen.dart';
import 'package:big_red/pages/signup_options.dart';
import 'package:big_red/pages/signup_screen.dart';
import 'package:big_red/pages/splash_screen.dart';
import 'package:big_red/services/firebase_auth_methods.dart';
import 'package:big_red/utils/theme_provider.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:provider/provider.dart';
import 'firebase_options.dart';
// import 'package:syncfusion_flutter_gauges/gauges.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (kIsWeb) {
    // initialiaze the facebook javascript SDK
    await FacebookAuth.instance.webAndDesktopInitialize(
      appId: "739581740811484",
      cookie: true,
      xfbml: true,
      version: "v15.0",
    );
  }
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  // final ThemeProvider themeProvider = ThemeProvider();
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => ThemeProvider(),
      child: Consumer<ThemeProvider>(
        builder: (context, themeProvider, child) {
          return MultiProvider(
            providers: [
              Provider<FirebaseAuthMethods>(
                create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
              ),
              StreamProvider(
                create: (context) =>
                    context.read<FirebaseAuthMethods>().authStream(),
                initialData: null,
              ),
            ],
            child: MaterialApp(
              debugShowCheckedModeBanner: false,
              home: const AuthWrapper(),
              theme: ThemeData(
                // colorScheme: ThemeData().colorScheme.copyWith(primary: Colors.blue),
                brightness:
                    themeProvider.isDark ? Brightness.dark : Brightness.light,
              ),
              routes: {
                SignupOptions.routeName: (context) => const SignupOptions(),
                SignupScreen.routeName: (context) => const SignupScreen(),
                LoginScreen.routeName: (context) => const LoginScreen(),
                ForgotPasswordScreen.routeName: (context) =>
                    const ForgotPasswordScreen(),
                SplashScreen.routeName: (context) => const SplashScreen(),
              },
            ),
          );
        },
      ),
    );
  }
}

class AuthWrapper extends StatelessWidget {
  const AuthWrapper({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder(
        stream: context.read<FirebaseAuthMethods>().authStream(),
        builder: ((context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasData) {
            User? user = snapshot.data;
            return FutureBuilder<DocumentSnapshot>(
              future: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user!.uid)
                  .get(),
              builder: (BuildContext context,
                  AsyncSnapshot<DocumentSnapshot> documentSnapshot) {
                if (documentSnapshot.connectionState ==
                    ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }
                if (!documentSnapshot.hasData ||
                    !documentSnapshot.data!.exists) {
                  return const LoginScreen();
                }
                String role = documentSnapshot.data!.get('role');
                if (role == "admin") {
                  return AdminHomePage(user: user);
                } else if (role == "user") {
                  return UserHomePage(user: user);
                } else {
                  return const SplashScreen();
                }
              },
            );
          } else {
            // user is not authenticated, navigate to login screen
            WidgetsBinding.instance.addPostFrameCallback((_) {
              Navigator.pushReplacementNamed(context, '/splash');
            });
            return const SizedBox.shrink();
          }
        }),
      ),
    );
  }
}

import 'package:big_red/pages/forgot_password_screen.dart';
import 'package:big_red/pages/home_page.dart';
import 'package:big_red/pages/login_screen.dart';
import 'package:big_red/pages/signup_options.dart';
import 'package:big_red/firebase_options.dart';
import 'package:big_red/pages/signup_screen.dart';
import 'package:big_red/pages/splash_screen.dart';
import 'package:big_red/services/firebase_auth_methods.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_facebook_auth/flutter_facebook_auth.dart';
import 'package:provider/provider.dart';
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

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        Provider<FirebaseAuthMethods>(
          create: (_) => FirebaseAuthMethods(FirebaseAuth.instance),
        ),
        StreamProvider(
          create: (context) => context.read<FirebaseAuthMethods>().authStream(),
          initialData: null,
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        home: const AuthWrapper(),
        theme: ThemeData(
          colorScheme: ThemeData().colorScheme.copyWith(primary: Colors.blue),
        ),
        routes: {
          SignupOptions.routeName: (context) => const SignupOptions(),
          SignupScreen.routeName: (context) => const SignupScreen(),
          LoginScreen.routeName: (context) => const LoginScreen(),
          ForgotPasswordScreen.routeName: (context) =>
              const ForgotPasswordScreen(),
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
      body: StreamBuilder<User?>(
        stream: context.read<FirebaseAuthMethods>().authStream(),
        builder: ((context, snapshot) {
          if (snapshot.hasData) {
            return const HomePage();
          } else {
            return const SplashScreen();
          }
        }),
      ),
    );
  }
}

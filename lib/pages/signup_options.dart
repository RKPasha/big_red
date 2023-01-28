import 'package:big_red/pages/login_screen.dart';
import 'package:big_red/pages/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class SignupOptions extends StatelessWidget {
  const SignupOptions({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: <Widget>[
          const SizedBox(height: 100),
          Center(
            child: Image.asset(
              'assets/images/logo.png',
              width: 230.0,
              height: 230.0,
            ),
          ),
          const SizedBox(height: 20),
          Text(
            'Let\'s you in',
            style: GoogleFonts.robotoSlab(
              textStyle: const TextStyle(
                fontSize: 45,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
          const SizedBox(height: 30),
          Container(
            height: 50,
            margin: const EdgeInsets.all(10.0),
            child: OutlinedButton(
              child: Row(
                children: <Widget>[
                  Image.asset('assets/images/facebook.png',
                      width: 35, height: 35),
                  const SizedBox(width: 10),
                  const Text(
                    'Continue with Facebook',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
              onPressed: () {},
            ),
          ),
          Container(
            height: 50,
            margin: const EdgeInsets.all(10.0),
            child: OutlinedButton(
              child: Row(
                children: <Widget>[
                  Image.asset('assets/images/google.png',
                      width: 30, height: 30),
                  const SizedBox(width: 10),
                  const Text(
                    'Continue with Google',
                    style: TextStyle(color: Colors.black, fontSize: 16),
                  ),
                ],
              ),
              onPressed: () {},
            ),
          ),
          const SizedBox(height: 10),
          Container(
            alignment: Alignment.center,
            child: const Text('or', style: TextStyle(color: Colors.black)),
          ),
          const SizedBox(height: 10),
          Container(
            margin: const EdgeInsets.all(10.0),
            width: double.infinity,
            height: 50,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              child: const Text('Login in with Email',
                  style: TextStyle(color: Colors.white, fontSize: 16)),
              onPressed: () {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const LoginScreen();
                    },
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
            const Text('Don\'t have an account? ',
                style: TextStyle(color: Colors.grey)),
            InkWell(
              child:
                  const Text('Sign up', style: TextStyle(color: Colors.black)),
              onTap: () {
                // Navigate to Signup screen
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (BuildContext context) {
                      return const SignupScreen();
                    },
                  ),
                );
              },
            ),
          ]),
        ],
      ),
    );
  }
}

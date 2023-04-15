import 'package:big_red/pages/login_screen.dart';
import 'package:big_red/pages/signup_screen.dart';
import 'package:big_red/utils/theme_provider.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

import '../services/firebase_auth_methods.dart';

class SignupOptions extends StatelessWidget {
  static String routeName = '/signup_options';
  const SignupOptions({super.key});

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    // ThemeProvider themeProvider = ThemeProvider();
    return Scaffold(
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                SizedBox(height: MediaQuery.of(context).size.height * 0.1),
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
                        Text(
                          'Continue with Facebook',
                          style: TextStyle(
                              fontSize: 16,
                              color: themeProvider.isDark
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ],
                    ),
                    onPressed: () {
                      context
                          .read<FirebaseAuthMethods>()
                          .signInWithFacebook(context);
                    },
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
                        Text(
                          'Continue with Google',
                          style: TextStyle(
                              fontSize: 16,
                              color: themeProvider.isDark
                                  ? Colors.white
                                  : Colors.black),
                        ),
                      ],
                    ),
                    onPressed: () {
                      context
                          .read<FirebaseAuthMethods>()
                          .signInWithGoogle(context);
                    },
                  ),
                ),
                // Container(
                //   height: 50,
                //   margin: const EdgeInsets.all(10.0),
                //   child: OutlinedButton(
                //     child: Row(
                //       children: <Widget>[
                //         Image.asset('assets/images/mobile.png',
                //             width: 30, height: 30),
                //         const SizedBox(width: 10),
                //         const Text(
                //           'Continue with Phone',
                //           style: TextStyle(color: Colors.black, fontSize: 16),
                //         ),
                //       ],
                //     ),
                //     onPressed: () {},
                //   ),
                // ),
                const SizedBox(height: 10),
                Container(
                  alignment: Alignment.center,
                  child: const Text('or'),
                ),
                const SizedBox(height: 10),
                Container(
                  margin: const EdgeInsets.all(10.0),
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style:
                        ElevatedButton.styleFrom(backgroundColor: Colors.black),
                    child: const Text('Login in with Email',
                        style: TextStyle(color: Colors.white, fontSize: 16)),
                    onPressed: () {
                      Navigator.pushNamed(context, LoginScreen.routeName);
                    },
                  ),
                ),
                const SizedBox(height: 10),
                Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      Text('Don\'t have an account? ',
                          style: TextStyle(color: Colors.grey[600])),
                      InkWell(
                        child: const Text('Sign up',
                            style: TextStyle(fontWeight: FontWeight.bold)),
                        onTap: () {
                          Navigator.pushNamed(context, SignupScreen.routeName);
                        },
                      ),
                    ]),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Icon(Icons.dark_mode),
              const Text('Dark Mode'),
              Switch(
                value: themeProvider.isDark,
                onChanged: (value) {
                  themeProvider.toggleTheme();
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

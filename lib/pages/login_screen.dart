import 'package:big_red/pages/forgot_password_screen.dart';
import 'package:big_red/pages/signup_screen.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';
import 'package:top_snackbar_flutter/top_snack_bar.dart';
import 'package:validators/validators.dart';
import 'package:top_snackbar_flutter/custom_snack_bar.dart';

import '../services/firebase_auth_methods.dart';

class LoginScreen extends StatefulWidget {
  static String routeName = '/login';
  const LoginScreen({Key? key}) : super(key: key);

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  void loginUser() async {
    showDialog(
        context: context,
        builder: (context) {
          return const Center(child: CircularProgressIndicator());
        });
    bool val = await context.read<FirebaseAuthMethods>().loginWithEmail(
          email: emailController.text.trim(),
          password: passwordController.text,
          context: context,
        );
    if (!mounted) return;
    if (!val) {
      Navigator.of(context).pop();
    }
    // Navigator.of(context)
    //     .pushNamedAndRemoveUntil('/', (Route<dynamic> route) => false);
  }

  bool isEmailCorrect = false;
  bool _hidePassword = true;

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Column(
            children: <Widget>[
              Container(
                alignment: Alignment.topLeft,
                margin: const EdgeInsets.only(top: 15, left: 10),
                child: IconButton(
                  onPressed: () {
                    Navigator.of(context).pop();
                  },
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: Colors.black,
                  ),
                ),
              ),
              Center(
                child: Image.asset(
                  'assets/images/logo.png',
                  width: MediaQuery.of(context).size.height * 0.3,
                  height: MediaQuery.of(context).size.height * 0.3,
                ),
              ),
              Text(
                'Login to Your Account',
                style: GoogleFonts.robotoSlab(
                  textStyle: const TextStyle(
                    fontSize: 28,
                    fontWeight: FontWeight.bold,
                  ),
                ),
              ),
              const SizedBox(height: 15),
              Container(
                height: 70,
                margin: const EdgeInsets.all(10.0),
                child: TextFormField(
                  controller: emailController,
                  onChanged: (val) {
                    setState(() {
                      isEmailCorrect = isEmail(val);
                    });
                  },
                  onTap: () {
                    showTopSnackBar(
                      Overlay.of(context),
                      const CustomSnackBar.info(
                        message:
                            'Info: Login button will appear when you enter a valid Email',
                      ),
                    );
                  },
                  decoration: InputDecoration(
                    prefixIcon: const Icon(Icons.email),
                    labelText: 'Email',
                    hintText: "your-email@domain.com",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10.0),
                    ),
                  ),
                  keyboardType: TextInputType.emailAddress,
                ),
              ),
              Container(
                height: 70,
                margin: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                child: Stack(
                  alignment: Alignment.centerRight,
                  children: <Widget>[
                    TextFormField(
                      obscureText: _hidePassword,
                      controller: passwordController,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.lock),
                        suffixIcon: IconButton(
                          icon: Icon(
                            // Based on passwordVisible state choose the icon
                            _hidePassword
                                ? Icons.visibility
                                : Icons.visibility_off,
                            color: Colors.grey,
                          ),
                          onPressed: () {
                            // Update the state i.e. toogle the state of passwordVisible variable
                            setState(() {
                              _hidePassword = !_hidePassword;
                            });
                          },
                        ),
                        labelText: "Password",
                        hintText: '***********',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10.0),
                        ),
                      ),
                      validator: (value) {
                        if (value!.isEmpty) {
                          return "Password is required";
                        }
                        if (value.length < 8) {
                          return "Password must be at least 8 characters";
                        }
                        return null;
                      },
                    ),
                  ],
                ),
              ),
              // const SizedBox(height: 10),
              isEmailCorrect
                  ? Container(
                      margin: const EdgeInsets.all(10.0),
                      width: double.infinity,
                      height: 50,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.black),
                        onPressed: loginUser,
                        child: const Text('Login',
                            style:
                                TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    )
                  : Container(),
              const SizedBox(height: 10),
              Container(
                alignment: Alignment.center,
                child: InkWell(
                  onTap: () {
                    // Navigate to Signup screen
                    // Navigator.of(context).push(
                    //   MaterialPageRoute(
                    //     builder: (BuildContext context) {
                    //       return const ForgotPasswordScreen();
                    //     },
                    //   ),
                    // );
                    Navigator.pushNamed(
                        context, ForgotPasswordScreen.routeName);
                  },
                  child: const Text(
                    'Forgot the password?',
                    style: TextStyle(
                      color: Colors.black,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Container(
                alignment: Alignment.center,
                child: const Text(
                  'or continue with',
                  style: TextStyle(
                    color: Colors.black,
                  ),
                ),
              ),
              const SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  OutlinedButton(
                    onPressed: () {
                      context
                          .read<FirebaseAuthMethods>()
                          .signInWithFacebook(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(8.1),
                      child: Image.asset('assets/images/facebook.png',
                          width: 35, height: 35),
                    ),
                  ),
                  const SizedBox(width: 10),
                  OutlinedButton(
                    onPressed: () {
                      context
                          .read<FirebaseAuthMethods>()
                          .signInWithGoogle(context);
                    },
                    child: Padding(
                      padding: const EdgeInsets.all(10.0),
                      child: Image.asset('assets/images/google.png',
                          width: 30, height: 30),
                    ),
                  ),
                  // const SizedBox(width: 10),
                  // OutlinedButton(
                  //   onPressed: () {},
                  //   child: Padding(
                  //     padding: const EdgeInsets.all(10.0),
                  //     child: Image.asset('assets/images/mobile.png',
                  //         width: 30, height: 30),
                  //   ),
                  // ),
                ],
              ),
              const SizedBox(height: 25),
              Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    const Text('Don\'t have an account? ',
                        style: TextStyle(color: Colors.grey)),
                    InkWell(
                      child: const Text('Sign up',
                          style: TextStyle(color: Colors.black)),
                      onTap: () {
                        Navigator.pushReplacementNamed(
                            context, SignupScreen.routeName);
                      },
                    ),
                  ]),
            ],
          ),
        ),
      ),
    );
  }
}

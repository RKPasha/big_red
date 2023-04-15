import 'package:big_red/models/usersModel.dart';
import 'package:big_red/services/userServices.dart';
import 'package:big_red/utils/side_navbar.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AdminHomePage extends StatefulWidget {
  final User user;
  const AdminHomePage({super.key, required this.user});

  @override
  State<AdminHomePage> createState() => _AdminHomePageState();
}

class _AdminHomePageState extends State<AdminHomePage> {
  Stream<UsersModel> get tempUser async* {
    yield await UserService.getUserFromDatabase(widget.user.uid);
  }

  @override
  Widget build(BuildContext context) {
    return StreamBuilder<UsersModel>(
        stream: tempUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              appBar: AppBar(
                title: Center(
                  child: Text('Big-Red Auto Sales',
                      style: GoogleFonts.robotoSlab(
                          textStyle: const TextStyle(
                        fontSize: 22,
                        fontWeight: FontWeight.bold,
                      ))),
                ),
                backgroundColor: Colors.red,
              ),
              drawer: SideNav(
                  user: widget.user, usersModel: snapshot.data as UsersModel),
              body: Center(
                child: Text('Admin Home ${widget.user.email}'),
              ),
            );
          }
          if (snapshot.hasError) {
            return Center(
                child: Text(
                    'user fetch krny me msla aa rha hai ${snapshot.error}'));
          }
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.red,
          ));
        });
  }
}

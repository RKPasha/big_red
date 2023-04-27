import 'package:big_red/models/usersModel.dart';
import 'package:big_red/services/userServices.dart';
import 'package:big_red/utils/custom_appBar.dart';
import 'package:big_red/utils/custom_bootom_tabbar.dart';
import 'package:big_red/utils/side_navbar.dart';
import 'package:big_red/utils/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

class UserHomePage extends StatefulWidget {
  final User user;
  const UserHomePage({super.key, required this.user});

  @override
  State<UserHomePage> createState() => _UserHomePageState();
}

class _UserHomePageState extends State<UserHomePage> {
  Stream<UsersModel> get tempUser async* {
    yield await UserService.getUserFromDatabase(widget.user.uid);
  }

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  int _currentIndex = 0;
  String _searchQuery = '';

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  void _updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery;
    });
  }

  @override
  Widget build(BuildContext context) {
    ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);

    return StreamBuilder<UsersModel>(
        stream: tempUser,
        builder: (context, snapshot) {
          if (snapshot.hasData) {
            return Scaffold(
              key: scaffoldKey,
              appBar: CustomAppBar(
                scaffoldKey: scaffoldKey,
                searchHint: switchSearchHint(),
                isDark: themeProvider.isDark,
                onSearchQueryChanged: _updateSearchQuery,
              ),
              drawer: SideNav(
                  user: widget.user, usersModel: snapshot.data as UsersModel),
              bottomNavigationBar: CustomBottomNavigationBar(
                currentIndex: _currentIndex,
                onTap: _onTabTapped,
              ),
              body: _buildBody(),
            );
          } else if (snapshot.hasError) {
            return Center(
              child:
                  Text('user fetch krny me msla aa rha hai ${snapshot.error}'),
            );
          }
          return const Center(
              child: CircularProgressIndicator(
            color: Colors.red,
          ));
        });
  }

  Widget _buildBody() {
    switch (_currentIndex) {
      case 0:
        // return CarsTab();
        return Center(
          child: Text('Cars Tab $_searchQuery'),
        );
      case 1:
        // return ServicesTab();
        return Center(
          child: Text('Services Tab $_searchQuery'),
        );
      case 2:
        // return ChatsTab();
        return Center(
          child: Text('Chats Tab $_searchQuery'),
        );
      default:
        return Container();
    }
  }

  switchSearchHint() {
    switch (_currentIndex) {
      case 0:
        return 'Cars';
      case 1:
        return 'Services';
      case 2:
        return 'Chats';
      default:
        return 'Search';
    }
  }
}

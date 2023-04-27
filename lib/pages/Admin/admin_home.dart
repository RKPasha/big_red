import 'package:big_red/models/usersModel.dart';
import 'package:big_red/pages/Admin/admin_add_car_form.dart';
import 'package:big_red/pages/Admin/admin_services_tab.dart';
import 'package:big_red/pages/cars_tab.dart';
import 'package:big_red/pages/chats_tab.dart';
import 'package:big_red/services/userServices.dart';
import 'package:big_red/utils/custom_appBar.dart';
import 'package:big_red/utils/custom_bootom_tabbar.dart';
import 'package:big_red/utils/side_navbar.dart';
import 'package:big_red/utils/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:provider/provider.dart';

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

  final GlobalKey<ScaffoldState> scaffoldKey = GlobalKey<ScaffoldState>();
  late int _currentIndex;
  late PageController _pageController;
  String _searchQuery = '';

  void _onTabTapped(int index) {
    setState(() {
      _currentIndex = index;
      _searchQuery = '';
      _pageController.animateToPage(
        _currentIndex,
        duration: const Duration(milliseconds: 300),
        curve: Curves.ease,
      );
    });
  }

  void _updateSearchQuery(String newQuery) {
    setState(() {
      _searchQuery = newQuery;
    });
  }

  @override
  void initState() {
    super.initState();
    _currentIndex = 0;
    _pageController = PageController(initialPage: _currentIndex);
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
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
            floatingActionButton: FloatingActionButton(
              onPressed: floatingButtonPressed(),
              child: const Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerDocked,
            bottomNavigationBar: CustomBottomNavigationBar(
              currentIndex: _currentIndex,
              onTap: _onTabTapped,
            ),
            body: PageView(
              scrollDirection: Axis.horizontal,
              controller: _pageController,
              onPageChanged: (index) {
                setState(() {
                  _currentIndex = index;
                  _searchQuery = '';
                });
              },
              children: [
                const CarsTab(),
                AdminServicesTab(
                  searchQuery: _searchQuery,
                ),
                ChatsTab(
                  searchQuery: _searchQuery,
                ),
              ],
            ),
          );
        }
        if (snapshot.hasError) {
          return Center(
              child:
                  Text('user fetch krny me msla aa rha hai ${snapshot.error}'));
        }
        return const Center(
            child: CircularProgressIndicator(
          color: Colors.red,
        ));
      },
    );
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

  floatingButtonPressed() {
    switch (_currentIndex) {
      case 0:
        return () {
          // Navigator.pushNamed(context, '/addCar');
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddCarForm(),
            ),
          );
        };
      case 1:
        return () {
          // Navigator.pushNamed(context, '/addService');
        };
      case 2:
        return () {
          // Navigator.pushNamed(context, '/addChat');
        };
      default:
        return () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const AddCarForm(),
            ),
          );
        };
    }
  }
}

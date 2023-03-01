import 'package:big_red/models/usersModel.dart';
import 'package:big_red/pages/manage_accounts.dart';
import 'package:big_red/pages/profile_page.dart';
import 'package:big_red/utils/theme_provider.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../services/firebase_auth_methods.dart';

class SideNav extends StatefulWidget {
  final User user;
  final UsersModel usersModel;
  const SideNav({super.key, required this.user, required this.usersModel});

  @override
  State<SideNav> createState() => _SideNavState();
}

class _SideNavState extends State<SideNav> {
  String? _imageUrl;
  ThemeProvider themeProvider = ThemeProvider();

  @override
  void initState() {
    super.initState();
    _fetchImageUrlFromDatabase();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    themeProvider = Provider.of<ThemeProvider>(context);
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(
        children: [
          Expanded(
            child: ListView(
              // Remove padding
              padding: EdgeInsets.zero,
              children: [
                UserAccountsDrawerHeader(
                  accountName: Text(widget.usersModel.name ?? ''),
                  accountEmail: Text(widget.user.email!),
                  currentAccountPicture: CircleAvatar(
                      // backgroundImage: AssetImage('assets/images/person.png'),
                      // backgroundColor: Colors.white,
                      child: ClipOval(
                    child: _imageUrl != null
                        ? Image.network(
                            _imageUrl!,
                            fit: BoxFit.fill,
                          )
                        : const Image(
                            image: AssetImage('assets/images/person.png'),
                            fit: BoxFit.fill,
                          ),
                  )),
                  decoration: const BoxDecoration(
                    color: Colors.red,
                    image: DecorationImage(
                        fit: BoxFit.fill,
                        image: AssetImage('assets/images/2020-05-22.jpg')),
                  ),
                ),
                ListTile(
                  leading: const Icon(Icons.favorite),
                  title: const Text('Favorites'),
                  onTap: () => null,
                ),
                ListTile(
                  leading: const Icon(Icons.person),
                  title: const Text('Friends'),
                  onTap: () => null,
                ),
                ListTile(
                  leading: const Icon(Icons.share),
                  title: const Text('Share'),
                  onTap: () => null,
                ),
                ListTile(
                  leading: const Icon(Icons.notifications),
                  title: const Text('Notifications'),
                  trailing: ClipOval(
                    child: Container(
                      color: Colors.red,
                      width: 20,
                      height: 20,
                      child: const Center(
                        child: Text(
                          '8',
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 12,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const Divider(),
                ListTile(
                  leading: const Icon(Icons.settings),
                  title: const Text('Settings'),
                  onTap: () async {
                    await Navigator.of(context)
                        .push(
                      MaterialPageRoute(
                        builder: (context) => ProfilePage(
                            user: widget.user, usersModel: widget.usersModel),
                      ),
                    )
                        .then((value) {
                      setState(() {
                        _fetchImageUrlFromDatabase();
                      });
                    });
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.manage_accounts_rounded),
                  title: const Text('Manage Accounts'),
                  onTap: () {
                    Navigator.of(context).push(
                      MaterialPageRoute(
                        builder: (context) => const ManageAccounts(),
                      ),
                    );
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.delete_forever),
                  title: const Text('Delete Account'),
                  onTap: () {
                    //show alert dialog to confirm account deletion
                    showDialog(
                      context: context,
                      builder: (context) => AlertDialog(
                        title: Row(
                          children: const [
                            Icon(
                              Icons.warning_amber_rounded,
                              color: Colors.red,
                            ),
                            Text('  Delete Account'),
                          ],
                        ),
                        content: const Text(
                            'Are you sure you want to delete your account?'),
                        actions: [
                          TextButton(
                            onPressed: () {
                              Navigator.of(context).pop();
                            },
                            child: const Text('Cancel'),
                          ),
                          TextButton(
                            onPressed: () async {
                              Navigator.of(context).pop();
                              showDialog(
                                context: context,
                                barrierDismissible: false,
                                builder: (context) => const Center(
                                  child: CircularProgressIndicator(),
                                ),
                              );
                              await context
                                  .read<FirebaseAuthMethods>()
                                  .deleteAccount(context);
                            },
                            child: const Text(
                              'Delete',
                              style: TextStyle(color: Colors.red),
                            ),
                          ),
                        ],
                      ),
                    );
                  },
                ),
                const Divider(),
                ListTile(
                  title: const Text('Sign Out'),
                  leading: const Icon(Icons.logout_rounded),
                  onTap: () {
                    context.read<FirebaseAuthMethods>().signOut(context);
                  },
                ),
              ],
            ),
          ),
          const Divider(),
          ListTile(
              title: const Text('Dark Mode'),
              leading: const Icon(Icons.dark_mode),
              trailing: Switch(
                value: themeProvider.isDark,
                onChanged: (value) {
                  setState(() {
                    themeProvider.toggleTheme();
                  });
                },
              )),
        ],
      ),
    );
  }

  Future<void> _fetchImageUrlFromDatabase() async {
    final ref = FirebaseDatabase.instance.ref('users/${widget.user.uid}');
    final snapshot = await ref.child('photo').get();

    if (snapshot.exists) {
      setState(() {
        _imageUrl = snapshot.value as String?;
      });
    }
  }
}

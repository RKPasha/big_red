import 'package:flutter/material.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final GlobalKey<ScaffoldState> scaffoldKey;
  final double appBarHeight = 65.0;
  final String searchHint;
  final bool isDark;
  final Function(String) onSearchQueryChanged;

  const CustomAppBar(
      {Key? key,
      required this.scaffoldKey,
      required this.searchHint,
      required this.isDark,
      required this.onSearchQueryChanged})
      : super(key: key);

  @override
  Size get preferredSize => Size.fromHeight(appBarHeight);

  @override
  Widget build(BuildContext context) {
    return AppBar(
      backgroundColor:
          isDark ? const Color.fromARGB(230, 14, 16, 1) : Colors.white,
      elevation: 5,
      automaticallyImplyLeading: false,
      title: Row(
        children: [
          IconButton(
            icon: Icon(
              Icons.menu,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () {
              scaffoldKey.currentState!.openDrawer();
            },
          ),
          Expanded(
            child: Column(
              children: [
                const SizedBox(height: 8),
                Container(
                  margin: const EdgeInsets.symmetric(horizontal: 16),
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: Colors.grey.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: TextField(
                    decoration: InputDecoration(
                      hintText: 'Search for $searchHint',
                      border: InputBorder.none,
                      icon: const Icon(Icons.search),
                    ),
                    onChanged: onSearchQueryChanged,
                  ),
                ),
              ],
            ),
          ),
          IconButton(
            icon: Icon(
              Icons.notifications,
              color: isDark ? Colors.white : Colors.black,
            ),
            onPressed: () {
              // Open notifications screen
            },
          ),
        ],
      ),
    );
  }
}

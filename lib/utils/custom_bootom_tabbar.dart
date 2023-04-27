import 'package:flutter/material.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final int currentIndex;
  final Function(int) onTap;

  const CustomBottomNavigationBar(
      {super.key, required this.currentIndex, required this.onTap});

  @override
  State<CustomBottomNavigationBar> createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar> {
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return BottomAppBar(
      color: isDark ? const Color.fromARGB(230, 14, 16, 1) : Colors.white,
      elevation: 8.0,
      shape: const CircularNotchedRectangle(),
      notchMargin: 8.0,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          IconButton(
            icon: const Icon(Icons.directions_car),
            color: widget.currentIndex == 0 ? Colors.blue : Colors.grey,
            onPressed: () => widget.onTap(0),
            // onPressed: () => onItemSelected(0),
          ),
          IconButton(
            icon: const Icon(Icons.build),
            color: widget.currentIndex == 1 ? Colors.blue : Colors.grey,
            onPressed: () => widget.onTap(1),
            // onPressed: () => onItemSelected(1),
          ),
          const SizedBox(width: 64.0),
          IconButton(
            icon: const Icon(Icons.chat),
            color: widget.currentIndex == 2 ? Colors.blue : Colors.grey,
            onPressed: () => widget.onTap(2),
            // onPressed: () => onItemSelected(2),
          ),
          IconButton(
            icon: const Icon(Icons.notifications),
            color: widget.currentIndex == 3 ? Colors.blue : Colors.grey,
            onPressed: () => {},
            // onPressed: () => onItemSelected(3),
          ),
        ],
      ),
    );
  }
}

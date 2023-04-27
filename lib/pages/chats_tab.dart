import 'package:flutter/material.dart';

class ChatsTab extends StatefulWidget {
  final String searchQuery;
  const ChatsTab({super.key, required this.searchQuery});

  @override
  State<ChatsTab> createState() => _ChatsTabState();
}

class _ChatsTabState extends State<ChatsTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Chats Tab ${widget.searchQuery}'),
    );
  }
}

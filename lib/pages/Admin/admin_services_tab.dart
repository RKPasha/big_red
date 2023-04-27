import 'package:flutter/material.dart';

class AdminServicesTab extends StatefulWidget {
  final String searchQuery;
  const AdminServicesTab({super.key, required this.searchQuery});

  @override
  State<AdminServicesTab> createState() => _AdminServicesTabState();
}

class _AdminServicesTabState extends State<AdminServicesTab> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text('Services Tab ${widget.searchQuery}'),
    );
  }
}

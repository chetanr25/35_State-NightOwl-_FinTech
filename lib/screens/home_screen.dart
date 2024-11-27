import 'package:fintech/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = const [
    Center(child: Text('SME Dashboard')),
    Center(child: Text('Investor Dashboard')),
    Center(child: Text('Investment Opportunities')),
    Center(child: Text('Profile')),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('SME Investment Platform'),
      ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: AppBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

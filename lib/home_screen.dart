import 'package:fintech/models/users_models.dart';
import 'package:fintech/screens/investment_screen.dart';
import 'package:fintech/screens/profile_screen.dart';
import 'package:fintech/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    Center(child: Text('SME Dashboard')),
    InvestmentsScreen(),
    Center(child: Text('Investment Opportunities')),
    ProfileScreen(user: UserModel.dummyUser(type: UserType.sme)),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      // appBar: AppBar(
      //   title: const Text('SME Investment Platform'),
      // ),
      body: _pages[_selectedIndex],
      bottomNavigationBar: AppBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

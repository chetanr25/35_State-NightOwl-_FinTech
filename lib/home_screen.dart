import 'package:fintech/models/users_models.dart';
import 'package:fintech/providers/user_providers.dart';
import 'package:fintech/screens/investment_screen.dart';
import 'package:fintech/screens/profile_screen.dart';
import 'package:fintech/widgets/bottom_nav_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class HomePage extends ConsumerStatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  @override
  void initState() {
    super.initState();
    user = ref.read(userProvider);
  }

  int _selectedIndex = 0;
  late UserModel user;
  late List<Widget> _pages = [
    Center(child: Text('SME Dashboard')),
    InvestmentsScreen(),
    Center(child: Text('Investment Opportunities')),
    ProfileScreen(user: user),
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

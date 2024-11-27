import 'package:fintech/models/users_models.dart';
import 'package:fintech/providers/user_providers.dart';
import 'package:fintech/screens/investers/investment_screen.dart';
import 'package:fintech/screens/investers/opportunities.dart';
import 'package:fintech/screens/profile_screen.dart';
import 'package:fintech/screens/sme/sme_dashboard.dart';
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
    // print(user.toFirestore());
  }

  int _selectedIndex = 0;
  late UserModel user;
  // ignore: prefer_final_fields
  late List<Widget> _pages = [
    SmeDashboard(),
    InvestmentsScreen(),
    OpportunitiesScreen(),
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
      body: _pages[_selectedIndex],
      bottomNavigationBar: AppBottomNavBar(
        selectedIndex: _selectedIndex,
        onItemTapped: _onItemTapped,
      ),
    );
  }
}

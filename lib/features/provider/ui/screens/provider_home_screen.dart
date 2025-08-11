import 'package:car_wash/features/provider/ui/screens/provider_appointments_screen.dart';
import 'package:car_wash/features/provider/ui/screens/provider_earnings_screen.dart';
import 'package:car_wash/features/provider/ui/screens/provider_profile_screen.dart';
import 'package:car_wash/features/provider/ui/widgets/provider_dashboard.dart';
import 'package:flutter/material.dart';

class ProviderHomeScreen extends StatefulWidget {
  const ProviderHomeScreen({super.key});

  @override
  State<ProviderHomeScreen> createState() => _ProviderHomeScreenState();
}

class _ProviderHomeScreenState extends State<ProviderHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ProviderDashboard(),
    const ProviderAppointmentsScreen(),
    const ProviderEarningsScreen(),
    const ProviderProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _pages[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        currentIndex: _selectedIndex,
        onTap: (index) => setState(() => _selectedIndex = index),
        selectedItemColor: const Color(0xFF2196F3),
        unselectedItemColor: Colors.grey,
        items: const [
          BottomNavigationBarItem(
              icon: Icon(Icons.dashboard), label: 'Dashboard'),
          BottomNavigationBarItem(
              icon: Icon(Icons.schedule), label: 'Appointments'),
          BottomNavigationBarItem(
              icon: Icon(Icons.monetization_on), label: 'Earnings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

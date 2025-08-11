import 'package:car_wash/features/client/ui/screens/booking_screen.dart';
import 'package:car_wash/features/client/ui/screens/client_bookings_screen.dart';
import 'package:car_wash/features/client/ui/widgets/client_dashboard.dart';
import 'package:car_wash/features/client/ui/screens/client_profile_screen.dart';
import 'package:flutter/material.dart';

class ClientHomeScreen extends StatefulWidget {
  const ClientHomeScreen({super.key});

  @override
  State<ClientHomeScreen> createState() => _ClientHomeScreenState();
}

class _ClientHomeScreenState extends State<ClientHomeScreen> {
  int _selectedIndex = 0;

  final List<Widget> _pages = [
    const ClientDashboard(),
    const BookingScreen(),
    const ClientBookingsScreen(),
    const ClientProfileScreen(),
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
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.add_circle), label: 'Book'),
          BottomNavigationBarItem(icon: Icon(Icons.list), label: 'My Bookings'),
          BottomNavigationBarItem(icon: Icon(Icons.person), label: 'Profile'),
        ],
      ),
    );
  }
}

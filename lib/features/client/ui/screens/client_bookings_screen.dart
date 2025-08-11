import 'package:flutter/material.dart';
import '../../../../core/constants/colors.dart';
import '../../data/models/booking.dart';
import '../widgets/booking_card.dart';

class ClientBookingsScreen extends StatelessWidget {
  const ClientBookingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final bookings = [
      Booking(
        id: '001',
        service: 'Basic Wash',
        date: '15/8/2025',
        time: '10:00 AM',
        status: 'Upcoming',
        price: 299,
      ),
      Booking(
        id: '002',
        service: 'Premium Wash',
        date: '12/8/2025',
        time: '2:30 PM',
        status: 'Completed',
        price: 599,
      ),
      Booking(
        id: '003',
        service: 'Interior Clean',
        date: '8/8/2025',
        time: '11:00 AM',
        status: 'Cancelled',
        price: 499,
      ),
    ];

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Column(
          children: [
            // Modern Gradient Header
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(0, 48, 0, 32),
              decoration: const BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.vertical(
                  bottom: Radius.circular(32),
                ),
                boxShadow: [
                  BoxShadow(
                    color: AppColors.shadowColor,
                    blurRadius: 16,
                    offset: Offset(0, 8),
                  ),
                ],
              ),
              child: Column(
                children: [
                  Icon(Icons.calendar_month, size: 48, color: AppColors.surface),
                  const SizedBox(height: 12),
                  const Text(
                    'My Bookings',
                    style: TextStyle(
                      fontSize: 28,
                      fontWeight: FontWeight.w800,
                      color: AppColors.surface,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 6),
                  const Text(
                    'Track and manage your car wash appointments',
                    style: TextStyle(
                      fontSize: 15,
                      color: AppColors.surface,
                      fontWeight: FontWeight.w400,
                    ),
                  ),
                ],
              ),
            ),
            // List or Empty State
            Expanded(
              child: bookings.isEmpty
                  ? _buildEmptyState()
                  : ListView.separated(
                      padding: const EdgeInsets.fromLTRB(20, 32, 20, 20),
                      itemCount: bookings.length,
                      separatorBuilder: (_, __) => const SizedBox(height: 0),
                      itemBuilder: (context, index) {
                        return TweenAnimationBuilder<double>(
                          tween: Tween(begin: 0, end: 1),
                          duration: Duration(milliseconds: 400 + index * 100),
                          builder: (context, value, child) {
                            return Opacity(
                              opacity: value,
                              child: Transform.translate(
                                offset: Offset(0, 40 * (1 - value)),
                                child: child,
                              ),
                            );
                          },
                          child: BookingCard(booking: bookings[index]),
                        );
                      },
                    ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Padding(
        padding: const EdgeInsets.only(top: 60),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(Icons.inbox, size: 80, color: AppColors.primary.withOpacity(0.15)),
            const SizedBox(height: 24),
            const Text(
              'No Bookings Yet',
              style: TextStyle(
                fontSize: 22,
                fontWeight: FontWeight.w700,
                color: AppColors.textSecondary,
              ),
            ),
            const SizedBox(height: 8),
            const Text(
              'You have not booked any car wash services yet.',
              style: TextStyle(
                fontSize: 15,
                color: AppColors.textTertiary,
              ),
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

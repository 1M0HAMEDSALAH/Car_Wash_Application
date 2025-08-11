import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/colors.dart';
import '../../../../core/widgets/action_card.dart';
import '../../../auth/ui/screens/login_screen.dart';
import '../../data/models/appointment.dart';
import '../screens/provider_appointments_screen.dart';
import '../screens/provider_earnings_screen.dart';
import 'appointment_card.dart';
import 'earning_card.dart';

class ProviderDashboard extends StatefulWidget {
  const ProviderDashboard({super.key});

  @override
  State<ProviderDashboard> createState() => _ProviderDashboardState();
}

class _ProviderDashboardState extends State<ProviderDashboard>
    with TickerProviderStateMixin {
  bool _isOnline = true;
  late AnimationController _pulseController;
  late Animation<double> _pulseAnimation;
  final ScrollController _scrollController = ScrollController();

  // Sample data - in real app, this would come from state management
  List<Appointment> _appointments = [
    Appointment(
      id: '001',
      service: 'Basic Wash',
      customer: 'John Doe',
      date: '15/8/2025',
      time: '10:00 AM',
      address: '123 Main St, City',
      price: 299,
      status: 'pending',
    ),
    Appointment(
      id: '002',
      service: 'Premium Wash',
      customer: 'Sarah Smith',
      date: '15/8/2025',
      time: '2:30 PM',
      address: '456 Oak Ave, City',
      price: 599,
      status: 'progress',
    ),
    Appointment(
      id: '003',
      service: 'Interior Clean',
      customer: 'Mike Johnson',
      date: '14/8/2025',
      time: '11:00 AM',
      address: '789 Pine Rd, City',
      price: 499,
      status: 'completed',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _pulseController = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    );
    _pulseAnimation = Tween<double>(
      begin: 1.0,
      end: 1.1,
    ).animate(CurvedAnimation(
      parent: _pulseController,
      curve: Curves.easeInOut,
    ));
    
    if (_isOnline) {
      _pulseController.repeat(reverse: true);
    }
  }

  @override
  void dispose() {
    _pulseController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _handleStatusChanged(String appointmentId, String newStatus) {
    setState(() {
      final index = _appointments.indexWhere((apt) => apt.id == appointmentId);
      if (index != -1) {
        _appointments[index] = Appointment(
          id: _appointments[index].id,
          service: _appointments[index].service,
          customer: _appointments[index].customer,
          date: _appointments[index].date,
          time: _appointments[index].time,
          address: _appointments[index].address,
          price: _appointments[index].price,
          status: newStatus,
        );
      }
    });
    
    // Provide haptic feedback
    HapticFeedback.lightImpact();
  }

  @override
  Widget build(BuildContext context) {
    final todayAppointments = _appointments.where((apt) => apt.date == '15/8/2025').toList();
    final pendingCount = _appointments.where((apt) => apt.status == 'pending').length;
    final totalEarnings = _appointments
        .where((apt) => apt.status == 'completed')
        .fold(0, (sum, apt) => sum + apt.price);

    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: CustomScrollView(
          controller: _scrollController,
          slivers: [
            // Custom App Bar
            SliverAppBar(
              expandedHeight: 120,
              floating: false,
              pinned: true,
              backgroundColor: Colors.transparent,
              elevation: 0,
              flexibleSpace: FlexibleSpaceBar(
                background: Container(
                  decoration: const BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.vertical(
                      bottom: Radius.circular(32),
                    ),
                  ),
                ),
              ),
              title: const Text(
                'Provider Dashboard',
                style: TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w700,
                ),
              ),
              actions: [
                // Online/Offline Toggle
                Container(
                  margin: const EdgeInsets.only(right: 8),
                  child: AnimatedBuilder(
                    animation: _pulseAnimation,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _isOnline ? _pulseAnimation.value : 1.0,
                        child: Switch(
                          value: _isOnline,
                          onChanged: _toggleOnlineStatus,
                          activeColor: AppColors.success,
                          inactiveThumbColor: AppColors.error,
                        ),
                      );
                    },
                  ),
                ),
                
                // Logout Button
                Container(
                  margin: const EdgeInsets.only(right: 16),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.2),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: IconButton(
                    icon: const Icon(Icons.logout, color: Colors.white),
                    onPressed: () => _showLogoutDialog(context),
                  ),
                ),
              ],
            ),

            // Main Content
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Welcome Section
                    Container(
                      padding: const EdgeInsets.all(24),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.shadowColor,
                            blurRadius: 16,
                            offset: const Offset(0, 8),
                          ),
                        ],
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Container(
                                padding: const EdgeInsets.all(12),
                                decoration: BoxDecoration(
                                  gradient: AppColors.primaryGradient,
                                  borderRadius: BorderRadius.circular(16),
                                ),
                                child: const Icon(
                                  Icons.waving_hand,
                                  color: Colors.white,
                                  size: 24,
                                ),
                              ),
                              const SizedBox(width: 16),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    const Text(
                                      'Welcome back!',
                                      style: TextStyle(
                                        fontSize: 24,
                                        fontWeight: FontWeight.w800,
                                        color: AppColors.textPrimary,
                                      ),
                                    ),
                                    Text(
                                      _isOnline 
                                        ? 'You are online and ready for bookings' 
                                        : 'You are offline',
                                      style: TextStyle(
                                        fontSize: 14,
                                        color: _isOnline ? AppColors.success : AppColors.error,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 16),
                          Text(
                            'Today is ${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}',
                            style: const TextStyle(
                              fontSize: 16,
                              color: AppColors.textSecondary,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    ),
                    
                    const SizedBox(height: 24),

                    // Stats Cards
                    Row(
                      children: [
                        Expanded(
                          child: EarningCard(
                            title: 'Today\'s Bookings',
                            amount: pendingCount.toString(),
                            color: AppColors.primary,
                            icon: Icons.schedule,
                            trend: '+2 from yesterday',
                            showTrend: true,
                            onTap: () => _navigateToAppointments(context, 'pending'),
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: EarningCard(
                            title: 'Today\'s Earnings',
                            amount: '₹2,450',
                            color: AppColors.success,
                            icon: Icons.monetization_on,
                            trend: '+12%',
                            showTrend: true,
                            onTap: () => _navigateToEarnings(context),
                          ),
                        ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    Row(
                      children: [
                        Expanded(
                          child: EarningCard(
                            title: 'This Month',
                            amount: '47',
                            color: AppColors.warning,
                            icon: Icons.calendar_month,
                            trend: '+8%',
                            showTrend: true,
                          ),
                        ),
                        const SizedBox(width: 16),
                        Expanded(
                          child: EarningCard(
                            title: 'Rating',
                            amount: '4.8⭐',
                            color: AppColors.pending,
                            icon: Icons.star,
                            onTap: () => _showRatingDetails(context),
                          ),
                        ),
                      ],
                    ),

                    const SizedBox(height: 32),

                    // Today's Appointments
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        const Text(
                          'Today\'s Appointments',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w800,
                            color: AppColors.textPrimary,
                          ),
                        ),
                        if (todayAppointments.isNotEmpty)
                          TextButton(
                            onPressed: () => _navigateToAppointments(context),
                            child: const Text(
                              'View All',
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                          ),
                      ],
                    ),
                    
                    const SizedBox(height: 16),
                    
                    if (todayAppointments.isEmpty)
                      _buildEmptyState()
                    else
                      ...todayAppointments.map(
                        (appointment) => AppointmentCard(
                          appointment: appointment,
                          onStatusChanged: _handleStatusChanged,
                        ),
                      ).toList(),

                    const SizedBox(height: 24),

                    // Quick Actions
                    const Text(
                      'Quick Actions',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w800,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    const SizedBox(height: 16),
                    
                    _buildQuickActions(),

                    const SizedBox(height: 32),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmptyState() {
    return Container(
      padding: const EdgeInsets.all(48),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 16,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: AppColors.primary.withOpacity(0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              Icons.event_available,
              size: 48,
              color: AppColors.primary,
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'No appointments today',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w700,
              color: AppColors.textPrimary,
            ),
          ),
          const SizedBox(height: 8),
          const Text(
            'You have a free day! Check tomorrow\'s schedule or promote your services.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 14,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildQuickActions() {
    return Column(
      children: [
        Row(
          children: [
            Expanded(
              child: ActionCard(
                title: 'View All\nAppointments',
                icon: Icons.schedule,
                color: AppColors.primary,
                onTap: () => _navigateToAppointments(context),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ActionCard(
                title: 'Earnings\nReport',
                icon: Icons.bar_chart,
                color: AppColors.success,
                onTap: () => _navigateToEarnings(context),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Row(
          children: [
            Expanded(
              child: ActionCard(
                title: 'Customer\nReviews',
                icon: Icons.star_rate,
                color: AppColors.warning,
                onTap: () => _showRatingDetails(context),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: ActionCard(
                title: 'Service\nSettings',
                icon: Icons.settings,
                color: AppColors.info,
                onTap: () => _showServiceSettings(context),
              ),
            ),
          ],
        ),
      ],
    );
  }

  void _toggleOnlineStatus(bool value) {
    setState(() {
      _isOnline = value;
    });
    
    if (value) {
      _pulseController.repeat(reverse: true);
    } else {
      _pulseController.stop();
    }

    HapticFeedback.selectionClick();
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          value ? 'You are now online and accepting bookings' : 'You are now offline',
        ),
        backgroundColor: value ? AppColors.success : AppColors.error,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void _navigateToAppointments(BuildContext context, [String? initialTab]) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const ProviderAppointmentsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
      ),
    );
  }

  void _navigateToEarnings(BuildContext context) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            const ProviderEarningsScreen(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return SlideTransition(
            position: animation.drive(
              Tween(begin: const Offset(1.0, 0.0), end: Offset.zero)
                  .chain(CurveTween(curve: Curves.easeInOut)),
            ),
            child: child,
          );
        },
      ),
    );
  }

  void _showRatingDetails(BuildContext context) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height * 0.7,
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Padding(
          padding: const EdgeInsets.all(24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: AppColors.textTertiary.withOpacity(0.3),
                    borderRadius: BorderRadius.circular(2),
                  ),
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Customer Reviews & Rating',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              Container(
                padding: const EdgeInsets.all(24),
                decoration: BoxDecoration(
                  gradient: AppColors.primaryGradient,
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Row(
                  children: [
                    Icon(Icons.star, color: Colors.white, size: 48),
                    SizedBox(width: 16),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            '4.8 out of 5',
                            style: TextStyle(
                              fontSize: 28,
                              fontWeight: FontWeight.w900,
                              color: Colors.white,
                            ),
                          ),
                          Text(
                            'Based on 125 reviews',
                            style: TextStyle(
                              fontSize: 14,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),
              const Text(
                'Recent Reviews',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 16),
              Expanded(
                child: ListView(
                  children: [
                    _buildReviewItem('John Doe', '5', 'Excellent service! Very professional and thorough.'),
                    _buildReviewItem('Sarah Smith', '5', 'Amazing work! Car looks brand new. Highly recommended.'),
                    _buildReviewItem('Mike Johnson', '4', 'Good service, arrived on time. Will book again.'),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildReviewItem(String name, String rating, String review) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CircleAvatar(
                backgroundColor: AppColors.primary,
                child: Text(
                  name.split(' ').map((n) => n[0]).join().toUpperCase(),
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w700,
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      name,
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.textPrimary,
                      ),
                    ),
                    Row(
                      children: List.generate(5, (index) {
                        return Icon(
                          index < int.parse(rating) ? Icons.star : Icons.star_border,
                          color: Colors.orange,
                          size: 16,
                        );
                      }),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            review,
            style: const TextStyle(
              color: AppColors.textSecondary,
              fontSize: 14,
            ),
          ),
        ],
      ),
    );
  }

  void _showServiceSettings(BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Service settings feature coming soon'),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showLogoutDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.error.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.logout, color: AppColors.error),
            ),
            const SizedBox(width: 12),
            const Text('Logout'),
          ],
        ),
        content: const Text('Are you sure you want to logout? You will stop receiving new bookings.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              Navigator.pushAndRemoveUntil(
                context,
                PageRouteBuilder(
                  pageBuilder: (context, animation, secondaryAnimation) =>
                      const LoginScreen(),
                  transitionsBuilder: (context, animation, secondaryAnimation, child) {
                    return FadeTransition(opacity: animation, child: child);
                  },
                ),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(backgroundColor: AppColors.error),
            child: const Text('Logout'),
          ),
        ],
      ),
    );
  }
}
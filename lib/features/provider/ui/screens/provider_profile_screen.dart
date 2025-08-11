import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/colors.dart';
import '../../../auth/ui/screens/login_screen.dart';

class ProviderProfileScreen extends StatefulWidget {
  const ProviderProfileScreen({super.key});

  @override
  State<ProviderProfileScreen> createState() => _ProviderProfileScreenState();
}

class _ProviderProfileScreenState extends State<ProviderProfileScreen>
    with TickerProviderStateMixin {
  late AnimationController _headerController;
  late AnimationController _itemsController;
  late Animation<double> _headerAnimation;
  late Animation<double> _itemsAnimation;

  bool _notificationsEnabled = true;
  bool _locationEnabled = true;
  bool _autoAcceptBookings = false;

  @override
  void initState() {
    super.initState();

    _headerController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _itemsController = AnimationController(
      duration: const Duration(milliseconds: 600),
      vsync: this,
    );

    _headerAnimation = CurvedAnimation(
      parent: _headerController,
      curve: Curves.easeOutBack,
    );

    _itemsAnimation = CurvedAnimation(
      parent: _itemsController,
      curve: Curves.easeOutCubic,
    );

    // Start animations
    _headerController.forward();
    Future.delayed(const Duration(milliseconds: 300), () {
      if (mounted) {
        _itemsController.forward();
      }
    });
  }

  @override
  void dispose() {
    _headerController.dispose();
    _itemsController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.background,
      body: Container(
        decoration: const BoxDecoration(
          gradient: AppColors.backgroundGradient,
        ),
        child: Column(
          children: [
            // Enhanced Header with Floating Profile Card
            AnimatedBuilder(
              animation: _headerAnimation,
              builder: (context, child) {
                return Transform.scale(
                  scale: _headerAnimation.value,
                  child: Stack(
                    children: [
                      // Background Header
                      SafeArea(
                        child: Padding(
                          padding: const EdgeInsets.all(20),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              const Text(
                                'Profile',
                                style: TextStyle(
                                  fontSize: 28,
                                  fontWeight: FontWeight.w900,
                                  color: Colors.white,
                                ),
                              ),
                              Row(
                                children: [
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.settings, color: Colors.white),
                                      onPressed: _showSettings,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Container(
                                    decoration: BoxDecoration(
                                      color: Colors.white.withOpacity(0.2),
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                    child: IconButton(
                                      icon: const Icon(Icons.edit, color: Colors.white),
                                      onPressed: _editProfile,
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // Floating Profile Card
                      Container(
                        padding: const EdgeInsets.all(28),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(28),
                          boxShadow: [
                            BoxShadow(
                              color: AppColors.primary.withOpacity(0.15),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: Column(
                          children: [
                            // Profile Avatar with Status Indicator
                            Stack(
                              children: [
                                Container(
                                  padding: const EdgeInsets.all(8),
                                  decoration: BoxDecoration(
                                    gradient: AppColors.primaryGradient,
                                    shape: BoxShape.circle,
                                    boxShadow: [
                                      BoxShadow(
                                        color: AppColors.primary.withOpacity(0.3),
                                        blurRadius: 16,
                                        offset: const Offset(0, 8),
                                      ),
                                    ],
                                  ),
                                  child: const CircleAvatar(
                                    radius: 48,
                                    backgroundColor: Colors.white,
                                    child: Text(
                                      'CW',
                                      style: TextStyle(
                                        fontSize: 36,
                                        color: AppColors.primary,
                                        fontWeight: FontWeight.w900,
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  right: 8,
                                  bottom: 8,
                                  child: Container(
                                    padding: const EdgeInsets.all(4),
                                    decoration: const BoxDecoration(
                                      color: Colors.white,
                                      shape: BoxShape.circle,
                                    ),
                                    child: Container(
                                      width: 16,
                                      height: 16,
                                      decoration: const BoxDecoration(
                                        color: AppColors.success,
                                        shape: BoxShape.circle,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            const SizedBox(height: 20),
                      
                            // Name and Email
                            const Text(
                              'Car Wash Pro Services',
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w900,
                                color: AppColors.textPrimary,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
                              decoration: BoxDecoration(
                                color: AppColors.success.withOpacity(0.1),
                                borderRadius: BorderRadius.circular(20),
                              ),
                              child: const Text(
                                'ACTIVE PROVIDER',
                                style: TextStyle(
                                  fontSize: 12,
                                  fontWeight: FontWeight.w800,
                                  color: AppColors.success,
                                  letterSpacing: 0.5,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              'provider@carwashpro.com',
                              style: TextStyle(
                                fontSize: 16,
                                color: AppColors.textSecondary,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                      
                            const SizedBox(height: 20),
                      
                            // Stats Row
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                _buildStatItem('4.8⭐', 'Rating', AppColors.warning),
                                Container(width: 1, height: 40, color: AppColors.textTertiary.withOpacity(0.3)),
                                _buildStatItem('125', 'Reviews', AppColors.info),
                                Container(width: 1, height: 40, color: AppColors.textTertiary.withOpacity(0.3)),
                                _buildStatItem('420', 'Jobs Done', AppColors.success),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                );
              },
            ),

            const SizedBox(height: 8), // Space for floating card

            // Profile Items List
            Expanded(
              child: AnimatedBuilder(
                animation: _itemsAnimation,
                builder: (context, child) {
                  return Opacity(
                    opacity: _itemsAnimation.value,
                    child: Transform.translate(
                      offset: Offset(0, 50 * (1 - _itemsAnimation.value)),
                      child: SingleChildScrollView(
                        padding: const EdgeInsets.symmetric(horizontal: 20),
                        child: Column(
                          children: [
                            // Account Section
                            _buildSectionHeader('Account'),
                            _buildProfileItem(
                              icon: Icons.phone,
                              iconBg: AppColors.primary,
                              title: 'Contact Information',
                              subtitle: '+91 98765 43210',
                              onTap: _editContactInfo,
                            ),
                            _buildProfileItem(
                              icon: Icons.location_on,
                              iconBg: AppColors.secondary,
                              title: 'Service Areas',
                              subtitle: 'Downtown, Midtown, Suburbs',
                              onTap: _manageServiceAreas,
                            ),
                            _buildProfileItem(
                              icon: Icons.schedule,
                              iconBg: AppColors.info,
                              title: 'Working Hours',
                              subtitle: '9:00 AM - 8:00 PM',
                              onTap: _setWorkingHours,
                            ),

                            const SizedBox(height: 24),

                            // Business Section
                            _buildSectionHeader('Business'),
                            _buildProfileItem(
                              icon: Icons.monetization_on,
                              iconBg: AppColors.success,
                              title: 'Payment Settings',
                              subtitle: 'Bank account and preferences',
                              onTap: _managePayments,
                            ),
                            _buildProfileItem(
                              icon: Icons.build,
                              iconBg: AppColors.warning,
                              title: 'Services & Pricing',
                              subtitle: 'Manage your service offerings',
                              onTap: _manageServices,
                            ),
                            _buildProfileItem(
                              icon: Icons.star_rate,
                              iconBg: AppColors.pending,
                              title: 'Reviews & Ratings',
                              subtitle: 'View customer feedback',
                              onTap: _viewReviews,
                            ),

                            const SizedBox(height: 24),

                            // App Section
                            _buildSectionHeader('App Settings'),
                            _buildSwitchItem(
                              icon: Icons.notifications,
                              iconBg: AppColors.error,
                              title: 'Push Notifications',
                              subtitle: 'Receive booking alerts',
                              value: _notificationsEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _notificationsEnabled = value;
                                });
                                HapticFeedback.lightImpact();
                              },
                            ),
                            _buildSwitchItem(
                              icon: Icons.location_on,
                              iconBg: AppColors.info,
                              title: 'Location Services',
                              subtitle: 'Share location with customers',
                              value: _locationEnabled,
                              onChanged: (value) {
                                setState(() {
                                  _locationEnabled = value;
                                });
                                HapticFeedback.lightImpact();
                              },
                            ),
                            _buildSwitchItem(
                              icon: Icons.auto_awesome,
                              iconBg: AppColors.secondary,
                              title: 'Auto-Accept Bookings',
                              subtitle: 'Automatically accept new bookings',
                              value: _autoAcceptBookings,
                              onChanged: (value) {
                                setState(() {
                                  _autoAcceptBookings = value;
                                });
                                HapticFeedback.lightImpact();
                              },
                            ),

                            const SizedBox(height: 24),

                            // Support Section
                            _buildSectionHeader('Support & Legal'),
                            _buildProfileItem(
                              icon: Icons.help,
                              iconBg: AppColors.infoLight,
                              title: 'Help & Support',
                              subtitle: 'Get help and contact support',
                              onTap: _showSupport,
                            ),
                            _buildProfileItem(
                              icon: Icons.policy,
                              iconBg: AppColors.textTertiary,
                              title: 'Terms & Privacy',
                              subtitle: 'App policies and terms',
                              onTap: _showTerms,
                            ),
                            _buildProfileItem(
                              icon: Icons.info,
                              iconBg: AppColors.textSecondary,
                              title: 'About App',
                              subtitle: 'Version 1.0.0',
                              onTap: _showAbout,
                            ),

                            const SizedBox(height: 32),

                            // Logout Button
                            Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                gradient: LinearGradient(
                                  colors: [AppColors.error, AppColors.error.withOpacity(0.8)],
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                ),
                                borderRadius: BorderRadius.circular(20),
                                boxShadow: [
                                  BoxShadow(
                                    color: AppColors.error.withOpacity(0.3),
                                    blurRadius: 16,
                                    offset: const Offset(0, 8),
                                  ),
                                ],
                              ),
                              child: ElevatedButton.icon(
                                onPressed: () => _showLogoutDialog(context),
                                icon: const Icon(Icons.logout, color: Colors.white),
                                label: const Text(
                                  'Logout',
                                  style: TextStyle(
                                    fontSize: 16,
                                    fontWeight: FontWeight.w800,
                                    color: Colors.white,
                                  ),
                                ),
                                style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.transparent,
                                  shadowColor: Colors.transparent,
                                  padding: const EdgeInsets.symmetric(vertical: 20),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                ),
                              ),
                            ),

                            const SizedBox(height: 32),
                          ],
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String value, String label, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.w900,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          style: const TextStyle(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: AppColors.textSecondary,
          ),
        ),
      ],
    );
  }

  Widget _buildSectionHeader(String title) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: Row(
        children: [
          Container(
            width: 4,
            height: 20,
            decoration: BoxDecoration(
              gradient: AppColors.primaryGradient,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 12),
          Text(
            title.toUpperCase(),
            style: const TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w800,
              color: AppColors.textSecondary,
              letterSpacing: 1,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildProfileItem({
    required IconData icon,
    required Color iconBg,
    required String title,
    required String subtitle,
    required VoidCallback onTap,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: iconBg.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(20),
          onTap: () {
            HapticFeedback.selectionClick();
            onTap();
          },
          child: Padding(
            padding: const EdgeInsets.all(20),
            child: Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(14),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [iconBg, iconBg.withOpacity(0.7)],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Icon(icon, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 20),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 4),
                      Text(
                        subtitle,
                        style: const TextStyle(
                          fontSize: 14,
                          color: AppColors.textSecondary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: AppColors.textTertiary.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: const Icon(
                    Icons.chevron_right,
                    color: AppColors.textTertiary,
                    size: 20,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildSwitchItem({
    required IconData icon,
    required Color iconBg,
    required String title,
    required String subtitle,
    required bool value,
    required ValueChanged<bool> onChanged,
  }) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: iconBg.withOpacity(0.08),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: iconBg.withOpacity(0.15),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Icon(icon, color: iconBg, size: 24),
            ),
            const SizedBox(width: 20),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: AppColors.textPrimary,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    subtitle,
                    style: const TextStyle(
                      fontSize: 14,
                      color: AppColors.textSecondary,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ],
              ),
            ),
            Switch(
              value: value,
              onChanged: onChanged,
              activeColor: iconBg,
              inactiveThumbColor: AppColors.textTertiary,
            ),
          ],
        ),
      ),
    );
  }

  // Action methods
  void _editProfile() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Edit profile feature coming soon'),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _showSettings() {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const SettingsScreen(),
      ),
    );
  }

  void _editContactInfo() {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.primary.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.phone, color: AppColors.primary),
            ),
            const SizedBox(width: 12),
            const Text('Edit Contact Info', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        content: TextField(
          decoration: InputDecoration(
            labelText: 'Phone Number',
            hintText: '+91 98765 43210',
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
          ),
          keyboardType: TextInputType.phone,
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Contact information updated'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _manageServiceAreas() {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ServiceAreasScreen(),
      ),
    );
  }

  void _setWorkingHours() {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.info.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.schedule, color: AppColors.info),
            ),
            const SizedBox(width: 12),
            const Text('Set Working Hours', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextButton(
              onPressed: () async {
                final TimeOfDay? startTime = await showTimePicker(
                  context: context,
                  initialTime: const TimeOfDay(hour: 9, minute: 0),
                );
                if (startTime != null) {
                  // Handle start time (e.g., update state or save to backend)
                }
              },
              child: const Text('Start Time: 9:00 AM'),
            ),
            TextButton(
              onPressed: () async {
                final TimeOfDay? endTime = await showTimePicker(
                  context: context,
                  initialTime: const TimeOfDay(hour: 20, minute: 0),
                );
                if (endTime != null) {
                  // Handle end time (e.g., update state or save to backend)
                }
              },
              child: const Text('End Time: 8:00 PM'),
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Cancel', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.of(context).pop();
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Working hours updated'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _managePayments() {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const PaymentSettingsScreen(),
      ),
    );
  }

  void _manageServices() {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ServicesPricingScreen(),
      ),
    );
  }

  void _viewReviews() {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ReviewsScreen(),
      ),
    );
  }

  void _showSupport() {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: AppColors.infoLight.withOpacity(0.1),
                borderRadius: BorderRadius.circular(12),
              ),
              child: const Icon(Icons.help, color: AppColors.infoLight),
            ),
            const SizedBox(width: 12),
            const Text('Help & Support', style: TextStyle(fontWeight: FontWeight.w700)),
          ],
        ),
        content: const Text('Contact support at support@carwashpro.com or call +1-800-123-4567.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('Close', style: TextStyle(fontWeight: FontWeight.w600)),
          ),
        ],
      ),
    );
  }

  void _showTerms() {
    HapticFeedback.lightImpact();
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const TermsPrivacyScreen(),
      ),
    );
  }

  void _showAbout() {
    HapticFeedback.lightImpact();
    showAboutDialog(
      context: context,
      applicationName: 'Car Wash Pro',
      applicationVersion: '1.0.0',
      applicationIcon: Container(
        padding: const EdgeInsets.all(8),
        decoration: BoxDecoration(
          gradient: AppColors.primaryGradient,
          borderRadius: BorderRadius.circular(12),
        ),
        child: const Icon(Icons.local_car_wash, color: Colors.white, size: 32),
      ),
      children: [
        const Text('A professional car wash service provider app.'),
      ],
    );
  }

  void _showLogoutDialog(BuildContext context) {
    HapticFeedback.lightImpact();
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
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
            const Text(
              'Logout',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          ],
        ),
        content: const Text(
          'Are you sure you want to logout? You will stop receiving new bookings.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text(
              'Cancel',
              style: TextStyle(fontWeight: FontWeight.w600),
            ),
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
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.error,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
            ),
            child: const Text('Logout', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

// Placeholder screens for navigation
class SettingsScreen extends StatelessWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
        backgroundColor: AppColors.primary,
      ),
      body: const Center(
        child: Text('Settings Screen', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}

class ServiceAreasScreen extends StatelessWidget {
  const ServiceAreasScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Manage Service Areas'),
        backgroundColor: AppColors.primary,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          CheckboxListTile(
            title: const Text('Downtown'),
            value: true,
            onChanged: (value) {},
            activeColor: AppColors.primary,
          ),
          CheckboxListTile(
            title: const Text('Midtown'),
            value: true,
            onChanged: (value) {},
            activeColor: AppColors.primary,
          ),
          CheckboxListTile(
            title: const Text('Suburbs'),
            value: true,
            onChanged: (value) {},
            activeColor: AppColors.primary,
          ),
          const SizedBox(height: 20),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Service areas updated'),
                  backgroundColor: AppColors.success,
                  behavior: SnackBarBehavior.floating,
                ),
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: AppColors.primary,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
              padding: const EdgeInsets.symmetric(vertical: 16),
            ),
            child: const Text('Save', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }
}

class PaymentSettingsScreen extends StatelessWidget {
  const PaymentSettingsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Payment Settings'),
        backgroundColor: AppColors.primary,
      ),
      body: const Center(
        child: Text('Payment Settings Screen', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}

class ServicesPricingScreen extends StatelessWidget {
  const ServicesPricingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Services & Pricing'),
        backgroundColor: AppColors.primary,
      ),
      body: const Center(
        child: Text('Services & Pricing Screen', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}

class ReviewsScreen extends StatelessWidget {
  const ReviewsScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Reviews & Ratings'),
        backgroundColor: AppColors.primary,
      ),
      body: const Center(
        child: Text('Reviews Screen', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}

class TermsPrivacyScreen extends StatelessWidget {
  const TermsPrivacyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Terms & Privacy'),
        backgroundColor: AppColors.primary,
      ),
      body: const Center(
        child: Text('Terms & Privacy Screen', style: TextStyle(fontSize: 20)),
      ),
    );
  }
}
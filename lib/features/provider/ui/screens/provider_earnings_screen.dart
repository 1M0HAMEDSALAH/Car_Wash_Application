import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/colors.dart';
import '../../data/models/appointment.dart';
import '../widgets/appointment_card.dart';

class ProviderAppointmentsScreen extends StatefulWidget {
  const ProviderAppointmentsScreen({super.key});

  @override
  State<ProviderAppointmentsScreen> createState() =>
      _ProviderAppointmentsScreenState();
}

class _ProviderAppointmentsScreenState extends State<ProviderAppointmentsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _fabController;
  late Animation<double> _fabAnimation;
  
  String _searchQuery = '';
  final TextEditingController _searchController = TextEditingController();
  
  // Sample data - in real app, this would come from state management
  final List<Appointment> _allAppointments = [
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
    Appointment(
      id: '004',
      service: 'Deluxe Wash',
      customer: 'Emma Wilson',
      date: '16/8/2025',
      time: '9:00 AM',
      address: '321 Elm St, City',
      price: 899,
      status: 'pending',
    ),
    Appointment(
      id: '005',
      service: 'Basic Wash',
      customer: 'Tom Brown',
      date: '13/8/2025',
      time: '3:00 PM',
      address: '654 Maple Ave, City',
      price: 299,
      status: 'completed',
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _fabController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fabAnimation = CurvedAnimation(
      parent: _fabController,
      curve: Curves.easeInOut,
    );
    
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        _fabController.forward();
        HapticFeedback.selectionClick();
      }
    });
    
    _fabController.forward();
  }

  @override
  void dispose() {
    _tabController.dispose();
    _fabController.dispose();
    _searchController.dispose();
    super.dispose();
  }

  void _handleStatusChanged(String appointmentId, String newStatus) {
    setState(() {
      final index = _allAppointments.indexWhere((apt) => apt.id == appointmentId);
      if (index != -1) {
        _allAppointments[index] = Appointment(
          id: _allAppointments[index].id,
          service: _allAppointments[index].service,
          customer: _allAppointments[index].customer,
          date: _allAppointments[index].date,
          time: _allAppointments[index].time,
          address: _allAppointments[index].address,
          price: _allAppointments[index].price,
          status: newStatus,
        );
      }
    });
    
    HapticFeedback.lightImpact();
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
            // Custom App Bar with Search
            Container(
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
              child: SafeArea(
                child: Padding(
                  padding: const EdgeInsets.all(16),
                  child: Column(
                    children: [
                      // Header
                      Row(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.arrow_back, color: Colors.white),
                              onPressed: () => Navigator.of(context).pop(),
                            ),
                          ),
                          const SizedBox(width: 16),
                          const Expanded(
                            child: Text(
                              'All Appointments',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.w800,
                                color: Colors.white,
                              ),
                            ),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.filter_list, color: Colors.white),
                              onPressed: _showFilterOptions,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Search Bar
                      Container(
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(16),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black.withOpacity(0.1),
                              blurRadius: 8,
                              offset: const Offset(0, 4),
                            ),
                          ],
                        ),
                        child: TextField(
                          controller: _searchController,
                          onChanged: (value) {
                            setState(() {
                              _searchQuery = value.toLowerCase();
                            });
                          },
                          decoration: InputDecoration(
                            hintText: 'Search appointments...',
                            hintStyle: TextStyle(color: AppColors.textSecondary),
                            prefixIcon: Icon(Icons.search, color: AppColors.textSecondary),
                            suffixIcon: _searchQuery.isNotEmpty
                                ? IconButton(
                                    icon: Icon(Icons.clear, color: AppColors.textSecondary),
                                    onPressed: () {
                                      _searchController.clear();
                                      setState(() {
                                        _searchQuery = '';
                                      });
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: const EdgeInsets.symmetric(
                              horizontal: 16,
                              vertical: 16,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            
            // Tab Bar
            Container(
              color: Colors.white,
              child: TabBar(
                controller: _tabController,
                labelColor: AppColors.primary,
                unselectedLabelColor: AppColors.textSecondary,
                indicatorColor: AppColors.primary,
                indicatorWeight: 3,
                isScrollable: true,
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 14,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 14,
                ),
                tabs: [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('All'),
                        const SizedBox(width: 6),
                        _buildCountBadge(_getFilteredAppointments('all').length),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Pending'),
                        const SizedBox(width: 6),
                        _buildCountBadge(_getFilteredAppointments('pending').length),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Active'),
                        const SizedBox(width: 6),
                        _buildCountBadge(_getFilteredAppointments('progress').length),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text('Complete'),
                        const SizedBox(width: 6),
                        _buildCountBadge(_getFilteredAppointments('completed').length),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            
            // Tab Content
            Expanded(
              child: TabBarView(
                controller: _tabController,
                children: [
                  _buildAppointmentsList('all'),
                  _buildAppointmentsList('pending'),
                  _buildAppointmentsList('progress'),
                  _buildAppointmentsList('completed'),
                ],
              ),
            ),
          ],
        ),
      ),
      
      // Floating Action Button
      floatingActionButton: ScaleTransition(
        scale: _fabAnimation,
        child: FloatingActionButton.extended(
          onPressed: _showQuickStats,
          backgroundColor: AppColors.primary,
          icon: const Icon(Icons.analytics, color: Colors.white),
          label: const Text(
            'Quick Stats',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildCountBadge(int count) {
    if (count == 0) return const SizedBox.shrink();
    
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 2),
      decoration: BoxDecoration(
        color: AppColors.primary.withOpacity(0.2),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Text(
        count.toString(),
        style: TextStyle(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: AppColors.primary,
        ),
      ),
    );
  }

  Widget _buildAppointmentsList(String type) {
    final appointments = _getFilteredAppointments(type);

    if (appointments.isEmpty) {
      return _buildEmptyState(type);
    }

    return RefreshIndicator(
      onRefresh: _refreshAppointments,
      color: AppColors.primary,
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: appointments.length,
        itemBuilder: (context, index) {
          return AnimatedContainer(
            duration: Duration(milliseconds: 300 + (index * 100)),
            curve: Curves.easeOutBack,
            child: AppointmentCard(
              appointment: appointments[index],
              onStatusChanged: _handleStatusChanged,
            ),
          );
        },
      ),
    );
  }

  Widget _buildEmptyState(String type) {
    IconData icon;
    String title;
    String subtitle;
    Color color;

    switch (type) {
      case 'pending':
        icon = Icons.schedule;
        title = 'No pending appointments';
        subtitle = 'New bookings will appear here';
        color = AppColors.pending;
        break;
      case 'progress':
        icon = Icons.hourglass_bottom;
        title = 'No active services';
        subtitle = 'Start a service to see it here';
        color = AppColors.inProgress;
        break;
      case 'completed':
        icon = Icons.check_circle;
        title = 'No completed services';
        subtitle = 'Completed appointments will be listed here';
        color = AppColors.success;
        break;
      default:
        icon = Icons.event_note;
        title = 'No appointments found';
        subtitle = _searchQuery.isNotEmpty 
            ? 'Try adjusting your search terms'
            : 'Your appointments will appear here';
        color = AppColors.textSecondary;
    }

    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: color.withOpacity(0.1),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                size: 64,
                color: color,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              title,
              style: const TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: AppColors.textPrimary,
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 8),
            Text(
              subtitle,
              style: const TextStyle(
                fontSize: 14,
                color: AppColors.textSecondary,
              ),
              textAlign: TextAlign.center,
            ),
            if (type == 'all' && _searchQuery.isEmpty) ...[
              const SizedBox(height: 24),
              ElevatedButton.icon(
                onPressed: () {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text('Promote services feature coming soon'),
                      backgroundColor: AppColors.info,
                    ),
                  );
                },
                icon: const Icon(Icons.campaign),
                label: const Text('Promote Your Services'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: AppColors.primary,
                  foregroundColor: Colors.white,
                  padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(16),
                  ),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  List<Appointment> _getFilteredAppointments(String type) {
    List<Appointment> filtered = _allAppointments;

    // Filter by search query
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((appointment) {
        return appointment.customer.toLowerCase().contains(_searchQuery) ||
            appointment.service.toLowerCase().contains(_searchQuery) ||
            appointment.address.toLowerCase().contains(_searchQuery) ||
            appointment.id.toLowerCase().contains(_searchQuery);
      }).toList();
    }

    // Filter by status
    if (type != 'all') {
      filtered = filtered.where((apt) => apt.status == type).toList();
    }

    // Sort by date and time
    filtered.sort((a, b) {
      // Convert date strings to comparable format
      final aDate = a.date.split('/').reversed.join('');
      final bDate = b.date.split('/').reversed.join('');
      final comparison = aDate.compareTo(bDate);
      if (comparison != 0) return comparison;
      
      // If same date, sort by time
      return a.time.compareTo(b.time);
    });

    return filtered;
  }

  Future<void> _refreshAppointments() async {
    // Simulate network call
    await Future.delayed(const Duration(seconds: 1));
    
    // In real app, this would fetch fresh data
    setState(() {
      // Refresh the data
    });

    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Appointments refreshed'),
        backgroundColor: AppColors.success,
        duration: Duration(seconds: 2),
      ),
    );
  }

  void _showFilterOptions() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
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
              'Filter & Sort Options',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: AppColors.textPrimary,
              ),
            ),
            const SizedBox(height: 24),
            _buildFilterOption(
              'Sort by Date',
              'Newest first',
              Icons.sort,
              () => Navigator.pop(context),
            ),
            _buildFilterOption(
              'Sort by Price',
              'Highest first',
              Icons.monetization_on,
              () => Navigator.pop(context),
            ),
            _buildFilterOption(
              'Filter by Service',
              'All services',
              Icons.build,
              () => Navigator.pop(context),
            ),
            _buildFilterOption(
              'Date Range',
              'All dates',
              Icons.date_range,
              () => Navigator.pop(context),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildFilterOption(String title, String subtitle, IconData icon, VoidCallback onTap) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: AppColors.background,
        borderRadius: BorderRadius.circular(16),
      ),
      child: ListTile(
        leading: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: AppColors.primary.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: Icon(icon, color: AppColors.primary, size: 20),
        ),
        title: Text(
          title,
          style: const TextStyle(
            fontWeight: FontWeight.w600,
            color: AppColors.textPrimary,
          ),
        ),
        subtitle: Text(
          subtitle,
          style: const TextStyle(
            color: AppColors.textSecondary,
            fontSize: 12,
          ),
        ),
        trailing: const Icon(Icons.chevron_right, color: AppColors.textTertiary),
        onTap: onTap,
      ),
    );
  }

  void _showQuickStats() {
    final totalAppointments = _allAppointments.length;
    final pendingCount = _allAppointments.where((apt) => apt.status == 'pending').length;
    final progressCount = _allAppointments.where((apt) => apt.status == 'progress').length;
    final completedCount = _allAppointments.where((apt) => apt.status == 'completed').length;
    final totalEarnings = _allAppointments
        .where((apt) => apt.status == 'completed')
        .fold(0, (sum, apt) => sum + apt.price);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        padding: const EdgeInsets.all(24),
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
            Container(
              width: 40,
              height: 4,
              decoration: BoxDecoration(
                color: AppColors.textTertiary.withOpacity(0.3),
                borderRadius: BorderRadius.circular(2),
              ),
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    gradient: AppColors.primaryGradient,
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: const Icon(Icons.analytics, color: Colors.white, size: 24),
                ),
                const SizedBox(width: 16),
                const Text(
                  'Quick Statistics',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.w800,
                    color: AppColors.textPrimary,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 24),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Total',
                    totalAppointments.toString(),
                    Icons.event_note,
                    AppColors.textSecondary,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Pending',
                    pendingCount.toString(),
                    Icons.schedule,
                    AppColors.pending,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Expanded(
                  child: _buildStatCard(
                    'Active',
                    progressCount.toString(),
                    Icons.hourglass_bottom,
                    AppColors.inProgress,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: _buildStatCard(
                    'Complete',
                    completedCount.toString(),
                    Icons.check_circle,
                    AppColors.success,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Container(
              width: double.infinity,
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                gradient: AppColors.primaryGradient,
                borderRadius: BorderRadius.circular(16),
              ),
              child: Column(
                children: [
                  const Icon(Icons.monetization_on, color: Colors.white, size: 32),
                  const SizedBox(height: 8),
                  Text(
                    '₹${totalEarnings.toStringAsFixed(0)}',
                    style: const TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.w900,
                      color: Colors.white,
                    ),
                  ),
                  const Text(
                    'Total Earnings',
                    style: TextStyle(
                      fontSize: 14,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(height: 16),
            SizedBox(
              width: double.infinity,
              child: TextButton(
                onPressed: () => Navigator.pop(context),
                child: const Text('Close'),
              ),
            ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            value,
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
          Text(
            title,
            style: const TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: AppColors.textSecondary,
            ),
          ),
        ],
      ),
    );
  }
}
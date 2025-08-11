import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../../core/constants/colors.dart';
import '../widgets/earning_card.dart';

class ProviderEarningsScreen extends StatefulWidget {
  const ProviderEarningsScreen({super.key});

  @override
  State<ProviderEarningsScreen> createState() => _ProviderEarningsScreenState();
}

class _ProviderEarningsScreenState extends State<ProviderEarningsScreen>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late AnimationController _chartController;
  late Animation<double> _chartAnimation;
  
  String _selectedPeriod = 'This Month';
  final List<String> _periods = ['Today', 'This Week', 'This Month', 'This Year'];
  
  // Sample data - in real app, this would come from state management
  final List<TransactionData> _transactions = [
    TransactionData('Basic Wash', 'John Doe', 299, '2 hours ago', 'completed'),
    TransactionData('Premium Wash', 'Sarah Smith', 599, '4 hours ago', 'completed'),
    TransactionData('Interior Clean', 'Mike Johnson', 499, '1 day ago', 'completed'),
    TransactionData('Deluxe Wash', 'Emma Wilson', 899, '2 days ago', 'completed'),
    TransactionData('Basic Wash', 'Tom Brown', 299, '3 days ago', 'completed'),
    TransactionData('Premium Wash', 'Lisa Davis', 599, '5 days ago', 'completed'),
    TransactionData('Interior Clean', 'James Wilson', 499, '1 week ago', 'completed'),
    TransactionData('Deluxe Wash', 'Anna Taylor', 899, '1 week ago', 'completed'),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
    _chartController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );
    _chartAnimation = CurvedAnimation(
      parent: _chartController,
      curve: Curves.easeInOut,
    );
    
    _chartController.forward();
    
    _tabController.addListener(() {
      if (_tabController.indexIsChanging) {
        HapticFeedback.selectionClick();
      }
    });
  }

  @override
  void dispose() {
    _tabController.dispose();
    _chartController.dispose();
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
            // Custom App Bar
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
                      // Header Row
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
                              'Earnings Report',
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
                              icon: const Icon(Icons.share, color: Colors.white),
                              onPressed: _shareEarningsReport,
                            ),
                          ),
                        ],
                      ),
                      
                      const SizedBox(height: 20),
                      
                      // Period Selector
                      Container(
                        height: 45,
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 4),
                          itemCount: _periods.length,
                          itemBuilder: (context, index) {
                            final period = _periods[index];
                            final isSelected = period == _selectedPeriod;
                            
                            return GestureDetector(
                              onTap: () {
                                setState(() {
                                  _selectedPeriod = period;
                                });
                                HapticFeedback.selectionClick();
                                _chartController.reset();
                                _chartController.forward();
                              },
                              child: AnimatedContainer(
                                duration: const Duration(milliseconds: 200),
                                margin: const EdgeInsets.symmetric(horizontal: 4, vertical: 4),
                                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                                decoration: BoxDecoration(
                                  color: isSelected ? Colors.white : Colors.transparent,
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                child: Center(
                                  child: Text(
                                    period,
                                    style: TextStyle(
                                      color: isSelected ? AppColors.primary : Colors.white,
                                      fontWeight: isSelected ? FontWeight.w700 : FontWeight.w500,
                                      fontSize: 14,
                                    ),
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
                labelStyle: const TextStyle(
                  fontWeight: FontWeight.w700,
                  fontSize: 16,
                ),
                unselectedLabelStyle: const TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
                tabs: const [
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.analytics, size: 20),
                        SizedBox(width: 8),
                        Text('Overview'),
                      ],
                    ),
                  ),
                  Tab(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.receipt_long, size: 20),
                        SizedBox(width: 8),
                        Text('Transactions'),
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
                  _buildOverviewTab(),
                  _buildTransactionsTab(),
                ],
              ),
            ),
          ],
        ),
      ),
      
      // Export Button
      floatingActionButton: FloatingActionButton.extended(
        onPressed: _exportEarningsData,
        backgroundColor: AppColors.success,
        icon: const Icon(Icons.download, color: Colors.white),
        label: const Text(
          'Export',
          style: TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Main Earnings Cards
          AnimatedBuilder(
            animation: _chartAnimation,
            builder: (context, child) {
              return Opacity(
                opacity: _chartAnimation.value,
                child: Transform.translate( 
                  offset: Offset(0, 20 * (1 - _chartAnimation.value)),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: AnimatedEarningCard(
                              title: 'Total Earnings',
                              amount: _getEarningsForPeriod(_selectedPeriod),
                              color: AppColors.success,
                              icon: Icons.monetization_on,
                              subtitle: _selectedPeriod,
                              animationDelay: const Duration(milliseconds: 100),
                              onTap: () => _showEarningsBreakdown(context),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AnimatedEarningCard(
                              title: 'Completed Jobs',
                              amount: _getCompletedJobsForPeriod(_selectedPeriod),
                              color: AppColors.primary,
                              icon: Icons.check_circle,
                              subtitle: _selectedPeriod,
                              animationDelay: const Duration(milliseconds: 200),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            child: AnimatedEarningCard(
                              title: 'Average Per Job',
                              amount: _getAverageEarningsForPeriod(_selectedPeriod),
                              color: AppColors.warning,
                              icon: Icons.trending_up,
                              subtitle: _selectedPeriod,
                              animationDelay: const Duration(milliseconds: 300),
                            ),
                          ),
                          const SizedBox(width: 16),
                          Expanded(
                            child: AnimatedEarningCard(
                              title: 'Growth',
                              amount: '+12%',
                              color: AppColors.info,
                              icon: Icons.show_chart,
                              subtitle: 'vs last period',
                              animationDelay: const Duration(milliseconds: 400),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          ),
          
          const SizedBox(height: 32),
          
          // Service Breakdown
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
                      child: const Icon(Icons.pie_chart, color: Colors.white, size: 24),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Service Breakdown',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                _buildServiceBreakdownItem('Premium Wash', 45, AppColors.success, '₹26,955'),
                _buildServiceBreakdownItem('Basic Wash', 30, AppColors.primary, '₹8,970'),
                _buildServiceBreakdownItem('Interior Clean', 20, AppColors.warning, '₹9,980'),
                _buildServiceBreakdownItem('Deluxe Wash', 5, AppColors.info, '₹4,495'),
              ],
            ),
          ),
          
          const SizedBox(height: 24),
          
          // Monthly Comparison Chart
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
                        color: AppColors.success.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: const Icon(Icons.show_chart, color: AppColors.success, size: 24),
                    ),
                    const SizedBox(width: 16),
                    const Expanded(
                      child: Text(
                        'Monthly Trends',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w800,
                          color: AppColors.textPrimary,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 24),
                
                // Simple chart representation
                _buildMonthlyChart(),
              ],
            ),
          ),
          
          const SizedBox(height: 32),
        ],
      ),
    );
  }

  Widget _buildServiceBreakdownItem(String service, int percentage, Color color, String amount) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Text(
                  service,
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: AppColors.textPrimary,
                  ),
                ),
              ),
              Text(
                '$percentage%',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                amount,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: AppColors.success,
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          AnimatedBuilder(
            animation: _chartAnimation,
            builder: (context, child) {
              return LinearProgressIndicator(
                value: _chartAnimation.value * (percentage / 100),
                backgroundColor: color.withOpacity(0.1),
                valueColor: AlwaysStoppedAnimation<Color>(color),
                minHeight: 6,
              );
            },
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyChart() {
    final months = ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun'];
    final earnings = [15000, 18000, 22000, 25000, 30000, 32500];
    final maxEarning = earnings.reduce((a, b) => a > b ? a : b);
    
    return AnimatedBuilder(
      animation: _chartAnimation,
      builder: (context, child) {
        return SizedBox(
          height: 200,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: months.asMap().entries.map((entry) {
              final index = entry.key;
              final month = entry.value;
              final earning = earnings[index];
              final height = (earning / maxEarning) * 150 * _chartAnimation.value;
              
              return Column(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Text(
                    '₹${(earning / 1000).toStringAsFixed(0)}K',
                    style: const TextStyle(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Container(
                    width: 24,
                    height: height,
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.bottomCenter,
                        end: Alignment.topCenter,
                        colors: [
                          AppColors.primary,
                          AppColors.primary.withOpacity(0.6),
                        ],
                      ),
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    month,
                    style: const TextStyle(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: AppColors.textSecondary,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
        );
      },
    );
  }

  Widget _buildTransactionsTab() {
    return Column(
      children: [
        // Transaction Summary
        Container(
          margin: const EdgeInsets.all(16),
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            gradient: AppColors.primaryGradient,
            borderRadius: BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: AppColors.primary.withOpacity(0.3),
                blurRadius: 16,
                offset: const Offset(0, 8),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: Colors.white.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: const Icon(Icons.receipt_long, color: Colors.white, size: 32),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Total Transactions',
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.white,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      _transactions.length.toString(),
                      style: const TextStyle(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
              ),
              Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  const Text(
                    'This Month',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.white,
                    ),
                  ),
                  Text(
                    '₹${_transactions.fold(0, (sum, t) => sum + t.amount)}',
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        
        // Transactions List
        Expanded(
          child: ListView.builder(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            itemCount: _transactions.length,
            itemBuilder: (context, index) {
              return _buildTransactionItem(_transactions[index], index);
            },
          ),
        ),
      ],
    );
  }

  Widget _buildTransactionItem(TransactionData transaction, int index) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.shadowColor,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: ListTile(
        contentPadding: const EdgeInsets.all(16),
        leading: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: AppColors.success.withOpacity(0.1),
            borderRadius: BorderRadius.circular(12),
          ),
          child: const Icon(
            Icons.monetization_on,
            color: AppColors.success,
            size: 24,
          ),
        ),
        title: Text(
          transaction.service,
          style: const TextStyle(
            fontWeight: FontWeight.w700,
            color: AppColors.textPrimary,
            fontSize: 16,
          ),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 4),
            Text(
              transaction.customer,
              style: const TextStyle(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w500,
                fontSize: 14,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              transaction.time,
              style: const TextStyle(
                color: AppColors.textTertiary,
                fontSize: 12,
              ),
            ),
          ],
        ),
        trailing: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text(
              '₹${transaction.amount}',
              style: const TextStyle(
                fontWeight: FontWeight.w800,
                color: AppColors.success,
                fontSize: 16,
              ),
            ),
            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: AppColors.success.withOpacity(0.1),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Text(
                transaction.status.toUpperCase(),
                style: const TextStyle(
                  fontSize: 10,
                  fontWeight: FontWeight.w700,
                  color: AppColors.success,
                ),
              ),
            ),
          ],
        ),
        onTap: () => _showTransactionDetails(transaction),
      ),
    );
  }

  String _getEarningsForPeriod(String period) {
    // Mock data calculation
    switch (period) {
      case 'Today':
        return '₹2,450';
      case 'This Week':
        return '₹8,400';
      case 'This Month':
        return '₹32,500';
      case 'This Year':
        return '₹1,25,000';
      default:
        return '₹0';
    }
  }

  String _getCompletedJobsForPeriod(String period) {
    switch (period) {
      case 'Today':
        return '5';
      case 'This Week':
        return '18';
      case 'This Month':
        return '65';
      case 'This Year':
        return '420';
      default:
        return '0';
    }
  }

  String _getAverageEarningsForPeriod(String period) {
    switch (period) {
      case 'Today':
        return '₹490';
      case 'This Week':
        return '₹467';
      case 'This Month':
        return '₹500';
      case 'This Year':
        return '₹298';
      default:
        return '₹0';
    }
  }

  void _showEarningsBreakdown(BuildContext context) {
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
                'Earnings Breakdown',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: AppColors.textPrimary,
                ),
              ),
              const SizedBox(height: 24),
              
              // Detailed breakdown content
              Expanded(
                child: SingleChildScrollView(
                  child: Column(
                    children: [
                      _buildBreakdownItem('Gross Earnings', '₹32,500', AppColors.success),
                      _buildBreakdownItem('Platform Fee (5%)', '-₹1,625', AppColors.error),
                      _buildBreakdownItem('Tax Deduction', '-₹2,275', AppColors.warning),
                      const Divider(height: 32),
                      _buildBreakdownItem('Net Earnings', '₹28,600', AppColors.primary, isTotal: true),
                      
                      const SizedBox(height: 24),
                      const Text(
                        'Payment Schedule',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.w700,
                          color: AppColors.textPrimary,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: AppColors.info.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: const Row(
                          children: [
                            Icon(Icons.info, color: AppColors.info, size: 20),
                            SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Payments are processed weekly on Fridays. Next payout: Friday, Aug 18',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: AppColors.textSecondary,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              
              SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  onPressed: () => Navigator.pop(context),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(16),
                    ),
                  ),
                  child: const Text(
                    'Close',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBreakdownItem(String title, String amount, Color color, {bool isTotal = false}) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isTotal ? color.withOpacity(0.1) : AppColors.background,
        borderRadius: BorderRadius.circular(12),
        border: isTotal ? Border.all(color: color.withOpacity(0.3)) : null,
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(
            title,
            style: TextStyle(
              fontSize: isTotal ? 16 : 14,
              fontWeight: isTotal ? FontWeight.w700 : FontWeight.w600,
              color: AppColors.textPrimary,
            ),
          ),
          Text(
            amount,
            style: TextStyle(
              fontSize: isTotal ? 18 : 16,
              fontWeight: FontWeight.w700,
              color: color,
            ),
          ),
        ],
      ),
    );
  }

  void _showTransactionDetails(TransactionData transaction) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        title: Text('Transaction #${transaction.hashCode.abs().toString().substring(0, 6)}'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildDetailRow('Service', transaction.service),
            _buildDetailRow('Customer', transaction.customer),
            _buildDetailRow('Amount', '₹${transaction.amount}'),
            _buildDetailRow('Time', transaction.time),
            _buildDetailRow('Status', transaction.status.toUpperCase()),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(context);
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text('Invoice feature coming soon'),
                  backgroundColor: AppColors.info,
                ),
              );
            },
            child: const Text('View Invoice'),
          ),
        ],
      ),
    );
  }

  Widget _buildDetailRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 80,
            child: Text(
              '$label:',
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textSecondary,
              ),
            ),
          ),
          Expanded(
            child: Text(
              value,
              style: const TextStyle(
                fontWeight: FontWeight.w600,
                color: AppColors.textPrimary,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _shareEarningsReport() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Share earnings report feature coming soon'),
        backgroundColor: AppColors.info,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  void _exportEarningsData() {
    HapticFeedback.lightImpact();
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Earnings data exported successfully'),
        backgroundColor: AppColors.success,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}

class TransactionData {
  final String service;
  final String customer;
  final int amount;
  final String time;
  final String status;

  TransactionData(this.service, this.customer, this.amount, this.time, this.status);
}
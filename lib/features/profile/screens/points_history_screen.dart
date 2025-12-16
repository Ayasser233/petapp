import 'package:flutter/material.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/services/points_service.dart';
import 'package:petapp/di/service_locator.dart';
import 'package:intl/intl.dart';

class PointsHistoryScreen extends StatefulWidget {
  const PointsHistoryScreen({super.key});

  @override
  State<PointsHistoryScreen> createState() => _PointsHistoryScreenState();
}

class _PointsHistoryScreenState extends State<PointsHistoryScreen>
    with WidgetsBindingObserver {
  final PointsService _pointsService = sl<PointsService>();

  // Balance data
  int _currentBalance = 0;
  int _totalEarned = 0;
  int _totalSpent = 0;

  // Transaction data
  List<Map<String, dynamic>> _transactions = [];
  bool _isLoading = true;
  bool _hasError = false;
  String _errorMessage = '';

  // Pagination
  int _currentPage = 1;
  final int _limit = 20;
  bool _hasMore = false;
  bool _isLoadingMore = false;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
    _loadPointsData();
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    // Refresh data when app comes back to foreground
    if (state == AppLifecycleState.resumed) {
      _loadPointsData();
    }
  }

  Future<void> _loadPointsData() async {
    if (!mounted) return;

    setState(() {
      _isLoading = true;
      _hasError = false;
      _currentPage = 1; // Reset to first page on refresh
    });

    try {
      // Load balance
      final balanceData = await _pointsService.getPointsBalance();

      // Load transactions
      final transactionsData = await _pointsService.getPointsTransactions(
        page: _currentPage,
        limit: _limit,
      );

      if (!mounted) return;

      setState(() {
        // Update balance
        _currentBalance = balanceData['currentBalance'] ?? 0;
        _totalEarned = balanceData['totalEarned'] ?? 0;
        _totalSpent = balanceData['totalSpent'] ?? 0;

        // Update transactions
        _transactions = List<Map<String, dynamic>>.from(transactionsData);

        // Check if there are more transactions
        _hasMore = _transactions.length >= _limit;

        _isLoading = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoading = false;
        _hasError = true;
        _errorMessage = e.toString();
      });

      // Show error snackbar
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).errorLoadingPoints),
            backgroundColor: Colors.red,
            action: SnackBarAction(
              label: AppLocalizations.of(context).retry,
              textColor: Colors.white,
              onPressed: _loadPointsData,
            ),
          ),
        );
      }
    }
  }

  Future<void> _loadMoreTransactions() async {
    if (_isLoadingMore || !_hasMore || !mounted) return;

    setState(() {
      _isLoadingMore = true;
    });

    try {
      final moreTransactions = await _pointsService.getPointsTransactions(
        page: _currentPage + 1,
        limit: _limit,
      );

      if (!mounted) return;

      setState(() {
        _currentPage++;
        _transactions.addAll(List<Map<String, dynamic>>.from(moreTransactions));
        _hasMore = moreTransactions.length >= _limit;
        _isLoadingMore = false;
      });
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _isLoadingMore = false;
      });

      // Show error snackbar for loading more
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(AppLocalizations.of(context).errorLoadingMore),
            backgroundColor: Colors.orange,
            duration: const Duration(seconds: 2),
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final localizations = AppLocalizations.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.aleefyPoints),
        centerTitle: true,
        elevation: 0,
      ),
      body: _isLoading
          ? const Center(child: CircularProgressIndicator())
          : _hasError
              ? Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(
                        Icons.error_outline,
                        size: 64,
                        color: Colors.red,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        localizations.errorLoadingPoints,
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 8),
                      Text(
                        _errorMessage,
                        style: Theme.of(context).textTheme.bodySmall,
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 16),
                      ElevatedButton(
                        onPressed: _loadPointsData,
                        child: Text(localizations.retry),
                      ),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: _loadPointsData,
                  child: Column(
                    children: [
                      // Points summary card
                      _buildPointsSummaryCard(isDark, localizations),

                      // Tabs for Earned and Spent
                      _buildStatsCards(isDark, localizations),

                      // Transaction list header
                      Padding(
                        padding: const EdgeInsets.all(16),
                        child: Row(
                          children: [
                            Text(
                              localizations.transactionHistory,
                              style: Theme.of(context)
                                  .textTheme
                                  .titleMedium
                                  ?.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                            ),
                          ],
                        ),
                      ),

                      // Transaction list
                      Expanded(
                        child: _transactions.isEmpty
                            ? Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.history,
                                      size: 64,
                                      color: isDark
                                          ? Colors.grey[600]
                                          : Colors.grey[400],
                                    ),
                                    const SizedBox(height: 16),
                                    Text(
                                      localizations.noTransactions,
                                      style: Theme.of(context)
                                          .textTheme
                                          .titleMedium
                                          ?.copyWith(
                                            color: isDark
                                                ? Colors.grey[400]
                                                : Colors.grey[600],
                                          ),
                                    ),
                                  ],
                                ),
                              )
                            : NotificationListener<ScrollNotification>(
                                onNotification:
                                    (ScrollNotification scrollInfo) {
                                  if (!_isLoadingMore &&
                                      _hasMore &&
                                      scrollInfo.metrics.pixels ==
                                          scrollInfo.metrics.maxScrollExtent) {
                                    _loadMoreTransactions();
                                  }
                                  return false;
                                },
                                child: ListView.builder(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 16),
                                  itemCount: _transactions.length +
                                      (_isLoadingMore ? 1 : 0),
                                  itemBuilder: (context, index) {
                                    if (index == _transactions.length) {
                                      return const Center(
                                        child: Padding(
                                          padding: EdgeInsets.all(16.0),
                                          child: CircularProgressIndicator(),
                                        ),
                                      );
                                    }
                                    return _buildTransactionCard(
                                      _transactions[index],
                                      isDark,
                                      localizations,
                                    );
                                  },
                                ),
                              ),
                      ),
                    ],
                  ),
                ),
    );
  }

  Widget _buildPointsSummaryCard(bool isDark, AppLocalizations localizations) {
    return Container(
      margin: const EdgeInsets.all(16),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [AppColors.orange, Color(0xFFF5A623)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: AppColors.orange.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: const BoxDecoration(
              color: Colors.white,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.stars_rounded,
              color: AppColors.orange,
              size: 32,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  localizations.currentBalance,
                  style: const TextStyle(
                    color: Colors.white70,
                    fontSize: 14,
                  ),
                ),
                Text(
                  _formatPoints(_currentBalance),
                  style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                      ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatsCards(bool isDark, AppLocalizations localizations) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      child: Row(
        children: [
          Expanded(
            child: _buildStatCard(
              localizations.totalEarned,
              _totalEarned,
              Icons.add_circle_outline,
              Colors.green,
              isDark,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: _buildStatCard(
              localizations.totalSpent,
              _totalSpent,
              Icons.remove_circle_outline,
              Colors.red,
              isDark,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStatCard(
      String title, int value, IconData icon, Color color, bool isDark) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: color, size: 24),
          const SizedBox(height: 8),
          Text(
            title,
            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  color: isDark ? Colors.grey[400] : Colors.grey[600],
                ),
          ),
          const SizedBox(height: 4),
          Text(
            _formatPoints(value),
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(
    Map<String, dynamic> transaction,
    bool isDark,
    AppLocalizations localizations,
  ) {
    // Parse transaction data from API
    final String type = transaction['type'] ?? 'unknown';
    final int points = transaction['points'] ?? transaction['amount'] ?? 0;
    final String description =
        transaction['description'] ?? transaction['reason'] ?? 'Transaction';
    final String? dateStr = transaction['createdAt'] ?? transaction['date'];

    final isPositive = points > 0 || type.toLowerCase().contains('earn');
    final color = isPositive ? Colors.green : Colors.red;

    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.1),
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withValues(alpha: 0.1),
              shape: BoxShape.circle,
            ),
            child: Icon(
              _getTransactionIcon(type),
              color: color,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  dateStr != null ? _formatDate(DateTime.parse(dateStr)) : '',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
          Text(
            '${isPositive ? '+' : ''}$points',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                ),
          ),
        ],
      ),
    );
  }

  IconData _getTransactionIcon(String type) {
    final lowerType = type.toLowerCase();
    if (lowerType.contains('earn') || lowerType.contains('reward')) {
      return Icons.add_circle_outline;
    } else if (lowerType.contains('redeem') || lowerType.contains('spend')) {
      return Icons.remove_circle_outline;
    } else if (lowerType.contains('bonus') || lowerType.contains('gift')) {
      return Icons.card_giftcard;
    } else if (lowerType.contains('refund')) {
      return Icons.replay;
    } else {
      return Icons.swap_horiz;
    }
  }

  String _formatDate(DateTime date) {
    final now = DateTime.now();
    final difference = now.difference(date).inDays;
    final localizations = AppLocalizations.of(context);

    if (difference == 0) {
      return localizations.dateToday;
    } else if (difference == 1) {
      return localizations.dateYesterday;
    } else if (difference < 7) {
      return localizations.dateDaysAgo
          .replaceAll('{days}', difference.toString());
    } else {
      return DateFormat('MMM dd, yyyy').format(date);
    }
  }

  String _formatPoints(int points) {
    if (points >= 1000000) {
      return '${(points / 1000000).toStringAsFixed(1)}M';
    } else if (points >= 1000) {
      return '${(points / 1000).toStringAsFixed(1)}K';
    }
    return points.toString();
  }
}

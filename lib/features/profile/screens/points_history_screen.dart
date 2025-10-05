import 'package:flutter/material.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import 'package:petapp/core/localization/app_localizations.dart';

class PointsHistoryScreen extends StatefulWidget {
  const PointsHistoryScreen({super.key});

  @override
  State<PointsHistoryScreen> createState() => _PointsHistoryScreenState();
}

class _PointsHistoryScreenState extends State<PointsHistoryScreen> {
  final List<PointTransaction> _transactions = [
    PointTransaction(
      id: '1',
      type: 'earned',
      points: 250,
      description: 'Veterinary consultation at PetCare Clinic',
      date: DateTime.now().subtract(const Duration(days: 2)),
    ),
    PointTransaction(
      id: '2',
      type: 'redeemed',
      points: -100,
      description: 'Redeemed for 10% off grooming coupon',
      date: DateTime.now().subtract(const Duration(days: 5)),
    ),
    PointTransaction(
      id: '3',
      type: 'earned',
      points: 150,
      description: 'Pet vaccination at VCA Animal Hospital',
      date: DateTime.now().subtract(const Duration(days: 8)),
    ),
    PointTransaction(
      id: '4',
      type: 'bonus',
      points: 500,
      description: 'Welcome bonus for new members',
      date: DateTime.now().subtract(const Duration(days: 30)),
    ),
  ];

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.pointsHistory),
        centerTitle: true,
        elevation: 0,
      ),
      body: Column(
        children: [
          // Points summary card
          Container(
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
                        localizations.pointsValue.replaceAll('{points}', '3,540'),
                        style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                            ),
                      ),
                      Text(
                        localizations.pointsSummary
                            .replaceAll('{earned}', '4,540')
                            .replaceAll('{redeemed}', '1,000'),
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.white.withValues(alpha: 0.9),
                            ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          
          // Transaction list
          Expanded(
            child: ListView.builder(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _transactions.length,
              itemBuilder: (context, index) {
                return _buildTransactionCard(_transactions[index], isDark);
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTransactionCard(PointTransaction transaction, bool isDark) {
    final isPositive = transaction.points > 0;
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
              _getTransactionIcon(transaction.type),
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
                  transaction.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w500,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  _formatDate(transaction.date),
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: isDark ? Colors.grey[400] : Colors.grey[600],
                      ),
                ),
              ],
            ),
          ),
          Text(
            '${isPositive ? '+' : ''}${transaction.points}',
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
    switch (type) {
      case 'earned':
        return Icons.add_circle_outline;
      case 'redeemed':
        return Icons.remove_circle_outline;
      case 'bonus':
        return Icons.card_giftcard;
      default:
        return Icons.help_outline;
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
      return localizations.dateDaysAgo.replaceAll('{days}', difference.toString());
    } else {
      return '${date.day}/${date.month}/${date.year}';
    }
  }
}

class PointTransaction {
  final String id;
  final String type;
  final int points;
  final String description;
  final DateTime date;

  PointTransaction({
    required this.id,
    required this.type,
    required this.points,
    required this.description,
    required this.date,
  });
}
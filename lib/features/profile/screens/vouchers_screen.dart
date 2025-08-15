import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/utils/helper_functions.dart';
import '../data/models/voucher_model.dart';
import 'package:petapp/core/localization/app_localizations.dart';

class VouchersScreen extends StatefulWidget {
  const VouchersScreen({super.key});

  @override
  State<VouchersScreen> createState() => _VouchersScreenState();
}

class _VouchersScreenState extends State<VouchersScreen> 
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  
  // Sample vouchers data
  final List<VoucherModel> _allVouchers = [
    VoucherModel(
      id: '1',
      title: '20% Off First Visit',
      description: 'Get 20% discount on your first veterinary consultation',
      code: 'FIRST20',
      discount: 20,
      discountType: 'percentage',
      expiryDate: DateTime.now().add(const Duration(days: 30)),
      category: 'Consultation',
      minPurchaseAmount: 50,
    ),
    VoucherModel(
      id: '2',
      title: 'Free Pet Grooming',
      description: 'Complimentary grooming service for your furry friend',
      code: 'FREEGROOM',
      discount: 45,
      discountType: 'fixed',
      expiryDate: DateTime.now().add(const Duration(days: 15)),
      category: 'Grooming',
    ),
    VoucherModel(
      id: '3',
      title: '\$10 Off Vaccination',
      description: 'Save \$10 on any vaccination package',
      code: 'VACC10',
      discount: 10,
      discountType: 'fixed',
      expiryDate: DateTime.now().add(const Duration(days: 45)),
      category: 'Vaccination',
      minPurchaseAmount: 30,
    ),
    VoucherModel(
      id: '4',
      title: '15% Off Dental Care',
      description: 'Special discount on dental cleaning and care services',
      code: 'DENTAL15',
      discount: 15,
      discountType: 'percentage',
      expiryDate: DateTime.now().subtract(const Duration(days: 5)),
      category: 'Dental',
      isUsed: true,
      usedDate: DateTime.now().subtract(const Duration(days: 10)).toString(),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = THelperFunctions.isDarkMode(context);
    final localizations = AppLocalizations.of(context);
    
    return Scaffold(
      appBar: AppBar(
        title: Text(localizations.myVouchers),
        centerTitle: true,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          tabs: [
            Tab(text: '${localizations.available} (${_getAvailableVouchers().length})'),
            Tab(text: '${localizations.used} (${_getUsedVouchers().length})'),
            Tab(text: '${localizations.expired} (${_getExpiredVouchers().length})'),
          ],
          labelColor: AppColors.orange,
          unselectedLabelColor: isDark ? Colors.grey[400] : Colors.grey[600],
          indicatorColor: AppColors.orange,
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildVouchersList(_getAvailableVouchers()),
          _buildVouchersList(_getUsedVouchers()),
          _buildVouchersList(_getExpiredVouchers()),
        ],
      ),
    );
  }

  List<VoucherModel> _getAvailableVouchers() {
    return _allVouchers.where((voucher) => voucher.isValid).toList();
  }

  List<VoucherModel> _getUsedVouchers() {
    return _allVouchers.where((voucher) => voucher.isUsed).toList();
  }

  List<VoucherModel> _getExpiredVouchers() {
    return _allVouchers.where((voucher) => voucher.isExpired && !voucher.isUsed).toList();
  }

  Widget _buildVouchersList(List<VoucherModel> vouchers) {
    if (vouchers.isEmpty) {
      return _buildEmptyState();
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: vouchers.length,
      itemBuilder: (context, index) {
        return _buildVoucherCard(vouchers[index]);
      },
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.confirmation_number_outlined,
            size: 64,
            color: Colors.grey[400],
          ),
          const SizedBox(height: 16),
          Text(
            AppLocalizations.of(context).noVouchersFound,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  color: Colors.grey[600],
                ),
          ),
          const SizedBox(height: 8),
          Text(
            AppLocalizations.of(context).checkBackLater,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Colors.grey[500],
                ),
          ),
        ],
      ),
    );
  }

  Widget _buildVoucherCard(VoucherModel voucher) {
    final isDark = THelperFunctions.isDarkMode(context);
    final isValid = voucher.isValid;
    
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      decoration: BoxDecoration(
        color: isDark ? Colors.grey[800] : Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: isValid 
              ? AppColors.orange.withOpacity(0.3)
              : Colors.grey.withOpacity(0.3),
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Main content
          Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header with discount and category
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: isValid 
                            ? AppColors.orange 
                            : Colors.grey,
                        borderRadius: BorderRadius.circular(20),
                      ),
                      child: Text(
                        voucher.formattedDiscount,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                    const Spacer(),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      decoration: BoxDecoration(
                        color: isDark ? Colors.grey[700] : Colors.grey[200],
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Text(
                        voucher.category,
                        style: TextStyle(
                          color: isDark ? Colors.grey[300] : Colors.grey[700],
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Title and description
                Text(
                  voucher.title,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: isValid 
                            ? (isDark ? Colors.white : Colors.black87)
                            : Colors.grey,
                      ),
                ),
                const SizedBox(height: 8),
                Text(
                  voucher.description,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: isValid 
                            ? (isDark ? Colors.grey[300] : Colors.grey[700])
                            : Colors.grey,
                      ),
                ),
                
                if (voucher.minPurchaseAmount != null) ...[
                  const SizedBox(height: 8),
                  Text(
                    'Min. purchase: \$${voucher.minPurchaseAmount!.toStringAsFixed(2)}',
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Colors.grey[600],
                          fontStyle: FontStyle.italic,
                        ),
                  ),
                ],
                
                const SizedBox(height: 16),
                
                // Code and expiry
                Row(
                  children: [
                    // Voucher code
                    Expanded(
                      child: Container(
                        padding: const EdgeInsets.all(12),
                        decoration: BoxDecoration(
                          color: isDark ? Colors.grey[700] : Colors.grey[100],
                          borderRadius: BorderRadius.circular(8),
                          border: Border.all(
                            color: isDark ? Colors.grey[600]! : Colors.grey[300]!,
                          ),
                        ),
                        child: Row(
                          children: [
                            Expanded(
                              child: Text(
                                voucher.code,
                                style: Theme.of(context).textTheme.titleSmall?.copyWith(
                                      fontWeight: FontWeight.bold,
                                      fontFamily: 'monospace',
                                    ),
                              ),
                            ),
                            if (isValid)
                              GestureDetector(
                                onTap: () => _copyCode(voucher.code),
                                child: Container(
                                  padding: const EdgeInsets.all(4),
                                  decoration: BoxDecoration(
                                    color: AppColors.orange,
                                    borderRadius: BorderRadius.circular(4),
                                  ),
                                  child: const Icon(
                                    Icons.copy,
                                    color: Colors.white,
                                    size: 16,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                
                const SizedBox(height: 12),
                
                // Expiry date
                Row(
                  children: [
                    Icon(
                      Icons.schedule,
                      size: 16,
                      color: voucher.isExpired ? Colors.red : Colors.grey[600],
                    ),
                    const SizedBox(width: 4),
                    Text(
                      voucher.formattedExpiry,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                            color: voucher.isExpired ? Colors.red : Colors.grey[600],
                            fontWeight: FontWeight.w500,
                          ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          
          // Status overlay
          if (!isValid)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(16),
                ),
                child: Center(
                  child: Transform.rotate(
                    angle: -0.3,
                    child: Container(
                      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                      decoration: BoxDecoration(
                        color: voucher.isUsed ? Colors.green : Colors.red,
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Text(
                        voucher.isUsed ? 'USED' : 'EXPIRED',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }

  void _copyCode(String code) {
    Clipboard.setData(ClipboardData(text: code));
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Voucher code "$code" copied to clipboard'),
        backgroundColor: AppColors.orange,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }
}
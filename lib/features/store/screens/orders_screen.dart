import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/core/routes/routes.dart';
import 'package:petapp/features/store/controllers/order_controller.dart';
import 'package:petapp/features/store/widgets/order_status_badge.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  late final OrderController _ctrl;
  String? _filterStatus;

  static const _statuses = ['All', 'pending', 'confirmed', 'processing', 'shipped', 'delivered', 'cancelled'];

  @override
  void initState() {
    super.initState();
    _ctrl = Get.find<OrderController>();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ctrl.loadOrders(reset: true);
    });
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: isDark ? Colors.black : Colors.white,
      appBar: AppBar(
        backgroundColor: isDark ? Colors.black : Colors.white,
        elevation: 0,
        surfaceTintColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          onPressed: () => Get.back(),
        ),
        title: Text(l10n.myOrders,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: Column(
        children: [
          // Filter chips
          SizedBox(
            height: 44,
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              padding: const EdgeInsets.symmetric(horizontal: 16),
              itemCount: _statuses.length,
              itemBuilder: (context, i) {
                final s = _statuses[i];
                final sel = (_filterStatus == null && s == 'All') ||
                    _filterStatus == s;
                final label = s == 'All' ? l10n.all : _localizedStatus(s, l10n);
                return GestureDetector(
                  onTap: () {
                    setState(() => _filterStatus = s == 'All' ? null : s);
                    _ctrl.loadOrders(reset: true, status: s == 'All' ? null : s);
                  },
                  child: AnimatedContainer(
                    duration: const Duration(milliseconds: 150),
                    margin: const EdgeInsets.only(right: 8),
                    padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
                    decoration: BoxDecoration(
                      color: sel
                          ? AppColors.orange
                          : (isDark ? AppColors.lightblack : Colors.grey.shade100),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      label,
                      style: TextStyle(
                        color: sel ? Colors.white : (isDark ? Colors.white70 : Colors.black87),
                        fontWeight: sel ? FontWeight.bold : FontWeight.normal,
                        fontSize: 13,
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: Obx(() {
              if (_ctrl.isLoading.value && _ctrl.orders.isEmpty) {
                return const Center(child: CircularProgressIndicator(color: AppColors.orange));
              }
              if (_ctrl.orders.isEmpty) {
                return Center(
                  child: Column(mainAxisAlignment: MainAxisAlignment.center, children: [
                    Icon(Icons.receipt_long_outlined, size: 60, color: isDark ? Colors.grey.shade600 : Colors.grey),
                    const SizedBox(height: 12),
                    Text(l10n.noOrdersYet, style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
                  ]),
                );
              }
              return NotificationListener<ScrollNotification>(
                onNotification: (n) {
                  if (n is ScrollEndNotification && n.metrics.extentAfter < 200) {
                    _ctrl.loadOrders(status: _filterStatus);
                  }
                  return false;
                },
                child: ListView.separated(
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
                  itemCount: _ctrl.orders.length + (_ctrl.isLoadingMore.value ? 1 : 0),
                  separatorBuilder: (_, __) => const SizedBox(height: 12),
                  itemBuilder: (context, i) {
                    if (i == _ctrl.orders.length) {
                      return const Center(child: Padding(
                        padding: EdgeInsets.all(16),
                        child: CircularProgressIndicator(color: AppColors.orange),
                      ));
                    }
                    final order = _ctrl.orders[i];
                    String dateStr = '';
                    try {
                      dateStr = DateFormat('MMM d, y').format(DateTime.parse(order.createdAt).toLocal());
                    } catch (_) {}
                    return GestureDetector(
                      onTap: () => Get.toNamed(AppRoutes.orderDetail, arguments: order.id),
                      child: Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: isDark ? AppColors.lightblack : Colors.white,
                          borderRadius: BorderRadius.circular(14),
                          boxShadow: [
                            if (!isDark)
                              BoxShadow(color: Colors.grey.withValues(alpha: 0.1), blurRadius: 8, offset: const Offset(0, 2)),
                          ],
                          border: isDark ? Border.all(color: Colors.grey.shade800) : Border.all(color: Colors.grey.shade100),
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('#${order.id.substring(0, 8).toUpperCase()}',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                                OrderStatusBadge(status: order.status),
                              ],
                            ),
                            const SizedBox(height: 6),
                            Text('$dateStr · ${order.itemCount} item${order.itemCount != 1 ? 's' : ''}',
                                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                    color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
                            const SizedBox(height: 8),
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text('${order.totalAmount.toStringAsFixed(0)} EGP',
                                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.bold)),
                                OrderStatusBadge(status: order.paymentStatus),
                              ],
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              );
            }),
          ),
        ],
      ),
    );
  }

  String _localizedStatus(String s, AppLocalizations l10n) {
    switch (s) {
      case 'pending': return l10n.orderStatusPending;
      case 'confirmed': return l10n.orderStatusConfirmed;
      case 'processing': return l10n.orderStatusProcessing;
      case 'shipped': return l10n.orderStatusShipped;
      case 'delivered': return l10n.orderStatusDelivered;
      case 'cancelled': return l10n.orderStatusCancelled;
      default: return s[0].toUpperCase() + s.substring(1);
    }
  }
}
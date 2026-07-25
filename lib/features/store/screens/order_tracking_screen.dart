import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/features/store/controllers/order_controller.dart';
import 'package:petapp/features/store/widgets/tracking_timeline.dart';

class OrderTrackingScreen extends StatefulWidget {
  const OrderTrackingScreen({super.key});

  @override
  State<OrderTrackingScreen> createState() => _OrderTrackingScreenState();
}

class _OrderTrackingScreenState extends State<OrderTrackingScreen> {
  late final OrderController _ctrl;

  @override
  void initState() {
    super.initState();
    _ctrl = Get.find<OrderController>();
    final orderId = Get.arguments as String;
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _ctrl.loadTracking(orderId);
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
        title: Text(l10n.orderTracking,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: Obx(() {
        if (_ctrl.isLoading.value) {
          return const Center(child: CircularProgressIndicator(color: AppColors.orange));
        }
        if (_ctrl.trackingEvents.isEmpty) {
          return Center(
            child: Text(l10n.noTrackingInfo,
                style: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
          );
        }
        return ListView(
          padding: const EdgeInsets.all(20),
          children: [
            TrackingTimeline(events: _ctrl.trackingEvents),
          ],
        );
      }),
    );
  }
}

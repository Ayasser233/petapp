import 'package:flutter/material.dart';
import 'package:petapp/core/localization/app_localizations.dart';

class OrderStatusBadge extends StatelessWidget {
  final String status;

  const OrderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    final (color, label) = _statusStyle(status, l10n);
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Text(
        label,
        style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  static (Color, String) _statusStyle(String status, AppLocalizations l10n) {
    switch (status.toLowerCase()) {
      case 'pending':
        return (Colors.orange, l10n.orderStatusPending);
      case 'confirmed':
        return (Colors.blue, l10n.orderStatusConfirmed);
      case 'processing':
        return (Colors.purple, l10n.orderStatusProcessing);
      case 'shipped':
        return (Colors.teal, l10n.orderStatusShipped);
      case 'delivered':
        return (Colors.green, l10n.orderStatusDelivered);
      case 'cancelled':
        return (Colors.red, l10n.orderStatusCancelled);
      case 'paid':
        return (Colors.green, l10n.paymentStatusPaid);
      case 'failed':
        return (Colors.red, l10n.paymentStatusFailed);
      case 'refunded':
        return (Colors.blueGrey, l10n.paymentStatusRefunded);
      default:
        return (Colors.grey, status);
    }
  }
}
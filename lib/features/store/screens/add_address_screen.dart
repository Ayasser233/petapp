import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/features/store/controllers/checkout_controller.dart';
import 'package:petapp/features/store/models/shipping_address_model.dart';

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameCtrl = TextEditingController();
  final _phoneCtrl = TextEditingController();
  final _countryCtrl = TextEditingController(text: 'Egypt');
  final _cityCtrl = TextEditingController();
  final _line1Ctrl = TextEditingController();
  final _line2Ctrl = TextEditingController();
  final _postalCtrl = TextEditingController();

  @override
  void dispose() {
    _fullNameCtrl.dispose(); _phoneCtrl.dispose(); _countryCtrl.dispose();
    _cityCtrl.dispose(); _line1Ctrl.dispose(); _line2Ctrl.dispose(); _postalCtrl.dispose();
    super.dispose();
  }

  void _save(AppLocalizations l10n) {
    if (!_formKey.currentState!.validate()) return;
    final address = ShippingAddressModel(
      fullName: _fullNameCtrl.text.trim(),
      phone: _phoneCtrl.text.trim(),
      country: _countryCtrl.text.trim(),
      city: _cityCtrl.text.trim(),
      addressLine1: _line1Ctrl.text.trim(),
      addressLine2: _line2Ctrl.text.trim().isEmpty ? null : _line2Ctrl.text.trim(),
      postalCode: _postalCtrl.text.trim().isEmpty ? null : _postalCtrl.text.trim(),
    );
    Get.find<CheckoutController>().addAddress(address);
    Get.back();
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
        title: Text(l10n.addAddress,
            style: Theme.of(context).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 16, 20, 120),
          children: [
            _field(context, l10n.fullName, _fullNameCtrl, required: true, isDark: isDark, l10n: l10n),
            _field(context, l10n.phone, _phoneCtrl, required: true, isDark: isDark, l10n: l10n, keyboard: TextInputType.phone),
            _field(context, l10n.country, _countryCtrl, required: true, isDark: isDark, l10n: l10n),
            _field(context, l10n.city, _cityCtrl, required: true, isDark: isDark, l10n: l10n),
            _field(context, l10n.addressLine1, _line1Ctrl, required: true, isDark: isDark, l10n: l10n),
            _field(context, l10n.addressLine2Optional, _line2Ctrl, isDark: isDark, l10n: l10n),
            _field(context, l10n.postalCodeOptional, _postalCtrl, isDark: isDark, l10n: l10n, keyboard: TextInputType.number),
          ],
        ),
      ),
      bottomNavigationBar: Padding(
        padding: const EdgeInsets.fromLTRB(20, 0, 20, 36),
        child: ElevatedButton(
          onPressed: () => _save(l10n),
          style: ElevatedButton.styleFrom(
            backgroundColor: AppColors.orange,
            foregroundColor: Colors.white,
            padding: const EdgeInsets.symmetric(vertical: 16),
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(30)),
            elevation: 0,
          ),
          child: Text(l10n.saveAddress, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
    );
  }

  Widget _field(BuildContext context, String label, TextEditingController ctrl,
      {bool required = false, bool isDark = false, TextInputType? keyboard, required AppLocalizations l10n}) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 16),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboard,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          labelText: label,
          filled: true,
          fillColor: isDark ? AppColors.lightblack : Colors.grey.shade100,
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12), borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: const BorderSide(color: AppColors.orange, width: 1.5),
          ),
          labelStyle: TextStyle(color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
        ),
        validator: required ? (v) => (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null : null,
      ),
    );
  }
}
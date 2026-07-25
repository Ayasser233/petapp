import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:petapp/core/localization/app_localizations.dart';
import 'package:petapp/core/utils/app_colors.dart';
import 'package:petapp/di/service_locator.dart';
import 'package:petapp/features/profile/controllers/profile_controller.dart';
import 'package:petapp/features/store/controllers/address_controller.dart';
import 'package:petapp/features/store/controllers/checkout_controller.dart';
import 'package:petapp/features/store/models/shipping_address_model.dart';

// ── All 27 Egyptian Governorates ─────────────────────────────────────────────
const _egyptGovernorates = [
  'Cairo', 'Alexandria', 'Giza', 'Qalyubia', 'Sharqia',
  'Dakahlia', 'Gharbia', 'Monufia', 'Kafr El Sheikh', 'Beheira',
  'Ismailia', 'Port Said', 'Suez', 'Damietta', 'North Sinai',
  'South Sinai', 'Red Sea', 'Matrouh', 'Luxor', 'Aswan',
  'Qena', 'Sohag', 'Asyut', 'New Valley', 'Minya',
  'Beni Suef', 'Fayyum',
];

class AddAddressScreen extends StatefulWidget {
  const AddAddressScreen({super.key});

  @override
  State<AddAddressScreen> createState() => _AddAddressScreenState();
}

class _AddAddressScreenState extends State<AddAddressScreen> {
  final _formKey = GlobalKey<FormState>();
  final _fullNameCtrl = TextEditingController();
  final _phoneCtrl    = TextEditingController();
  final _cityCtrl     = TextEditingController();
  final _line1Ctrl    = TextEditingController();
  final _line2Ctrl    = TextEditingController();
  final _postalCtrl   = TextEditingController();

  String? _selectedGovernorate;
  bool _isLocating = false;

  @override
  void initState() {
    super.initState();
    _prefillFromProfile();
  }

  void _prefillFromProfile() {
    try {
      final profile = sl<ProfileController>().userProfile;
      if (profile != null) {
        if (profile.name.isNotEmpty) _fullNameCtrl.text = profile.name;
        final phone = profile.mobile ?? profile.phone;
        if (phone.isNotEmpty) _phoneCtrl.text = phone;
      }
    } catch (_) {}
  }

  @override
  void dispose() {
    _fullNameCtrl.dispose();
    _phoneCtrl.dispose();
    _cityCtrl.dispose();
    _line1Ctrl.dispose();
    _line2Ctrl.dispose();
    _postalCtrl.dispose();
    super.dispose();
  }

  // ── Current GPS location ──────────────────────────────────────────────────

  Future<void> _useCurrentLocation() async {
    setState(() => _isLocating = true);
    try {
      LocationPermission perm = await Geolocator.checkPermission();
      if (perm == LocationPermission.denied) {
        perm = await Geolocator.requestPermission();
      }
      if (perm == LocationPermission.deniedForever ||
          perm == LocationPermission.denied) {
        _showSnack('Location permission denied. Enable it in Settings.');
        return;
      }
      final pos = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.high,
          timeLimit: Duration(seconds: 12),
        ),
      );
      await _fillFromCoordinates(pos.latitude, pos.longitude);
    } catch (_) {
      _showSnack('Could not get current location. Try again.');
    } finally {
      if (mounted) setState(() => _isLocating = false);
    }
  }

  Future<void> _fillFromCoordinates(double lat, double lng) async {
    try {
      final placemarks = await placemarkFromCoordinates(lat, lng);
      if (placemarks.isEmpty || !mounted) return;
      final p = placemarks.first;

      // Address line 1
      final addrParts = <String>[
        if (p.name != null && p.name!.isNotEmpty && p.name != p.street)
          p.name!,
        if (p.street != null && p.street!.isNotEmpty) p.street!,
        if (p.subLocality != null && p.subLocality!.isNotEmpty) p.subLocality!,
      ];
      if (addrParts.isNotEmpty) _line1Ctrl.text = addrParts.join(', ');

      // City / district
      final locality = p.locality ?? p.subAdministrativeArea ?? '';
      if (locality.isNotEmpty) _cityCtrl.text = locality;

      // Postal code
      if (p.postalCode != null && p.postalCode!.isNotEmpty) {
        _postalCtrl.text = p.postalCode!;
      }

      // Governorate
      final rawGov = p.administrativeArea ?? p.locality ?? '';
      final gov = _matchGovernorate(rawGov);
      if (gov != null && mounted) setState(() => _selectedGovernorate = gov);
    } catch (_) {
      _showSnack('Could not determine address. Fill in manually.');
    }
  }

  String? _matchGovernorate(String raw) {
    if (raw.isEmpty) return null;
    final lower = raw.toLowerCase();
    for (final g in _egyptGovernorates) {
      if (lower.contains(g.toLowerCase())) return g;
    }
    // Arabic names
    const arabicMap = <String, String>{
      'القاهرة': 'Cairo', 'محافظة القاهرة': 'Cairo',
      'الإسكندرية': 'Alexandria', 'إسكندرية': 'Alexandria',
      'الجيزة': 'Giza', 'محافظة الجيزة': 'Giza',
      'القليوبية': 'Qalyubia', 'الشرقية': 'Sharqia',
      'الدقهلية': 'Dakahlia', 'الغربية': 'Gharbia',
      'المنوفية': 'Monufia', 'كفر الشيخ': 'Kafr El Sheikh',
      'البحيرة': 'Beheira', 'الإسماعيلية': 'Ismailia',
      'بورسعيد': 'Port Said', 'السويس': 'Suez',
      'دمياط': 'Damietta', 'شمال سيناء': 'North Sinai',
      'جنوب سيناء': 'South Sinai', 'البحر الأحمر': 'Red Sea',
      'مطروح': 'Matrouh', 'الأقصر': 'Luxor',
      'أسوان': 'Aswan', 'قنا': 'Qena',
      'سوهاج': 'Sohag', 'أسيوط': 'Asyut',
      'الوادي الجديد': 'New Valley', 'المنيا': 'Minya',
      'بني سويف': 'Beni Suef', 'الفيوم': 'Fayyum',
    };
    for (final entry in arabicMap.entries) {
      if (raw.contains(entry.key)) return entry.value;
    }
    return null;
  }

  void _showSnack(String msg) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(msg), backgroundColor: AppColors.orange),
    );
  }

  // ── Save ──────────────────────────────────────────────────────────────────

  void _save(AppLocalizations l10n) {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedGovernorate == null) {
      _showSnack('Please select a governorate.');
      return;
    }
    final address = ShippingAddressModel(
      fullName:     _fullNameCtrl.text.trim(),
      phone:        _phoneCtrl.text.trim(),
      country:      'Egypt',
      governorate:  _selectedGovernorate!,
      city:         _cityCtrl.text.trim(),
      addressLine1: _line1Ctrl.text.trim(),
      addressLine2: _line2Ctrl.text.trim().isEmpty ? null : _line2Ctrl.text.trim(),
      postalCode:   _postalCtrl.text.trim().isEmpty ? null : _postalCtrl.text.trim(),
    );
    final addrCtrl = Get.find<AddressController>();
    final saved = addrCtrl.addAddress(address);
    if (Get.isRegistered<CheckoutController>()) {
      Get.find<CheckoutController>().selectAddress(saved);
    }
    Get.back();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final l10n   = AppLocalizations.of(context);

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
            style: Theme.of(context)
                .textTheme
                .titleLarge
                ?.copyWith(fontWeight: FontWeight.bold)),
      ),
      body: Form(
        key: _formKey,
        child: ListView(
          padding: const EdgeInsets.fromLTRB(20, 20, 20, 120),
          children: [
            // ── My Location button ────────────────────────────────────────
            _isLocating
                ? const Center(
                    child: Padding(
                      padding: EdgeInsets.symmetric(vertical: 8),
                      child: SizedBox(
                        width: 26, height: 26,
                        child: CircularProgressIndicator(
                            strokeWidth: 2.5, color: AppColors.orange),
                      ),
                    ),
                  )
                : InkWell(
                    onTap: _useCurrentLocation,
                    borderRadius: BorderRadius.circular(12),
                    child: Container(
                      width: double.infinity,
                      padding: const EdgeInsets.symmetric(
                          horizontal: 16, vertical: 14),
                      decoration: BoxDecoration(
                        color: AppColors.orange.withValues(alpha: 0.08),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(
                            color: AppColors.orange.withValues(alpha: 0.35),
                            width: 1.2),
                      ),
                      child: const Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(Icons.my_location_rounded,
                              color: AppColors.orange, size: 18),
                          SizedBox(width: 8),
                          Text('Use My Current Location',
                              style: TextStyle(
                                  color: AppColors.orange,
                                  fontWeight: FontWeight.w600,
                                  fontSize: 14)),
                        ],
                      ),
                    ),
                  ),
            const SizedBox(height: 22),

            // ── Contact info ──────────────────────────────────────────────
            _SectionLabel('CONTACT INFO'),
            const SizedBox(height: 10),
            _field(context, l10n.fullName, _fullNameCtrl,
                required: true, isDark: isDark, l10n: l10n,
                icon: Icons.person_outline),
            _field(context, l10n.phone, _phoneCtrl,
                required: true, isDark: isDark, l10n: l10n,
                keyboard: TextInputType.phone,
                icon: Icons.phone_outlined),

            // ── Delivery address ──────────────────────────────────────────
            _SectionLabel('DELIVERY ADDRESS'),
            const SizedBox(height: 10),

            // Governorate dropdown
            _GovernorateDropdown(
              value: _selectedGovernorate,
              isDark: isDark,
              onChanged: (v) => setState(() => _selectedGovernorate = v),
              validator: (_) =>
                  _selectedGovernorate == null ? l10n.fieldRequired : null,
            ),

            // City / district
            _field(context, 'City / District', _cityCtrl,
                isDark: isDark, l10n: l10n,
                icon: Icons.apartment_outlined,
                hint: 'e.g. Nasr City, Maadi, Heliopolis'),

            // Street address
            _field(context, l10n.addressLine1, _line1Ctrl,
                required: true, isDark: isDark, l10n: l10n,
                icon: Icons.location_on_outlined),

            // Apt / floor (optional)
            _field(context, l10n.addressLine2Optional, _line2Ctrl,
                isDark: isDark, l10n: l10n,
                icon: Icons.home_outlined),

            // Postal code (optional)
            _field(context, l10n.postalCodeOptional, _postalCtrl,
                isDark: isDark, l10n: l10n,
                keyboard: TextInputType.number,
                icon: Icons.markunread_mailbox_outlined),
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
            shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30)),
            elevation: 0,
          ),
          child: Text(l10n.saveAddress,
              style: const TextStyle(
                  fontWeight: FontWeight.bold, fontSize: 16)),
        ),
      ),
    );
  }

  Widget _field(
    BuildContext context,
    String label,
    TextEditingController ctrl, {
    bool required = false,
    bool isDark = false,
    TextInputType? keyboard,
    IconData? icon,
    String? hint,
    required AppLocalizations l10n,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: TextFormField(
        controller: ctrl,
        keyboardType: keyboard,
        style: Theme.of(context).textTheme.bodyMedium,
        decoration: InputDecoration(
          labelText: label,
          hintText: hint,
          hintStyle: TextStyle(color: Colors.grey.shade400, fontSize: 13),
          prefixIcon: icon != null
              ? Icon(icon, size: 20,
                  color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)
              : null,
          filled: true,
          fillColor: isDark ? AppColors.lightblack : Colors.grey.shade100,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.orange, width: 1.5)),
          labelStyle: TextStyle(
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600),
        ),
        validator: required
            ? (v) => (v == null || v.trim().isEmpty) ? l10n.fieldRequired : null
            : null,
      ),
    );
  }
}

// ── Governorate Dropdown ──────────────────────────────────────────────────────

class _GovernorateDropdown extends StatelessWidget {
  final String? value;
  final bool isDark;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;

  const _GovernorateDropdown({
    required this.value,
    required this.isDark,
    required this.onChanged,
    this.validator,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: DropdownButtonFormField<String>(
        value: value,
        hint: Text('Select Governorate',
            style: TextStyle(
                color: isDark ? Colors.grey.shade400 : Colors.grey.shade600)),
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.map_outlined,
              color: isDark ? Colors.grey.shade400 : Colors.grey.shade600,
              size: 20),
          filled: true,
          fillColor: isDark ? AppColors.lightblack : Colors.grey.shade100,
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none),
          focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide:
                  const BorderSide(color: AppColors.orange, width: 1.5)),
        ),
        dropdownColor: isDark ? const Color(0xFF2A2A2A) : Colors.white,
        isExpanded: true,
        items: _egyptGovernorates
            .map((g) => DropdownMenuItem(value: g, child: Text(g)))
            .toList(),
        onChanged: onChanged,
        validator: validator,
      ),
    );
  }
}

// ── Section label ─────────────────────────────────────────────────────────────

class _SectionLabel extends StatelessWidget {
  final String text;
  const _SectionLabel(this.text);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 2),
      child: Text(text,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                color: AppColors.orange,
                fontWeight: FontWeight.bold,
                letterSpacing: 1.1,
              )),
    );
  }
}

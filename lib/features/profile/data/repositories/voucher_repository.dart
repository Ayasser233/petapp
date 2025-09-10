import 'package:petapp/features/profile/data/models/voucher_model.dart';

class VoucherRepository {
  // Static dummy vouchers data
  static final List<VoucherModel> _dummyVouchers = [
    VoucherModel(
      id: '1',
      title: '20% Off Pet Food',
      description: 'Get 20% discount on all pet food items',
      code: 'ALEEFY20',
      discount: 20,
      discountType: 'percentage',
      expiryDate: DateTime.now().add(const Duration(days: 30)),
      category: 'food',
      isUsed: false,
    ),
    VoucherModel(
      id: '2',
      title: 'Free Veterinary Consultation',
      description: 'Free consultation with our certified veterinarians',
      code: 'FREEVET',
      discount: 50,
      discountType: 'fixed',
      expiryDate: DateTime.now().add(const Duration(days: 15)),
      category: 'consultation',
      isUsed: false,
    ),
    VoucherModel(
      id: '3',
      title: '10% Pet Accessories',
      description: 'Get 10% discount on all pet accessories',
      code: 'SAVE10',
      discount: 10,
      discountType: 'percentage',
      expiryDate: DateTime.now().add(const Duration(days: 7)),
      category: 'accessories',
      isUsed: false,
    ),
    VoucherModel(
      id: '4',
      title: 'Free Pet Grooming',
      description: 'Complimentary grooming service for your pet',
      code: 'GROOM001',
      discount: 75,
      discountType: 'fixed',
      expiryDate: DateTime.now().subtract(const Duration(days: 5)), // Expired
      category: 'grooming',
      isUsed: false,
    ),
    VoucherModel(
      id: '5',
      title: '15% Pet Training',
      description: 'Discount on pet training sessions',
      code: 'TRAIN15',
      discount: 15,
      discountType: 'percentage',
      expiryDate: DateTime.now().add(const Duration(days: 45)),
      category: 'training',
      isUsed: true,
      usedDate: DateTime.now().subtract(const Duration(days: 2)).toIso8601String(),
    ),
  ];

  // Current user vouchers (will be modified based on authentication)
  static List<VoucherModel> _userVouchers = List.from(_dummyVouchers);

  VoucherRepository();

  /// Get user vouchers (returns static dummy data)
  Future<List<VoucherModel>> getUserVouchers() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Return copy of vouchers to prevent direct modification
    return List.from(_dummyVouchers);
  }

  /// Add/Redeem a voucher code
  Future<VoucherModel> addVoucher(String code) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 800));
    
    // Check if code already exists in user's vouchers
    if (_userVouchers.any((v) => v.code == code)) {
      throw Exception('Voucher code already redeemed');
    }
    
    // Find voucher by code in dummy data
    final availableVoucher = _dummyVouchers.firstWhere(
      (v) => v.code == code,
      orElse: () => throw Exception('Invalid voucher code'),
    );
    
    // Create a copy for the user
    final newVoucher = VoucherModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: availableVoucher.title,
      description: availableVoucher.description,
      code: availableVoucher.code,
      discount: availableVoucher.discount,
      discountType: availableVoucher.discountType,
      expiryDate: availableVoucher.expiryDate,
      category: availableVoucher.category,
      isUsed: false,
    );
    
    // Add to user's vouchers
    _userVouchers.add(newVoucher);
    
    return newVoucher;
  }

  /// Use/Apply a voucher
  Future<void> useVoucher(String voucherId) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 600));
    
    // Find and mark voucher as used
    final voucherIndex = _userVouchers.indexWhere((v) => v.id == voucherId);
    if (voucherIndex == -1) {
      throw Exception('Voucher not found');
    }
    
    final voucher = _userVouchers[voucherIndex];
    if (voucher.isUsed) {
      throw Exception('Voucher already used');
    }
    
    if (voucher.expiryDate.isBefore(DateTime.now())) {
      throw Exception('Voucher has expired');
    }
    
    // Mark as used
    _userVouchers[voucherIndex] = VoucherModel(
      id: voucher.id,
      title: voucher.title,
      description: voucher.description,
      code: voucher.code,
      discount: voucher.discount,
      discountType: voucher.discountType,
      expiryDate: voucher.expiryDate,
      category: voucher.category,
      isUsed: true,
      usedDate: DateTime.now().toIso8601String(),
    );
  }

  /// Get voucher statistics (counts)
  Future<Map<String, int>> getVoucherStats() async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 400));
    
    final now = DateTime.now();
    final available = _userVouchers.where((v) => !v.isUsed && v.expiryDate.isAfter(now)).length;
    final used = _userVouchers.where((v) => v.isUsed).length;
    final expired = _userVouchers.where((v) => !v.isUsed && v.expiryDate.isBefore(now)).length;
    
    return {
      'total': _userVouchers.length,
      'available': available,
      'used': used,
      'expired': expired,
    };
  }

  /// Validate voucher code (for preview before adding)
  Future<bool> validateVoucherCode(String code) async {
    // Simulate API delay
    await Future.delayed(const Duration(milliseconds: 300));
    
    // Check if code exists in dummy vouchers and not already used by user
    final isValidCode = _dummyVouchers.any((v) => v.code == code);
    final alreadyRedeemed = _userVouchers.any((v) => v.code == code);
    
    return isValidCode && !alreadyRedeemed;
  }

  /// Reset user vouchers (useful for testing)
  void resetUserVouchers() {
    _userVouchers.clear();
    _userVouchers.addAll(List.from(_dummyVouchers));
  }
}

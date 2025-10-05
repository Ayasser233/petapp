class VoucherModel {
  final String id;
  final String title;
  final String description;
  final String code;
  final double discount;
  final String discountType; // 'percentage' or 'fixed'
  final DateTime expiryDate;
  final bool isUsed;
  final String? usedDate;
  final String category;
  final double? minPurchaseAmount;
  final String? imageUrl;

  VoucherModel({
    required this.id,
    required this.title,
    required this.description,
    required this.code,
    required this.discount,
    required this.discountType,
    required this.expiryDate,
    this.isUsed = false,
    this.usedDate,
    required this.category,
    this.minPurchaseAmount,
    this.imageUrl,
  });

  bool get isExpired => DateTime.now().isAfter(expiryDate);
  bool get isValid => !isUsed && !isExpired;

  // Factory constructor for creating VoucherModel from JSON
  factory VoucherModel.fromJson(Map<String, dynamic> json) {
    return VoucherModel(
      id: json['id']?.toString() ?? '',
      title: json['title'] ?? '',
      description: json['description'] ?? '',
      code: json['code'] ?? '',
      discount: (json['discount'] ?? 0).toDouble(),
      discountType: json['discount_type'] ?? 'percentage',
      expiryDate: json['expiry_date'] != null 
          ? DateTime.parse(json['expiry_date']) 
          : DateTime.now().add(const Duration(days: 30)),
      isUsed: json['is_used'] ?? false,
      usedDate: json['used_date'],
      category: json['category'] ?? '',
      minPurchaseAmount: json['min_purchase_amount']?.toDouble(),
      imageUrl: json['image_url'],
    );
  }

  // Convert VoucherModel to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'title': title,
      'description': description,
      'code': code,
      'discount': discount,
      'discount_type': discountType,
      'expiry_date': expiryDate.toIso8601String(),
      'is_used': isUsed,
      'used_date': usedDate,
      'category': category,
      'min_purchase_amount': minPurchaseAmount,
      'image_url': imageUrl,
    };
  }

  String get formattedDiscount {
    if (discountType == 'percentage') {
      return '${discount.toInt()}% OFF';
    } else {
      return '\$${discount.toStringAsFixed(2)} OFF';
    }
  }

  String get formattedExpiry {
    final now = DateTime.now();
    final difference = expiryDate.difference(now).inDays;
    
    if (difference < 0) {
      return 'Expired';
    } else if (difference == 0) {
      return 'Expires today';
    } else if (difference == 1) {
      return 'Expires tomorrow';
    } else if (difference < 7) {
      return 'Expires in $difference days';
    } else {
      return 'Expires ${expiryDate.day}/${expiryDate.month}/${expiryDate.year}';
    }
  }
}
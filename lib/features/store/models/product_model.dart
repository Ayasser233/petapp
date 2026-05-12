class ProductModel {
  final String id;
  final String name;
  final String description;
  final String image;
  final String category;
  final String brand;
  final double price;
  final double rating;
  final int reviewCount;
  final bool isFavorite;

  const ProductModel({
    required this.id,
    required this.name,
    required this.description,
    required this.image,
    required this.category,
    required this.brand,
    required this.price,
    this.rating = 0.0,
    this.reviewCount = 0,
    this.isFavorite = false,
  });

  ProductModel copyWith({
    String? id,
    String? name,
    String? description,
    String? image,
    String? category,
    String? brand,
    double? price,
    double? rating,
    int? reviewCount,
    bool? isFavorite,
  }) {
    return ProductModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      image: image ?? this.image,
      category: category ?? this.category,
      brand: brand ?? this.brand,
      price: price ?? this.price,
      rating: rating ?? this.rating,
      reviewCount: reviewCount ?? this.reviewCount,
      isFavorite: isFavorite ?? this.isFavorite,
    );
  }
}

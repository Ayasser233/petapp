class ServiceModel {
  final String id;
  final String name;
  final String image;
  final bool available;
  final double price;
  final String description;
  
  ServiceModel({
    required this.id,
    required this.name,
    required this.image,
    required this.available,
    required this.price,
    this.description = '',
  });
  
  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'image': image,
      'available': available,
      'price': price,
      'description': description,
    };
  }
  
  factory ServiceModel.fromMap(Map<String, dynamic> map) {
    return ServiceModel(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      image: map['image'] ?? '',
      available: map['available'] ?? true,
      price: map['price']?.toDouble() ?? 0.0,
      description: map['description'] ?? '',
    );
  }
}
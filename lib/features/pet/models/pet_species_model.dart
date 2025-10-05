class PetSpecies {
  final String id;
  final String name;
  final String? description;
  final bool isActive;

  PetSpecies({
    required this.id,
    required this.name,
    this.description,
    required this.isActive,
  });

  factory PetSpecies.fromJson(Map<String, dynamic> json) {
    return PetSpecies(
      id: json['id']?.toString() ?? '',
      name: json['name'] ?? '',
      description: json['description'],
      isActive: json['isActive'] ?? json['is_active'] ?? true,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'isActive': isActive,
    };
  }

  @override
  String toString() {
    return 'PetSpecies(id: $id, name: $name, isActive: $isActive)';
  }

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;

    return other is PetSpecies &&
        other.id == id &&
        other.name == name &&
        other.isActive == isActive;
  }

  @override
  int get hashCode => id.hashCode ^ name.hashCode ^ isActive.hashCode;
}

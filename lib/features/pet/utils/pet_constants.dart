/// Pet-specific constants and utilities
class PetConstants {
  // Allowed species
  static const List<String> allowedSpecies = ['cat', 'dog'];

  // Species validation
  static bool isValidSpecies(String? species) {
    if (species == null || species.isEmpty) return false;
    return allowedSpecies.contains(species.toLowerCase());
  }

  static void validateSpecies(String? species, {String? operation}) {
    if (!isValidSpecies(species)) {
      final operationText = operation != null ? ' to $operation' : '';
      throw Exception(
          'Invalid species$operationText. Only cats and dogs are supported. '
          'Allowed values: ${allowedSpecies.join(", ")}. '
          'Provided: ${species ?? "null"}');
    }
  }


}

class Recipe {
  final String name;
  final List<String> ingredients;
  final String instructions;

  Recipe({
    required this.name,
    required this.ingredients,
    required this.instructions,
  });

  // Convert a Recipe into a Map for JSON serialization
  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'ingredients': ingredients,
      'instructions': instructions, // Include instructions in serialization
    };
  }

  // Convert a Map back into a Recipe object
  factory Recipe.fromJson(Map<String, dynamic> json) {
    return Recipe(
      name: json['name'],
      ingredients: List<String>.from(json['ingredients']),
      instructions: json['instructions'], // Deserialize the instructions field
    );
  }
}

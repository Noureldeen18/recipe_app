import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert'; // For JSON encoding/decoding
import 'recipe_class.dart'; // Ensure this imports your Recipe class
import 'user_add_recipe.dart'; // Ensure this imports the file with your UserAdd widget

class UserDisp extends StatefulWidget {
  const UserDisp({super.key});

  @override
  _UserDispState createState() => _UserDispState();
}

class _UserDispState extends State<UserDisp> {
  List<Recipe> recipes = [];

  @override
  void initState() {
    super.initState();
    _loadRecipes(); // Load saved recipes when the app starts
  }

  // Function to load recipes from SharedPreferences
  void _loadRecipes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? savedRecipes = prefs.getString('recipes');

    if (savedRecipes != null) {
      print('Loaded raw data: $savedRecipes'); // Debugging statement
      List<dynamic> decodedData = jsonDecode(savedRecipes);
      setState(() {
        recipes = decodedData.map((recipe) => Recipe.fromJson(jsonDecode(recipe))).toList();
        print('Loaded recipes: $recipes'); // Debugging statement
      });
    } else {
      print('No recipes found in SharedPreferences'); // Debugging statement
    }
  }

  // Function to save recipes to SharedPreferences
  void _saveRecipes() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String> encodedRecipes = recipes.map((recipe) => jsonEncode(recipe.toJson())).toList();
    print('Saving recipes: $encodedRecipes'); // Debugging statement
    await prefs.setString('recipes', jsonEncode(encodedRecipes));
  }

  // Function to add a new recipe
  void _addRecipe(Recipe recipe) {
    setState(() {
      recipes.add(recipe);
    });
    _saveRecipes(); // Save to SharedPreferences every time a recipe is added
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("User Recipes"),
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(recipes[index].name),
            subtitle: Text("Ingredients: ${recipes[index].ingredients.join(', ')}\nInstructions: ${recipes[index].instructions}"),
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newRecipe = await Navigator.push<Recipe>(
            context,
            MaterialPageRoute(builder: (context) => UserAdd(onRecipeAdded: _addRecipe)),
          );

          if (newRecipe != null) {
            _addRecipe(newRecipe);
          }
        },
        child: const Icon(Icons.add, color: Color(0xFFEE3625)),
        tooltip: "Add Recipe",
      ),
    );
  }
}

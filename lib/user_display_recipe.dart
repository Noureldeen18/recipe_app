import 'package:flutter/material.dart';
import 'package:recipe_app/recipe_class.dart';
import 'user_add_recipe.dart'; // Ensure this imports the file with your UserAdd widget and Recipe class

class UserDisp extends StatefulWidget {
  @override
  _UserDispState createState() => _UserDispState();
}

class _UserDispState extends State<UserDisp> {
  List<Recipe> recipes = []; // Store a list of Recipe objects

  void _addRecipe(Recipe recipe) {
    setState(() {
      recipes.add(recipe); // Add the Recipe object to the list
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("User Recipes"),
      ),
      body: ListView.builder(
        itemCount: recipes.length,
        itemBuilder: (context, index) {
          return ListTile(
            title: Text(recipes[index].name), // Access the name field of Recipe
            subtitle: Text("Ingredients: ${recipes[index].ingredients.join(', ')}"), // Join ingredients into a string
          );
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newRecipe = await Navigator.push<Recipe>(
            context,
            MaterialPageRoute(builder: (context) => UserAdd(onRecipeAdded: _addRecipe)),
          );

          // Add new recipe only if it's not null
          if (newRecipe != null) {
            _addRecipe(newRecipe);
          }
        },
        child: Icon(Icons.add,color: Color(0xFFEE3625),),
        tooltip: "Add Recipe",
      ),
    );
  }
}

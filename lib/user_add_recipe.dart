import 'package:flutter/material.dart';
import 'package:recipe_app/recipe_class.dart';

class UserAdd extends StatefulWidget {
  final Function(Recipe) onRecipeAdded;
  UserAdd({Key? key, required this.onRecipeAdded}) : super(key: key); // Update constructor

  @override
  State<UserAdd> createState() => _UserAddState();
}

class _UserAddState extends State<UserAdd> {
  final _formKey = GlobalKey<FormState>(); // Add GlobalKey for Form validation
  String recipeName = '';
  String ingredient = '';
  String instructions = '';
  List<String> ingredients = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: const Text(
            "Add Recipe",
            style: TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Form(
                key: _formKey, // Assign formKey to the Form widget
                child: Padding( // Add Padding around the form
                  padding: const EdgeInsets.all(20.0),
                  child: Column(
                      children: [
                        const Text(
                          "Add Recipe",
                          style: TextStyle(
                            fontSize: 24,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: const InputDecoration(
                            labelText: "Enter Recipe Name",
                            border: OutlineInputBorder(borderSide: BorderSide()),
                          ),
                          onChanged: (value) {
                            setState(() {
                              recipeName = value; // Correct assignment
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return "Please enter recipe name";
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Ingredient'),
                          onChanged: (value) {
                            setState(() {
                              ingredient = value;
                            });
                          },
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: () {
                            if (ingredient.isNotEmpty) {
                              setState(() {
                                ingredients.add(ingredient);
                                ingredient = ''; // Clear the input field
                              });
                            }
                          },
                          child: const Text('Add Ingredient'),
                        ),
                        // Display the list of ingredients
                        if (ingredients.isNotEmpty)
                          Padding(
                            padding: const EdgeInsets.symmetric(vertical: 10.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: ingredients.map((ingredient) {
                                return ListTile(
                                  title: Text(ingredient),
                                  trailing: IconButton(
                                    icon: const Icon(Icons.delete, color: Colors.red),
                                    onPressed: () {
                                      setState(() {
                                        ingredients.remove(ingredient);
                                      });
                                    },
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        const SizedBox(height: 20),
                        TextFormField(
                          decoration: const InputDecoration(labelText: 'Instructions'),
                          onChanged: (value) {
                            setState(() {
                              instructions = value;
                            });
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter instructions';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 20),
                        ElevatedButton(
                          onPressed: () {
                            if (_formKey.currentState!.validate() && ingredients.isNotEmpty) {
                              // Create a new Recipe object
                              Recipe newRecipe = Recipe(
                                name: recipeName,
                                ingredients: ingredients,
                                instructions: instructions,
                              );

                              // Call the onRecipeAdded function with the new Recipe object
                              widget.onRecipeAdded(newRecipe);

                              Navigator.pop(context); // Navigate back to the previous screen
                            }
                          },

                          child: const Text('Submit'),
                        ),
                      ]
                  ),
                )

            )
        )
    );
  }
}
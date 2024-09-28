import 'package:flutter/material.dart';
import 'package:recipe_app/recipe_view_page.dart';
import 'dio_helper.dart';

class RecipeMenu extends StatefulWidget {
  const RecipeMenu({super.key});

  @override
  State<RecipeMenu> createState() => _MenuViewState();
}

class _MenuViewState extends State<RecipeMenu> {
  List<String> categories = [];
  List<Map<String, String>> meals = [];
  int _selectedIndex = 0;
  Set<String> favoriteMeals = Set<String>();

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  void fetchCategories() {
    DioHelper.getData(url: 'api/json/v1/1/categories.php').then((value) {
      setState(() {
        categories = List<String>.from(value?.data['categories']
            .map((category) => category['strCategory']));
      });
      fetchMeals(categories[0]);
    }).catchError((error) {
      print(error.toString());
    });
  }

  void fetchMeals(String category) {
    DioHelper.getData(
      url: 'api/json/v1/1/filter.php',
      query: {'c': category},
    ).then((value) {
      setState(() {
        meals = List<Map<String, String>>.from(
          (value?.data['meals'] as List<dynamic>).map((meal) => {
            'idMeal': meal['idMeal'] as String,
            'strMeal': meal['strMeal'] as String,
            'strMealThumb': meal['strMealThumb'] as String,
          }),
        );
      });
    }).catchError((error) {
      print(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 20.0),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "Easy To Cook Menu",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
                textAlign: TextAlign.start,
              ),
            ),
            const SizedBox(height: 20),
            const Padding(
              padding: EdgeInsets.only(left: 20.0),
              child: Text(
                "Category",
                style: TextStyle(
                  fontWeight: FontWeight.w500,
                  fontSize: 18,
                ),
              ),
            ),
            const SizedBox(height: 20),
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: List.generate(categories.length, (index) {
                  return Padding(
                    padding: const EdgeInsets.only(left: 8.0),
                    child: ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _selectedIndex = index;
                        });
                        fetchMeals(categories[index]);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: _selectedIndex == index
                            ? const Color(0xFFf96163)
                            : Colors.white,
                      ),
                      child: Text(categories[index]),
                    ),
                  );
                }),
              ),
            ),
            const SizedBox(height: 20),
            GridView.builder(
              padding: const EdgeInsets.all(10.0),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemCount: meals.length,
              physics: const NeverScrollableScrollPhysics(),
              shrinkWrap: true,
              itemBuilder: (context, index) {
                final meal = meals[index];
                final isFavorite = favoriteMeals.contains(meal['idMeal']!);

                return GestureDetector(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => MealDetailScreen(
                          idMeal: meal['idMeal']!,
                        ),
                      ),
                    );
                  },
                  child: Card(
                    elevation: 3.0,
                    child: Stack(
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Expanded(
                              child: Image.network(
                                meal['strMealThumb']!,
                                fit: BoxFit.cover,
                              ),
                            ),
                            const SizedBox(height: 10),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 8.0),
                              child: Text(
                                meal['strMeal']!,
                                textAlign: TextAlign.center,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                            const SizedBox(height: 10),
                          ],
                        ),
                        Positioned(
                          top: 8,
                          right: 8,
                          child: IconButton(
                            onPressed: () {
                              setState(() {
                                if (isFavorite) {
                                  favoriteMeals.remove(meal['idMeal']);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text("Removed from Favorites"),
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: Colors.black.withOpacity(0.5),
                                    ),
                                  );
                                } else {
                                  favoriteMeals.add(meal['idMeal']!);
                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      content: const Text("Added To Favorites"),
                                      duration: const Duration(seconds: 2),
                                      backgroundColor: Colors.black.withOpacity(0.5),
                                    ),
                                  );
                                }
                              });
                            },
                            icon: Icon(
                              Icons.favorite,
                              color: isFavorite ? Colors.pink : Colors.grey,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ],
        ),
      ),
    );
  }
}

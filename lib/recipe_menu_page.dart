import 'package:flutter/material.dart';
import 'package:recipe_app/recipe_view_page.dart';
import 'package:shared_preferences/shared_preferences.dart';
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
  Map<String, double> mealRatings = {}; // Map to store meal ratings
  bool isLoading = true; // To show loading indicator

  @override
  void initState() {
    super.initState();
    fetchCategories();
    loadFavorites(); // Load favorites when the app starts
  }

  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedFavorites = prefs.getStringList('favoriteMeals');
    if (savedFavorites != null) {
      setState(() {
        favoriteMeals = savedFavorites.toSet();
      });
    }
  }

  // Toggle favorite meals and save to SharedPreferences
  Future<void> toggleFavorite(String mealId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (favoriteMeals.contains(mealId)) {
      favoriteMeals.remove(mealId);
    } else {
      favoriteMeals.add(mealId);
    }
    await prefs.setStringList('favoriteMeals', favoriteMeals.toList());
    setState(() {});
  }

  // Load saved rating from SharedPreferences for all meals
  Future<void> loadRatings() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    for (var meal in meals) {
      String mealId = meal['idMeal']!;
      double? rating = prefs.getDouble(mealId);
      setState(() {
        mealRatings[mealId] = rating ?? 0.0;
      });
    }
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
      loadRatings().then((_) {
        setState(() {
          isLoading = false; // Set loading false after ratings are loaded
        });
      });
    }).catchError((error) {
      print(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
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
                            isLoading = true; // Show loading when switching category
                          });
                          fetchMeals(categories[index]);
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: _selectedIndex == index
                              ? const Color(0xffee3625)
                              : Colors.grey,
                        ),
                        child: Text(categories[index]),
                      ),
                    );
                  }),
                ),
              ),
              const SizedBox(height: 20.0),
              isLoading
                  ? const Center(child: CircularProgressIndicator())
                  : GridView.builder(
                padding: const EdgeInsets.all(10.0),
                gridDelegate:
                const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 5.0,
                  mainAxisSpacing: 5.0,
                ),
                itemCount: meals.length,
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                itemBuilder: (context, index) {
                  final meal = meals[index];
                  final mealId = meal['idMeal']!;
                  final mealRating = mealRatings[mealId] ?? 0.0; // Fetch rating

                  return GestureDetector(
                    onTap: () async {
                      // Navigate to the MealDetailScreen and wait for the returned rating
                      final updatedRating = await Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              MealDetailScreen(idMeal: mealId),
                        ),
                      );

                      // If a rating is returned, update the mealRatings map
                      if (updatedRating != null) {
                        setState(() {
                          mealRatings[mealId] = updatedRating;
                        });
                      }
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
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 8.0),
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
                            left: 8,
                            child: Container(
                              padding: EdgeInsets.all(5.0),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.8),
                                borderRadius: BorderRadius.circular(5.0),
                              ),
                              child: Row(
                                children: [
                                  Icon(Icons.star,
                                      color: Color(0xFFEE3625), size: 16),
                                  SizedBox(width: 2),
                                  Text(
                                    mealRating.toStringAsFixed(1),
                                    style: TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 12,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          Positioned(
                            top: 8,
                            right: 8,
                            child: IconButton(
                              onPressed: () {
                                toggleFavorite(meal['idMeal']!);
                              },
                              icon: Icon(
                                Icons.favorite,
                                color: favoriteMeals
                                    .contains(meal['idMeal']!)
                                    ? Colors.pink
                                    : Colors.grey,
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
      ),
    );
  }
}

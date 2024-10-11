import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/material.dart';
import 'dio_helper.dart';

class MealDetailScreen extends StatefulWidget {
  final String idMeal;

  MealDetailScreen({required this.idMeal});

  @override
  _MealDetailScreenState createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  Map<String, dynamic>? mealDetails;
  Set<String> favoriteMeals = Set<String>();
  double? savedRating;

  @override
  void initState() {
    super.initState();
    fetchMealDetails();
    loadSavedRating();
    loadFavorites();  // Load favorites when screen opens
  }

  void fetchMealDetails() {
    DioHelper.getData(
      url: 'api/json/v1/1/lookup.php',
      query: {'i': widget.idMeal},
    ).then((value) {
      setState(() {
        mealDetails = value?.data['meals'][0];
      });
    }).catchError((error) {
      print(error.toString());
    });
  }

  void _launchUrl(String url) async {
    Uri uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not launch $url';
    }
  }

  void loadSavedRating() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      savedRating = prefs.getDouble(widget.idMeal) ?? 0.0;
    });
  }

  void saveRating(double rating) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setDouble(widget.idMeal, rating);
    setState(() {
      savedRating = rating;
    });
  }

  // Toggle favorite and update SharedPreferences
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

  // Load favorite meals from SharedPreferences
  Future<void> loadFavorites() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    List<String>? savedFavorites = prefs.getStringList('favoriteMeals');
    if (savedFavorites != null) {
      setState(() {
        favoriteMeals = savedFavorites.toSet();
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfffdcbcb),
        title: Text(mealDetails != null ? mealDetails!['strMeal'] : 'Loading...'),
        centerTitle: true,
        actions: [
          IconButton(
            onPressed: () {
              if (mealDetails != null) {
                toggleFavorite(mealDetails!['idMeal']);
              }
            },
            icon: Icon(
              Icons.favorite,
              color: mealDetails != null && favoriteMeals.contains(mealDetails!['idMeal'])
                  ? Colors.red
                  : Colors.grey,
            ),
          ),
        ],
      ),
      body: mealDetails == null
          ? Center(child: CircularProgressIndicator())
          : SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Image.network(
              mealDetails!['strMealThumb'],
              height: 250,
              fit: BoxFit.cover,
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                mealDetails!['strMeal'],
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Ingredients',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(20, (index) {
                  String? ingredient = mealDetails!['strIngredient${index + 1}'];
                  String? measure = mealDetails!['strMeasure${index + 1}'];
                  if (ingredient != null && ingredient.isNotEmpty) {
                    return Text('- $ingredient (${measure ?? ''})');
                  }
                  return SizedBox();
                }),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(16.0),
              child: Text(
                'Instructions',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Text(mealDetails!['strInstructions']),
            ),
            SizedBox(height: 30),
            TextButton(
              onPressed: () {
                if (mealDetails!['strYoutube'] != null && mealDetails!['strYoutube'].isNotEmpty) {
                  _launchUrl(mealDetails!['strYoutube']);
                } else {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text("No video available for this recipe"),
                    ),
                  );
                }
              },
              child: Text('Watch Recipe Video'),
            ),
            SizedBox(height: 20,),
            Center(
              child: Text("Rate the recipe",
                style: TextStyle(fontWeight: FontWeight.bold,
                    fontSize: 20),),
            ),
            SizedBox(height: 30,),
            Center(
              child: RatingBar.builder(
                minRating: 1,
                allowHalfRating: true,
                itemPadding: EdgeInsets.symmetric(horizontal: 3),
                direction: Axis.horizontal,
                itemBuilder: (context, _) =>
                    Icon(Icons.star, color: Color(0xFFEE3625)),
                onRatingUpdate: (rating) {
                  saveRating(rating);  // Save the rating
                  Navigator.pop(context, rating);  // Pass the updated rating back
                },
                initialRating: savedRating ?? 0.0, // Show saved rating
              ),
            ),
            SizedBox(height: 40),
          ],
        ),
      ),
    );
  }
}

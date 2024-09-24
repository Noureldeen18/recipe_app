
import 'package:flutter/material.dart';

import 'dio_helper.dart';

class MealDetailScreen extends StatefulWidget {
  final String idMeal;

  const MealDetailScreen({super.key, required this.idMeal});

  @override
  _MealDetailScreenState createState() => _MealDetailScreenState();
}

class _MealDetailScreenState extends State<MealDetailScreen> {
  Map<String, dynamic>? mealDetails;


  @override
  void initState() {
    super.initState();
    fetchMealDetails();
  }

  // Fetch meal details using the meal ID
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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xfffdcbcb),
        title: Text(mealDetails != null ? mealDetails!['strMeal'] : 'Loading...'),
        centerTitle: true,
      ),
      body: mealDetails == null
          ? const Center(child: CircularProgressIndicator())
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
                style: const TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
              child: Text(
                'Ingredients',
                style: TextStyle(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
            // Display ingredients
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: List.generate(20, (index) {
                  String? ingredient = mealDetails!['strIngredient${index + 1}'];
                  String? measure = mealDetails!['strMeasure${index + 1}'];
                  if (ingredient != null && ingredient.isNotEmpty) {
                    return Text(
                        '- $ingredient (${measure ?? ''})');
                  }
                  return const SizedBox();
                }),
              ),
            ),
            const Padding(
              padding: EdgeInsets.all(16.0),
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
          ],
        ),
      ),
    );
  }
}
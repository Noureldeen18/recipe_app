import 'package:flutter/material.dart';
import 'package:recipe_app/recipe_view_page.dart';
import 'dio_helper.dart';

class Test extends StatefulWidget {
  const Test({super.key});

  @override
  State<Test> createState() => _MenuViewState();
}

class _MenuViewState extends State<Test> {
  List<String> categories = [];
  List<Map<String, String>> meals = [];  // Store meals for the selected category
  int _selectedIndex = 0;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  // Fetch categories from the API
  void fetchCategories() {
    DioHelper.getData(url: 'api/json/v1/1/categories.php').then((value) {
      setState(() {
        categories = List<String>.from(
            value?.data['categories'].map((category) => category['strCategory']));
      });
      // After fetching categories, fetch meals for the default (first) category
      fetchMeals(categories[0]);
    }).catchError((error) {
      print(error.toString());
    });
  }

  // Fetch meals from the API based on the selected category
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
            })
        );
      });
    }).catchError((error) {
      print(error.toString());
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xfffdcbcb),
        leading: IconButton(
          onPressed: () {},
          icon: Icon(Icons.menu),
          color: Colors.black,
        ),
        actions: [
          IconButton(
            onPressed: () {},
            icon: Icon(Icons.notification_add),
            color: Color(0xFFf96163),
          ),
        ],
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 20.0),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              "Easy To Cook Menu",
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 22),
              textAlign: TextAlign.start,
            ),
          ),
          SizedBox(height: 40),
          Padding(
            padding: const EdgeInsets.only(left: 20.0),
            child: Text(
              "Category",
              style: TextStyle(
                fontWeight: FontWeight.w500,
                fontSize: 18,
              ),
            ),
          ),
          SizedBox(height: 20),
          // Display category buttons
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
                      fetchMeals(categories[index]);  // Fetch meals when a category is selected
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _selectedIndex == index
                          ? Color(0xFFf96163)
                          : Colors.white,
                    ),
                    child: Text(categories[index]),
                  ),
                );
              }),
            ),
          ),
          SizedBox(height: 20),
          // Display meals in a GridView
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(10.0),
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,  // 2 items per row
                crossAxisSpacing: 5.0,
                mainAxisSpacing: 5.0,
              ),
              itemCount: meals.length,
              itemBuilder:(context, index) {
                return GestureDetector(
                    onTap: () {
                      // Navigate to MealDetailScreen when a meal is clicked
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MealDetailScreen(
                            idMeal: meals[index]['idMeal']!,
                          ),
                        ),
                      );
                    },
                    child: Card(
                      elevation: 3.0,
                      child: Column(
                        children: [
                          Image.network(
                            meals[index]['strMealThumb']!,
                            height: 100,
                            width: double.infinity,
                            fit: BoxFit.cover,
                          ),
                          SizedBox(height: 10),
                          Text(
                            meals[index]['strMeal']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                        ],
                      ),
                    )
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

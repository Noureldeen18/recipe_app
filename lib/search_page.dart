import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'recipe_view_page.dart'; // صفحة تفاصيل الوصفة
import 'dio_helper.dart'; // لاستيراد DioHelper

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  _SearchPageState createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> searchResults = [];
  bool isLoading = false;
  String? errorMessage;

  // دالة البحث عن الوصفات
  Future<void> searchRecipes(String query) async {
    if (query.isEmpty) return;

    setState(() {
      isLoading = true;
      errorMessage = null;
      searchResults = [];
    });

    try {
      // استخدام DioHelper للبحث عن الوصفات
      Response? response = await DioHelper.searchRecipesByName(query);

      if (response != null &&
          response.statusCode == 200 &&
          response.data['meals'] != null) {
        setState(() {
          searchResults =
          List<Map<String, dynamic>>.from(response.data['meals']);
        });
      } else {
        setState(() {
          errorMessage = "No results found.";
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = "An error occurred. Please try again.";
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Search Recipes'),
        backgroundColor: const Color(0xffee3625), // لون الشريط العلوي
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            // شريط البحث
            TextField(
              controller: _searchController,
              decoration: InputDecoration(
                hintText: 'Search for recipes...',
                prefixIcon: const Icon(Icons.search, color: Color(0xffee3625)),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Color(0xffee3625)),
                ),
                focusedBorder: const OutlineInputBorder(
                  borderSide: BorderSide(color: Color(0xffee3625), width: 2),
                ),
              ),
              onSubmitted: (query) => searchRecipes(query),
            ),
            const SizedBox(height: 20),

            // عرض النتائج أو الرسالة بناءً على الحالة
            if (isLoading)
              const Center(child: CircularProgressIndicator(color: Color(0xffee3625)))
            else if (errorMessage != null)
              Center(child: Text(errorMessage!))
            else if (searchResults.isEmpty)
                const Center(child: Text('Start searching for your favorite recipes!'))
              else
                Expanded(
                  child: ListView.builder(
                    itemCount: searchResults.length,
                    itemBuilder: (context, index) {
                      var recipe = searchResults[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                        elevation: 5,
                        child: ListTile(
                          leading: Image.network(
                            recipe['strMealThumb'],
                            width: 50,
                            height: 50,
                            fit: BoxFit.cover,
                          ),
                          title: Text(recipe['strMeal']),
                          trailing: const Icon(Icons.arrow_forward_ios, color: Color(0xffee3625)),
                          onTap: () {
                            // الانتقال إلى صفحة تفاصيل الوصفة عند الضغط على الوصفة
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MealDetailScreen(idMeal: recipe['idMeal']),
                              ),
                            );
                          },
                        ),
                      );
                    },
                  ),
                ),
          ],
        ),
      ),
    );
  }
}

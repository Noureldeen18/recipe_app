import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dio_helper.dart'; // تأكد من استيراد DioHelper
import 'recipe_view_page.dart'; // تأكد من استيراد صفحة تفاصيل الوصفة

class FavoritesPage extends StatefulWidget {
  const FavoritesPage({Key? key}) : super(key: key);

  @override
  State<FavoritesPage> createState() => _FavoritesPageState();
}

class _FavoritesPageState extends State<FavoritesPage> {
  List<Map<String, String>> favoriteMeals = []; // لتخزين الوصفات المفضلة
  bool isLoading = true; // لإظهار مؤشر التحميل
  String errorMessage = ''; // لتخزين رسائل الخطأ

  @override
  void initState() {
    super.initState();
    loadFavorites(); // تحميل المفضلات عند بدء الصفحة
  }

  Future<void> loadFavorites() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      List<String>? savedFavorites = prefs.getStringList('favoriteMeals');

      if (savedFavorites != null && savedFavorites.isNotEmpty) {
        // الحصول على تفاصيل الوصفات من الـ API بناءً على الـ IDs
        for (var mealId in savedFavorites) {
          final response = await DioHelper.getData(
            url: 'api/json/v1/1/lookup.php',
            query: {'i': mealId},
          );

          if (response?.data['meals'] != null) {
            favoriteMeals.add({
              'idMeal': mealId,
              'strMeal': response!.data['meals'][0]['strMeal'],
              'strMealThumb': response.data['meals'][0]['strMealThumb'],
            });
          }
        }
      }
    } catch (error) {
      setState(() {
        errorMessage = 'Failed to load favorites: ${error.toString()}';
      });
    } finally {
      setState(() {
        isLoading = false; // تعيين التحميل إلى false بعد محاولة تحميل المفضلات
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Favorites'),
        backgroundColor: const Color(0xFFf96163),
      ),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : errorMessage.isNotEmpty
          ? Center(child: Text(errorMessage)) // عرض رسالة الخطأ إذا كانت موجودة
          : favoriteMeals.isNotEmpty
          ? GridView.builder(
        padding: const EdgeInsets.all(10.0),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: 5.0,
          mainAxisSpacing: 5.0,
        ),
        itemCount: favoriteMeals.length,
        itemBuilder: (context, index) {
          final meal = favoriteMeals[index];
          return GestureDetector(
            onTap: () {
              // الانتقال إلى صفحة تفاصيل الوصفة
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => MealDetailScreen(idMeal: meal['idMeal']!),
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
                ],
              ),
            ),
          );
        },
      )
          : const Center(
        child: Text(
          'No favorite recipes yet!',
          style: TextStyle(fontSize: 18),
        ),
      ),
    );
  }
}

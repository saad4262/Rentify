import 'package:flutter/material.dart';

class Category {
  final String name;
  final String imagePath;

  Category(this.name, this.imagePath);
}

class CategoryProvider with ChangeNotifier {
  List<Category> _categoriesList = [
    Category("Apartment", "assets/images/category1.png"),
    Category("Villa", "assets/images/category2.png"),
    Category("House", "assets/images/category3.png"),
    Category("Cottage", "assets/images/image9.png"),
    Category("WareHouse", "assets/images/image13.png"),
    Category("Resorts", "assets/images/image16.png"),

    // Add more categories here
  ];

  List<bool> selectedImages = List.filled(10, false); // Adjust size according to your categories

  List<Category> get categoriesList => _categoriesList;

  void toggleSelection(int index) {
    selectedImages[index] = !selectedImages[index];
    notifyListeners();
  }

  List<String> getSelectedCategories() {
    return selectedImages
        .asMap()
        .entries
        .where((entry) => entry.value)
        .map((entry) => _categoriesList[entry.key].name)
        .toList();
  }
}

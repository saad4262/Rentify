import 'package:flutter/material.dart';


import 'dart:io';
import 'package:flutter/foundation.dart';
import 'package:image_picker/image_picker.dart';
import 'package:firebase_storage/firebase_storage.dart';

import 'package:flutter/foundation.dart';

import 'package:flutter/foundation.dart';

class SellProvider {
  final String name;

  SellProvider(this.name);
}

class SellProviders with ChangeNotifier {
  String? _currentPropertyType="Residential";
  String? _propertyType = "Sell";


  // Current selected indices for different categories
  List<int> _selectedResidentialIndices = [];
  List<int> _selectedCommercialIndices = [];
  List<int> _selectedPlotCategories = [];

  List<int> _selectedSellIndices = [];
  List<int> _selectedRentIndices = [];

  final List<SellProvider> _sellCategories = [
    // SellProvider("Sell Category 1"),
    // SellProvider("Sell Category 2"),
  ];

  final List<SellProvider> _rentCategories = [
    // SellProvider("Rent Category 1"),
    // SellProvider("Rent Category 2"),
  ];


  // Categories
  final List<SellProvider> _residentialCategories = [
    SellProvider("Flat"),
    SellProvider("Room"),
    SellProvider("Farmhouse"),
    SellProvider("Upper Portion"),
    SellProvider("Pent House"),
    SellProvider("Lower Portion"),
    SellProvider("Studio Apartment"),
    SellProvider("Hotel Suites"),
    SellProvider("Guest House"),
    SellProvider("Basement"),
    SellProvider("Hostel"),
    SellProvider("Annexe"),
  ];

  final List<SellProvider> _commercialCategories = [
    SellProvider("Office"),
    SellProvider("Shop"),
    SellProvider("Warehouse"),
    SellProvider("Showroom"),
    SellProvider("Building"),
    SellProvider("Plaza"),
    SellProvider("Gym"),
    SellProvider("Land"),
    SellProvider("Food Court"),
    SellProvider("Factory"),
  ];

  final List<SellProvider> _plotCategories = [
    SellProvider("Residential Plot"),
    SellProvider("Commercial Plot"),
    SellProvider("Agriculture Land"),
    SellProvider("Industrial Land"),
    SellProvider("Farmhouse Plot"),
  ];

  List<SellProvider> get currentCategories2 {
    switch (_propertyType) {
      case 'Sell':
        return _sellCategories;
      case 'Rent':
        return _rentCategories;

      default:
        return [];
    }
  }

  List<SellProvider> get currentCategories {
    switch (_currentPropertyType) {
      case 'Residential':
        return _residentialCategories;
      case 'Commercial':
        return _commercialCategories;
      case 'Plot':
        return _plotCategories;
      default:
        return [];
    }
  }


  List<int> get selectedResidentialIndices => _selectedResidentialIndices;
  List<int> get selectedCommercialIndices => _selectedCommercialIndices;
  List<int> get selectedPlotCategories => _selectedPlotCategories;

  List<int> get selectedSellIndices => _selectedSellIndices;
  List<int> get selectedRentIndices => _selectedRentIndices;

  String? get selectedCategory => _currentPropertyType; // Getter for selected category

  String? get selectedCategory2 => _propertyType;



  void setPropertyType(String type) {
    _currentPropertyType = type;
    clearSelections(); // Clear previous selections
    notifyListeners();
  }

  void clearSelections() {
    _selectedResidentialIndices.clear();
    _selectedCommercialIndices.clear();
    _selectedPlotCategories.clear();
  }

  void toggleSelection(int index) {
    if (index >= 0 && index < currentCategories.length) {
      if (_currentPropertyType == 'Residential') {
        _selectedResidentialIndices.clear();
        _selectedResidentialIndices.add(index);
      } else if (_currentPropertyType == 'Commercial') {
        _selectedCommercialIndices.clear();
        _selectedCommercialIndices.add(index);
      } else if (_currentPropertyType == 'Plot') {
        _selectedPlotCategories.clear();
        _selectedPlotCategories.add(index);
      }
      notifyListeners();
    }
  }


  void toggleSelection2(int index) {
    if (index >= 0 && index < currentCategories2.length) {
      if (_propertyType == 'Sell') {
        selectedSellIndices.clear();
        selectedSellIndices.add(index);
      } else if (_propertyType == 'Rent') {
        selectedRentIndices.clear();
        selectedRentIndices.add(index);
      }
      notifyListeners();
    }
  }



  List<String> getSelectedResidentialCategories() {
    return _selectedResidentialIndices
        .map((index) => _residentialCategories[index].name)
        .toList();
  }

  List<String> getSelectedCommercialCategories() {
    return _selectedCommercialIndices
        .map((index) => _commercialCategories[index].name)
        .toList();
  }


  List<String> getSelectedSellCategories() {
    return _selectedSellIndices
        .map((index) => _sellCategories[index].name)
        .toList();
  }

  List<String> getSelectedRentCategories() {
    return _selectedRentIndices
        .map((index) => _rentCategories[index].name)
        .toList();
  }


  void setPropertyType2(String type) {
    _propertyType = type; // "Sell" or "Rent"
    notifyListeners();
  }

  List<String> getSelectedPlotCategories() {
    return _selectedPlotCategories
        .map((index) => _plotCategories[index].name)
        .toList();
  }

  void clearResidentialSelections() {
    _selectedResidentialIndices.clear();
    notifyListeners();
  }

  void clearCommercialSelections() {
    _selectedCommercialIndices.clear();
    notifyListeners();
  }

  void clearPlotSelections() {
    _selectedPlotCategories.clear();
    notifyListeners();
  }


}



// class ImagePickerProvider2 with ChangeNotifier {
//   XFile? _imageFile;
//   bool _isLoading = false;
//
//   XFile? get imageFile => _imageFile;
//   bool get isLoading => _isLoading;
//
//   void setLoading(bool loading) {
//     _isLoading = loading;
//     notifyListeners();
//   }
//   List<String> _imageUrls = [];
//
//   List<String> get imageUrls => _imageUrls;
//
//   void addImage(String imageUrl) {
//     _imageUrls.add(imageUrl);
//     notifyListeners();
//   }
//
//   Future<void> pickImage() async {
//     final ImagePicker picker = ImagePicker();
//     _imageFile = await picker.pickImage(source: ImageSource.gallery);
//     notifyListeners();
//   }
//
//   Future<String?> uploadImage() async {
//     if (_imageFile == null) return null; // No image to upload
//
//     final file = File(_imageFile!.path);
//     String fileName = DateTime.now().millisecondsSinceEpoch.toString();
//     Reference storageRef = FirebaseStorage.instance.ref().child('user_images/$fileName');
//
//     try {
//       await storageRef.putFile(file);
//       return await storageRef.getDownloadURL(); // Return the image URL
//     } catch (e) {
//       print("Error uploading image: $e");
//       return null; // Return null if upload fails
//     }
//   }
// }


class SellProviders2 extends ChangeNotifier {
  // Form fields data
  String _size = '';
  String _price = '';
  String _selectedCategory = 'Residential';
  String _selectedSubcategory = '';

  // Getters to retrieve data
  String get size => _size;
  String get price => _price;
  String get selectedCategory => _selectedCategory;
  String get selectedSubcategory => _selectedSubcategory;

  // Setters to update form field data
  void setSize(String size) {
    _size = size;
    notifyListeners();  // Notify listeners (like your SellScreen) to rebuild UI
  }

  void setPrice(String price) {
    _price = price;
    notifyListeners();
  }

  void setCategory(String category) {
    _selectedCategory = category;
    notifyListeners();
  }

  void setSubcategory(String subcategory) {
    _selectedSubcategory = subcategory;
    notifyListeners();
  }
}

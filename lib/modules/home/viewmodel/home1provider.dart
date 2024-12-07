
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:custom_info_window/custom_info_window.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';


class FavoriteProvider with ChangeNotifier {
  // Store the full property data, not just a boolean
  Map<String, Map<String, dynamic>> _favorites = {};

  // Getter to access the favorites map
  Map<String, Map<String, dynamic>> get favorites => _favorites;

  // Method to check if a property is favorited
  bool isFavorite(String propertyId) {
    return _favorites.containsKey(propertyId);
  }

  // Method to toggle the favorite state
  void toggleFavorite(String propertyId, Map<String, dynamic> propertyData) async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      print("No user is logged in.");
      return;
    }

    // Toggle the local favorite state
    if (_favorites.containsKey(propertyId)) {
      // Remove from favorites
      _favorites.remove(propertyId);
    } else {
      // Add to favorites
      _favorites[propertyId] = propertyData;
    }

    // Update Firestore
    try {
      if (_favorites.containsKey(propertyId)) {
        // Add to favorites in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('favoriteProperties')
            .doc(propertyId)
            .set({
          'isFavorite': true,
          'propertyData': propertyData,
        }, SetOptions(merge: true));
      } else {
        // Remove from favorites in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .collection('favoriteProperties')
            .doc(propertyId)
            .delete();
      }
    } catch (e) {
      print("Error updating favorite in Firestore: $e");
    }

    notifyListeners();
  }

  // Fetch favorite properties from Firestore
  Future<void> fetchFavoriteProperties() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user == null) {
      return;
    }

    try {
      final snapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .collection('favoriteProperties')
          .get();

      // Store the full property data in the favorites map
      for (var doc in snapshot.docs) {
        _favorites[doc.id] = doc.data()['propertyData'] as Map<String, dynamic>;
      }

      notifyListeners();
    } catch (e) {
      print("Error fetching favorite properties: $e");
    }
  }
}




class TabSelectionProvider extends ChangeNotifier {
  int _selectedIndex = 0;

  int get selectedIndex => _selectedIndex;

  void setSelectedIndex(int index) {
    if (_selectedIndex != index) {
      _selectedIndex = index;
      notifyListeners();
    }
  }
}


// class ChatProvider with ChangeNotifier {
//   List<String> _chatIds = [];
//
//   List<String> get chatIds => _chatIds;
//
//   Future<void> fetchChatIds() async {
//     User? user = FirebaseAuth.instance.currentUser;
//     if (user == null) {
//       print("No user is logged in.");
//       return;
//     }
//
//     try {
//       final snapshot = await FirebaseFirestore.instance
//           .collection('users')
//           .doc(user.uid)
//           .collection('chats') // Ensure this matches your Firestore structure
//           .get();
//
//       _chatIds = snapshot.docs.map((doc) => doc.id).toList();
//       notifyListeners();
//     } catch (e) {
//       print("Error fetching chat IDs: $e");
//     }
//   }
// }




class RatingProvider with ChangeNotifier {
  double _rating = 0.0;

  double get rating => _rating;

  set rating(double value) {
    _rating = value;
    notifyListeners();  // Notify listeners when the rating changes
  }
}


class ReviewProvider with ChangeNotifier {
  bool _showAllReviews = false;

  bool get showAllReviews => _showAllReviews;

  // Method to toggle the state
  void toggleShowAllReviews() {
    _showAllReviews = !_showAllReviews;
    notifyListeners(); // Notify listeners when the state changes
  }
}


class SearchProvider extends ChangeNotifier {
  String _searchQuery = '';

  String get searchQuery => _searchQuery;

  // Method to update the search query
  void updateSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();  // Notify listeners whenever the query changes
  }
}
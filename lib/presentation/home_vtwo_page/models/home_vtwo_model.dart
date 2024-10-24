import 'dart:convert';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../../../models/item.dart';
import '../../../services/database_helper.dart';


class HomeVtwoModel {
  RxList<Item> items = RxList<Item>(); // Observing items in UI
  final String token;

  HomeVtwoModel(this.token) {
    fetchAndSaveData(); // Trigger data fetching on initialization
  }

  Future<void> saveUserData(String fname, String lname) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('fname', fname);
    await prefs.setString('lname', lname);
  }

  // Retrieve user's full name from SharedPreferences
  Future<String> getUserFullName() async {
    final prefs = await SharedPreferences.getInstance(); // Await the future
    final fname = prefs.getString('fname') ?? '';
    final lname = prefs.getString('lname') ?? '';
    return '$fname $lname'; // Combine first and last name
  }

  // New getter for user data
 // New getter for user data
Future<Map<String, String>> get userData async {
  final prefs = await SharedPreferences.getInstance();
  String fname = prefs.getString('fname') ?? '';
  String lname = prefs.getString('lname') ?? '';
  return {'fname': fname, 'lname': lname};
}

  // Load user credentials with detailed logging
  Future<Map<String, String?>> loadUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    
    final shopId = prefs.getString('shop_id');
    final adminId = prefs.getString('admin_id');
    final userId = prefs.getString('user_id');

    // Logging to verify fetched credentials
    if (shopId != null && adminId != null && userId != null) {
      print('Loaded credentials: shop_id=$shopId, admin_id=$adminId, user_id=$userId');
    } else {
      if (userId == null) print('User ID not found');
      if (shopId == null) print('Shop ID not found');
      if (adminId == null) print('Admin ID not found');
      print('User credentials not found. Returning empty map.');
      return {}; // Return empty map to indicate missing credentials
    }

    return {'shop_id': shopId, 'admin_id': adminId, 'user_id': userId};
  }

  // Fetch from API, save locally, and load for UI
  Future<void> fetchAndSaveData() async {
    try {
      final connectivityResult = await Connectivity().checkConnectivity();

      if (connectivityResult == ConnectivityResult.none) {
        print('No internet. Loading from local database...');
        await loadItemsFromLocal();
      } else {
        print('Internet available. Fetching from API...');
        await fetchFromAPIAndSave();
        await loadItemsFromLocal(); // Always load from local after saving
      }
    } catch (e) {
      print('Error in fetchAndSaveData: $e');
    }
  }

  // Fetch data from API and save to local database
  Future<void> fetchFromAPIAndSave() async {
    const String apiUrl = 'https://mauzo360.com/login/get-stocks';
    const String deviceKey = 'KEY'; // Replace with the actual device key

    try {
      final credentials = await loadUserCredentials();
      if (credentials.isEmpty) return; // Stop if credentials are missing

      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({
          'header': {'Token': token, 'device_key': deviceKey},
          'shop_id': credentials['shop_id'],
          'admin_id': credentials['admin_id'],
          'user_id': credentials['user_id'],
          'filter': {},
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['statuscode'] == 1) {
          List<Item> itemsList = (data['data'] ?? [])
              .map<Item>((jsonItem) => Item.fromJson(jsonItem))
              .toList();

          print('Fetched ${itemsList.length} items from API.');

          // Clear existing items in local database for the user
          await DatabaseHelper.clearItems(credentials['user_id']!);

          // Save items to local database with duplicate check
          await saveItemsToLocal(itemsList, credentials['user_id']!);
          print('Stock data fetched and assigned successfully.');
        } else {
          print('API Error: ${data['message']}');
        }
      } else {
        print('Failed to fetch from API. Status: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching from API: $e');
    }
  }

  // Save items to local database with logging and duplicate check
  Future<void> saveItemsToLocal(List<Item> itemsList, String userId) async {
    try {
      for (var item in itemsList) {
        bool success = await DatabaseHelper.addItem(item, userId);
        print(success
            ? 'Successfully saved item: ${item.name}'
            : 'Failed to save item: ${item.name} (may be a duplicate)');
      }
      print('All items processed for saving.');
    } catch (e) {
      print('Error saving items to local database: $e');
    }
  }

  // Load items from local database with logging
  Future<void> loadItemsFromLocal() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      String? userId = prefs.getString('user_id');

      if (userId == null) {
        print('User ID not found');
        return;
      }

      final localItems = await DatabaseHelper.getAllItems(userId);

      // Use a Set to track unique item names
      Set<String> uniqueItemNames = Set<String>();
      List<Item> filteredItems = [];

      for (var item in localItems) {
        // Check if the item name is already in the set
        if (!uniqueItemNames.contains(item.name)) {
          // Add the item name to the set and the item to the filtered list
          uniqueItemNames.add(item.name);
          filteredItems.add(item);
        } else {
          print('Duplicate item found: ${item.name}. Skipping.');
        }
      }

      // Update the items observable with the filtered list
      items.value = filteredItems;
      print('Loaded ${filteredItems.length} unique items from local database.');
    } catch (e) {
      print('Error loading from local database: $e');
    }
  }
}

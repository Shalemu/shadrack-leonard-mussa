import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mauzoApp/core/utils/size_utils.dart';
import 'package:mauzoApp/services/database_helper.dart';
import 'package:mauzoApp/widgets/custom_button.dart';
import 'package:mauzoApp/widgets/custom_text_form_field.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // For network check
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class CustomerController extends GetxController {
  final dbHelper = DatabaseHelper();
  var customers = <dynamic>[].obs; // Observable list for reactive UI
  var isLoading = false.obs; // Loading state
  var errorMessage = ''.obs; // Error message state
  final formKey = GlobalKey<FormState>();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController phoneController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    loadInitialCustomers(); // Start the process of loading customers
  }

  Future<Map<String, String>> loadUserCredentials() async {
    // Simulate loading user credentials from storage
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      String? shopId = prefs.getString('shop_id');
      String? adminId = prefs.getString('admin_id');
      String? userId = prefs.getString('user_id');

      if (shopId != null && adminId != null && userId != null) {
        return {
          'shop_id': shopId,
          'admin_id': adminId,
          'user_id': userId,
        };
      } else {
        throw Exception('Missing credentials');
      }
    } catch (e) {
      print('Error loading credentials: ${e.toString()}');
      rethrow;
    }
  }

  Future<void> loadInitialCustomers() async {
    // Fetch from local database first to display existing data immediately
    await fetchCustomersFromLocal();

    // Then check for internet connectivity to fetch the latest data from API
    checkConnectivityAndFetchData();
  }

  Future<void> checkConnectivityAndFetchData() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      print('No internet connection. Displaying local data.');
      Get.snackbar('Offline Mode', 'Displaying local data.');
    } else {
      print('Internet connection available. Fetching data from API...');
      await fetchCustomers(); // Fetch from API
    }
  }

  Future<void> fetchCustomersFromLocal() async {
    isLoading.value = true;
    try {
      final localCustomers = await dbHelper.getAccountsByType(true);

      customers.value = localCustomers
          .where((customer) =>
              customer['sync_status'] == 0 || customer['sync_status'] == 1)
          .toList();

      print("Fetched ${customers.length} customers from local database.");

      if (customers.isEmpty) {
        print('No customers found in local database.');
        Get.snackbar('No Customers', 'No customers found in local database.');
      }
    } catch (e) {
      errorMessage.value = 'Error fetching data from local: ${e.toString()}';
      print(errorMessage.value);
    } finally {
      isLoading.value = false; // Stop loading
    }
  }

  Future<void> fetchCustomers() async {
    final url = 'https://mauzo360.com/login/get-customers';
    final token = await _getToken();

    // Load user credentials
    final credentials = await loadUserCredentials();
    String shopId = credentials['shop_id']!;
    String adminId = credentials['admin_id']!;
    String userId = credentials['user_id']!;

    final headers = {
      'Content-Type': 'application/json',
      'Token': token,
    };

    final body = jsonEncode({
      'header': {'Token': token},
      'shop_id': shopId,
      'admin_id': adminId,
      'user_id': userId,
      'filter': {},
    });

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: headers,
        body: body,
      );

      print("Response Status Code: ${response.statusCode}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);

        if (data['statuscode'] == 1) {
          List<dynamic> apiCustomers = data['data'];
          print("Fetched ${apiCustomers.length} customers from API.");

          if (apiCustomers.isNotEmpty) {
            int savedCount = await saveCustomersToLocal(apiCustomers);
            customers.addAll(apiCustomers); // Update observable list
            print("Customers saved and added to the observable list.");

            Get.snackbar(
                'Success',
                'Fetched ${apiCustomers.length} customers from API and saved '
                    '$savedCount to local database.');
          } else {
            print('No customers found in API response.');
          }
        } else {
          print('Error occurred: ${data['message']}');
          await fetchCustomersFromLocal(); // Fallback to local data
        }
      } else {
        print(
            'Failed to load data: ${response.reasonPhrase} (Status Code: ${response.statusCode})');
        await fetchCustomersFromLocal(); // Fallback to local data
      }
    } catch (e) {
      print('Error fetching data: ${e.toString()}');
      await fetchCustomersFromLocal(); // Fallback to local data
    }
  }

  Future<int> saveCustomersToLocal(List<dynamic> apiCustomers) async {
    final credentials = await loadUserCredentials();
    String shopId = credentials['shop_id']!;
    String adminId = credentials['admin_id']!;
    String userId = credentials['user_id']!;

    int savedCount = 0; // Count of saved customers

    try {
      for (var customer in apiCustomers) {
        await dbHelper.insertCustomerSupplierAccount({
          'id': customer['id'],
          'name': customer['name'],
          'phone': customer['phone'],
          'shop_id': customer[shopId],
          'user_id': customer[userId],
          'is_customer': 1,
          'email': customer['email'],
          'profile_image': customer['profile_image'],
          'admin_id': customer[adminId],
          'sync_status': 1, // Set sync_status for API suppliers
        });
        savedCount++;
        print("Saved customer: ${customer['name']} to local database.");
      }

      print("Total customers saved to local database: $savedCount");
    } catch (e) {
      print('Error saving customers to local: ${e.toString()}');
    }

    return savedCount; // Return the count of saved customers
  }

  void showAddCustomerForm(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Add Customer', style: TextStyle(fontSize: 12)),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: size.width * 0.9,
                    margin: const EdgeInsets.symmetric(horizontal: 0),
                    child: CustomTextFormField(
                      focusNode: FocusNode(),
                      controller: nameController,
                      hintText: "Full name",
                      prefix: Icon(Icons.person),
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter name";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 24),
                  Container(
                    width: size.width * 0.9,
                    margin: const EdgeInsets.symmetric(horizontal: 0),
                    child: CustomTextFormField(
                      focusNode: FocusNode(),
                      controller: phoneController,
                      hintText: "Phone number",
                      prefix: Icon(Icons.phone),
                      keyboardType: TextInputType.number,
                      validator: (value) {
                        if (value == null || value.isEmpty) {
                          return "Please enter phone";
                        }
                        return null;
                      },
                    ),
                  ),
                  SizedBox(height: 34),
                  CustomButton(
                    text: "Save",
                    width: size.width,
                    margin: EdgeInsets.symmetric(horizontal: 24),
                    shape: ButtonShape.RoundedBorder16,
                    fontStyle: ButtonFontStyle.NotoSansJPMedium14,
                    onTap: () {
                      if (formKey.currentState!.validate()) {
                        addCustomer().then((_) {
                          Navigator.of(context).pop(); // Close dialog
                        });
                      }
                    },
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }

  Future<void> addCustomer() async {
    final newCustomer = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': nameController.text,
      'phone': phoneController.text,
      'is_customer': 1,
      'sync_status': 0,
    };

    await dbHelper.insertCustomerSupplierAccount(newCustomer);
    customers.add(newCustomer); // Update the list
    nameController.clear(); // Clear input fields
    phoneController.clear();
    print("Added new customer: ${newCustomer['name']}");
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token') ?? '';
  }
}

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:mauzoApp/core/utils/size_utils.dart';
import 'package:mauzoApp/services/database_helper.dart';
import 'package:mauzoApp/widgets/custom_button.dart';
import 'package:mauzoApp/widgets/custom_text_form_field.dart';
import 'package:connectivity_plus/connectivity_plus.dart'; // For network check
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class SupplierPage extends StatefulWidget {
  @override
  _SupplierPageState createState() => _SupplierPageState();
}

class _SupplierPageState extends State<SupplierPage> {
  List<dynamic> suppliers = [];
  bool isLoading = false;
  String errorMessage = '';
  final dbHelper = DatabaseHelper();
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();

  @override
  void initState() {
    super.initState();
    loadInitialSuppliers(); // Load suppliers on initialization
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

  Future<void> loadInitialSuppliers() async {
    setState(() => isLoading = false); // Start loading
    await fetchSuppliersFromLocal(); // Fetch from local first
    await checkConnectivityAndFetchData(); // Check connectivity and fetch data
    setState(() => isLoading = false); // End loading
  }

  Future<void> checkConnectivityAndFetchData() async {
    var connectivityResult = await Connectivity().checkConnectivity();
    if (connectivityResult == ConnectivityResult.none) {
      print('Internet connection available. Fetching data from API...');
      await fetchSuppliers(); // Fetch from API
    } else {
      print('No internet connection. Displaying local data...');
    }
  }

  Future<void> fetchSuppliersFromLocal() async {
    try {
      final localSuppliers = await dbHelper.getAccountsByType(false);
      print("Fetched ${localSuppliers.length} suppliers from local database.");
      setState(() {
        suppliers = localSuppliers
            .where((supplier) =>
                supplier['sync_status'] == 0 || supplier['sync_status'] == 1)
            .toList();
      });

      print("Fetched ${suppliers.length} suppliers from local database.");
      print("Suppliers: $suppliers"); // Print the fetched suppliers
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching data from local: $e';
      });
      print(errorMessage);
    }
  }

  Future<void> fetchSuppliers() async {
    final url =
        'https://mauzo360.com/login/get-suppliers'; // Adjust the URL accordingly
    final token = await _getToken();

    // Dynamically fetch IDs
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
      final response =
          await http.post(Uri.parse(url), headers: headers, body: body);

      print("Response Headers: ${response.headers}");
      print("Response Body: ${response.body}");

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        if (data['statuscode'] == 1) {
          List<dynamic> apiSuppliers = data['data'];
          print("Fetched ${apiSuppliers.length} suppliers from API.");

          if (apiSuppliers.isNotEmpty) {
            await saveSuppliersToLocal(apiSuppliers); // Save to local database
            setState(() {
              suppliers.clear(); // Clear current list
              suppliers.addAll(apiSuppliers); // Add new suppliers from API
            });
          } else {
            setState(() {
              errorMessage = 'No suppliers found in API response.';
            });
          }
        } else {
          setState(() {
            errorMessage = data['message'] ?? 'Error occurred';
          });
        }
      } else {
        setState(() {
          errorMessage = 'Failed to load data: ${response.reasonPhrase}';
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Error fetching data: ${e.toString()}';
      });
    }
  }

  Future<void> saveSuppliersToLocal(List<dynamic> apiSuppliers) async {
    final credentials = await loadUserCredentials();
    String shopId = credentials['shop_id']!;
    String adminId = credentials['admin_id']!;
    String userId = credentials['user_id']!;
    for (var supplier in apiSuppliers) {
      await dbHelper.insertCustomerSupplierAccount({
        'id': supplier['id'],
        'name': supplier['name'],
        'phone': supplier['phone'],
        'user_id': supplier[userId],
        'shop_id': supplier[shopId],
        'is_customer': 0, // Assuming 0 indicates a supplier
        'email': supplier['email'],
        'profile_image': supplier['profile_image'],
        'admin_id': supplier[adminId], // Change this according to your logic
        'sync_status': 1, // Set sync_status for API suppliers
      });
      print("Saved supplier: ${supplier['name']} to local database.");
    }
  }

  void _showAddSupplierForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Add Supplier',
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Container(
                    width: size.width * 0.9, // 90% of screen width
                    margin: const EdgeInsets.symmetric(horizontal: 0),
                    child: CustomTextFormField(
                      controller: _nameController,
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
                    width: size.width * 0.9, // 90% of screen width
                    margin: const EdgeInsets.symmetric(horizontal: 0),
                    child: CustomTextFormField(
                      controller: _phoneController,
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
                      if (_formKey.currentState!.validate()) {
                        addSupplier().then((_) {
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

  Future<void> addSupplier() async {
    final newSupplier = {
      'id': DateTime.now().millisecondsSinceEpoch.toString(),
      'name': _nameController.text,
      'phone': _phoneController.text,
      'is_customer': 0, // Assuming 0 indicates a supplier
      'sync_status': 0,
    };

    await dbHelper.insertCustomerSupplierAccount(newSupplier);
    setState(() {
      suppliers.add(newSupplier); // Update the list
    });
    _nameController.clear(); // Clear input fields
    _phoneController.clear();
    print("Added new supplier: ${newSupplier['name']}");
  }

  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token') ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Suppliers"),
        actions: [
          // Optional: Add a refresh button to reload suppliers
          IconButton(
            icon: Icon(Icons.refresh),
            onPressed: () {
              loadInitialSuppliers(); // Reload suppliers when button is pressed
            },
          ),
        ],
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : suppliers.isEmpty
              ? Center(child: Text("No suppliers available"))
              : ListView.builder(
                  itemCount: suppliers.length,
                  itemBuilder: (context, index) {
                    final supplier = suppliers[index]; // Get the supplier data
                    return ListTile(
                      title: Text(supplier['name'] ?? 'Unknown Supplier'),
                      subtitle: Text(supplier['phone'] ?? 'No Phone'),
                    );
                  },
                ),
      floatingActionButton: FloatingActionButton(
        onPressed: _showAddSupplierForm,
        backgroundColor: Colors.orange[400],
        child: const Icon(Icons.add),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(6),
        ),
        mini: true,
      ),
    );
  }
}

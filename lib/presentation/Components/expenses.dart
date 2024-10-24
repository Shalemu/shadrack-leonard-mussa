import 'dart:convert';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mauzoApp/core/app_export.dart';
import 'package:mauzoApp/models/expenses.dart';
import 'package:mauzoApp/services/database_helper.dart';
import 'package:mauzoApp/widgets/app_bar/appbar_image.dart';
import 'package:mauzoApp/widgets/app_bar/appbar_subtitle.dart';
import 'package:mauzoApp/widgets/app_bar/custom_app_bar.dart';
import 'package:mauzoApp/widgets/custom_button.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:intl/intl.dart';

class ExpensesPage extends StatefulWidget {
  const ExpensesPage({Key? key}) : super(key: key);

  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  List<Expense> _expensesItems = [];
  bool _isLoading = false;
  String _errorMessage = '';
  String? _selectedFileName;
  DateTime _selectedDate = DateTime.now(); // Default to today's date

  // Function to show the date picker and handle date selection
  Future<void> _selectDate(BuildContext context) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate: _selectedDate, // Current date selected
      firstDate: DateTime(2000), // Start date of picker
      lastDate: DateTime(2101), // End date of picker
    );

    if (pickedDate != null && pickedDate != _selectedDate) {
      setState(() {
        _selectedDate = pickedDate; // Update selected date
      });
    }
  } // Class variable to hold the selected file name

  // Form controllers for adding a new expense
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  // DateTime? _selectedDate;

  @override
  void initState() {
    super.initState();
    checkConnectivityAndFetchData();
  }

  // Check connectivity and fetch data accordingly
  Future<void> checkConnectivityAndFetchData() async {
    var connectivityResult = await Connectivity().checkConnectivity();

    if (connectivityResult == ConnectivityResult.none) {
      // No internet connection, fetch from local database
      print('No internet connection. Fetching data from local database...');
      await fetchLocalExpensesData();
    } else {
      // Has internet connection, fetch from API
      print('Internet connection available. Fetching data from API...');
      await fetchExpensesData(); // Fetch from API
    }
  }

  // Retrieve user token from shared preferences
  Future<String> _getToken() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('user_token') ?? ''; // Retrieve the token
  }

  // Load user credentials from shared preferences
  Future<Map<String, String?>> loadUserCredentials() async {
    final prefs = await SharedPreferences.getInstance();
    final shopId = prefs.getString('shop_id');
    final adminId = prefs.getString('admin_id');
    final userId = prefs.getString('user_id');

    // Log the loaded credentials
    if (shopId != null && adminId != null && userId != null) {
      print(
          'Loaded credentials: shop_id=$shopId, admin_id=$adminId, user_id=$userId');
    } else {
      if (userId == null) print('User ID not found');
      if (shopId == null) print('Shop ID not found');
      if (adminId == null) print('Admin ID not found');
    }

    return {'shop_id': shopId, 'admin_id': adminId, 'user_id': userId};
  }

  // Fetch expenses data from API
  Future<void> fetchExpensesData() async {
    const String apiUrl = 'https://mauzo360.com/login/get-expenses';
    final token = await _getToken();
    final String deviceKey = 'KEY'; // Replace with your actual device key

    setState(() {
      _isLoading = false; // Set loading to true while fetching
    });

    final credentials = await loadUserCredentials();
    String shopId = credentials['shop_id']!;
    String adminId = credentials['admin_id']!;
    String userId = credentials['user_id']!;

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
        body: jsonEncode({
          'header': {
            'Token': token,
            'device_key': deviceKey,
          },
          'shop_id': shopId,
          'admin_id': adminId,
          'user_id': userId,
          'filter': {},
        }),
      );

      final data = json.decode(response.body) as Map<String, dynamic>;

      if (data['statuscode'] == 1) {
        final expensesData = data['data'];
        if (expensesData == null || !(expensesData is List)) {
          throw Exception('Expenses data is missing or not in expected format');
        }

        // Clear previous expenses in the local database before saving new ones
        await DatabaseHelper.clearExpenses();
        List<Expense> expenses = [];
        for (var item in expensesData) {
          try {
            final expense = Expense.fromMap(item);
            await DatabaseHelper.insertExpense(expense); // Save to local DB
            expenses.add(expense);
          } catch (e) {
            print('Error parsing expense item: $e');
          }
        }

        // Update UI with the new data
        setState(() {
          _expensesItems = expenses; // Update with fetched expenses
          _isLoading = false;
        });
      } else {
        setState(() {
          _errorMessage = data['message'] ?? 'Error fetching expenses data';
          _isLoading = false;
        });
      }
    } catch (error) {
      setState(() {
        _errorMessage = 'Error fetching data: $error';
        _isLoading = false;
      });
    }
  }

  // Fetch local expenses data from local database
  Future<void> fetchLocalExpensesData() async {
    try {
      final localExpenses = await DatabaseHelper.getExpenses();
      // Set local expenses with syncStatus of 0
      _expensesItems = localExpenses
          .map((expense) => expense.copyWith(syncStatus: 0))
          .toList();
      setState(() {
        _isLoading = false; // Reset loading state
      });
    } catch (error) {
      setState(() {
        _errorMessage = 'Error fetching local data: $error';
        _isLoading = false;
      });
    }
  }

  Future<void> _saveExpense() async {
    if (_formKey.currentState!.validate()) {
      final expense = Expense(
        id: 0, // Will be auto-incremented in the local database
        name: _nameController.text,
        date: _selectedDate,
        amount: int.tryParse(_amountController.text) ?? 0,
        description: _descriptionController.text,
        shop: 1, // Assuming shop ID as 1 for now
        expenseCategory: 1, // Assuming a default category
        adminId: 1, // Assuming an admin ID as 1
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        syncStatus: 0, // Set sync status to 0 for new expenses
      );

      // Insert the new expense into the database
      await DatabaseHelper.insertExpense(expense);

      // Immediately add the new expense to the local list to update the UI
      setState(() {
        _expensesItems.add(expense);
      });

      // Clear the text fields
      _nameController.clear();
      _amountController.clear();
      _descriptionController.clear();

      // Close the popup
      Navigator.pop(context);
    }
  }

  void _showAddExpenseForm() {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            'Add Expense',
            style: TextStyle(fontSize: 12),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          content: SingleChildScrollView(
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  // Title Row
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Title:',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  TextFormField(
                    controller: _nameController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter a name';
                      }
                      return null;
                    },
                  ),
                  const Divider(),

                  // Amount Row
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Amount:',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  TextFormField(
                    controller: _amountController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                    ),
                    keyboardType: TextInputType.number,
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please enter an amount';
                      }
                      if (int.tryParse(value) == null) {
                        return 'Please enter a valid number';
                      }
                      return null;
                    },
                  ),
                  const Divider(),

                  // Details Row
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Details:',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  TextFormField(
                    controller: _descriptionController,
                    decoration: InputDecoration(
                      isDense: true,
                      contentPadding: const EdgeInsets.all(10),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),
                        borderSide: const BorderSide(color: Colors.black),
                      ),
                    ),
                    maxLines: 3,
                  ),
                  const Divider(),

                  // Attachment Row
                  const Padding(
                    padding: EdgeInsets.symmetric(vertical: 8.0),
                    child: Text(
                      'Attachment:',
                      style: TextStyle(fontSize: 12),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        _selectedFileName ?? 'No file chosen',
                        style: TextStyle(color: Colors.grey),
                      ),
                      IconButton(
                        icon: const Icon(Icons.attach_file),
                        onPressed: () async {
                          // Implement logic to select the file
                          final result = await FilePicker.platform.pickFiles(
                            allowMultiple: false,
                            type: FileType.custom,
                            allowedExtensions: ['jpg', 'jpeg', 'png', 'pdf'],
                          );

                          if (result != null && result.files.isNotEmpty) {
                            // Handle the selected file
                            setState(() {
                              _selectedFileName = result.files.first.name;
                            });
                          }
                        },
                      ),
                    ],
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
                        _saveExpense();
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

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: ColorConstant.gray100,
        body: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            // Custom AppBar
            Align(
              alignment: Alignment.centerLeft,
              child: Container(
                width: double.infinity,
                decoration: AppDecoration.fillWhiteA700.copyWith(
                  borderRadius: BorderRadiusStyle.customBorderBL30,
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    CustomAppBar(
                      height: getVerticalSize(56.00),
                      leadingWidth: 56,
                      leading: AppbarImage(
                        height: getSize(32.00),
                        width: getSize(32.00),
                        svgPath: ImageConstant.imgArrowleft,
                        margin: EdgeInsets.only(left: 24),
                        onTap: _onTapArrowleft,
                      ),
                      centerTitle: true,
                      title: AppbarSubtitle(text: "lbl_expenses_report".tr),
                      actions: [
                        AppbarImage(
                          height: getSize(24.00),
                          width: getSize(24.00),
                          svgPath: ImageConstant.imgOverflowmenu,
                          margin:
                              getMargin(left: 24, top: 4, right: 24, bottom: 4),
                        ),
                      ],
                    ),
                    Padding(
                      padding: getPadding(left: 24, top: 28, right: 24),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          // Date Section
                          Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              Padding(
                                padding: getPadding(left: 8, top: 3),
                                child: Row(
                                  children: [
                                    const Icon(Icons.calendar_today,
                                        size: 16), // Calendar icon
                                    const SizedBox(
                                        width:
                                            8), // Spacing between icon and text
                                    Text(
                                      DateFormat('dd MMM yyyy').format(
                                          DateTime.now()), // Current date
                                      overflow: TextOverflow.ellipsis,
                                      textAlign: TextAlign.start,
                                      style:
                                          AppStyle.txtNotoSansJPMedium14Gray902,
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                          // Total Expenses Section
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text(
                                "Total Expenses (TZS):",
                                style: TextStyle(fontWeight: FontWeight.bold),
                              ),
                              const SizedBox(height: 6),
                              Text(
                                'TZS ${calculateTotalExpenses()}', // Total expenses calculation
                                style: const TextStyle(fontSize: 16),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            // Expenses List
            _isLoading
                ? const Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                    ? Center(child: Text(_errorMessage))
                    : Expanded(
                        child: ListView.builder(
                          itemCount: _expensesItems.length,
                          itemBuilder: (context, index) {
                            final expense = _expensesItems[index];
                            return ListTile(
                              title: Text(expense.name),
                              subtitle: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text('Amount: ${expense.amount}'),
                                  Text(
                                      'Date: ${expense.date?.toLocal().toString().split(' ')[0]}'),
                                ],
                              ),
                            );
                          },
                        ),
                      ),
          ],
        ),
        // Floating Action Button
        floatingActionButton: FloatingActionButton(
          onPressed: _showAddExpenseForm,
          backgroundColor: Colors.orange[400],
          child: const Icon(Icons.add),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(6),
          ),
          mini: true,
        ),
      ),
    );
  }

  // Calculates total expenses
  int calculateTotalExpenses() {
    return _expensesItems.fold(0, (sum, expense) => sum + expense.amount);
  }

  // Handles back button press
  void _onTapArrowleft() {
    Navigator.of(context).pop();
  }

  // Placeholder for showing add expense form
}

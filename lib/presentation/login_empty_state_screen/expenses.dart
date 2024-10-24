import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mauzoApp/models/expenses.dart';
import 'package:mauzoApp/services/database_helper.dart'; // Ensure this is correctly imported

class ExpensesPage extends StatefulWidget {
  final String token;

  const ExpensesPage({Key? key, required this.token}) : super(key: key);

  @override
  _ExpensesPageState createState() => _ExpensesPageState();
}

class _ExpensesPageState extends State<ExpensesPage> {
  List<Expense> _expensesItems = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchLocalExpensesData(); // Fetch from local database first
    fetchExpensesData(); // Fetch from API
  }

  Future<void> fetchExpensesData() async {
    const String apiUrl = 'https://mauzo360.com/login/get-expenses';
    final String token = widget.token;
    final String deviceKey = 'KEY'; // Replace with your actual device key

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: {
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'header': {
            'Token': token,
            'device_key': deviceKey,
          },
          'shop_id': '1',
          'admin_id': '1',
          'user_id': '141',
          'filter': {},
        }),
      );

      print('Response status: ${response.statusCode}');
      print('Response body: ${response.body}');

      final data = json.decode(response.body);

      if (data == null) {
        throw Exception('No data received');
      }

      if (data['statuscode'] == null) {
        throw Exception('Invalid response format');
      }

      if (data['statuscode'] == 101) {
        setState(() {
          _errorMessage = 'Session expired';
          _isLoading = false;
        });
        print('Session expired');
      } else if (data['statuscode'] == 1) {
        final expensesData = data['data'];
        if (expensesData == null || !(expensesData is List)) {
          throw Exception('Expenses data is missing or not in expected format');
        }

        // Save the fetched data to local database
        await DatabaseHelper.clearExpenses();
        List<Expense> expenses = [];
        for (var item in expensesData) {
          try {
            final expense = Expense.fromMap(item);
            await DatabaseHelper.insertExpense(expense);
            expenses.add(expense);
          } catch (e) {
            print('Error parsing expense item: $e');
          }
        }

        setState(() {
          _expensesItems = expenses;
          _isLoading = false;
        });
        print('Data fetched and saved successfully');
      } else {
        setState(() {
          _errorMessage = data['message'] ?? 'Error fetching expenses data';
          _isLoading = false;
        });
        print('Server error message: ${data['message']}');
      }
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        _errorMessage = 'Error fetching data: $error';
        _isLoading = false;
      });
    }
  }

  Future<void> fetchLocalExpensesData() async {
    try {
      final localExpenses = await DatabaseHelper.getExpenses();
      setState(() {
        _expensesItems = localExpenses;
        _isLoading = false;
      });
      print('Local data fetched successfully');
    } catch (error) {
      print('Error fetching local data: $error');
      setState(() {
        _errorMessage = 'Error fetching local data: $error';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Expenses'),
      ),
      body: _isLoading
          ? Center(child: CircularProgressIndicator())
          : _errorMessage.isNotEmpty
              ? Center(child: Text(_errorMessage))
              : ListView.builder(
                  itemCount: _expensesItems.length,
                  itemBuilder: (context, index) {
                    final item = _expensesItems[index];
                    return ListTile(
                      title: Text(item.name),
                      subtitle: Text(
                        'Amount: ${item.amount}\n'
                        'Date: ${item.date?.toLocal().toString() ?? 'No Date'}\n' // Handle null date
                        'Description: ${item.description ?? 'No Description'}',
                      ),
                    );
                  },
                ),
    );
  }
}

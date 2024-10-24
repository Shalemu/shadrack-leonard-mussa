import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:mauzoApp/models/item.dart';
import 'package:mauzoApp/presentation/login_empty_state_screen/LoginPage.dart';
import 'dart:convert';
// import 'package:mauzoApp/services/database_helper.dart'; // Import the DatabaseHelper class

class HomePage extends StatefulWidget {
  final String username;
  final String token;

  const HomePage({Key? key, required this.username, required this.token, required deviceKey}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Item> _stockItems = [];
  bool _isLoading = true;
  String _errorMessage = '';

  @override
  void initState() {
    super.initState();
    fetchStockData();
  }

  Future<void> fetchStockData() async {
    const String apiUrl = 'https://mauzo360.com/login/get-stocks';
    final String token = widget.token;
    final String deviceKey = 'KEY';

    print('Fetching stock data from API...');
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

      print('Response data: $data');

      if (data == null || data['statuscode'] == null) {
        print('Invalid response format');
        throw Exception('Invalid response format');
      }

      if (data['statuscode'] == 101) {
        // Handle token expiration or unauthorized status
        print('Token expired or unauthorized. Navigating to TestPage.');
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => LoginPage(),
          ),
        );
      } else if (data['statuscode'] == 1) {
        final stockData = data['data'];
        if (stockData == null || !(stockData is List)) {
          print('Stock data is missing or not in expected format');
          throw Exception('Stock data is missing or not in expected format');
        }

        // Convert the stock data to List<Item> and save to local database
        List<Item> items = [];
        for (var jsonItem in stockData) {
          try {
            items.add(Item.fromJson(jsonItem));
          } catch (e) {
            print('Error converting item: $e');
          }
        }

        print('Saving ${items.length} items to local database...');
        for (var item in items) {
          print('Item saved: ${item.name}');
        }

        setState(() {
          _stockItems = items;
          _isLoading = false;
        });
        print('Stock data successfully fetched and saved.');
      } else {
        print('Error fetching stock data: ${data['message']}');
        setState(() {
          _errorMessage = data['message'] ?? 'Error fetching stock data';
          _isLoading = false;
        });
      }
    } catch (error) {
      print('Error fetching data: $error');
      setState(() {
        _errorMessage = 'Error fetching data: $error';
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Welcome, ${widget.username}'),
      ),
      body: Column(
        children: [
          // Search Bar
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 24, vertical: 16),
            child: TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: 'Search',
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              onChanged: (query) {
                // Implement search functionality here
              },
            ),
          ),
          // Main Content
          Expanded(
            child: _isLoading
                ? Center(child: CircularProgressIndicator())
                : _errorMessage.isNotEmpty
                    ? Center(child: Text(_errorMessage))
                    : ListView.separated(
                        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 10),
                        separatorBuilder: (context, index) => SizedBox(height: 10),
                        itemCount: _stockItems.length,
                        itemBuilder: (context, index) {
                          final item = _stockItems[index];
                          return InkWell(
                            onTap: () {
                              // Handle item tap
                            },
                            child: Container(
                              height: 130,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(16),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.grey.withOpacity(0.1),
                                    spreadRadius: 0,
                                    blurRadius: 10,
                                    offset: Offset(0, 4),
                                  ),
                                ],
                              ),
                              child: Row(
                                children: [
                                  // Image Section
                                  Container(
                                    height: 96,
                                    width: 88,
                                    margin: EdgeInsets.all(12),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(12),
                                      child: item.img.isNotEmpty
                                          ? Image.network(item.img, fit: BoxFit.cover)
                                          : Icon(Icons.image_not_supported),
                                    ),
                                  ),
                                  // Info Section
                                  Expanded(
                                    child: Padding(
                                      padding: EdgeInsets.symmetric(horizontal: 12),
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            item.name,
                                            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                                            maxLines: 1,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                          SizedBox(height: 8),
                                          Text(
                                            'Sale Price: ${item.salePrice}\n'
                                            'Unit: ${item.unit}\n'
                                            'Quantity: ${item.minStock}',
                                            style: TextStyle(fontSize: 14),
                                            maxLines: 3,
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          );
                        },
                      ),
          ),
          // Button Section
          Padding(
            padding: EdgeInsets.all(24),
            // child: ElevatedButton(
            //   // onPressed: () {
            //   //   Navigator.push(
            //   //     context,
            //   //     MaterialPageRoute(
            //   //       // builder: (context) => ExpensesPage(),
            //   //     ),
            //   //   );
            //   // },
            //   child: Text('View Expenses'),
            // ),
          ),
        ],
      ),
    );
  }
}

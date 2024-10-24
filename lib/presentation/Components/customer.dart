import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mauzoApp/presentation/Components/customer_controller.dart';

class CustomerPage extends StatelessWidget {
  final CustomerController customerController = Get.put(CustomerController());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Customers'),
      ),
      body: Obx(() {
        // Show loading indicator if data is being fetched
        if (customerController.isLoading.value) {
          return Center(child: CircularProgressIndicator());
        }
        // Show error message if there is one
        else if (customerController.errorMessage.isNotEmpty) {
          return Center(child: Text(customerController.errorMessage.value));
        }
        // Show a message if there are no customers
        else if (customerController.customers.isEmpty) {
          return Center(child: Text('No customers found.'));
        }
        // Display the list of customers
        else {
          return ListView.builder(
            itemCount: customerController.customers.length,
            itemBuilder: (context, index) {
              final customer = customerController.customers[index];
              return ListTile(
                title: Text(customer['name'] ?? 'No Name'),
                subtitle: Text(customer['phone'] ?? 'No Phone'),
              );
            },
          );
        }
      }),
      floatingActionButton: FloatingActionButton(
        onPressed: () => customerController.showAddCustomerForm(context),
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

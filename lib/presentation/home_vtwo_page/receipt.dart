
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:mauzoApp/core/utils/size_utils.dart';
import 'package:mauzoApp/presentation/home_vtwo_page/ReceiptController.dart';
import 'package:mauzoApp/widgets/app_bar/custom_app_bar.dart';

class ReceiptView extends StatelessWidget {
  final ReceiptController receiptController = Get.put(ReceiptController());
  final String receipt; // The receipt content
  final String customer; // Customer name
  final String paymentMethod; // Payment method
  final String billAmount; // Bill amount
  final String paidAmount; // Paid amount

  ReceiptView({
    Key? key,
    required this.receipt,
    required this.customer,
    required this.paymentMethod,
    required this.billAmount,
    required this.paidAmount,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        backgroundColor: Colors.white,
        appBar: CustomAppBar(
          backgroundColor: const Color.fromARGB(255, 248, 248, 213),
          height: getVerticalSize(56.00),
          leadingWidth: 48,
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Get.back(),
          ),
          centerTitle: true,
          title: const Text(
            'Receipt',
            style: TextStyle(color: Colors.black, fontSize: 20),
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                'Customer: $customer',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                'Payment Type: $paymentMethod',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                'Bill Amount: $billAmount',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 10),
              Text(
                'Paid Amount: $paidAmount',
                style: const TextStyle(fontSize: 18),
              ),
              const SizedBox(height: 20),
              Text(
                receipt, // Display the receipt content directly
                style: const TextStyle(fontSize: 16),
                textAlign: TextAlign.left,
              ),
              const SizedBox(height: 20),
            ],
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              TextButton(
                onPressed: () {
                  Get.back(); // Go back to the previous page
                },
                child: const Text(
                  'Cancel',
                  style: TextStyle(color: Colors.black),
                ),
              ),
              // TextButton(
              //   // onPressed: () {
              //   //   printReceipt(receipt); // Call the print function
              //   // },
              //   child: const Text(
              //     'Print',
              //     style: TextStyle(color: Colors.black),
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

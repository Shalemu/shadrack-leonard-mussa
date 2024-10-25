import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mauzoApp/core/utils/size_utils.dart';
import 'package:mauzoApp/presentation/home_vtwo_page/controller/home_vtwo_controller.dart';
import 'package:mauzoApp/services/database_helper.dart';
import 'package:mauzoApp/widgets/app_bar/custom_app_bar.dart';
import 'package:qr_flutter/qr_flutter.dart';

class ReceiptPage extends StatelessWidget {
  final HomeVtwoController controller = Get.find<HomeVtwoController>();

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
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Get.back(),
          ),
          centerTitle: true,
          title: Text(
            'Receipt',
            style: TextStyle(
              color: Colors.black,
              fontSize: 20,
            ),
          ),

          // centerTitle: true,
          // title: AppbarSubtitle(text: "lbl_payment_method".tr),
        ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: FutureBuilder<String>(
            future:
                generateReceipt(), // Call the function to generate the receipt
            builder: (context, snapshot) {
              if (snapshot.connectionState == ConnectionState.waiting) {
                return Center(child: CircularProgressIndicator());
              } else if (snapshot.hasError) {
                return Center(child: Text('Error: ${snapshot.error}'));
              } else if (snapshot.hasData) {
                return _buildReceiptWidget(snapshot.data!);
              } else {
                return Center(child: Text('No receipt data available.'));
              }
            },
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Colors.transparent, // Fixed capitalization and syntax
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context); // Close the ReceiptPage
                },
                child: Text(
                  'Cancel',
                  style: GoogleFonts.poppins(
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[900],
                  ),
                ),
              ),
              Text(
                'Print',
                style: GoogleFonts.poppins(
                  fontSize: 16,
                  fontWeight: FontWeight.w500,
                  color: Colors.grey[900],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<String> generateReceipt() async {
    String customerName = controller.selectedCustomer.value;
    String paymentType = controller.selectedPaymentMethod.value;
    String orderDate = DateTime.now().toString(); // Example date

    // Calculate values before generating the receipt content
    double totalBill =
        controller.billAmount.value; // Correctly accessing the value
// Assuming discount is tracked in controller
// Calculate the actual price

    // Generate the receipt content based on payment type
    String receipt = ''; // Initialize receipt string
    switch (paymentType) {
      case 'Credit':
        receipt = '''
Order Date: $orderDate
Customer: $customerName
Payment Type: Credit
Paid Amount: ${controller.paidAmount.value}
Pending Amount: ${controller.pendingAmount.value}
''';
        break;
      case 'Mobile':
        String mobileMethod = controller.selectedMobile.value;
        receipt = '''
Order Date: $orderDate
Customer: $customerName
Payment Type: Mobile ($mobileMethod)
Bill Amount: $totalBill
Paid Amount: ${controller.paidAmount.value}
''';
        break;
      case 'Bank':
        String bankName = controller.selectedBank.value;
        receipt = '''
Order Date: $orderDate
Customer: $customerName
Payment Type: Bank ($bankName)
Bill Amount: $totalBill
Paid Amount: ${controller.paidAmount.value}
''';
        break;
      case 'Cash':
        receipt = '''
Order Date: $orderDate
Customer: $customerName
Payment Type: Cash
Bill Amount: $totalBill
Paid Amount: ${controller.paidAmount.value}
''';
        break;
    }

    // Clear the cart after generating the receipt
    await DatabaseHelper.clearCart();

    return receipt; // Return the generated receipt
  }

  Widget dottedDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        30,
        (index) => Container(
          width: 8, // Adjust the width of each dot
          height: 1, // Height of the dot
          color: Colors.black, // Color of the dot
          margin: EdgeInsets.symmetric(horizontal: 1), // Spacing between dots
        ),
      ),
    );
  }

  Widget _buildReceiptWidget(String receiptDetails) {
    // This method is now used to display the receipt in the body
    String shortId =
        '#TS-${DateTime.now().millisecondsSinceEpoch}'; // Re-generate the short ID for the display
// Access totalBill directly
// Access discount directly
    // Calculate actual price

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(controller.selectedCustomer.value,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
              )),
          SizedBox(height: 5),
          Text(shortId, style: TextStyle(fontSize: 16)),
          SizedBox(height: 10),
          dottedDivider(),
          SizedBox(height: 10),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              for (String line in receiptDetails.split('\n'))
                if (line.trim().isNotEmpty)
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(line.split(':')[0]), // Label on the left
                      Text(line.split(':')[1].trim()), // Value on the right
                    ],
                  ),
            ],
          ),
          SizedBox(height: 10),
          dottedDivider(),
          SizedBox(height: 10),
          Container(
            height: 50,
            color: Colors.grey[200],
            child: const Center(
                child: Text('mauzo360')), // Placeholder text for logo
          ),
          SizedBox(height: 10),
          dottedDivider(),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 12, bottom: 12),
                child: Text(
                  "Subtotal:",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[900],
                  ),
                ),
              ),
              Padding(
                padding: getPadding(top: 16, right: 16, bottom: 16),
                child: Obx(() {
                  // Calculate total bill by summing price * quantity of each item
                  double totalBill = 0.0;
                  controller.cartItems.forEach((itemName, quantity) {
                    double itemPrice = controller.getItemPrice(itemName);
                    totalBill += itemPrice * quantity;
                  });
                  return Text(
                    '${totalBill.toStringAsFixed(2)}',
                    style: GoogleFonts.poppins(
                      fontSize: 12,

                      color: Colors.grey, // Bolder text for emphasis
                    ),
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: 5),
          Row(
             mainAxisAlignment: MainAxisAlignment.spaceBetween,
             crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 12, bottom: 12),
                child: Text(
                  "Discount:",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[900], // Dark text for readability
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 24, top: 12, bottom: 12),
                child: Obx(() {
                  return Text(
                    "${controller.discount.value}", // Display dynamic discount value
                    style: GoogleFonts.poppins(
                      fontSize: 12,

                      color: Colors.grey, // Slightly bolder for emphasis
                    ),
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: 10),
          dottedDivider(),
          SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 24, top: 12, bottom: 12),
                child: Text(
                  "Bill:",
                  style: GoogleFonts.poppins(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: Colors.grey[900],
                  ),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 24, top: 12, bottom: 12),
                child: Obx(() {
                  double discount = controller.discount.value;
                  double actualPrice = controller.totalBill - discount;
                  actualPrice = actualPrice < 0 ? 0.0 : actualPrice;
                  return Text(
                    '${actualPrice.toStringAsFixed(2)}', // Display calculated bill
                    style: GoogleFonts.poppins(
                      fontSize: 12,
                      color: Colors.grey,
                    ),
                  );
                }),
              ),
            ],
          ),
          SizedBox(height: 10),
          Center(
            child: Container(
              height: 100,
              width: 100,
              child: CustomPaint(
                painter: QrPainter(
                  data: 'mauzo360.com/login/auth/login',
                  version: QrVersions.auto,
                  errorCorrectionLevel: QrErrorCorrectLevel.L,
                  color: const Color(0xFF000000),
                  gapless: true,
                ),
              ),
            ),
          ),
          SizedBox(height: 10),
          Container(
            margin: EdgeInsets.symmetric(
                horizontal: 15.0), // Adjust horizontal margin as needed
            alignment:
                Alignment.center, // Center the content within the container
            child: const Text(
              'Scan to visit mauzo360.com',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 16, // Adjust font size as needed
                color: Colors.black, // Adjust color as needed
              ),
            ),
          ),
          SizedBox(height: 60),
        ],
      ),
    );
  }

  void printReceipt(String receiptDetails) {}
}

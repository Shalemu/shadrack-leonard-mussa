// controllers/receipt_controller.dart
import 'package:get/get.dart';
import 'package:mauzoApp/models/item.dart';
import 'package:mauzoApp/presentation/home_vtwo_page/receipt.dart';
import 'package:mauzoApp/services/database_helper.dart';
import 'dart:ui' as ui;
import 'package:qr_flutter/qr_flutter.dart';
import 'package:flutter/material.dart';

class ReceiptController extends GetxController {
  // Variables to hold customer, payment type, cart data, etc.
   RxMap<String, int> minStock = RxMap(); // Available stock
 // Items in the cart
  RxMap<String, String> itemImages = RxMap(); // Item images
  RxMap<String, double> itemPrices = RxMap();
 
  var selectedCustomer = ''.obs;
  var selectedPaymentMethod = ''.obs;
  var selectedMobile = ''.obs;
  var selectedBank = ''.obs;
  var discount = 0.0.obs;

  var cartItems = <String, int>{}.obs; // Cart: item name and quantity
  var billAmount = 0.0.obs;
  var paidAmount = 0.0.obs;
  var pendingAmount = 0.0.obs;
  var items = <Item>[].obs;
  // Item prices
   double get totalBill =>
      getTotalPrice(); // Total bill calculated from the cart
  double get actualPrice =>
      (totalBill - discount.value).clamp(0.0, double.infinity);

  var showDropdown = false.obs;
  var selectedMobileOption = ''.obs; // Define the items list

  Future<String> generateReceipt() async {
    String receipt = '';
    String customerName = selectedCustomer.value;
    String paymentType = selectedPaymentMethod.value;
    String orderDate = DateTime.now().toString();
    String shortId = '#TS-${DateTime.now().millisecondsSinceEpoch}';

    // Insert items into the local database
    for (var entry in cartItems.entries) {
      String itemName = entry.key;

      if (items.isNotEmpty) {
        items.firstWhere((item) => item.name == itemName);
      } else {
        print('The items list is empty.');
      }
    }

    // Generate receipt content based on payment type
    switch (paymentType) {
      case 'Credit':
        receipt = '''
Order Date: $orderDate
Customer: $customerName
Payment Type: Credit
Paid Amount: $paidAmount
Pending Amount: $pendingAmount
''';
        break;
      case 'Mobile':
        String mobileMethod = selectedMobile.value;
        receipt = '''
Order Date: $orderDate
Customer: $customerName
Payment Type: Mobile ($mobileMethod)
Bill Amount: $billAmount
Paid Amount: $paidAmount
''';
        break;
      case 'Bank':
        String bankName = selectedBank.value;
        receipt = '''
Order Date: $orderDate
Customer: $customerName
Payment Type: Bank ($bankName)
Bill Amount: $billAmount
Paid Amount: $paidAmount
''';
        break;
      case 'Cash':
        receipt = '''
Order Date: $orderDate
Customer: $customerName
Payment Type: Cash
Bill Amount: $billAmount
Paid Amount: $paidAmount
''';
        break;
    }

    await DatabaseHelper.clearCart(); // Clear cart

    return receipt;
  }

  // Generate QR code image
  Future<ui.Image> generateQrCode(String data) async {
    final qrValidationResult = QrValidator.validate(
      data: data,
      version: QrVersions.auto,
      errorCorrectionLevel: QrErrorCorrectLevel.L,
    );

    if (qrValidationResult.status == QrValidationStatus.valid) {
      final painter = QrPainter.withQr(
        qr: qrValidationResult.qrCode!,
        color: const Color(0xFF000000),
        emptyColor: const Color(0xFFFFFFFF),
        gapless: true,
      );

      final picData =
          await painter.toImageData(200, format: ui.ImageByteFormat.png);
      final codec =
          await ui.instantiateImageCodec(picData!.buffer.asUint8List());
      final frame = await codec.getNextFrame();

      return frame.image;
    } else {
      throw Exception('QR code generation failed');
    }
  }
    double getTotalPrice() {
    double totalPrice = 0.0;
    cartItems.forEach((name, quantity) {
      totalPrice += (itemPrices[name] ?? 0.0) * quantity;
    });
    return totalPrice;
  }

  void _showReceiptDialog(
      String receiptDetails, String shortId, String logoBase64) async {
    // Generate receipt data needed for the ReceiptView
    String customer = selectedCustomer.value;
    String paymentMethod =
        "Cash"; // Example: you can get this from your controller
    String billAmount = totalBill.toStringAsFixed(2); // Convert to string
    String paidAmount = actualPrice.toStringAsFixed(2); // Convert to string

    // Close any existing dialogs (if applicable)
    Get.back();

    // Navigate to ReceiptView with the necessary data
    Get.to(() => ReceiptView(
          receipt: receiptDetails,
          customer: customer,
          paymentMethod: paymentMethod,
          billAmount: billAmount,
          paidAmount: paidAmount,
        ));
  }
}

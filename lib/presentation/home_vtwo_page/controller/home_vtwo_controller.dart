import 'package:flutter/material.dart';
import 'package:mauzoApp/models/cart_model.dart';
import 'package:mauzoApp/services/database_helper.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:get/get.dart';
import 'package:mauzoApp/models/item.dart';
import 'package:mauzoApp/presentation/home_vtwo_page/cart.dart';
import 'package:mauzoApp/presentation/home_vtwo_page/models/home_vtwo_model.dart';

class HomeVtwoController extends GetxController {
  final String token;
  late final HomeVtwoModel _homeVtwoModel;
  RxMap<String, int> quantities = RxMap();
  RxList<Item> items = RxList<Item>(); // List of all items
  RxList<Item> _filteredItems = RxList<Item>();
  List<Item> get filteredItems => _filteredItems;
  // Initial value can be set
  var selectedCustomer = ''.obs;
  RxBool isAdding =
      false.obs; // Track if the button is in the process of adding

  // Cart items (name: quantity)

  // Discount and total bill as observables
  var discount = 0.0.obs;

  // Computed properties
  double get totalBill =>
      getTotalPrice(); // Total bill calculated from the cart
  double get actualPrice =>
      (totalBill - discount.value).clamp(0.0, double.infinity);

  var homeVtwoModelObj = Rx<HomeVtwoModel>(HomeVtwoModel(''));
  var selectedCategory = 0.obs;

  RxMap<String, int> minStock = RxMap(); // Available stock
  RxMap<String, int> cartItems = RxMap(); // Items in the cart
  RxMap<String, String> itemImages = RxMap(); // Item images
  RxMap<String, double> itemPrices = RxMap();
  List<Cart> cartItemsList = []; // Store fetched cart items

  // Load cart items from the database
  Future<void> loadCartItems() async {
    // Fetch all cart items from the database
    List<Cart> loadedCartItems = await DatabaseHelper.getAllCart();

    cartItems.clear(); // Clear existing items

    if (loadedCartItems.isNotEmpty) {
      for (var item in loadedCartItems) {
        cartItems[item.itemName] = item.quantity; // Rebuild cart
        itemImages[item.itemName] = item.img; // Store images
        itemPrices[item.itemName] = item.salePrice; // Store prices
        minStock[item.itemName] = item.quantity; // Store min stock if needed
      }
      print('Cart items retrieved successfully: ${loadedCartItems.length}');
    } else {
      print('No items found in cart.');
    }
    update(); // Notify UI of changes
  }

  // Fetch cart items directly (example method)

  int get uniqueItemsCount {
    return cartItems.length; // This will give you the count of unique items
  }

  // RxString selectedPaymentMethod = ''.obs;
  var selectedPaymentMethod = ''.obs; // Item prices
  var selectedBank = "".obs;
  var selectedMobile = "".obs;
  var showDropdown = false.obs;
  var paidAmount = 0.0.obs;
  var billAmount = 0.0.obs; // Set this to the actual bill amount
  var pendingAmount = 0.0.obs;
  var selectedMobileOption = ''.obs;

  // var bankOptions = ['CRDB', 'NMB', 'NBC'].obs;
  // var mobileOptions = ['M-PESA', 'AIRTEL MONEY', 'TIGOPESA', 'HALO PESA'].obs;
  var banks = ['CRDB', 'NMB', 'NBC'].obs;
  var mobileOptions = ['M-PESA', 'HALO PESA', 'TIGOPESA', 'AIRTEL MONEY'].obs;
  var paymentTypes = <String, List<String>>{
    'Bank': ['CRDB', 'NMB', 'NBC'],
    'Mobile': ['M-PESA', 'HALO PESA', 'TIGOPESA', 'AIRTEL MONEY'],
    'Cash': [],
    'Credit': [],
  }.obs;
  Widget dottedDivider() {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(
        30,
        (index) => Container(
          width: 5, // Adjust the width of each dot
          height: 1, // Height of the dot
          color: Colors.black, // Color of the dot
          margin: EdgeInsets.symmetric(horizontal: 1), // Spacing between dots
        ),
      ),
    );
  }

  void updatePrice(String itemName, double newPrice) {
    int index = items.indexWhere((item) => item.name == itemName);
    if (index != -1) {
      items[index].salePrice = newPrice; // Directly modify the salePrice
      items.refresh(); // Notify listeners about the change
    }
  }

  void updatePendingAmount() {
    double paid = paidAmount.value;

    // Use actualPrice for the pending amount calculation
    double bill = actualPrice; // Get actual price using your computed property

    // Print bill and paid amounts for debugging
    print("Actual Price (Bill Amount): $bill");
    print("Paid Amount: $paid");

    // Calculate pending amount
    pendingAmount.value = (bill - paid)
        .clamp(0.0, double.infinity); // Clamp to prevent negative values
    print("Updated Pending Amount: ${pendingAmount.value}"); // For debugging
  }

  void updatePaymentMethod(String method) {
    selectedPaymentMethod.value = method;
    selectedBank.value = ''; // Reset bank selection
    selectedMobile.value = ''; // Reset mobile selection
  }

  TextEditingController searchController = TextEditingController();
  void updateSelectedCustomer(String name) {
    selectedCustomer.value = name;
  }

  final DatabaseHelper dbHelper = DatabaseHelper();

  void generateReceipt() async {
    // Ensure these variables are defined and initialized elsewhere in your code
    String customerName = selectedCustomer.value;
    String paymentType = selectedPaymentMethod.value;
    String orderDate = DateTime.now().toString(); // Example date
    String shortId = '#TS-${DateTime.now().millisecondsSinceEpoch}';

    // Generate the receipt content based on payment type
    String receipt = ''; // Initialize receipt string
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

    // Display the receipt dialog with QR code
    _showReceiptDialog(receipt, shortId, "");

    // Clear the cart after generating the receipt
    await DatabaseHelper.clearCart();
  }

// Display the receipt in a dialog with QR code
  void _showReceiptDialog(
      String receiptDetails, String shortId, String logoBase64) {
    Get.dialog(
      AlertDialog(
        title: Center(
          child: Text('Receipt', style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(selectedCustomer.value,
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
                child: Center(
                    child: Text('mauzo360')), // Placeholder text for logo
              ),
              SizedBox(height: 10),
              dottedDivider(),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Subtotal:'),
                  Text(
                      '${totalBill.toStringAsFixed(2)}'), // Display subtotal value
                ],
              ),
              SizedBox(height: 5),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Discount:'),
                  Text(
                      '${(discount.value).toString()}'), // Display discount value
                ],
              ),
              SizedBox(height: 10),
              dottedDivider(),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Total:'),
                  Text(
                      '${actualPrice.toStringAsFixed(2)}'), // Display total value
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
              Text('Scan to visit mauzo360.com', textAlign: TextAlign.center),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () {
              printReceipt(receiptDetails); // Implement print functionality
            },
            child: Text('Print', style: TextStyle(color: Colors.black)),
          ),
          TextButton(
            onPressed: () {
              Get.back(); // Close the dialog
            },
            child: Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }

// Implement your print functionality here
  void printReceipt(String receiptDetails) {
    // Print functionality implementation goes here
  }

  @override
  void onInit() {
    super.onInit();
    // Initially, show all items
    _filteredItems.assignAll(items);
  }

  HomeVtwoController(this.token) {
    _homeVtwoModel = HomeVtwoModel(token);
    fetchStockData();
  }

  Future<void> fetchStockData() async {
    try {
      // await _homeVtwoModel.fetchStockData();
      homeVtwoModelObj.value = _homeVtwoModel;

      for (var item in _homeVtwoModel.items) {
        String itemName = item.name; // Use empty string if name is null
        int itemMinStock;

        // Handle minStock and ensure it's an int
        if (item.minStock is String) {
          itemMinStock = int.tryParse(item.minStock as String) ?? 0;
        } else {
          itemMinStock = item.minStock;
        }

        // Check if name is valid before adding to maps
        if (itemName.isNotEmpty) {
          minStock[itemName] = itemMinStock;
        } else {
          print('Warning: name is null or empty for an item');
        }
      }

      print('Stock data successfully fetched and updated.');
    } catch (e) {
      print('Error in fetchStockData: $e');
    }
  }

  void addToCart(
      String name, String itemImage, double originalPrice, int minStock) async {
    print("Inside addToCart: $name | MinStock: $minStock");
    int totalAdded = cartItems[name] ?? 0; // Quantity already in cart
    int newQuantity = quantities[name] ?? 0; // Quantity user wants to add

    print("Adding to cart: $name | MinStock: $minStock");

    if (totalAdded + newQuantity > minStock) {
      Get.snackbar(
        "Stock Limit Exceeded",
        "Only $minStock units of $name are available. You already added $totalAdded.",
        snackPosition: SnackPosition.BOTTOM,
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return; // Stop if exceeding stock
    }

    // Add to cart if quantity is valid
    if (newQuantity > 0) {
      // Update cartItems with the new quantity
      cartItems.update(name, (value) => value + newQuantity,
          ifAbsent: () => newQuantity);
      itemImages[name] = itemImage;
      itemPrices[name] = originalPrice; // Ensure to keep the original price
      quantities[name] = 0; // Reset quantity input after adding
      this.minStock[name] = minStock; // Store minStock value

      // Create a new Cart object with the original price
      final cartItem = Cart(
        transactionId: 1, // Use a transactionId or generate dynamically
        itemId: itemPrices.keys.toList().indexOf(name) +
            1, // Item ID (or map to DB ID)
        itemName: name,
        salePrice: originalPrice, // Use the original price here
        quantity: newQuantity,
        total: originalPrice *
            newQuantity, // Calculate total based on original price
        discountValue: 0.0, // Adjust if discounts are applied
        price: originalPrice, // Store original price
        img: itemImage,
        createdAt: DateTime.now().toString(),
      );

      // Save to local database
      int result = await DatabaseHelper.addCart(cart: cartItem);

      if (result > 0) {
        print("Added to local database: $name | Quantity: $newQuantity");
      } else {
        print("Failed to add $name to local database.");
      }

      update(); // Notify UI of changes
    }
  }

// Increment quantity of an item
  void incrementQuantity(String name, int minStock) {
    if (quantities.containsKey(name)) {
      quantities[name] = quantities[name]! + 1;
      print('Increased quantity of $name to ${quantities[name]}');
    } else {
      quantities[name] = 1;
      print('Added $name to quantities with a quantity of 1');
    }
    update(); // Notify the UI
  }

// Decrement quantity of an item
  void decrementQuantity(
    String name,
  ) {
    if (quantities.containsKey(name) && quantities[name]! > 0) {
      quantities[name] = quantities[name]! - 1;
      print('Decreased quantity of $name to ${quantities[name]}');
    } else {
      print('Cannot decrease quantity of $name below 0');
    }
    update(); // Notify the UI
  }

  // Get item image
  String getItemImage(String name) {
    return itemImages[name] ?? '';
  }

  void currentQuantity(String itemName, int quantity) {
    quantities[itemName] = quantity;
    update(); // To notify listeners of the change
  }

  // Get quantity of an item
  int getQuantity(String name) {
    return quantities[name] ?? 0;
  }

  // Get total number of items in the cart
  int getTotalCartItems() {
    int totalItems = 0;
    cartItems.forEach((key, value) {
      totalItems += value;
    });
    return totalItems;
  }

  // Get price of an item
  double getItemPrice(String name) {
    return itemPrices[name] ?? 0.0;
  }

  // Calculate total price of items in the cart
  double getTotalPrice() {
    double totalPrice = 0.0;
    cartItems.forEach((name, quantity) {
      totalPrice += (itemPrices[name] ?? 0.0) * quantity;
    });
    return totalPrice;
  }

  // Navigate to the CartPage
  void goToCartPage() {
    Get.to(() => CartPage());
  }

  // Increment the quantity of an item in the cart
// Increment the quantity of an item in the cart
  void incrementCartItem(String name) {
    if (cartItems.containsKey(name)) {
      int currentQuantity = cartItems[name] ?? 0;
      int stockLimit = minStock[name] ?? 0; // Retrieve saved minStock

      print(
          "Incrementing $name | Current Quantity: $currentQuantity | MinStock: $stockLimit");

      if (currentQuantity + 1 <= stockLimit) {
        cartItems[name] = currentQuantity + 1;
        update(); // Notify UI
      } else {
        Get.snackbar(
          "Stock Limit Exceeded",
          "Only $stockLimit units of $name are available.",
          snackPosition: SnackPosition.BOTTOM,
          backgroundColor: Colors.redAccent,
          colorText: Colors.white,
        );
      }
    }
  }

  void decrementCartItem(String name) {
    if (cartItems.containsKey(name) && cartItems[name]! > 0) {
      cartItems[name] = cartItems[name]! - 1;

      // Remove the item if the quantity reaches zero
      if (cartItems[name] == 0) {
        cartItems.remove(name);
      }

      update(); // Notify UI of changes
    }
  }

  // Remove an item from the cart
  void removeCartItem(String name) {
    cartItems.remove(name);
    itemImages.remove(name);
    itemPrices.remove(name);
  }

  void clearCart() async {
    // Clear items from the local database
    try {
      await DatabaseHelper
          .clearCart(); // Clear the cart items from the database
      print('Cart items cleared from the local database successfully.');
    } catch (e) {
      print('Error clearing cart items from local database: $e');
    }

    // Clear all items in memory
    cartItems.clear();
    itemImages.clear();
    itemPrices.clear();
    update(); // Notify UI of changes
    print('Cart items cleared from memory successfully.');
  }

  // void printReceipt(String receiptDetails) {}

  void updateQuantity(String itemN, int quantity) {
    if (quantity < 0) {
      quantity = 0; // Prevent negative quantities
    }
    // Update the quantity
    update(); // Call update to refresh the UI
  }

  // Method to get the current quantity of an item
}

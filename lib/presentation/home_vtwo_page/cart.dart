import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:animate_do/animate_do.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mauzoApp/core/utils/size_utils.dart';
import 'package:mauzoApp/presentation/Components/customer_controller.dart';
import 'package:mauzoApp/presentation/home_vtwo_page/controller/home_vtwo_controller.dart';
import 'package:mauzoApp/presentation/home_vtwo_page/payment.dart';
import 'package:mauzoApp/services/database_helper.dart';
import 'package:mauzoApp/theme/app_decoration.dart';
import 'package:mauzoApp/theme/app_style.dart';
import 'package:mauzoApp/widgets/app_bar/custom_app_bar.dart';
import 'package:mauzoApp/widgets/custom_button.dart';

// import 'package:shared_preferences/shared_preferences.dart';

class CartPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final HomeVtwoController controller = Get.find();
    final CustomerController customerController = Get.find();
    final String selectedCustomer = controller.selectedCustomer.value;
    // String selectedCustomer = "Walk In";
    // Retrieve the controller

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
              'Cart',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
              ),
            ),
            actions: [
              // Show the cancel icon only if the cart is not empty
              Obx(() {
                return controller.cartItems.isNotEmpty
                    ? Padding(
                        padding: const EdgeInsets.only(right: 16),
                        child: CircleAvatar(
                          radius: 18,
                          backgroundColor: Colors.transparent, // Outer color
                          child: IconButton(
                            padding: EdgeInsets
                                .zero, // Removes extra padding around the icon
                            icon: Icon(Icons.cancel,
                                size: 20, color: Colors.red), // Cancel icon
                            onPressed: () {
                              // Clear the cart items
                              controller
                                  .clearCart(); // Now clears both memory and local database
                            },
                          ),
                        ),
                      )
                    : Container(); // Empty container when the cart is empty
              }),
            ],
            // centerTitle: true,
            // title: AppbarSubtitle(text: "lbl_payment_method".tr),
          ),
          body: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Display total bill section
              InkWell(
                highlightColor: Colors.transparent,
                child: AbsorbPointer(
                  child: Container(
                    margin: getMargin(left: 0, top: 14, right: 0),
                    decoration: AppDecoration.fillGray100.copyWith(
                        // borderRadius: BorderRadiusStyle.roundedBorder16,
                        ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Padding(
                          padding: getPadding(left: 16, top: 19, bottom: 15),
                          child: Text(
                            "Total Bill:",
                            style: GoogleFonts.poppins(
                              fontSize: 16,
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
                              double itemPrice =
                                  controller.getItemPrice(itemName);
                              totalBill += itemPrice * quantity;
                            });
                            return Text(
                              '${totalBill.toStringAsFixed(2)}',
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                                color: Colors.black, // Bolder text for emphasis
                              ),
                            );
                          }),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              Expanded(
                child: Obx(
                  () {
                    // If cart is empty, display empty cart icon
                    if (controller.cartItems.isEmpty) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.shopping_cart_outlined,
                              size: 100,
                              color: Colors.grey,
                            ),
                            SizedBox(height: 20),
                            Text(
                              'Your cart is empty',
                              style:
                                  TextStyle(fontSize: 12, color: Colors.grey),
                            ),
                          ],
                        ),
                      );
                    }

                    // If cart is not empty, display the cart items
                    return ListView.builder(
                      padding: EdgeInsets.all(16),
                      itemCount: controller.cartItems.length,
                      itemBuilder: (context, index) {
                        final itemName =
                            controller.cartItems.keys.elementAt(index);
                        final quantity = controller.cartItems[itemName]!;
                        final itemPrice = controller.getItemPrice(itemName);

                        return FadeInLeft(
                          child: Container(
                            margin: EdgeInsets.only(bottom: 16),
                            padding: EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.1),
                                  spreadRadius: 1,
                                  blurRadius: 5,
                                  offset: Offset(0, 2),
                                ),
                              ],
                            ),
                            child: Row(
                              children: [
                                // Product Image
                                Container(
                                  height: 60,
                                  width: 60,
                                  decoration: BoxDecoration(
                                    color: Colors.grey[300],
                                    borderRadius: BorderRadius.circular(8),
                                  ),
                                  // Always display the icon
                                  child: Center(
                                    child: Icon(
                                      Icons.image,
                                      color: Colors.red[600],
                                      size: 20,
                                    ),
                                  ),
                                ),
                                SizedBox(width: 12),
                                // Product Name, Price, and Quantity in One Column
                                Expanded(
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    children: [
                                      // Item Name
                                      Text(
                                        itemName,
                                        style: TextStyle(
                                          fontSize: 14,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      // Item Price
                                      Text(
                                        'Price: ${itemPrice.toStringAsFixed(2)}',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                      SizedBox(height: 4),
                                      // Quantity
                                      Text(
                                        'Quantity: $quantity',
                                        style: TextStyle(
                                          fontSize: 12,
                                          color: Colors.grey[700],
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(width: 12),
                                // Increase/Decrease Buttons and Quantity
                                Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    // Decrease/Remove Button
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundColor: Colors.orange[200],
                                      child: IconButton(
                                        icon: quantity > 1
                                            ? Icon(Icons.remove,
                                                size: 14, color: Colors.black54)
                                            : Icon(Icons.delete,
                                                size: 14, color: Colors.red),
                                        onPressed: () {
                                          if (quantity > 1) {
                                            controller
                                                .decrementCartItem(itemName);
                                          } else {
                                            controller.removeCartItem(itemName);
                                          }
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Container(
                                      padding: EdgeInsets.symmetric(
                                          horizontal: 8, vertical: 4),
                                      decoration: BoxDecoration(
                                        color: Colors.grey[200],
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Center(
                                        child: Text(
                                          '$quantity',
                                          style: TextStyle(
                                            fontSize: 14,
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    CircleAvatar(
                                      radius: 14,
                                      backgroundColor: Colors.orange[200],
                                      child: IconButton(
                                        icon: Icon(Icons.add,
                                            size: 14, color: Colors.black54),
                                        onPressed: () {
                                          controller
                                              .incrementCartItem(itemName);
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  },
                ),
              ),
              Obx(() {
                return controller.cartItems.isNotEmpty
                    ? Column(
                        children: [
                          // Customer Info Container
                          InkWell(
                            highlightColor: Colors.transparent,
                            child: AbsorbPointer(
                              absorbing: false,
                              child: Container(
                                margin: getMargin(left: 24, top: 14, right: 24),
                                decoration: AppDecoration.fillGray100.copyWith(
                                  borderRadius:
                                      BorderRadiusStyle.roundedBorder16,
                                ),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Padding(
                                      padding: getPadding(
                                          left: 16, top: 19, bottom: 15),
                                      child: Row(
                                        children: [
                                          Text(
                                            "Customer: ",
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w500,
                                              color: Colors.grey[900],
                                            ),
                                          ),
                                          SizedBox(width: 20),
                                          InkWell(
                                            onTap: () async {
                                              print('Walk In tapped');
                                              String? customerName =
                                                  await fetchCustomersFromLocal(
                                                      context);
                                              if (customerName != null) {
                                                controller.selectedCustomer
                                                        .value =
                                                    customerName; // Update selected customer
                                              }
                                            },
                                            child: Text(
                                              controller.selectedCustomer.value
                                                      .isEmpty
                                                  ? "Walk In" // Default text
                                                  : controller.selectedCustomer
                                                      .value, // Display selected customer
                                              style: GoogleFonts.poppins(
                                                fontSize: 16,
                                                fontWeight: FontWeight.w600,
                                                color: Colors
                                                    .black, // Bolder text for emphasis
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    Padding(
                                      padding: getPadding(
                                          top: 16, right: 16, bottom: 16),
                                      child: IconButton(
                                        icon: Icon(
                                          Icons.add,
                                          color: Colors.orange[200],
                                        ),
                                        onPressed: () {
                                          customerController
                                              .showAddCustomerForm(context);
                                        }, // Your action here
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                          // Cart Summary Container
                          Container(
                            width: double.infinity, // Expand to full width
                            margin: getMargin(left: 24, top: 13, right: 24),
                            decoration: AppDecoration.fillGray100.copyWith(
                              borderRadius: BorderRadiusStyle.roundedBorder16,
                            ),
                            child: Padding(
                              padding: getPadding(
                                  left: 18, top: 15, right: 18, bottom: 15),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  // Total Unique Items in Cart
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Items:",
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[900],
                                        ),
                                      ),
                                      Expanded(
                                        child: Obx(() {
                                          int totalItemNames =
                                              controller.cartItems.length;
                                          return Text(
                                            "$totalItemNames",
                                            textAlign: TextAlign.right,
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors
                                                  .black, // Bolder text for emphasis
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),

                                  // Total Quantity of Items in Cart
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Quantity:",
                                        // style:
                                        //     AppStyle.txtNotoSansJPMedium14Gray902,
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[900],
                                        ),
                                      ),
                                      Expanded(
                                        child: Obx(() {
                                          int totalQuantity = 0;
                                          controller.cartItems
                                              .forEach((itemName, quantity) {
                                            totalQuantity += quantity;
                                          });
                                          return Text(
                                            "$totalQuantity",
                                            textAlign: TextAlign.right,
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors
                                                  .black, // Bolder text for emphasis
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),
                                  Divider(
                                    color: Colors.grey
                                        .withOpacity(0.5), // 50% opacity
                                    thickness: 1, // Thickness remains the same
                                    height: 5, // Reduced height
                                  ),
                                  SizedBox(height: 20),
                                  // Discount Input Field
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Discount:",
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[900],
                                        ),
                                      ),
                                      SizedBox(
                                        width:
                                            20, // Space between the label and input
                                      ),
                                      ConstrainedBox(
                                        constraints: BoxConstraints(
                                          maxWidth:
                                              100, // Set a maximum width for the input field
                                        ),
                                        child: TextFormField(
                                          textAlign: TextAlign
                                              .right, // Align input and hint text to the right
                                          decoration: InputDecoration(
                                            isDense: true,
                                            hintText: "0.00",
                                            contentPadding:
                                                const EdgeInsets.all(10),
                                            border: OutlineInputBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                              borderSide: const BorderSide(
                                                  color: Colors.black),
                                            ),
                                          ),
                                          keyboardType: TextInputType.number,
                                          onChanged: (value) {
                                            if (value.isEmpty) {
                                              controller.discount.value = 0.0;
                                            } else {
                                              double parsedValue =
                                                  double.tryParse(value) ?? 0.0;
                                              controller.discount.value =
                                                  parsedValue;
                                            }
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  SizedBox(height: 20),

                                  Divider(
                                    color: Colors.grey
                                        .withOpacity(0.5), // 50% opacity
                                    thickness: 1, // Thickness remains the same
                                    height: 5, // Reduced height
                                  ),
                                  SizedBox(height: 20),

                                  // Actual Price Calculation
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        "Actual Price:",
                                        style: GoogleFonts.poppins(
                                          fontSize: 16,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[900],
                                        ),
                                      ),
                                      Expanded(
                                        child: Obx(() {
                                          double discount =
                                              controller.discount.value;
                                          double actualPrice =
                                              controller.totalBill - discount;
                                          actualPrice = actualPrice < 0
                                              ? 0.0
                                              : actualPrice;
                                          return Text(
                                            '${actualPrice.toStringAsFixed(2)}',
                                            textAlign: TextAlign.right,
                                            style: GoogleFonts.poppins(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                              color: Colors
                                                  .black, // Bolder text for emphasis
                                            ),
                                          );
                                        }),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),

                          // Show "Next" button only when cart has items
                          Container(
                            width: double.infinity,
                            decoration: AppDecoration.fillWhiteA700,
                            child: CustomButton(
                              width: MediaQuery.of(context).size.width,
                              text: "lbl_checkout".tr,
                              margin: getMargin(
                                  left: 24, top: 10, right: 24, bottom: 20),
                              shape: ButtonShape.RoundedBorder16,
                              fontStyle: ButtonFontStyle.NotoSansJPMedium14,
                              onTap: () async {
                                final result = await Get.to(() => PaymentPage(
                                      selectedCustomer: selectedCustomer,
                                    ));

                                if (result != null && result == 'success') {
                                  print('Payment Successful');
                                } else {
                                  print('Payment Canceled or Failed');
                                }
                              },
                            ),
                          ),
                        ],
                      )
                    : Container(); // Empty container when the cart is empty
              })
            ],
          ),
        ));
  }

  Future<String?> fetchCustomersFromLocal(BuildContext context) async {
    var dbHelper = DatabaseHelper();

    try {
      // Fetch customers from the database
      final localCustomers = await dbHelper.getAccountsByType(true);

      // Log the number of customers fetched
      print('Number of customers fetched: ${localCustomers.length}');

      // Check if the customers list is empty
      if (localCustomers.isEmpty) {
        print('No customers found in the local database.');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('No customers found.')),
        );
        return null; // Exit if there are no customers to show
      }

      // Successfully fetched customers, show the modal bottom sheet with the customer list
      return await showModalBottomSheet<String>(
        context: context,
        builder: (BuildContext context) {
          return ListView.builder(
            itemCount: localCustomers.length,
            itemBuilder: (context, index) {
              var customer = localCustomers[index];
              return ListTile(
                title: Text(customer['name']),
                onTap: () {
                  Navigator.pop(
                      context, customer['name']); // Return selected customer
                },
              );
            },
          );
        },
      );
    } catch (e) {
      // Handle any exceptions that occur during the fetch operation
      print('Failed to fetch customers: $e');
      // ScaffoldMessenger.of(context).showSnackBar(
      //   SnackBar(content: Text('Failed to fetch customers: $e')),
      // );
      return null; // Return null on error
    }
  }
}

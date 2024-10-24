import 'package:flutter/material.dart'; // Import for date formatting
import 'package:mauzoApp/core/app_export.dart';
import 'package:mauzoApp/presentation/home_vtwo_page/controller/home_vtwo_controller.dart';
import 'package:mauzoApp/widgets/app_bar/appbar_image.dart';
import 'package:mauzoApp/widgets/app_bar/appbar_subtitle.dart';
import 'package:mauzoApp/widgets/app_bar/custom_app_bar.dart';
import 'package:mauzoApp/widgets/custom_button.dart';
import 'package:mauzoApp/widgets/spacing.dart';
import 'package:google_fonts/google_fonts.dart';

class PaymentPage extends StatefulWidget {
  final String selectedCustomer;

  PaymentPage({required this.selectedCustomer});

  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {
  final HomeVtwoController controller =
      Get.find(); // Initialize the controller here

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Scaffold(
        // backgroundColor: const Color.fromARGB(255, 245, 245, 243),
        appBar: CustomAppBar(
          backgroundColor: const Color.fromARGB(255, 248, 248, 213),
          height: getVerticalSize(56.00),
          leadingWidth: 48,
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Get.back(),
          ),

          // centerTitle: true,
          // title: AppbarSubtitle(text: "lbl_payment_method".tr),
        ),
        body: Column(
          children: [
            // Padding(
            //   padding: getPadding(left: 16, top: 19, bottom: 15),
            //   child: Text(
            //     "PAYMENT METHOD:", // Label for payment type
            //     style: AppStyle.txtNotoSansJPMedium14Gray902,
            //   ),
            // ),
            Expanded(
              child: SingleChildScrollView(
                padding: getPadding(top: 1),
                child: Padding(
                  padding: getPadding(top: 1),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Divider(
                      //   color: Colors.grey.withOpacity(0.5), // 50% opacity
                      //   thickness: 1, // Thickness remains the same
                      //   height: 5, // Reduced height
                      // ),
                      SizedBox(height: 4),
                      // Payment Method Selection
                      Column(
                        children: [
                          Obx(() {
                            return Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Expanded(
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Radio<String>(
                                          value: "Cash",
                                          groupValue: controller
                                              .selectedPaymentMethod.value,
                                          activeColor: Colors.orange,
                                          onChanged: (value) {
                                            controller.selectedPaymentMethod
                                                .value = value!;
                                          },
                                        ),
                                      ),
                                      Flexible(
                                          child: Text(
                                        "Cash",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[900],
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Radio<String>(
                                          value: "Bank",
                                          groupValue: controller
                                              .selectedPaymentMethod.value,
                                          activeColor: Colors.orange,
                                          onChanged: (value) {
                                            controller.selectedPaymentMethod
                                                .value = value!;
                                          },
                                        ),
                                      ),
                                      Flexible(
                                          child: Text(
                                        "Bank",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[900],
                                        ),
                                      )),
                                    ],
                                  ),
                                ),
                                Expanded(
                                  child: Row(
                                    children: [
                                      Flexible(
                                        child: Radio<String>(
                                          value: "Mobile",
                                          groupValue: controller
                                              .selectedPaymentMethod.value,
                                          activeColor: Colors.orange,
                                          onChanged: (value) {
                                            controller.selectedPaymentMethod
                                                .value = value!;
                                          },
                                        ),
                                      ),
                                      Flexible(
                                          child: Text(
                                        "Mobile",
                                        style: GoogleFonts.poppins(
                                          fontSize: 14,
                                          fontWeight: FontWeight.w500,
                                          color: Colors.grey[900],
                                        ),
                                      ))
                                    ],
                                  ),
                                ),
                                if (controller
                                    .selectedCustomer.value.isNotEmpty)
                                  Expanded(
                                    child: Row(
                                      children: [
                                        Flexible(
                                          child: Radio<String>(
                                            value: "Credit",
                                            groupValue: controller
                                                .selectedPaymentMethod.value,
                                            activeColor: Colors.orange,
                                            onChanged: (value) {
                                              controller.selectedPaymentMethod
                                                  .value = value!;
                                            },
                                          ),
                                        ),
                                        Flexible(
                                            child: Text(
                                          "Credit",
                                          style: GoogleFonts.poppins(
                                            fontSize: 14,
                                            fontWeight: FontWeight.w500,
                                            color: Colors.grey[900],
                                          ),
                                        )),
                                      ],
                                    ),
                                  ),
                              ],
                            );
                          }),
                        ],
                      ),
                      // Container to show the selected payment type
                      Container(
                        margin: getMargin(left: 24, top: 14, right: 24),
                        decoration: AppDecoration.fillGray100.copyWith(
                          borderRadius: BorderRadiusStyle.roundedBorder16,
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Padding(
                              padding:
                                  getPadding(left: 16, top: 19, bottom: 15),
                              child: Text(
                                "PAYMENT TYPE:", // Label for payment type
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w500,
                                  color: Colors.grey[900],
                                ),
                              ),
                            ),
                            // Container displaying the selected payment method
                            Padding(
                              padding:
                                  getPadding(right: 16, top: 19, bottom: 15),
                              child: GestureDetector(
                                onTap: () {
                                  _showOptions(context);
                                },
                                child: Container(
                                  width: 150, // Adjust the width as needed
                                  child: Obx(() => TextField(
                                        enabled:
                                            false, // Make the TextField read-only
                                        decoration: InputDecoration(
                                          labelText: controller
                                                  .selectedPaymentMethod
                                                  .value
                                                  .isNotEmpty
                                              ? controller
                                                  .selectedPaymentMethod.value
                                              : "Select Payment Type", // Default text if no type is selected
                                          border: OutlineInputBorder(),
                                        ),
                                      )),
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      // Show Paid Amount and Pending Amount when Credit is selected

                      SizedBox(
                        height: 10,
                      ),

                      Divider(
                        color: Colors.grey.withOpacity(0.5), // 50% opacity
                        thickness: 1, // Thickness remains the same
                        height: 5, // Reduced height
                      ),
                      Padding(
                        padding: getPadding(left: 0, top: 15, bottom: 15),
                        child: Obx(() => Center(
                                child: Container(
                              width: double.infinity,
                              decoration: BoxDecoration(
                                color: Colors.white, // Background color
                                borderRadius: BorderRadius.circular(
                                    2), // Adjust radius as needed
                                // Optional box shadow for visual appeal
                                // boxShadow: [
                                //   BoxShadow(
                                //     color: Colors.black26,
                                //     blurRadius: 2.0,
                                //     offset: Offset(0, 4),
                                //   ),
                                // ],
                              ),
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16,
                                    vertical: 15), // Adjust padding
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment
                                      .spaceBetween, // Space between left and right elements
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  children: [
                                    // Left side: Icon and "Customer" label
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.person, // User icon
                                          color: Colors.orange, // Icon color
                                          size: 24, // Icon size
                                        ),
                                        SizedBox(
                                            width:
                                                8), // Space between icon and text
                                        Text(
                                          "Customer:",
                                          style: GoogleFonts.poppins(
                                            fontSize: 16,
                                            fontWeight: FontWeight.w500,
                                            color:
                                                Colors.grey[900], // Text color
                                          ),
                                        ),
                                      ],
                                    ),
                                    // Right side: Customer value or "Walk In"
                                    Text(
                                      controller.selectedCustomer.value.isEmpty
                                          ? "Walk In" // Default value if no customer selected
                                          : controller.selectedCustomer.value,
                                      style: GoogleFonts.poppins(
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600,
                                        color: Colors
                                            .black, // Bolder text for emphasis
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ))),
                      ),

                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 24, top: 12, bottom: 12),
                            child: Text(
                              "Discount:",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors
                                    .grey[900], // Dark text for readability
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 24, top: 12, bottom: 12),
                            child: Obx(() {
                              return Text(
                                "${controller.discount.value}", // Display dynamic discount value
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors
                                      .black, // Slightly bolder for emphasis
                                ),
                              );
                            }),
                          ),
                        ],
                      ),

                      SizedBox(
                          height:
                              8), // Add spacing between rows for better layout

                      // Bill Row
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Padding(
                            padding: const EdgeInsets.only(
                                left: 24, top: 12, bottom: 12),
                            child: Text(
                              "Bill:",
                              style: GoogleFonts.poppins(
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                                color: Colors.grey[900],
                              ),
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.only(
                                right: 24, top: 12, bottom: 12),
                            child: Obx(() {
                              double discount = controller.discount.value;
                              double actualPrice =
                                  controller.totalBill - discount;
                              actualPrice = actualPrice < 0 ? 0.0 : actualPrice;
                              return Text(
                                '${actualPrice.toStringAsFixed(2)}', // Display calculated bill
                                style: GoogleFonts.poppins(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.black,
                                ),
                              );
                            }),
                          ),
                        ],
                      ),

                      SizedBox(
                        height: 10,
                      ),
                      Obx(() {
                        return controller.selectedPaymentMethod.value ==
                                "Credit"
                            ? Padding(
                                padding: EdgeInsets.symmetric(vertical: 10.0),
                                child: Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceEvenly,
                                  children: [
                                    // Paid Amount field
                                    Container(
                                      width: 150, // Adjust the width as needed
                                      child: TextField(
                                        decoration: InputDecoration(
                                          labelText: "Paid Amount",
                                          border: OutlineInputBorder(),
                                        ),
                                        keyboardType: TextInputType.number,
                                        onChanged: (value) {
                                          // Update the paid amount
                                          controller.paidAmount.value =
                                              double.tryParse(value) ?? 0;

                                          // Print the paid amount for debugging
                                          print(
                                              "Paid Amount: ${controller.paidAmount.value}");

                                          // Update pending amount based on bill
                                          controller.updatePendingAmount();

                                          // Print the pending amount for debugging
                                          print(
                                              "Pending Amount: ${controller.pendingAmount.value}");
                                        },
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    // Pending Amount field
                                    Container(
                                      width: 150, // Adjust the width as needed
                                      child: TextField(
                                        decoration: InputDecoration(
                                          labelText: "Pending Amount",
                                          border: OutlineInputBorder(),
                                        ),
                                        controller: TextEditingController(
                                          text: controller.pendingAmount.value
                                              .toStringAsFixed(2),
                                        ),
                                        readOnly: true, // Make it read-only
                                        enabled: false, // Disable editing
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            : SizedBox.shrink(); // Hide if not selected
                      }),
                    ],
                  ),
                ),
              ),
            ),
            Container(
              width: double.infinity,
              decoration: AppDecoration.fillWhiteA700,
              child: CustomButton(
                width: MediaQuery.of(context).size.width,
                text: "lbl_Pay".tr,
                margin: getMargin(left: 34, top: 10, right: 34, bottom: 20),
                shape: ButtonShape.RoundedBorder16,
                fontStyle: ButtonFontStyle.NotoSansJPMedium14,
                onTap: () {
                  _showConfirmationDialog(
                      context); // Call generateReceipt from the controller
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Reduce the radius
          ),
          title: const SizedBox.shrink(), // Remove title for a cleaner look
          content: const Text(
            'Do you want a receipt?',
            style: TextStyle(
              fontSize: 14, // Adjusted font size
              fontWeight: FontWeight.w500,
            ),
          ),
          actions: [
            TextButton(
              child: const Text(
                'No',
                style: TextStyle(color: Colors.black), // Black color text
              ),
              onPressed: () {
                // Complete sales, clear cart, and navigate to Home page
                controller.clearCart();
                Navigator.of(context).pop(); // Close the dialog
                Get.offNamed(AppRoutes.homeVtwoPage, arguments: {
                  'itemName': "",
                  'token': "",
                  'deviceKey': "",
                }); // Navigate to Home page
              },
            ),
            TextButton(
              child: const Text(
                'Yes',
                style: TextStyle(color: Colors.black), // Black color text
              ),
              onPressed: () {
                // Generate receipt and close the dialog
                controller.generateReceipt();
                Navigator.of(context).pop(); // Close the dialog
              },
            ),
          ],
        );
      },
    );
  }

  void onTapClose() {
    Get.back();
  }

  void _showOptions(BuildContext context) {
    // You can customize this to show specific options based on the selected payment method.
    if (controller.selectedPaymentMethod.value == "Bank") {
      _showBankOptions(context);
    } else if (controller.selectedPaymentMethod.value == "Mobile") {
      _showMobileOptions(context);
    }
  }

  void _showBankOptions(BuildContext context) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100.0, 200.0, 100.0, 100.0),
      items: controller.banks.map((bank) {
        return PopupMenuItem(
          value: bank,
          child: Text(bank),
        );
      }).toList(),
      elevation: 8.0,
    ).then((value) {
      if (value != null) {
        controller.selectedBank.value = value;
        // Update the selectedPaymentMethod to show the specific bank name
        controller.selectedPaymentMethod.value =
            value; // Update the payment method to the selected bank
      }
    });
  }

  void _showMobileOptions(BuildContext context) {
    showMenu(
      context: context,
      position: RelativeRect.fromLTRB(100.0, 200.0, 100.0, 100.0),
      items: controller.mobileOptions.map((mobile) {
        return PopupMenuItem(
          value: mobile,
          child: Text(mobile),
        );
      }).toList(),
      elevation: 8.0,
    ).then((value) {
      if (value != null) {
        controller.selectedMobileOption.value = value;
        // Update the selectedPaymentMethod to show the specific mobile option name
        controller.selectedPaymentMethod.value =
            value; // Update the payment method to the selected mobile option
      }
    });
  }
}

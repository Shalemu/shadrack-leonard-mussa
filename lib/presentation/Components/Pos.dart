import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:mauzoApp/presentation/home_vtwo_page/home_vtwo_page.dart';
import 'package:mauzoApp/presentation/home_vtwo_page/models/home_vtwo_model.dart';
import 'package:mauzoApp/presentation/home_vtwo_page/scnner.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:mauzoApp/core/app_export.dart';
import 'package:mauzoApp/models/item.dart';
import 'package:mauzoApp/presentation/home_vtwo_page/cart.dart';
import 'package:mauzoApp/presentation/home_vtwo_page/controller/home_vtwo_controller.dart';
import 'package:mauzoApp/presentation/login_empty_state_screen/LoginPage.dart';
import 'package:mauzoApp/presentation/my_profile_page/my_profile_page.dart';
import 'package:mauzoApp/widgets/app_bar/appbar_image.dart';
import 'package:mauzoApp/widgets/custom_bottom_bar.dart';
import 'package:mauzoApp/widgets/custom_button.dart';
import 'package:mauzoApp/widgets/custom_search_view.dart';
import 'package:animate_do/animate_do.dart'; // Ensure you import this package
import 'package:mauzoApp/widgets/app_bar/custom_app_bar.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'dart:async';

class HomeVtwoPage1 extends StatefulWidget {
  final String itemName;
  final String token;
  final String deviceKey;

  HomeVtwoPage1({
    Key? key,
    required this.itemName,
    required this.token,
    required this.deviceKey,
  }) : super(key: key);

  @override
  _HomeVtwoPageState createState() => _HomeVtwoPageState();
}

class _HomeVtwoPageState extends State<HomeVtwoPage1> {
  final TextEditingController _searchController = TextEditingController();
  final RxList<Item> _allItems = <Item>[].obs; // Store all items
  final RxList<Item> _filteredItems = <Item>[].obs; // Store filtered items
  final MobileScannerController _scannerController = MobileScannerController();
  final TextEditingController _usernameController = TextEditingController();
  String token = '';
  late final HomeVtwoController controller;
  @override
  void initState() {
    super.initState();

    // Initialize controller with the provided token
    controller = Get.put<HomeVtwoController>(HomeVtwoController(widget.token));

    // Load items from local storage
    loadItemsFromLocal();

    // Load cart items from the database
    controller.loadCartItems();
  }

  Future<HomeVtwoModel> loadItemsFromLocal() async {
    try {
      final homeVtwoModel = HomeVtwoModel(widget.token);

      // Wait for data to be fetched and saved to local database
      await homeVtwoModel.fetchAndSaveData();

      // Assign the items to the observable lists
      _allItems.assignAll(homeVtwoModel.items); // Initialize with all items
      _filteredItems
          .assignAll(homeVtwoModel.items); // Display all items initially

      print('Stock data fetched and assigned successfully.');
      return homeVtwoModel; // Return the HomeVtwoModel instance
    } catch (e) {
      print('Error fetching stock data: $e');
      rethrow; // Re-throw the error to handle it in the FutureBuilder
    }
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<HomeVtwoController>();
    Get.lazyPut<HomeVtwoController>(() => HomeVtwoController(widget.token));

    return WillPopScope(
        onWillPop: () async {
          final shouldExit = await _showExitConfirmationDialog(context);
          return shouldExit ?? false; // Exit only if confirmed
        },
        child: SafeArea(
          top: false,
          child: Scaffold(
            backgroundColor: Colors.white,
            appBar: CustomAppBar(
              height: getVerticalSize(56.00),
              leadingWidth: 56,
              leading: AppbarImage(
                height: getSize(32.00),
                width: getSize(32.00),
                svgPath: ImageConstant.imgArrowleft,
                margin: EdgeInsets.only(left: 24, top: 12, bottom: 12),
                onTap: onTapArrowleft14,
              ),
              title: Padding(
                padding: getPadding(left: 24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ),
              actions: [
                Card(
                  clipBehavior: Clip.antiAlias,
                  elevation: 0,
                  margin: getMargin(left: 24, top: 5, right: 24, bottom: 6),
                  color: ColorConstant.gray100,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadiusStyle.roundedBorder13,
                  ),
                  child: Container(
                    height: getSize(44.00),
                    width: getSize(44.00),
                    decoration: AppDecoration.fillGray100.copyWith(
                      borderRadius: BorderRadiusStyle.roundedBorder13,
                    ),
                    child: Stack(
                      alignment: Alignment.topRight,
                      children: [
                        Align(
                          alignment: Alignment.center,
                          child: Padding(
                            padding: EdgeInsets.all(10),
                            child: Container(
                              decoration: BoxDecoration(
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.orange[400]!.withOpacity(0.2),
                                    spreadRadius: 1,
                                    blurRadius: 2,
                                    offset: Offset(0, 2),
                                  ),
                                ],
                              ),
                              child: Transform.translate(
                                offset: Offset(-7, -7),
                                child: Obx(() {
                                  int totalUniqueItems =
                                      controller.uniqueItemsCount;

                                  // Wrap the entire stack with GestureDetector for quick navigation
                                  return GestureDetector(
                                    onTap: controller
                                        .goToCartPage, // Navigate faster to cart page
                                    child: Stack(
                                      children: [
                                        IconButton(
                                          icon: Icon(
                                            Icons.shopping_cart,
                                            size: 20.0,
                                            color: Colors.black54,
                                          ),
                                          onPressed: controller
                                              .goToCartPage, // Ensure fast response
                                        ),
                                        if (totalUniqueItems >
                                            0) // Display the badge if items exist
                                          Positioned(
                                            right: 0,
                                            child: GestureDetector(
                                              onTap: controller
                                                  .goToCartPage, // Also navigate on badge tap
                                              child: Container(
                                                padding: EdgeInsets.all(4),
                                                decoration: BoxDecoration(
                                                  color: Colors.red,
                                                  shape: BoxShape.circle,
                                                ),
                                                child: Text(
                                                  '$totalUniqueItems',
                                                  style: TextStyle(
                                                    color: Colors.white,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  );
                                }),
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),

// In your build method
            body: FutureBuilder<HomeVtwoModel>(
              future:
                  loadItemsFromLocal(), // This should return Future<HomeVtwoModel>
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(
                    child: Column(
                      mainAxisSize: MainAxisSize
                          .min, // Make sure the column takes up minimal space
                      children: [
                        // Container(
                        //   width: 24,
                        //   height: 24,
                        //   child: CircularProgressIndicator(
                        //     valueColor: AlwaysStoppedAnimation<Color>(
                        //         Colors.orange[400]!),
                        //     strokeWidth: 2.0,
                        //   ),
                        // ),
                        SizedBox(
                            height:
                                8), // Add some spacing between the indicator and text
                        // Text(
                        //   "Syncing data...",
                        //   style: TextStyle(
                        //     fontSize: 14, // Set the font size
                        //     color: Colors.black, // Set the text color
                        //   ),
                        // ),
                      ],
                    ),
                  );
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else if (!snapshot.hasData || snapshot.data!.items.isEmpty) {
                  return Center(child: Text('No data available'));
                }

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // Static search view at the top
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 10),
                      child: CustomSearchView(
                        width: MediaQuery.of(context).size.width,
                        focusNode: FocusNode(),
                        controller: _searchController,
                        hintText: "lbl_search".tr,
                        onChanged: (value) {
                          print('Search input: $value');
                          filterItems(value);
                        },
                        prefix: Container(
                          margin: getMargin(
                            left: 16,
                            top: 18,
                            right: 10,
                            bottom: 18,
                          ),
                          child: CommonImageView(
                            svgPath: ImageConstant.imgSearch,
                          ),
                        ),
                        suffix: IconButton(
                          icon: Icon(Icons.qr_code_scanner),
                          onPressed: () {
                            // Start scanning when the button is clicked
                            _startScanning();
                          },
                          color: Colors.orange[400],
                        ),
                      ),
                    ),
                    // SizedBox(height: 10),
                    // Padding(
                    //   padding: EdgeInsets.only(top: 26, left: 24, right: 24),
                    //   child: Row(
                    //     mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    //     // children: [
                    //     //   Text(
                    //     //     "lbl_available_stock".tr,
                    //     //     style: AppStyle.txtNotoSansJPBold16,
                    //     //   ),
                    //     //   Padding(
                    //     //     padding: EdgeInsets.only(top: 1, bottom: 2),
                    //     //     child: Text(
                    //     //       "lbl_see_all".tr,
                    //     //       style: AppStyle.txtNotoSansJPMedium14Bluegray301,
                    //     //     ),
                    //     //   ),
                    //     // ],
                    //   ),
                    // ),
                    SizedBox(height: 6),

                    Expanded(
                      child: Obx(() {
                        if (_filteredItems.isEmpty) {
                          return Center(child: Text('No items found'));
                        }

                       return FadeInLeft(
                          child: ListView.separated(
                            padding: EdgeInsets.symmetric(horizontal: 24),
                            shrinkWrap: true,
                            separatorBuilder: (context, index) =>
                                SizedBox(height: 0),
                            itemCount: _filteredItems.length,
                            itemBuilder: (context, index) {
                              var item = _filteredItems[index];
                              TextEditingController priceController =
                                  TextEditingController(
                                      text: item.salePrice.toString());
                              bool isEditingPrice =
                                  false; // Track if the price is being edited

                              return GestureDetector(
                                onTap: () {
                                  // Handle tap event if necessary
                                },
                                child: Container(
                                  margin: EdgeInsets.symmetric(vertical: 5),
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: Colors.white,
                                    boxShadow: [
                                      BoxShadow(
                                        color: Colors.grey.withOpacity(0.1),
                                        spreadRadius: 1,
                                        blurRadius: 4,
                                        offset: Offset(0, 2),
                                      ),
                                    ],
                                  ),
                                  child: ListTile(
                                    contentPadding: EdgeInsets.symmetric(
                                        vertical: 10, horizontal: 15),
                                    leading: Icon(Icons.image,
                                        size: 40, color: Colors.grey),
                                    title: Text(item.name),
                                    subtitle: StatefulBuilder(
                                      builder: (BuildContext context,
                                          StateSetter setState) {
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            // Display the price as a TextField if in editing mode
                                            isEditingPrice
                                                ? Container(
                                                    width:
                                                        100, // Adjust the width as needed
                                                    child: TextField(
                                                      controller:
                                                          priceController,
                                                      keyboardType:
                                                          TextInputType.number,
                                                      decoration:
                                                          InputDecoration(
                                                        border:
                                                            OutlineInputBorder(),
                                                        labelText: 'Price',
                                                        contentPadding:
                                                            EdgeInsets.symmetric(
                                                                vertical: 3,
                                                                horizontal:
                                                                    3), // Adjust padding
                                                      ),
                                                      onSubmitted: (newValue) {
                                                        // Update the price in the controller and switch back to display mode
                                                        if (newValue
                                                            .isNotEmpty) {
                                                          item.salePrice =
                                                              double.tryParse(
                                                                      newValue) ??
                                                                  item.salePrice;
                                                          controller.updatePrice(
                                                              item.name,
                                                              item.salePrice);
                                                        }
                                                        setState(() {
                                                          isEditingPrice =
                                                              false; // Switch back to display mode
                                                        });
                                                      },
                                                    ),
                                                  )
                                                : GestureDetector(
                                                    onTap: () {
                                                      setState(() {
                                                        isEditingPrice =
                                                            true; // Switch to editing mode
                                                      });
                                                    },
                                                    child: Text(
                                                      'Price: ${item.salePrice}',
                                                      style: TextStyle(
                                                          fontSize: 16),
                                                    ),
                                                  ),
                                            Text(
                                                '${item.minStock} ${item.unit}'),
                                          ],
                                        );
                                      },
                                    ),
                                    trailing: Obx(() {
                                      int currentQuantity =
                                          controller.getQuantity(item.name);

                                      return Column(
                                        mainAxisSize: MainAxisSize.min,
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              CircleAvatar(
                                                radius: 14,
                                                backgroundColor:
                                                    Colors.orange[200],
                                                child: IconButton(
                                                  icon: Icon(Icons.remove,
                                                      size: 14,
                                                      color: Colors.black54),
                                                  onPressed: () {
                                                    controller
                                                        .decrementQuantity(
                                                            item.name);
                                                  },
                                                ),
                                              ),
                                              SizedBox(width: 16),
                                              // Updated TextField for quantity input
                                              Container(
                                                padding: EdgeInsets.symmetric(
                                                    horizontal: 14, vertical: 4),
                                                decoration: BoxDecoration(
                                                  color: Colors.grey[200],
                                                  borderRadius:
                                                      BorderRadius.circular(6),
                                                ),
                                                
                                                child: Center(
                                                  child: Text(
                                                    currentQuantity.toString(),
                                                    style: GoogleFonts.poppins(
                                                      fontSize: 14,
                                                      fontWeight:
                                                          FontWeight.w600,
                                                      color: Colors
                                                          .black, // Bolder text for emphasis
                                                    ),
                                                  ),
                                                ),
                                              ),
                                              SizedBox(width: 16),
                                              CircleAvatar(
                                                radius: 14,
                                                backgroundColor:
                                                    Colors.orange[200],
                                                child: IconButton(
                                                  icon: Icon(Icons.add,
                                                      size: 14,
                                                      color: Colors.black54),
                                                  onPressed: () {
                                                    controller
                                                        .incrementQuantity(
                                                            item.name,
                                                            item.minStock);
                                                  },
                                                ),
                                              ),
                                            ],
                                          ),
                                          SizedBox(height: 2.5),
                                          if (currentQuantity > 0)
                                            CustomButton(
                                              width: 74,
                                              text: "Add to Cart",
                                              margin: EdgeInsets.only(left: 25),
                                              variant:
                                                  ButtonVariant.FillGray102,
                                              shape: ButtonShape.RoundedBorder8,
                                              padding:
                                                  ButtonPadding.PaddingAll6,
                                              fontStyle: ButtonFontStyle
                                                  .NotoSansJPMedium12,
                                              onTap: () {
                                                print(
                                                    "Adding ${item.name} to cart | MinStock: ${item.minStock}");
                                                controller.addToCart(
                                                    item.name,
                                                    item.img,
                                                    item.salePrice,
                                                    item.minStock);
                                              },
                                            ),
                                        ],
                                      );
                                    }),
                                  ),
                                ),
                              );
                            },
                          ),
                        );
                      }),
                    ),
                  ],
                );
              },
            ),
            bottomNavigationBar: CustomBottomBar(
              onChanged: (BottomBarEnum type) {
                // Handle bottom navigation bar change
                switch (type) {
                  case BottomBarEnum.Home:
                    return Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => HomeVtwoPage(
                          itemName:
                              _usernameController.text, // Pass necessary data
                          token: token, // Pass the token if required
                          deviceKey: '',
                        ),
                      ),
                    );

                  case BottomBarEnum.Scanner:
                    return Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => ScannerPage()),
                    );
                  case BottomBarEnum.cart:
                    return Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => CartPage()),
                    );
                  case BottomBarEnum.logout:
                    _showLogoutConfirmationDialog(context);
                    break;

                  case BottomBarEnum.Profile:
                    return Navigator.push(
                      context,
                      MaterialPageRoute(builder: (context) => MyProfilePage()),
                    );
                  default:
                    return Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => getDefaultWidget()),
                    );
                }
              },
            ),
          ),
        ));
  }

  void _showLogoutConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(
            "Logout",
            style: TextStyle(
              fontSize: 12,
            ),
          ),
          content: Container(
            constraints: BoxConstraints(
              maxHeight: 20, // Set the maximum height
            ),
            child: Text(
              "Are you sure you want to logout?",
              style: TextStyle(fontSize: 12),
            ),
          ),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(2.0), // Adjust radius here
          ),
          actions: <Widget>[
            TextButton(
              child: Text(
                "Cancel",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
              onPressed: () {
                Navigator.of(context)
                    .pop(); // Close the dialog and stay on the same page
              },
            ),
            TextButton(
              child: Text(
                "Yes",
                style: TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                ),
              ),
              onPressed: () {
                _logout(context); // Call the logout function
              },
            ),
          ],
        );
      },
    );
  }

  Future<bool?> _showExitConfirmationDialog(BuildContext context) {
    return showDialog<bool>(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(2), // Adjust the radius here
        ),
        child: Padding(
          padding: const EdgeInsets.all(16.0), // Add padding inside the dialog
          child: Column(
            mainAxisSize: MainAxisSize.min, // Wrap content tightly
            children: [
              Text(
                'Are you sure you want to exist mauzo360?',
                style: TextStyle(fontSize: 12), // Adjust font size if needed
              ),
              const SizedBox(
                  height: 20), // Add spacing between content and buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  TextButton(
                    onPressed: () =>
                        Navigator.of(context).pop(false), // Stay in app
                    child: Text(
                      'No',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  const SizedBox(width: 8), // Add spacing between buttons
                  TextButton(
                    onPressed: () {
                      _exitApp(); // Exit the app
                    },
                    child: Text(
                      'Yes',
                      style: TextStyle(
                        color: Colors.black,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _exitApp() {
    if (Platform.isAndroid) {
      SystemNavigator.pop(); // Graceful exit on Android
    } else if (Platform.isIOS) {
      exit(0); // Force exit on iOS (not recommended, but functional)
    }
  }

  Future<void> _logout(BuildContext context) async {
    // Clear user session data
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('user_token'); // Clear the stored token
    await prefs.setBool('isLoggedIn', false); // Update login status

    // Navigate to the login page and clear the back stack
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(
          builder: (context) => LoginPage()), // Navigate to LoginPage
      (Route<dynamic> route) => false, // Prevents going back to previous pages
    );
  }

  void filterItems(String query) {
    if (query.isEmpty) {
      // Reset the filtered items to show all when the search input is empty
      _filteredItems.assignAll(_allItems);
      print("Search cleared, displaying all items.");
    } else {
      try {
        var filteredList = _allItems
            .where(
                (item) => item.name.toLowerCase().contains(query.toLowerCase()))
            .toList();
        _filteredItems.assignAll(filteredList);
        print("Filtered items: $filteredList");
      } catch (e) {
        print("Error filtering items: $e");
      }
    }
  }

  void _startScanning() {
    // Open the scanner directly in the widget
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Scaffold(
          appBar: AppBar(
            title: Text("Scan a code"),
          ),
          body: MobileScanner(
            controller: _scannerController,
            onDetect: (BarcodeCapture barcodeCapture) {
              final List<Barcode> barcodes = barcodeCapture.barcodes;
              if (barcodes.isNotEmpty) {
                String scannedCode = barcodes[0].rawValue!;
                setState(() {
                  _searchController.text =
                      scannedCode; // Update the search input
                  filterItems(
                      scannedCode); // Filter items based on scanned code
                });

                // Navigate back to the previous page and update the UI
                Navigator.of(context)
                    .pop(); // This returns to the previous screen
                // Optionally call setState or another method to refresh the list if needed
                // Example: refreshItems(); // Implement this method to refresh items if necessary
              }
            },
          ),
        ),
      ),
    );
  }

  void onTapArrowleft14() {
    Navigator.pop(context);
  }
}

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart'; // Import the mobile_scanner package
import 'package:mauzoApp/core/app_export.dart';
import 'package:mauzoApp/presentation/home_vtwo_page/cart.dart';
import 'package:mauzoApp/presentation/home_vtwo_page/home_vtwo_page.dart';
import 'package:mauzoApp/presentation/login_empty_state_screen/LoginPage.dart';
import 'package:mauzoApp/presentation/my_profile_page/my_profile_page.dart';
import 'package:mauzoApp/widgets/app_bar/appbar_image.dart';
import 'package:mauzoApp/widgets/app_bar/custom_app_bar.dart';
import 'package:mauzoApp/widgets/custom_bottom_bar.dart';
import 'package:mauzoApp/widgets/custom_button.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({Key? key}) : super(key: key);

  @override
  _ScannerPageState createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  String _scanResult = '';

void _onScanResult(BarcodeCapture barcodeCapture) {
  // Access the scanned barcode data
  final Object? scannedData = barcodeCapture.raw;

  // Check if the scannedData is a String and cast it
  if (scannedData is String) {
    setState(() {
      _scanResult = scannedData; // Update the scan result state
    });
  } else {
    // Handle the case where scannedData is not a String
    print("Scanned Data is not a string: $scannedData");
  }

  // Print the scanned data for debugging
  print("Scanned Data: $scannedData");
}


  @override
  Widget build(BuildContext context) {
    return SafeArea(
      child: Scaffold(
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
          title: const Text("QR Code Scanner"),
        ),
        body: Column(
          children: [
            Expanded(
              flex: 4,
              child: MobileScanner(
                onDetect: (BarcodeCapture barcode) {
                  _onScanResult(barcode);
                },
              ),
            ),
            Expanded(
              flex: 1,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      _scanResult.isEmpty ? 'No code scanned.' : 'Code: $_scanResult',
                      style: const TextStyle(fontSize: 12),
                    ),
                    const SizedBox(height: 24),
                    CustomButton(
                      text: _scanResult.isEmpty ? "Scan" : "Submit",
                      width: size.width,
                      margin: EdgeInsets.symmetric(horizontal: 24),
                      shape: ButtonShape.RoundedBorder16,
                      fontStyle: ButtonFontStyle.NotoSansJPMedium14,
                      onTap: _scanResult.isEmpty ? _startScan : _submitScanResult,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
        bottomNavigationBar: CustomBottomBar(
          onChanged: (BottomBarEnum type) {
            // Navigation handling
            switch (type) {
              case BottomBarEnum.Home:
                Navigator.push(context, MaterialPageRoute(builder: (context) => HomeVtwoPage(itemName: '', token: '', deviceKey: '')));
                break;
              case BottomBarEnum.Scanner:
                Navigator.push(context, MaterialPageRoute(builder: (context) => const ScannerPage()));
                break;
              case BottomBarEnum.cart:
                Navigator.push(context, MaterialPageRoute(builder: (context) => CartPage()));
                break;
              case BottomBarEnum.logout:
                Navigator.push(context, MaterialPageRoute(builder: (context) => LoginPage()));
                break;
              case BottomBarEnum.Profile:
                Navigator.push(context, MaterialPageRoute(builder: (context) => MyProfilePage()));
                break;
              default:
                Navigator.push(context, MaterialPageRoute(builder: (context) => getDefaultWidget()));
            }
          },
        ),
      ),
    );
  }

  void onTapArrowleft14() {
    Navigator.pop(context); // Pop to the previous screen
  }

  Future<void> _startScan() async {
    // Implement any additional logic for starting a scan if needed
  }

  void _submitScanResult() {
    if (_scanResult.isNotEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Submitted result: $_scanResult')),
      );
    }
  }
}

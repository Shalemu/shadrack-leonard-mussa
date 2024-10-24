import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'dart:ui' as ui;
import 'package:flutter/services.dart';

// Function to generate QR code image
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

    final picData = await painter.toImageData(200, format: ui.ImageByteFormat.png);
    final codec = await ui.instantiateImageCodec(picData!.buffer.asUint8List());
    final frame = await codec.getNextFrame();

    return frame.image;
  } else {
    throw Exception('QR code generation failed');
  }
}

class ReceiptView extends StatelessWidget {
  final String paymentType;
  final String customerName;
  final double billAmount;
  final double paidAmount;
  final double pendingAmount;
  final String qrContent;

  ReceiptView({
    required this.paymentType,
    required this.customerName,
    required this.billAmount,
    required this.paidAmount,
    required this.pendingAmount,
    required this.qrContent,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Receipt Template'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            // Title
            Text(
              'Receipt',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 10),
            Divider(),
            
            // Customer Details
            Text('Customer: $customerName'),
            SizedBox(height: 5),
            Text('Payment Type: $paymentType'),
            SizedBox(height: 5),
            Text('Bill: \$${billAmount.toStringAsFixed(2)}'),
            SizedBox(height: 5),
            Text('Paid: \$${paidAmount.toStringAsFixed(2)}'),
            if (paymentType == 'Credit') ...[
              SizedBox(height: 5),
              Text('Pending: \$${pendingAmount.toStringAsFixed(2)}'),
            ],
            Divider(),

            // QR Code
            FutureBuilder<ui.Image>(
              future: generateQrCode(qrContent),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done && snapshot.hasData) {
                  return RawImage(image: snapshot.data);
                } else {
                  return CircularProgressIndicator();
                }
              },
            ),
            SizedBox(height: 20),

            // Simulate Print Button
            ElevatedButton(
              onPressed: () {
                print('Printing Receipt...'); // Simulating the print function
              },
              child: Text('Pay & Print Receipt'),
            ),
          ],
        ),
      ),
    );
  }
}

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: ReceiptView(
        paymentType: 'Credit',
        customerName: 'John Doe',
        billAmount: 150.00,
        paidAmount: 50.00,
        pendingAmount: 100.00,
        qrContent: 'QR Code Content Here',
      ),
    );
  }
}

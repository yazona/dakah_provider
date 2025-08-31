import 'dart:convert';
import 'package:crypto/crypto.dart';
import 'package:dakeh_service_provider/core/utils/constants.dart';
import 'package:dakeh_service_provider/core/utils/functions.dart';
import 'package:dakeh_service_provider/features/reservations/manager/reservations_cubit.dart';
import 'package:dakeh_service_provider/features/reservations/presentation/screens/reservation_details_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScanBarcodeScreen extends StatefulWidget {
  const ScanBarcodeScreen({super.key});

  @override
  State<ScanBarcodeScreen> createState() => _ScanBarcodeScreenState();
}

class _ScanBarcodeScreenState extends State<ScanBarcodeScreen> {
  MobileScannerController scannerController = MobileScannerController();

  @override
  void dispose() {
    super.dispose();
    scannerController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Expanded(
          flex: 4,
          child: MobileScanner(
            controller: scannerController,
            errorBuilder: (p0, p1, p2) {
             
              return const SizedBox();
            },
            onDetect: (BarcodeCapture capture) async {
              final List<Barcode> result = capture.barcodes;
              final barcode = result.first;
              Map<String, dynamic>? data =
                  parseQRCodeData(barcode.rawValue!, 'DAKEHQRCODE');
              if (data != null) {
                if (data['providerName'] == AppConstants.user!.data.name) {
                  if (context.mounted) {
                    // ReservationsCubit.get(context)
                    //     .getReservationsDetails(reservationID: data['orderID']);
                    AppFunctions.navTo(context,
                        screen: BlocProvider(
                          create: (context) => ReservationsCubit()..getReservationsDetails(reservationID: data['orderID']),
                          child: const ReservationDetailsScreen(),
                        ));
                  }
                  await scannerController.stop();
                }
              } else {}
            },
          ),
        ),
      ],
    );
  }

  bool verifySignedQRCodeData(String scannedData, String secretKey) {
    var parts = scannedData.split('|');
    if (parts.length != 2) {
      return false;
    }

    var jsonData = parts[0];
    var providedSignature = parts[1];
    var key = utf8.encode(secretKey);
    var bytes = utf8.encode(jsonData);
    var hmacSha256 = Hmac(sha256, key);
    var digest = hmacSha256.convert(bytes);
    return digest.toString() == providedSignature;
  }

  Map<String, dynamic>? parseQRCodeData(String scannedData, String secretKey) {
    if (verifySignedQRCodeData(scannedData, secretKey)) {
      var jsonData = scannedData.split('|')[0];
      return jsonDecode(jsonData);
    }
    return null;
  }
}

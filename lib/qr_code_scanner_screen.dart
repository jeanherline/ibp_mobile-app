import 'dart:io';
import 'package:flutter/material.dart';
import 'package:qr_code_scanner/qr_code_scanner.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';

class QRCodeScannerScreen extends StatefulWidget {
  @override
  _QRCodeScannerScreenState createState() => _QRCodeScannerScreenState();
}

class _QRCodeScannerScreenState extends State<QRCodeScannerScreen> {
  final GlobalKey qrKey = GlobalKey(debugLabel: 'QR');
  QRViewController? controller;
  String? qrText;
  Map<String, dynamic>? appointmentDetails;
  String? reviewedByName;

  @override
  void reassemble() {
    super.reassemble();
    if (Platform.isAndroid) {
      controller?.pauseCamera();
    }
    controller?.resumeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('QR Code Scanner'),
      ),
      body: Column(
        children: <Widget>[
          Expanded(
            flex: 5,
            child: QRView(
              key: qrKey,
              onQRViewCreated: _onQRViewCreated,
              overlay: QrScannerOverlayShape(
                borderColor: Colors.red,
                borderRadius: 10,
                borderLength: 30,
                borderWidth: 10,
                cutOutSize: 300,
              ),
              cameraFacing: CameraFacing.back,
            ),
          ),
          Expanded(
            flex: 1,
            child: SingleChildScrollView(
              child: Center(
                child: qrText != null
                    ? appointmentDetails != null
                        ? Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                Text(
                                  appointmentDetails!['appointmentDate'] != null
                                      ? formatDate(
                                          appointmentDetails!['appointmentDate']
                                              .toDate())
                                      : 'No Appointment Date',
                                  style: const TextStyle(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'Full Name: ${appointmentDetails!['fullName']}',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'Appointment Status: ${capitalize(appointmentDetails!['appointmentStatus'])}',
                                  style: TextStyle(
                                    fontSize: 16,
                                    color: getStatusColor(appointmentDetails![
                                        'appointmentStatus']),
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  'Reviewed By: $reviewedByName',
                                  style: TextStyle(
                                    fontSize: 16,
                                  ),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            ),
                          )
                        : CircularProgressIndicator()
                    : Text(
                        'Scan a code',
                        style: TextStyle(
                          fontSize: 18,
                        ),
                      ),
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _onQRViewCreated(QRViewController controller) {
    this.controller = controller;
    controller.scannedDataStream.listen((scanData) async {
      setState(() {
        qrText = scanData.code;
      });
      await fetchAppointmentDetails(scanData.code);
    });
  }

  Future<void> fetchAppointmentDetails(String? controlNumber) async {
    if (controlNumber == null) return;

    final snapshot = await FirebaseFirestore.instance
        .collection('appointments')
        .where('appointmentDetails.controlNumber', isEqualTo: controlNumber)
        .limit(1)
        .get();

    if (snapshot.docs.isNotEmpty) {
      final data = snapshot.docs.first.data();
      final reviewedById = data['appointmentDetails']['reviewedBy'];

      final userSnapshot = await FirebaseFirestore.instance
          .collection('users')
          .doc(reviewedById)
          .get();

      if (userSnapshot.exists) {
        final userData = userSnapshot.data();
        reviewedByName =
            '${userData!['display_name']} ${userData['middle_name']} ${userData['last_name']}';
      }

      setState(() {
        appointmentDetails = {
          'appointmentStatus': data['appointmentDetails']['appointmentStatus'],
          'fullName': data['applicantProfile']['fullName'],
          'appointmentDate': data['appointmentDetails']['appointmentDate'],
        };
      });
    }
  }

  String capitalize(String text) {
    if (text.isEmpty) return text;
    return text[0].toUpperCase() + text.substring(1).toLowerCase();
  }

  String formatDate(DateTime dateTime) {
    final DateFormat formatter = DateFormat('MMMM d, yyyy \'at\' h:mm a');
    return formatter.format(dateTime);
  }

  Color getStatusColor(String status) {
    switch (status.toLowerCase()) {
      case 'approved':
        return Colors.green;
      case 'pending':
        return Colors.yellow;
      case 'cancelled':
        return Colors.red;
      default:
        return Colors.black;
    }
  }

  @override
  void dispose() {
    controller?.dispose();
    super.dispose();
  }
}

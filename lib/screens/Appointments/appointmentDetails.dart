import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ibp_app_ver2/screens/home.dart';

class AppointmentDetails extends StatefulWidget {
  final String controlNumber;

  const AppointmentDetails({Key? key, required this.controlNumber})
      : super(key: key);

  @override
  _AppointmentDetailsState createState() => _AppointmentDetailsState();
}

class _AppointmentDetailsState extends State<AppointmentDetails> {
  Future<Map<String, dynamic>?> fetchAppointmentDetails(
      String controlNumber) async {
    final doc = await FirebaseFirestore.instance
        .collection('appointments')
        .doc(controlNumber)
        .get();

    if (doc.exists) {
      return doc.data();
    }
    return null;
  }

  String capitalizeFirstLetter(String value) {
    if (value.isEmpty) return value;
    return value[0].toUpperCase() + value.substring(1);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Appointment Details'),
        leading: IconButton(
          icon: Icon(Icons.arrow_back),
          onPressed: () => Navigator.of(context).pop(),
        ),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: FutureBuilder<Map<String, dynamic>?>(
              future: fetchAppointmentDetails(widget.controlNumber),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return const Center(
                      child: Text('Error loading appointment details.'));
                } else if (!snapshot.hasData) {
                  return const Center(
                      child: Text('No appointment details available.'));
                }

                final appointmentDetails = snapshot.data!;
                final qrCodeUrl =
                    appointmentDetails['appointmentDetails']['qrCode'];
                final appointmentStatus =
                    appointmentDetails['appointmentDetails']
                        ['appointmentStatus'];

                return Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    const SizedBox(height: 20),
                    const Center(
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            'MUNTING PAALALA:',
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.green,
                            ),
                          ),
                          SizedBox(width: 8),
                          Text(
                            '(Reminder)',
                            style: TextStyle(
                              fontSize: 14,
                              fontStyle: FontStyle.italic,
                              color: Colors.grey,
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        'Mangyaring hintayin ang kumpirmasyon ng petsa at oras ng inyong personal na pagkonsulta. Huwag kalimutang i-save ang QR Code at dalhin ang mga hard copy ng mga dokumentong ipinasa online sakaling maaprubahan ang inyong appointment.',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        '(Please wait for the confirmation of the date and time of consultation. Do not forget to save the QR Code and bring hard copies of the documents submitted online in case your appointment is approved.)',
                        style: TextStyle(
                          fontSize: 14,
                          color: Colors.grey,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 30),
                    Container(
                      padding: const EdgeInsets.all(30.0),
                      decoration: BoxDecoration(
                        color: Colors.blue[50],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          const Icon(
                            Icons.check_circle_outline,
                            size: 100,
                            color: Colors.green,
                          ),
                          const SizedBox(height: 10),
                          Text(
                            'TICKET #${widget.controlNumber}',
                            style: const TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                              color: Colors.black,
                            ),
                          ),
                          Text(
                            capitalizeFirstLetter(appointmentStatus),
                            style: const TextStyle(
                              fontSize: 16,
                              color: Colors.grey,
                              fontStyle: FontStyle.italic,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 10),
                          const Text(
                            'IBP Building, Provincial Capitol Malolos, Bulacan',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                            ),
                            textAlign: TextAlign.center,
                          ),
                          const SizedBox(height: 20),
                          qrCodeUrl != null
                              ? Image.network(qrCodeUrl)
                              : const Center(
                                  child: Text('No QR code available.')),
                          const SizedBox(height: 20),
                        ],
                      ),
                    ),
                    const SizedBox(height: 20),
                    Container(
                      padding: const EdgeInsets.all(16.0),
                      decoration: BoxDecoration(
                        color: Colors.grey[200],
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: const Row(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          Icon(Icons.lock_outline, color: Colors.grey),
                          SizedBox(width: 10),
                          Expanded(
                            child: Text(
                              'Sineseryoso namin ang mga isyu sa privacy. Maaari kang makasiguro na ang iyong personal na data ay ligtas na nakaprotekta.',
                              style: TextStyle(color: Colors.black),
                            ),
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(height: 10),
                    const Center(
                      child: Text(
                        'We take privacy issues seriously. You can be sure that your personal data is safely protected.',
                        style: TextStyle(
                          color: Colors.grey,
                          fontSize: 14,
                          fontStyle: FontStyle.italic,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ),
                    const SizedBox(height: 20),
                  ],
                );
              },
            ),
          ),
        ),
      ),
    );
  }
}

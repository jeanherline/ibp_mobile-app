import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ibp_app_ver2/screens/home.dart';
import 'package:provider/provider.dart';
import 'dart:async';
import 'form_state_provider.dart';

class KonsultaSubmit extends StatefulWidget {
  final String controlNumber;

  const KonsultaSubmit({super.key, required this.controlNumber});

  @override
  _KonsultaSubmitState createState() => _KonsultaSubmitState();
}

class _KonsultaSubmitState extends State<KonsultaSubmit> {
  int _selectedRating = 0;
  bool _isThankYouVisible = false;

  Future<String?> _getQrCodeUrl(String controlNumber) async {
    final doc = await FirebaseFirestore.instance
        .collection('appointments')
        .where('appointmentDetails.controlNumber', isEqualTo: controlNumber)
        .limit(1)
        .get();

    if (doc.docs.isNotEmpty) {
      return doc.docs.first.data()['appointmentDetails']['qrCode'];
    }
    return null;
  }

  Future<void> _submitRating() async {
    final doc = await FirebaseFirestore.instance
        .collection('appointments')
        .where('appointmentDetails.controlNumber',
            isEqualTo: widget.controlNumber)
        .limit(1)
        .get();
// 
    if (doc.docs.isNotEmpty) {
      final docId = doc.docs.first.id;
      await FirebaseFirestore.instance
          .collection('appointments')
          .doc(docId)
          .update({
        'appointmentDetails.rating': _selectedRating,
      });

      Navigator.of(context).pop(); // Close the modal after rating

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Thank you for your rating!'),
        ),
      );

      // Clear form state after 10 seconds
      Timer(Duration(seconds: 5), () {
        Provider.of<FormStateProvider>(context, listen: false).clearFormState();
      });
    }
  }

  @override
  void dispose() {
    super.dispose();
    Provider.of<FormStateProvider>(context, listen: false).clearFormState();
  }

  @override
  void initState() {
    super.initState();
    // Show the rating modal after 10 seconds
    Timer(Duration(seconds: 10), () {
      showDialog(
        context: context,
        builder: (BuildContext context) => _buildRatingDialog(context),
      );
    });
  }

  Widget _buildRatingDialog(BuildContext context) {
    return StatefulBuilder(
      builder: (context, setState) {
        return AlertDialog(
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text('I-rate ang karanasan'),
              IconButton(
                icon: const Icon(Icons.close),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
            ],
          ),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text(
                  'Ang iyong puna ay makakatulong sa pagbuti ng pag-book ng appointment'),
              const SizedBox(height: 20),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: List.generate(5, (index) {
                  return IconButton(
                    icon: Icon(
                      index < _selectedRating ? Icons.star : Icons.star_border,
                    ),
                    iconSize: 30,
                    color: Colors.amber,
                    onPressed: () {
                      setState(() {
                        _selectedRating = index + 1;
                      });
                      _submitRating();
                    },
                  );
                }),
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            Provider.of<FormStateProvider>(context, listen: false)
                .clearFormState();
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => const Home(),
              ),
            );
          },
        ),
        title: const Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Isumite ang Suliraning Legal',
              style: TextStyle(
                color: Colors.black,
                fontSize: 20,
                fontWeight: FontWeight.bold,
              ),
            ),
            Text(
              '(Submit your legal problem)',
              style: TextStyle(color: Colors.grey, fontSize: 14),
            ),
          ],
        ),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 20),
                const Center(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Maraming Salamat!',
                        style: TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(width: 8), // Add some space between the texts
                      Text(
                        '(Thank you very much!)',
                        style: TextStyle(
                          fontSize: 14, // Set the font size to 14
                          fontStyle: FontStyle.italic,
                          color: Colors.grey,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 10),
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
                      SizedBox(width: 8), // Add some space between the texts
                      Text(
                        '(Reminder)',
                        style: TextStyle(
                          fontSize: 14, // Set the font size to 14
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
                    '(Please wait for the confirmation of the date and time of your personal consultation. Do not forget to save the QR Code and bring hard copies of the documents submitted online in case your appointment is approved.)',
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
                      const Text(
                        'Nakabinbing Kahilingan (Pending Request)',
                        style: TextStyle(
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
                      FutureBuilder<String?>(
                        future: _getQrCodeUrl(widget.controlNumber),
                        builder: (context, snapshot) {
                          if (snapshot.connectionState ==
                              ConnectionState.waiting) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          } else if (snapshot.hasError) {
                            return const Center(
                              child: Text('Error loading QR code.'),
                            );
                          } else if (snapshot.hasData) {
                            final qrCodeUrl = snapshot.data;
                            return qrCodeUrl != null
                                ? Image.network(qrCodeUrl)
                                : const Center(
                                    child: Text('No QR code available.'),
                                  );
                          } else {
                            return const Center(
                              child: Text('No QR code available.'),
                            );
                          }
                        },
                      ),
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
            ),
          ),
        ),
      ),
    );
  }
}

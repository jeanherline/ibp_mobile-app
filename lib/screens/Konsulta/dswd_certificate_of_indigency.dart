import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'form_state_provider.dart';
import 'pao_disqualification_letter.dart';
import 'progress_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html;

class DSWDCertificateOfIndigency extends StatefulWidget {
  const DSWDCertificateOfIndigency({super.key});

  @override
  _DSWDCertificateOfIndigencyState createState() =>
      _DSWDCertificateOfIndigencyState();
}

class _DSWDCertificateOfIndigencyState
    extends State<DSWDCertificateOfIndigency> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImage(BuildContext context) async {
    final formStateProvider =
        Provider.of<FormStateProvider>(context, listen: false);

    if (kIsWeb) {
      html.FileUploadInputElement uploadInput = html.FileUploadInputElement();
      uploadInput.accept = 'image/*';
      uploadInput.click();

      uploadInput.onChange.listen((event) {
        final files = uploadInput.files;
        if (files != null && files.isNotEmpty) {
          final reader = html.FileReader();
          reader.readAsDataUrl(files[0]);
          reader.onLoadEnd.listen((event) {
            final imageDataUrl = reader.result as String;
            if (mounted) {
              formStateProvider
                  .setDSWDSelectedImage(NetworkImage(imageDataUrl));
            }
          });
        }
      });
    } else {
      showModalBottomSheet(
        context: context,
        builder: (BuildContext context) {
          return SafeArea(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                ListTile(
                  leading: const Icon(Icons.photo_library),
                  title: const Text('Gallery'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final pickedFile = await _picker.pickImage(
                      source: ImageSource.gallery,
                      maxHeight: 300,
                      maxWidth: 300,
                    );
                    if (pickedFile != null) {
                      print('Gallery image picked: ${pickedFile.path}');
                      if (mounted) {
                        formStateProvider.setDSWDSelectedImage(
                            FileImage(File(pickedFile.path)));
                      }
                    }
                  },
                ),
                ListTile(
                  leading: const Icon(Icons.camera_alt),
                  title: const Text('Camera'),
                  onTap: () async {
                    Navigator.of(context).pop();
                    final pickedFile = await _picker.pickImage(
                      source: ImageSource.camera,
                      maxHeight: 300,
                      maxWidth: 300,
                    );
                    if (pickedFile != null) {
                      print('Camera image picked: ${pickedFile.path}');
                      if (mounted) {
                        formStateProvider.setDSWDSelectedImage(
                            FileImage(File(pickedFile.path)));
                      }
                    }
                  },
                ),
              ],
            ),
          );
        },
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final formStateProvider = Provider.of<FormStateProvider>(context);
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
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
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 10),
                  const Center(
                    child: CustomProgressBar(currentStep: 4, totalSteps: 6),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'Certificate of Indigency from DSWD',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      '(Attach your Certificate of Indigency from DSWD)',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 20),
                  GestureDetector(
                    onTap: () => _pickImage(context),
                    child: Container(
                      height: 300,
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.grey),
                        borderRadius: BorderRadius.circular(10),
                        image: formStateProvider.dswdSelectedImage != null
                            ? DecorationImage(
                                image: formStateProvider.dswdSelectedImage!,
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: formStateProvider.dswdSelectedImage == null
                          ? const Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Icon(
                                  Icons.cloud_upload_outlined,
                                  size: 100,
                                  color: Colors.grey,
                                ),
                                SizedBox(height: 10),
                                Text(
                                  'I-click para piliin ang mga image files na nais mong i-upload.',
                                  style: TextStyle(color: Colors.black),
                                  textAlign: TextAlign.center,
                                ),
                                Text(
                                  '(Click to select the image files you wish to upload.)',
                                  style: TextStyle(color: Colors.grey),
                                  textAlign: TextAlign.center,
                                ),
                              ],
                            )
                          : null,
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
                      style: TextStyle(color: Colors.grey),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 55),
                        backgroundColor: const Color(0xFF580049),
                      ),
                      onPressed: () {
                        if (formStateProvider.dswdSelectedImage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please upload an image before proceeding.'),
                            ),
                          );
                          return;
                        }

                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) =>
                                const PAODisqualificationLetter(),
                          ),
                        );
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text.rich(
                            TextSpan(
                              text: 'Sunod ',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '(Next)',
                                  style: TextStyle(
                                    fontSize: 18,
                                    fontStyle: FontStyle.italic,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(width: 5),
                          Icon(
                            Icons.arrow_forward,
                            color: Colors.white,
                          ),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

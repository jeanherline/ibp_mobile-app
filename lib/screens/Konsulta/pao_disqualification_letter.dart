import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'form_state_provider.dart';
import 'progress_bar.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:universal_html/html.dart' as html;
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

class PAODisqualificationLetter extends StatefulWidget {
  const PAODisqualificationLetter({super.key});

  @override
  _PAODisqualificationLetterState createState() =>
      _PAODisqualificationLetterState();
}

class _PAODisqualificationLetterState extends State<PAODisqualificationLetter> {
  final _formKey = GlobalKey<FormState>();
  final ImagePicker _picker = ImagePicker();
  bool _isChecked = false; // Added

  Future<void> _pickImage(BuildContext context) async {
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
            Provider.of<FormStateProvider>(context, listen: false)
                .setPAOSelectedImage(NetworkImage(imageDataUrl));
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
                      Provider.of<FormStateProvider>(context, listen: false)
                          .setPAOSelectedImage(
                              FileImage(File(pickedFile.path)));
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
                      Provider.of<FormStateProvider>(context, listen: false)
                          .setPAOSelectedImage(
                              FileImage(File(pickedFile.path)));
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
                    child: CustomProgressBar(currentStep: 5, totalSteps: 6),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'Disqualification Letter from PAO',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Center(
                    child: Text(
                      '(Attach your Disqualification Letter from PAO)',
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
                        image: formStateProvider.paoSelectedImage != null
                            ? DecorationImage(
                                image: formStateProvider.paoSelectedImage!,
                                fit: BoxFit.cover,
                              )
                            : null,
                      ),
                      child: formStateProvider.paoSelectedImage == null
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
                            'Sineseryoso namin ang mga isyu sa privacy. Maaari kang makasiguro na ang iyong personal na data ay ligtas na nakaprotecta.',
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
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Checkbox(
                        value: _isChecked,
                        onChanged: (bool? value) {
                          setState(() {
                            _isChecked = value!;
                          });
                        },
                      ),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: const [
                            Text(
                              'Naiintindihan ko ang mga katanungan at aking pinanunumpaan ang aking mga kasagutan at mga ibinigay na mga dokumento ay totoo at wasto.',
                              style: TextStyle(
                                color: Colors.blue,
                                fontSize: 16,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              '(I fully understood all questions asked in this form and swear on the truth and veracity of my answers, and documents provided are true and correct.)',
                              style: TextStyle(
                                color: Colors.grey,
                                fontSize: 14,
                                fontStyle: FontStyle.italic,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 55),
                        backgroundColor: const Color(0xFF580049),
                      ),
                      onPressed: () async {
                        if (formStateProvider.paoSelectedImage == null) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text(
                                  'Please upload an image before proceeding.'),
                            ),
                          );
                          return;
                        }

                        if (!_isChecked) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            const SnackBar(
                              content: Text('Please accept the declaration.'),
                            ),
                          );
                          return;
                        }

                        // Show loading indicator
                        showDialog(
                          context: context,
                          barrierDismissible: false,
                          builder: (BuildContext context) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );

                        // Save form data and images to Firestore and Firebase Storage
                        await _saveFormData(context);

                        // Hide loading indicator
                        Navigator.of(context).pop();

                        // Show success message and navigate to KonsultaSubmit
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Form submitted successfully'),
                          ),
                        );

                        Navigator.pushNamed(
                          context,
                          '/konsulta_submit',
                          arguments: formStateProvider.controlNumber,
                        );
                      },
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text.rich(
                            TextSpan(
                              text: 'Isumite ',
                              style: TextStyle(
                                fontSize: 18,
                                color: Colors.white,
                              ),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '(Submit)',
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
                  SizedBox(height: 20),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _saveFormData(BuildContext context) async {
    final formStateProvider = context.read<FormStateProvider>();
    final user = FirebaseAuth.instance.currentUser;

    if (user != null) {
      final userDoc =
          FirebaseFirestore.instance.collection('appointments').doc();
      final now = DateTime.now();
      final String datetime = DateFormat('yyyyMMdd_HHmmss').format(now);
      final storageRef = FirebaseStorage.instance
          .ref()
          .child('konsulta_user_uploads/${user.uid}/$datetime');

      // Upload images to Firebase Storage
      final barangayImageUrl = await _uploadImage(
          storageRef,
          'barangayCertificateOfIndigency',
          formStateProvider.barangaySelectedImage);
      final dswdImageUrl = await _uploadImage(storageRef,
          'dswdCertificateOfIndigency', formStateProvider.dswdSelectedImage);
      final paoImageUrl = await _uploadImage(storageRef,
          'paoDisqualificationLetter', formStateProvider.paoSelectedImage);

      // Generate control number
      final controlNumber = generateControlNumber();
      formStateProvider.setControlNumber(controlNumber);

      // Save form data to Firestore
      await userDoc.set({
        'uid': user.uid,
        'controlNumber': controlNumber,
        'createdDate': FieldValue.serverTimestamp(),
        'appointmentStatus': 'pending',
        'applicantProfile': {
          'fullName': formStateProvider.fullName,
          'dob': formStateProvider.dob,
          'address': formStateProvider.address,
          'contactNumber': formStateProvider.contactNumber,
          'selectedGender': formStateProvider.selectedGender,
          'spouseName': formStateProvider.spouseName,
          'spouseOccupation': formStateProvider.spouseOccupation,
          'childrenNamesAges': formStateProvider.childrenNamesAges,
        },
        'employmentProfile': {
          'occupation': formStateProvider.occupation,
          'kindOfEmployment': formStateProvider.kindOfEmployment,
          'employerName': formStateProvider.employerName,
          'employerAddress': formStateProvider.employerAddress,
          'monthlyIncome': formStateProvider.monthlyIncome,
        },
        'legalAssistanceRequested': {
          'selectedAssistanceType': formStateProvider.selectedAssistanceType,
          'problems': formStateProvider.problems,
          'problemReason': formStateProvider.problemReason,
          'desiredSolutions': formStateProvider.desiredSolutions,
        },
        'uploadedImages': {
          'barangayImageUrl': barangayImageUrl,
          'dswdImageUrl': dswdImageUrl,
          'paoImageUrl': paoImageUrl,
        },
      });
    }
  }

  Future<String?> _uploadImage(
      Reference storageRef, String imageType, ImageProvider? image) async {
    if (image == null) {
      return null;
    }

    UploadTask uploadTask;

    if (image is FileImage) {
      final file = image.file;
      uploadTask = storageRef.child('$imageType.jpg').putFile(file);
    } else if (image is NetworkImage) {
      final url = image.url;
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final bytes = response.bodyBytes;
        uploadTask = storageRef.child('$imageType.jpg').putData(bytes);
      } else {
        throw Exception('Failed to load image');
      }
    } else {
      throw UnsupportedError('Unsupported image type');
    }

    final snapshot = await uploadTask;
    return await snapshot.ref.getDownloadURL();
  }

  String generateControlNumber() {
    final now = DateTime.now();
    return '${now.year.toString().padLeft(4, '0')}${now.month.toString().padLeft(2, '0')}${now.day.toString().padLeft(2, '0')}${now.hour.toString().padLeft(2, '0')}${now.minute.toString().padLeft(2, '0')}${now.second.toString().padLeft(2, '0')}';
  }
}

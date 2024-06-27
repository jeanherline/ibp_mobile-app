import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:intl/intl.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';
import 'package:firebase_storage/firebase_storage.dart';

class EditProfile extends StatefulWidget {
  @override
  _EditProfileState createState() => _EditProfileState();
}

class _EditProfileState extends State<EditProfile> {
  final TextEditingController _displayNameController = TextEditingController();
  final TextEditingController _middleNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _spouseController = TextEditingController();
  final TextEditingController _spouseOccupationController =
      TextEditingController();

  String _photoUrl = '';
  DateTime _selectedDate = DateTime.now();
  String _selectedCity = 'Angat';
  String _selectedGender = 'Male';
  File? _imageFile;
  bool _isUploading = false;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final data = userData.data();

      if (data != null) {
        setState(() {
          _photoUrl = data['photo_url'] ?? 'https://via.placeholder.com/150';
          _displayNameController.text = data['display_name'] ?? '';
          _middleNameController.text = data['middle_name'] ?? '';
          _lastNameController.text = data['last_name'] ?? '';
          if (data['dob'] != null) {
            _selectedDate = (data['dob'] as Timestamp).toDate();
            _dobController.text =
                DateFormat('yyyy-MM-dd').format(_selectedDate);
          }
          _selectedCity = data['city'] ?? 'Angat';
          _phoneController.text = data['phone'] ?? '';
          _selectedGender = data['gender'] ?? 'Male';
          _spouseController.text = data['spouse'] ?? '';
          _spouseOccupationController.text = data['spouseOccupation'] ?? '';
        });
      }
    }
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate,
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
        _dobController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);

    if (pickedFile != null) {
      setState(() {
        _imageFile = File(pickedFile.path);
      });
    }
  }

  Future<void> _uploadImage() async {
    if (_imageFile == null) return;

    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _isUploading = true;
      });

      final storageRef = FirebaseStorage.instance
          .ref()
          .child('profile_images')
          .child(user.uid + '.jpg');

      try {
        // Log upload start
        print('Starting image upload...');

        // Upload file to Firebase Storage
        await storageRef.putFile(_imageFile!);

        // Log upload completion
        print('Image upload completed.');

        final photoUrl = await storageRef.getDownloadURL();

        setState(() {
          _photoUrl = photoUrl;
          _isUploading = false;
          _imageFile = null; // Clear the local file after upload
        });

        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({
          'photo_url': _photoUrl,
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Image uploaded successfully')),
        );
      } catch (e) {
        setState(() {
          _isUploading = false;
        });

        print('Image upload failed: $e'); // Log error

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Failed to upload image')),
        );
      }
    }
  }

  ImageProvider _getImageProvider() {
    if (_isUploading) {
      return const AssetImage(
          'assets/images/loading.gif'); // Show a loading gif or image
    } else if (_imageFile != null) {
      return FileImage(_imageFile!);
    } else if (_photoUrl.isNotEmpty && !_photoUrl.startsWith('blob:')) {
      return NetworkImage(_photoUrl);
    } else {
      return const NetworkImage(
          'https://as2.ftcdn.net/v2/jpg/03/49/49/79/1000_F_349497933_Ly4im8BDmHLaLzgyKg2f2yZOvJjBtlw5.jpg');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Edit Profile'),
        backgroundColor: Colors.blueAccent,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            // Profile picture
            Stack(
              alignment: Alignment.bottomRight,
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundImage: _getImageProvider(),
                ),
                InkWell(
                  onTap: _pickImage,
                  child: CircleAvatar(
                    radius: 15,
                    backgroundColor: Colors.white,
                    child: Icon(Icons.edit, size: 15, color: Colors.black),
                  ),
                ),
              ],
            ),
            SizedBox(height: 20),
            // Display Name
            TextFormField(
              controller: _displayNameController,
              decoration: InputDecoration(
                labelText: 'First Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // Middle Name
            TextFormField(
              controller: _middleNameController,
              decoration: InputDecoration(
                labelText: 'Middle Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // Last Name
            TextFormField(
              controller: _lastNameController,
              decoration: InputDecoration(
                labelText: 'Last Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // Date of Birth
            TextFormField(
              controller: _dobController,
              decoration: InputDecoration(
                labelText: 'Date of Birth',
                border: OutlineInputBorder(),
                suffixIcon: Icon(Icons.calendar_today),
              ),
              readOnly: true,
              onTap: () => _selectDate(context),
            ),
            SizedBox(height: 20),
            // Phone Number
            TextFormField(
              controller: _phoneController,
              decoration: InputDecoration(
                labelText: 'Phone Number',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // Gender
            DropdownButtonFormField<String>(
              value: _selectedGender,
              decoration: InputDecoration(
                labelText: 'Gender',
                border: OutlineInputBorder(),
              ),
              items: ['Male', 'Female', 'Other'].map((String gender) {
                return DropdownMenuItem<String>(
                  value: gender,
                  child: Text(gender),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedGender = newValue!;
                });
              },
            ),
            SizedBox(height: 20),
            // Spouse Name
            TextFormField(
              controller: _spouseController,
              decoration: InputDecoration(
                labelText: 'Spouse Name',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // Spouse Occupation
            TextFormField(
              controller: _spouseOccupationController,
              decoration: InputDecoration(
                labelText: 'Spouse Occupation',
                border: OutlineInputBorder(),
              ),
            ),
            SizedBox(height: 20),
            // City
            DropdownButtonFormField<String>(
              value: _selectedCity,
              decoration: InputDecoration(
                labelText: 'City',
                border: OutlineInputBorder(),
              ),
              items: [
                'Angat',
                'Balagtas',
                'Baliuag',
                'Bocaue',
                'Bulakan',
                'Bustos',
                'Calumpit',
                'Doña Remedios Trinidad',
                'Guiguinto',
                'Hagonoy',
                'Marilao',
                'Norzagaray',
                'Obando',
                'Pandi',
                'Paombong',
                'Plaridel',
                'Pulilan',
                'San Ildefonso',
                'San Miguel',
                'San Rafael',
                'Santa Maria',
              ].map((String city) {
                return DropdownMenuItem<String>(
                  value: city,
                  child: Text(city),
                );
              }).toList(),
              onChanged: (String? newValue) {
                setState(() {
                  _selectedCity = newValue!;
                });
              },
            ),
            SizedBox(height: 24),
            ElevatedButton(
              onPressed: () async {
                // Save profile changes
                await _uploadImage();
                await _saveProfile();
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF580049),
                foregroundColor: Colors.white,
                minimumSize: const Size(double.infinity, 55),
              ),
              child: const Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Save Changes',
                    style: TextStyle(color: Colors.white, fontSize: 18),
                  ),
                  SizedBox(width: 10), // Add some space between text and icon
                  Icon(
                    Icons.arrow_forward,
                    color: Colors.white,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _saveProfile() async {
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      final userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      final data = userData.data();

      if (data == null) return;

      Map<String, dynamic> updatedData = {
        'display_name': _displayNameController.text,
        'middle_name': _middleNameController.text,
        'last_name': _lastNameController.text,
        'dob': Timestamp.fromDate(_selectedDate),
        'phone': _phoneController.text,
        'gender': _selectedGender,
        'spouse': _spouseController.text,
        'spouseOccupation': _spouseOccupationController.text,
        'city': _selectedCity,
        'photo_url': _photoUrl,
      };

      // Detect changes and map to user-friendly labels
      Map<String, String> fieldLabels = {
        'display_name': 'First Name',
        'middle_name': 'Middle Name',
        'last_name': 'Last Name',
        'dob': 'Date of Birth',
        'phone': 'Phone Number',
        'gender': 'Gender',
        'spouse': 'Spouse Name',
        'spouseOccupation': 'Spouse\'s Occupation',
        'city': 'City',
        'photo_url': 'Profile Picture',
      };

      List<String> changes = [];
      updatedData.forEach((key, value) {
        if (data[key] != value) {
          changes.add(fieldLabels[key] ?? key);
        }
      });

      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update(updatedData);

      await _sendNotification(user.uid, changes);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Profile updated successfully')),
      );
    }
  }

  Future<void> _sendNotification(String uid, List<String> changes) async {
    final notificationDoc =
        FirebaseFirestore.instance.collection('notifications').doc();

    String changeMessage =
        'Your profile has been updated successfully. Changes: ${changes.join(', ')}.';

    await notificationDoc.set({
      'notifId': notificationDoc.id,
      'uid': uid,
      'message': changeMessage,
      'type': 'profile_update',
      'read': false,
      'timestamp': FieldValue.serverTimestamp(),
    });
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _middleNameController.dispose();
    _lastNameController.dispose();
    _dobController.dispose();
    _phoneController.dispose();
    _spouseController.dispose();
    _spouseOccupationController.dispose();
    super.dispose();
  }
}

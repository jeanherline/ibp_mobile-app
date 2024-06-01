import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'progress_bar.dart'; // Import the custom progress bar widget
import 'form_state_provider.dart';
import 'employment_profile.dart';

class ApplicantProfile extends StatefulWidget {
  const ApplicantProfile({super.key});

  @override
  _ApplicantProfileState createState() => _ApplicantProfileState();
}

class _ApplicantProfileState extends State<ApplicantProfile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _fullNameController = TextEditingController();
  final TextEditingController _dobController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _contactNumberController =
      TextEditingController();
  final TextEditingController _spouseNameController = TextEditingController();
  final TextEditingController _spouseOccupationController =
      TextEditingController();
  final TextEditingController _childrenNamesAgesController =
      TextEditingController();
  String? _selectedGender;

  @override
  void initState() {
    super.initState();
    _fetchUserData();
    final formState = context.read<FormStateProvider>();
    _fullNameController.text = formState.fullName;
    _dobController.text = formState.dob;
    _addressController.text = formState.address;
    _contactNumberController.text = formState.contactNumber;
    _spouseNameController.text = formState.spouseName;
    _spouseOccupationController.text = formState.spouseOccupation;
    _childrenNamesAgesController.text = formState.childrenNamesAges;
    _selectedGender =
        formState.selectedGender.isNotEmpty ? formState.selectedGender : null;
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot userData = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();

      if (userData.exists) {
        String displayName = userData['display_name'] ?? '';
        String middleName = userData['middle_name'] ?? '';
        String lastName = userData['last_name'] ?? '';
        String fullName = '$displayName $middleName $lastName';

        setState(() {
          _fullNameController.text = fullName.trim();
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: const [
            Text(
              'Isumite ang Suliraning Legal',
              style: TextStyle(
                  color: Colors.black,
                  fontSize: 20,
                  fontWeight: FontWeight.bold),
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
                    child: CustomProgressBar(currentStep: 0, totalSteps: 6),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'Applicant\'s Profile',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    'Buong Pangalan',
                    'Full Name',
                    _fullNameController,
                    'Ilagay ang buong pangalan (Enter full name)',
                    true,
                  ),
                  const SizedBox(height: 20),
                  _buildDateField(
                    'Araw ng Kapanganakan',
                    'Date of Birth',
                    _dobController,
                    'Ilagay ang araw ng kapanganakan (Enter date of birth)',
                    true,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    'Adres o Tinitirahan',
                    'Address',
                    _addressController,
                    'Ilagay ang adres o tinitirahan (Enter full address)',
                    true,
                  ),
                  const SizedBox(height: 20),
                  _buildNumberField(
                    'Numero ng Telepono',
                    'Contact Number',
                    _contactNumberController,
                    'Ilagay ang numero ng telepono (Enter contact number)',
                    true,
                  ),
                  const SizedBox(height: 20),
                  _buildDropdownField(
                    'Kasarian',
                    'Gender',
                    ['Male', 'Female', 'Other'],
                    _selectedGender,
                    'Piliin ang kasarian (Choose gender)',
                    true,
                    (value) {
                      setState(() {
                        _selectedGender = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    'Pangalan ng Asawa',
                    'Name of Spouse',
                    _spouseNameController,
                    'Ilagay ang pangalan ng asawa (Enter spouse’s name)',
                    false,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    'Trabaho ng Asawa',
                    'Occupation of Spouse',
                    _spouseOccupationController,
                    'Ilagay ang trabaho ng asawa (Enter spouse’s occupation)',
                    false,
                  ),
                  const SizedBox(height: 20),
                  _buildTextAreaField(
                    'Kung kasal, ilagay ang pangalan ng mga anak at edad nila',
                    'If married, write name of children and age',
                    _childrenNamesAgesController,
                    'Ilagay ang pangalan at edad ng mga anak\n(Enter children’s name and age)',
                    false,
                  ),
                  const SizedBox(height: 30),
                  Center(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        minimumSize: const Size(double.infinity, 55),
                        backgroundColor: const Color(0xFF580049),
                      ),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          // Save form state
                          final formState = context.read<FormStateProvider>();
                          formState.updateApplicantProfile(
                            fullName: _fullNameController.text,
                            dob: _dobController.text,
                            address: _addressController.text,
                            contactNumber: _contactNumberController.text,
                            selectedGender: _selectedGender ?? '',
                            spouseName: _spouseNameController.text,
                            spouseOccupation: _spouseOccupationController.text,
                            childrenNamesAges:
                                _childrenNamesAgesController.text,
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => const EmploymentProfile(),
                            ),
                          );
                        }
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
                          SizedBox(
                              width: 5), // Add some space between text and icon
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

  Widget _buildTextField(String label, String subLabel,
      TextEditingController controller, String hintText, bool isRequired) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: '$label ',
            style: const TextStyle(color: Colors.black, fontSize: 16),
            children: [
              TextSpan(
                text: '($subLabel)',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field cannot be empty';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildDateField(String label, String subLabel,
      TextEditingController controller, String hintText, bool isRequired) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: '$label ',
            style: const TextStyle(color: Colors.black, fontSize: 16),
            children: [
              TextSpan(
                text: '($subLabel)',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          readOnly: true,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          onTap: () async {
            DateTime? pickedDate = await showDatePicker(
              context: context,
              initialDate: DateTime.now(),
              firstDate: DateTime(1900),
              lastDate: DateTime.now(),
            );

            if (pickedDate != null) {
              setState(() {
                controller.text =
                    "${pickedDate.year}-${pickedDate.month}-${pickedDate.day}";
              });
            }
          },
          validator: isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field cannot be empty';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildNumberField(String label, String subLabel,
      TextEditingController controller, String hintText, bool isRequired) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: '$label ',
            style: const TextStyle(color: Colors.black, fontSize: 16),
            children: [
              TextSpan(
                text: '($subLabel)',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          keyboardType: TextInputType.number,
          inputFormatters: [
            FilteringTextInputFormatter.digitsOnly,
          ],
          validator: isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field cannot be empty';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildDropdownField(
      String label,
      String subLabel,
      List<String> items,
      String? selectedItem,
      String hintText,
      bool isRequired,
      ValueChanged<String?> onChanged) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: '$label ',
            style: const TextStyle(color: Colors.black, fontSize: 16),
            children: [
              TextSpan(
                text: '($subLabel)',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        DropdownButtonFormField<String>(
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          items: items.map((item) {
            return DropdownMenuItem<String>(
              value: item,
              child: Text(item),
            );
          }).toList(),
          value: selectedItem,
          onChanged: onChanged,
          validator: isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field cannot be empty';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }

  Widget _buildTextAreaField(String label, String subLabel,
      TextEditingController controller, String hintText, bool isRequired) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: TextSpan(
            text: '$label ',
            style: const TextStyle(color: Colors.black, fontSize: 16),
            children: [
              TextSpan(
                text: '($subLabel)',
                style: const TextStyle(color: Colors.grey, fontSize: 12),
              ),
              if (isRequired)
                const TextSpan(
                  text: ' *',
                  style: TextStyle(color: Colors.red),
                ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        TextFormField(
          controller: controller,
          maxLines: 4,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
              fontSize: 15,
              fontStyle: FontStyle.italic,
              color: Colors.grey,
            ),
            contentPadding:
                const EdgeInsets.symmetric(vertical: 18.0, horizontal: 12.0),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          validator: isRequired
              ? (value) {
                  if (value == null || value.isEmpty) {
                    return 'This field cannot be empty';
                  }
                  return null;
                }
              : null,
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:provider/provider.dart';
import 'form_state_provider.dart';
import 'nature_of_legal_assitance_requested.dart';
import 'progress_bar.dart'; // Import the custom progress bar widget

class EmploymentProfile extends StatefulWidget {
  const EmploymentProfile({Key? key}) : super(key: key);

  @override
  _EmploymentProfileState createState() => _EmploymentProfileState();
}

class _EmploymentProfileState extends State<EmploymentProfile> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _occupationController = TextEditingController();
  final TextEditingController _employerNameController = TextEditingController();
  final TextEditingController _employerAddressController =
      TextEditingController();
  final TextEditingController _monthlyIncomeController =
      TextEditingController();

  // Define dropdown options for "Klase ng Trabaho"
  final List<String> employmentOptions = [
    'Lokal na Trabaho (Local Employer/Agency)',
    'Dayuhang Amo (Foreign Employer)',
    'Sa sarili nagtatrabaho (Self-Employed)',
    'Iba pa (Others)'
  ];

  String? _selectedEmploymentOption;

  @override
  void initState() {
    super.initState();
    final formState = context.read<FormStateProvider>();
    _occupationController.text = formState.occupation;
    _employerNameController.text = formState.employerName;
    _employerAddressController.text = formState.employerAddress;
    _monthlyIncomeController.text = formState.monthlyIncome;

    // Ensure _selectedEmploymentOption is set to a valid option or null
    _selectedEmploymentOption = formState.kindOfEmployment.isNotEmpty &&
            employmentOptions.contains(formState.kindOfEmployment)
        ? formState.kindOfEmployment
        : null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () {
            // Save the current text values when navigating back
            _saveTextValues();
            Navigator.of(context).pop();
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
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 10),
                  const Center(
                    child: CustomProgressBar(currentStep: 1, totalSteps: 6),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'Impormasyon patungkol sa Trabaho',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Center(
                    child: Text(
                      '(Employment Profile, if any)',
                      style: TextStyle(color: Colors.grey, fontSize: 14),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    'Hanapbuhay',
                    'Occupation',
                    _occupationController,
                    'Ilagay ang hanapbuhay (Enter occupation)',
                    true,
                  ),
                  const SizedBox(height: 20),
                  _buildDropdownField(
                    'Klase ng Trabaho',
                    'Kind of Employment',
                    _selectedEmploymentOption,
                    employmentOptions,
                    'Piliin ang klase ng trabaho (Choose kind of employment)',
                    true,
                    (String? newValue) {
                      setState(() {
                        _selectedEmploymentOption = newValue;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    'Pangalan ng iyong Amo',
                    'Employer’s Name',
                    _employerNameController,
                    'Ilagay ang pangalan ng amo (Enter employer’s name)',
                    false,
                  ),
                  const SizedBox(height: 20),
                  _buildTextField(
                    'Adres o Tinitirahan ng amo',
                    'Employer’s Address',
                    _employerAddressController,
                    'Ilagay ang adres o tinitirahan ng amo (Enter employer’s address)',
                    false,
                  ),
                  const SizedBox(height: 20),
                  _buildNumberField(
                    'Buwanang sahod ng buong pamilya',
                    'Monthly Family Income',
                    _monthlyIncomeController,
                    'Ilagay ang buwanang sahod ng buong pamilya (Enter family’s monthly income)',
                    true,
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
                          // Save the current text values before navigating forward
                          _saveTextValues();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const NatureOfLegalAssistanceRequested(),
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
                              style:
                                  TextStyle(fontSize: 18, color: Colors.white),
                              children: <TextSpan>[
                                TextSpan(
                                  text: '(Next)',
                                  style: TextStyle(
                                      fontSize: 18,
                                      fontStyle: FontStyle.italic),
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

  void _saveTextValues() {
    // Save the current text values
    final formState = context.read<FormStateProvider>();
    formState.updateEmploymentProfile(
      occupation: _occupationController.text,
      kindOfEmployment: _selectedEmploymentOption ?? '',
      employerName: _employerNameController.text,
      employerAddress: _employerAddressController.text,
      monthlyIncome: _monthlyIncomeController.text,
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
                fontSize: 15, fontStyle: FontStyle.italic, color: Colors.grey),
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
                fontSize: 15, fontStyle: FontStyle.italic, color: Colors.grey),
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
    String? selectedItem,
    List<String> items,
    String hintText,
    bool isRequired,
    ValueChanged<String?> onChanged,
  ) {
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
          value: selectedItem,
          items: items.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(value),
            );
          }).toList(),
          onChanged: onChanged,
          decoration: InputDecoration(
            hintText: hintText,
            hintStyle: const TextStyle(
                fontSize: 15, fontStyle: FontStyle.italic, color: Colors.grey),
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

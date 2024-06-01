import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'form_state_provider.dart';
import 'barangay_certificate_of_indigency.dart';
import 'progress_bar.dart'; // Import the custom progress bar widget

class NatureOfLegalAssistanceRequested extends StatefulWidget {
  const NatureOfLegalAssistanceRequested({super.key});

  @override
  _NatureOfLegalAssistanceRequestedState createState() =>
      _NatureOfLegalAssistanceRequestedState();
}

class _NatureOfLegalAssistanceRequestedState
    extends State<NatureOfLegalAssistanceRequested> {
  final _formKey = GlobalKey<FormState>();
  String? _selectedAssistanceType;
  final TextEditingController _problemsController = TextEditingController();
  final TextEditingController _problemReasonController =
      TextEditingController();
  final TextEditingController _desiredSolutionsController =
      TextEditingController();

  final List<String> assistanceOptions = [
    'Payong Legal (Legal Advice)',
    'Legal na Representasyon (Legal Representation)',
    'Pag gawa ng Legal na Dokumento (Drafting of Legal Document)'
  ];

  @override
  void initState() {
    super.initState();
    final formState = context.read<FormStateProvider>();
    _selectedAssistanceType = formState.selectedAssistanceType.isNotEmpty &&
            assistanceOptions.contains(formState.selectedAssistanceType)
        ? formState.selectedAssistanceType
        : null;
    _problemsController.text = formState.problems;
    _problemReasonController.text = formState.problemReason;
    _desiredSolutionsController.text = formState.desiredSolutions;
  }

  @override
  Widget build(BuildContext context) {
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
                    child: CustomProgressBar(currentStep: 2, totalSteps: 6),
                  ),
                  const SizedBox(height: 20),
                  const Center(
                    child: Text(
                      'Nature of Legal Assistance Requested',
                      style:
                          TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const SizedBox(height: 20),
                  _buildDropdownField(
                    'Klase ng tulong legal',
                    'Nature of Legal assistance',
                    assistanceOptions,
                    _selectedAssistanceType,
                    'Piliin ang klase ng tulong legal (Choose nature of legal assistance)',
                    true,
                    (value) {
                      setState(() {
                        _selectedAssistanceType = value;
                      });
                    },
                  ),
                  const SizedBox(height: 20),
                  _buildTextAreaField(
                    'Ano ang iyong problema?',
                    'Enter your problem/s or complaint/s',
                    _problemsController,
                    'Ilagay ang iyong problema (Enter your problem/s or complaint/s)',
                    true,
                  ),
                  const SizedBox(height: 20),
                  _buildTextAreaField(
                    'Bakit o papaano nagkaroon ng ganoong problema?',
                    'Why or how did such problem/s arise?',
                    _problemReasonController,
                    'Ilagay ang dahilan ng problema (Enter the reason why or how the problem/s arise)',
                    true,
                  ),
                  const SizedBox(height: 20),
                  _buildTextAreaField(
                    'Ano ang mga maaaring solusyon na gusto mong ibigay ng Abogado sa iyo?',
                    'What possible solution/s would you like to be given by the lawyer to you?',
                    _desiredSolutionsController,
                    'Ilagay ang mga maaaring solusyon (Enter the possible solution/s would you like)',
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
                          // Save form state
                          final formState = context.read<FormStateProvider>();
                          formState.updateNatureOfLegalAssistanceRequested(
                            selectedAssistanceType:
                                _selectedAssistanceType ?? '',
                            problems: _problemsController.text,
                            problemReason: _problemReasonController.text,
                            desiredSolutions: _desiredSolutionsController.text,
                          );

                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) =>
                                  const BarangayCertificateOfIndigency(),
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

  Widget _buildDropdownField(
    String label,
    String subLabel,
    List<String> items,
    String? selectedItem,
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
        LayoutBuilder(
          builder: (BuildContext context, BoxConstraints constraints) {
            return Container(
              width: constraints.maxWidth,
              child: DropdownButtonFormField<String>(
                isExpanded: true,
                decoration: InputDecoration(
                  hintText: hintText,
                  hintStyle: const TextStyle(
                      fontSize: 15,
                      fontStyle: FontStyle.italic,
                      color: Colors.grey),
                  contentPadding: const EdgeInsets.symmetric(
                      vertical: 18.0, horizontal: 10.0),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                items: items.map((item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      overflow: TextOverflow.ellipsis,
                    ),
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
            );
          },
        ),
      ],
    );
  }

  Widget _buildTextAreaField(
    String label,
    String subLabel,
    TextEditingController controller,
    String hintText,
    bool isRequired,
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
        TextFormField(
          controller: controller,
          maxLines: 4,
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

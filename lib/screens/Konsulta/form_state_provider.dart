import 'package:flutter/material.dart';

class FormStateProvider extends ChangeNotifier {
  // Applicant profile fields
  String fullName = '';
  String dob = '';
  String address = '';
  String city = ''; // Added city field
  String contactNumber = '';
  String selectedGender = '';
  String spouseName = '';
  String spouseOccupation = '';
  String childrenNamesAges = '';

  // Employment profile fields
  String occupation = '';
  String kindOfEmployment = '';
  String employerName = '';
  String employerAddress = '';
  String monthlyIncome = '';

  // Nature of legal assistance requested fields
  String selectedAssistanceType = '';
  String problems = '';
  String problemReason = '';
  String desiredSolutions = '';

  // Image upload fields for Barangay, DSWD, and PAO
  ImageProvider? barangaySelectedImage;
  ImageProvider? dswdSelectedImage;
  ImageProvider? paoSelectedImage;

  // Control number field
  String controlNumber = '';

  get qrCodeImageUrl => null;

  // Update methods for applicant profile
  void updateApplicantProfile({
    required String fullName,
    required String dob,
    required String address,
    required String city, // Added city parameter
    required String contactNumber,
    required String selectedGender,
    required String spouseName,
    required String spouseOccupation,
    required String childrenNamesAges,
  }) {
    this.fullName = fullName;
    this.dob = dob;
    this.address = address;
    this.city = city; // Added city field
    this.contactNumber = contactNumber;
    this.selectedGender = selectedGender;
    this.spouseName = spouseName;
    this.spouseOccupation = spouseOccupation;
    this.childrenNamesAges = childrenNamesAges;
    notifyListeners();
  }

  // Update methods for employment profile
  void updateEmploymentProfile({
    required String occupation,
    required String kindOfEmployment,
    required String employerName,
    required String employerAddress,
    required String monthlyIncome,
  }) {
    this.occupation = occupation;
    this.kindOfEmployment = kindOfEmployment;
    this.employerName = employerName;
    this.employerAddress = employerAddress;
    this.monthlyIncome = monthlyIncome;
    notifyListeners();
  }

  // Update methods for nature of legal assistance requested
  void updateNatureOfLegalAssistanceRequested({
    required String selectedAssistanceType,
    required String problems,
    required String problemReason,
    required String desiredSolutions,
  }) {
    this.selectedAssistanceType = selectedAssistanceType;
    this.problems = problems;
    this.problemReason = problemReason;
    this.desiredSolutions = desiredSolutions;
    notifyListeners();
  }

  // Update method for Barangay image upload
  void setBarangaySelectedImage(ImageProvider image) {
    barangaySelectedImage = image;
    notifyListeners();
  }

  // Update method for DSWD image upload
  void setDSWDSelectedImage(ImageProvider image) {
    dswdSelectedImage = image;
    notifyListeners();
  }

  // Update method for PAO image upload
  void setPAOSelectedImage(ImageProvider image) {
    paoSelectedImage = image;
    notifyListeners();
  }

  // Update method for control number
  void setControlNumber(String number) {
    controlNumber = number;
    notifyListeners();
  }

  // Clear form state
  void clearFormState() {
    fullName = '';
    dob = '';
    address = '';
    city = ''; // Clear city field
    contactNumber = '';
    selectedGender = '';
    spouseName = '';
    spouseOccupation = '';
    childrenNamesAges = '';

    occupation = '';
    kindOfEmployment = '';
    employerName = '';
    employerAddress = '';
    monthlyIncome = '';

    selectedAssistanceType = '';
    problems = '';
    problemReason = '';
    desiredSolutions = '';

    barangaySelectedImage = null;
    dswdSelectedImage = null;
    paoSelectedImage = null;

    controlNumber = '';

    notifyListeners();
  }
}

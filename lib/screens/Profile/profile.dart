import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:ibp_app_ver2/navbar.dart';
import 'package:ibp_app_ver2/qr_code_scanner_screen.dart';
import 'package:ibp_app_ver2/screens/Profile/edit_profile.dart';

class Profile extends StatefulWidget {
  const Profile({super.key});

  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<Profile> {
  String _displayName = '';
  String _email = '';
  String _city = '';
  String _memberType = '';
  int _selectedRating = 0;
  String _photoUrl = '';

  @override
  void initState() {
    super.initState();
    _fetchUserEmail();
  }

  Future<void> _fetchUserEmail() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      setState(() {
        _email = user.email ?? '';
      });
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  Future<void> _showRatingDialog() async {
    return showDialog<void>(
      context: context,
      barrierDismissible: false, // user must tap button!
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Rate our App'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const Text('Ang iyong puna ay makakatulong sa pagbuti ng app'),
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

  Future<void> _submitRating() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .update({'appRating': _selectedRating});
    }
    ScaffoldMessenger.of(context).showSnackBar(
      const SnackBar(
        content: Text('Thank you for rating!'),
      ),
    );
    _signOut();
  }

  Future<void> _updateProfileImage(String newPhotoUrl) async {
    setState(() {
      _photoUrl = newPhotoUrl;
    });
  }

  @override
  Widget build(BuildContext context) {
    User? user = FirebaseAuth.instance.currentUser;

    return Scaffold(
      backgroundColor: const Color(0xFFF5F5F5),
      appBar: AppBar(
        backgroundColor: const Color(0xFF580049),
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Colors.white,
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        top: true,
        child: Stack(
          children: [
            StreamBuilder<DocumentSnapshot>(
              stream: FirebaseFirestore.instance
                  .collection('users')
                  .doc(user?.uid)
                  .snapshots(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return const Center(child: CircularProgressIndicator());
                }

                if (snapshot.hasError) {
                  return const Center(child: Text('Something went wrong'));
                }

                if (snapshot.hasData && snapshot.data != null) {
                  final data = snapshot.data!.data() as Map<String, dynamic>?;

                  if (data != null) {
                    _photoUrl = data['photo_url'] ??
                        'https://as2.ftcdn.net/v2/jpg/03/49/49/79/1000_F_349497933_Ly4im8BDmHLaLzgyKg2f2yZOvJjBtlw5.jpg';
                    String firstName = data['display_name'] ?? '';
                    String middleName = data['middle_name'] ?? '';
                    String lastName = data['last_name'] ?? '';
                    _displayName = '$firstName $middleName $lastName';
                    _city = data['city'] ?? '';
                    _memberType = data['member_type'] ?? '';
                    _selectedRating = data['appRating'] ?? 0;
                  }
                }

                return SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 20.0),
                        child: CircleAvatar(
                          radius: 65,
                          backgroundImage: NetworkImage(
                            _photoUrl.isNotEmpty
                                ? _photoUrl
                                : 'https://as2.ftcdn.net/v2/jpg/03/49/49/79/1000_F_349497933_Ly4im8BDmHLaLzgyKg2f2yZOvJjBtlw5.jpg',
                          ),
                        ),
                      ),
                      Text(
                        _displayName,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                          color: Color(0xFF333333),
                        ),
                      ),
                      Text(
                        _email,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          color: Color(0xFF777777),
                        ),
                      ),
                      Text(
                        _city,
                        style: const TextStyle(
                          fontFamily: 'Roboto',
                          fontSize: 16,
                          color: Color(0xFF777777),
                        ),
                      ),
                      const SizedBox(height: 20), // Add space below the city
                      Container(
                        padding: const EdgeInsets.all(16.0),
                        margin: const EdgeInsets.symmetric(horizontal: 20.0),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                              color: Colors.black12,
                              blurRadius: 5,
                              offset: Offset(0, 5),
                            ),
                          ],
                        ),
                        child: const Text(
                          'Daily Quotes:\nAng hustisya ay hindi lang isang salita; ito ay isang pangako sa pagiging makatarungan, katotohanan, at ang proteksyon ng mga karapatan.',
                          style: TextStyle(
                            fontFamily: 'Roboto',
                            fontSize: 14,
                            color: Color(0xFF333333),
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                      const SizedBox(height: 20),
                      if (_memberType == 'frontdesk')
                        ProfileButton(
                          icon: Icons.qr_code_scanner,
                          label: 'Front Desk QR Scanner',
                          onPressed: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                  builder: (context) => QRCodeScannerScreen()),
                            );
                          },
                        ),
                      ProfileButton(
                        icon: Icons.edit,
                        label: 'I-edit ang Profile',
                        onPressed: () async {
                          final newPhotoUrl = await Navigator.of(context).push(
                            MaterialPageRoute(
                                builder: (context) => EditProfile()),
                          );
                          if (newPhotoUrl != null) {
                            _updateProfileImage(newPhotoUrl);
                          }
                        },
                      ),
                      ProfileButton(
                        icon: Icons.settings,
                        label: 'Settings',
                        onPressed: () {
                          print('Settings pressed');
                        },
                      ),
                      ProfileButton(
                        icon: Icons.favorite,
                        label: 'Tulong at Suporta',
                        onPressed: () {
                          print('Tulong at Suporta pressed');
                        },
                      ),
                      ProfileButton(
                        icon: Icons.logout,
                        label: 'Logout',
                        onPressed: _showRatingDialog,
                      ),
                      const SizedBox(
                          height:
                              90), // Add some space above the navigation bar
                    ],
                  ),
                );
              },
            ),
            const Align(
              alignment: Alignment.bottomCenter,
              child: CustomNavigationBar(),
            ),
          ],
        ),
      ),
    );
  }
}

class ProfileButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onPressed;

  ProfileButton({
    required this.icon,
    required this.label,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10.0, horizontal: 20.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          foregroundColor: Colors.black,
          backgroundColor: Colors.white,
          shadowColor: Colors.grey[50],
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10.0),
          ),
          padding: const EdgeInsets.symmetric(vertical: 15.0),
        ),
        onPressed: onPressed,
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(10.0),
              decoration: BoxDecoration(
                color: Colors.grey[200],
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(
                icon,
                size: 30,
                color: Colors.grey[700],
              ),
            ),
            const SizedBox(width: 20),
            Text(
              label,
              style: const TextStyle(
                fontFamily: 'Roboto',
                fontSize: 16,
                fontWeight: FontWeight.bold,
                color: Color(0xFF333333),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

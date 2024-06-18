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

  @override
  void initState() {
    super.initState();
    _fetchUserData();
  }

  Future<void> _fetchUserData() async {
    User? user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      DocumentSnapshot users = await FirebaseFirestore.instance
          .collection('users')
          .doc(user.uid)
          .get();
      setState(() {
        String firstName = users['display_name'] ?? '';
        String middleName = users['middle_name'] ?? '';
        String lastName = users['last_name'] ?? '';
        _displayName = '$firstName $middleName $lastName';
        _email = user.email ?? '';
        _city = users['city'] ?? '';
        _memberType = users['member_type'] ?? '';
      });
    }
  }

  Future<void> _signOut() async {
    await FirebaseAuth.instance.signOut();
    Navigator.of(context).pushReplacementNamed('/login');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFFFFFFFF),
      appBar: AppBar(
        backgroundColor: const Color(0xFFFFFFFF),
        automaticallyImplyLeading: false,
        elevation: 0,
        title: const Text(
          'Profile',
          style: TextStyle(
            fontFamily: 'Roboto',
            color: Color(0xFF580049),
            fontSize: 24,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: SafeArea(
        top: true,
        child: Stack(
          children: [
            SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.max,
                children: [
                  Padding(
                    padding: const EdgeInsetsDirectional.fromSTEB(0, 0, 0, 30),
                    child: Row(
                      mainAxisSize: MainAxisSize.max,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(100),
                          child: Image.network(
                            'https://encrypted-tbn0.gstatic.com/images?q=tbn:ANd9GcQvCibYwqUu8UVjFCKDtsxEeGQNtXqgPIwzSw&usqp=CAU',
                            width: 130,
                            height: 130,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Text(
                    _displayName,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _email,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  Text(
                    _city,
                    style: const TextStyle(
                      fontFamily: 'Roboto',
                      color: Color(0xFF7A7979),
                      fontSize: 16,
                    ),
                  ),
                  const SizedBox(height: 20), // Add space below the city
                  Container(
                    padding: const EdgeInsets.all(16.0),
                    color: Colors.grey[200],
                    child: const Text(
                      'Daily Quotes:\nAng hustisya ay hindi lang isang salita; ito ay isang pangako sa pagiging makatarungan, katotohanan, at ang proteksyon ng mga karapatan.',
                      style: TextStyle(
                        fontFamily: 'Roboto',
                        fontSize: 14,
                        color: Colors.black,
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
                    onPressed: () {
                      Navigator.of(context).push(
                        MaterialPageRoute(
                            builder: (context) => const EditProfile()),
                      );
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
                    onPressed: _signOut,
                  ),
                  const SizedBox(
                      height: 90), // Add some space above the navigation bar
                ],
              ),
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
      padding: const EdgeInsetsDirectional.fromSTEB(0, 10, 0, 10),
      child: Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Container(
            width: 70,
            height: 70,
            decoration: BoxDecoration(
              color: const Color(0xFFD9D9D9),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(
              icon,
              color: const Color(0xFF7A7979),
              size: 40,
            ),
          ),
          const SizedBox(width: 10),
          Container(
            width: 230,
            height: 60,
            decoration: BoxDecoration(
              color: const Color(0xFFE8EAED),
              borderRadius: BorderRadius.circular(8),
            ),
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                foregroundColor: Colors.black,
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
                padding: const EdgeInsets.symmetric(horizontal: 24),
              ),
              onPressed: onPressed,
              child: Text(
                label,
                style: const TextStyle(
                  fontFamily: 'Roboto',
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

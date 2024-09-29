import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:ibp_app_ver2/screens/home.dart';
import 'package:fluttertoast/fluttertoast.dart';

class OTPScreen extends StatefulWidget {
  final String email;
  OTPScreen({Key? key, required this.email}) : super(key: key);

  @override
  _OTPScreenState createState() => _OTPScreenState();
}

class _OTPScreenState extends State<OTPScreen> {
  bool _isLinkSent = false;

  @override
  void initState() {
    super.initState();
    _sendSignInLinkToEmail();
  }

  void _sendSignInLinkToEmail() async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      // Set up action code settings to define how the email link should be opened.
      ActionCodeSettings actionCodeSettings = ActionCodeSettings(
        url: 'https://yourapp.page.link/verifyemail', // Replace with your dynamic link or app URL
        handleCodeInApp: true,
        androidPackageName: 'com.example.ibp_app_ver2', // Your Android package name
        androidInstallApp: true,
        androidMinimumVersion: '12',
        iOSBundleId: 'com.example.ibpAppVer2', // Your iOS bundle ID
      );

      // Send sign-in link to email
      await auth.sendSignInLinkToEmail(
        email: widget.email,
        actionCodeSettings: actionCodeSettings,
      );

      Fluttertoast.showToast(msg: "Sign-in link sent to ${widget.email}");
      setState(() {
        _isLinkSent = true;
      });
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to send link: $e");
    }
  }

  Future<void> _signInWithEmailLink(String email, String emailLink) async {
    final FirebaseAuth auth = FirebaseAuth.instance;

    try {
      // Check if the email link is valid
      if (auth.isSignInWithEmailLink(emailLink)) {
        // Complete sign-in with the email and link
        final UserCredential userCredential =
            await auth.signInWithEmailLink(email: email, emailLink: emailLink);

        final User? user = userCredential.user;
        if (user != null) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Home()),
          );
        }
      }
    } catch (e) {
      Fluttertoast.showToast(msg: "Failed to sign in: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Email OTP Verification')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            if (!_isLinkSent)
              CircularProgressIndicator() // Show loading indicator until the email is sent
            else
              Text(
                'A sign-in link has been sent to ${widget.email}. Please check your email to continue.',
                style: TextStyle(fontSize: 16),
              ),
          ],
        ),
      ),
    );
  }
}

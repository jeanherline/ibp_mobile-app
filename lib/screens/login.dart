import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart'; // Import Google Sign-In package
import 'package:ibp_app_ver2/screens/home.dart';
import 'package:ibp_app_ver2/screens/signup.dart';
import 'package:cloud_firestore/cloud_firestore.dart';

class Login extends StatefulWidget {
  const Login({Key? key}) : super(key: key);

  @override
  _LoginState createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _passwordVisible = false;
  bool _isLoading = false;

  Future<bool> checkUserStatus(String? userId) async {
    try {
      if (userId == null) {
        return false;
      }

      DocumentSnapshot<Map<String, dynamic>> userDoc = await FirebaseFirestore
          .instance
          .collection('users')
          .doc(userId)
          .get();

      if (userDoc.exists &&
          userDoc.data() != null &&
          userDoc.data()!.containsKey('user_status')) {
        String userStatus = userDoc.data()!['user_status'];
        if (userStatus == 'active') {
          return true;
        }
      }
      return false;
    } catch (e) {
      print('Error checking user status: $e');
      return false;
    }
  }

  Future<void> _signIn() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text.trim(),
      );

      User? user = userCredential.user;
      if (user != null && !user.emailVerified) {
        await user.reload();
        user = FirebaseAuth.instance.currentUser;
      }

      if (user != null && user.emailVerified) {
        // Update user status to active in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'user_status': 'active'});
      }

      bool isActive = await checkUserStatus(user?.uid);

      if (isActive) {
        Navigator.of(context).pushReplacement(
          MaterialPageRoute(builder: (context) => const Home()),
        );
      } else {
        showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Sign In Failed'),
            content: const Text('Your account is not active.'),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text('OK'),
              ),
            ],
          ),
        );
      }
    } on FirebaseAuthException catch (e) {
      String message;
      switch (e.code) {
        case 'user-not-found':
          message = 'No user found for that email.';
          break;
        case 'wrong-password':
          message = 'Wrong password provided.';
          break;
        default:
          message = 'An error occurred. Please try again.';
      }
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Sign In Failed'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

Future<void> _signInWithGoogle() async {
  try {
    // Create a GoogleSignIn instance with scopes
    final GoogleSignIn googleSignIn = GoogleSignIn(
      scopes: ['email', 'https://www.googleapis.com/auth/userinfo.profile'],
    );

    // Trigger the Google Authentication flow
    final GoogleSignInAccount? googleUser = await googleSignIn.signIn();
    final GoogleSignInAuthentication? googleAuth =
        await googleUser?.authentication;

    print('Google Authentication: ${googleAuth?.accessToken}, ${googleAuth?.idToken}');

    if (googleAuth?.accessToken != null && googleAuth?.idToken != null) {
      // Create a credential from the access token and idToken
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth?.accessToken, // Use ?. for nullable properties
        idToken: googleAuth?.idToken,
      );

      // Sign in to Firebase with the Google credential
      UserCredential userCredential =
          await FirebaseAuth.instance.signInWithCredential(credential);

      // Optionally, check user status and navigate to home
      User? user = userCredential.user;
      if (user != null) {
        // Update user status to active in Firestore
        await FirebaseFirestore.instance
            .collection('users')
            .doc(user.uid)
            .update({'user_status': 'active'});

        bool isActive = await checkUserStatus(user.uid);

        if (isActive) {
          Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => const Home()),
          );
        } else {
          showDialog(
            context: context,
            builder: (context) => AlertDialog(
              title: const Text('Sign In Failed'),
              content: const Text('Your account is not active.'),
              actions: [
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text('OK'),
                ),
              ],
            ),
          );
        }
      }
    } else {
      print('Google login failed: No access token or ID token');
      showDialog(
        context: context,
        builder: (context) => AlertDialog(
          title: const Text('Sign In Failed'),
          content: const Text('No access token or ID token was provided.'),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }
  } catch (e) {
    print('Error signing in with Google: $e');
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Sign In Failed'),
        content: Text('An error occurred while signing in: $e'),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }
}


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Padding(
          padding:
              const EdgeInsets.symmetric(vertical: 100.0, horizontal: 24.0),
          child: Column(
            children: [
              const Text(
                'Mag-Sign In',
                style: TextStyle(
                  color: Color(0xFF580049),
                  fontSize: 32.0,
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 48.0),
              TextField(
                controller: _emailController,
                decoration: InputDecoration(
                  labelText: 'Ilagay ang iyong email',
                  prefixIcon: const Icon(Icons.email),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                keyboardType: TextInputType.emailAddress,
              ),
              const SizedBox(height: 24.0),
              TextField(
                controller: _passwordController,
                decoration: InputDecoration(
                  labelText: 'Ilagay ang iyong password',
                  prefixIcon: const Icon(Icons.lock),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  suffixIcon: IconButton(
                    icon: Icon(
                      _passwordVisible
                          ? Icons.visibility
                          : Icons.visibility_off,
                    ),
                    onPressed: () {
                      setState(() {
                        _passwordVisible = !_passwordVisible;
                      });
                    },
                  ),
                ),
                obscureText: !_passwordVisible,
              ),
              const SizedBox(height: 8.0),
              Align(
                alignment: Alignment.centerRight,
                child: TextButton(
                  onPressed: () {
                    // TODO: Implement forgot password
                  },
                  child: const Text(
                    'Nakalimutan ang password?',
                    style: TextStyle(fontSize: 16),
                  ),
                ),
              ),
              const SizedBox(height: 24.0),
              _isLoading
                  ? const CircularProgressIndicator()
                  : ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF580049),
                        foregroundColor: Colors.white,
                        minimumSize: const Size(double.infinity, 55),
                      ),
                      onPressed: _signIn,
                      child: const Text(
                        'Sign In',
                        style: TextStyle(fontSize: 18),
                      ),
                    ),
              const SizedBox(height: 18),
              TextButton(
                onPressed: () {
                  Navigator.of(context).push(
                    MaterialPageRoute(builder: (context) => const SignUp()),
                  );
                },
                child: const Text(
                  'Wala pang account? Mag-Sign Up',
                  style: TextStyle(fontSize: 16),
                ),
              ),
              const SizedBox(
                height: 25,
              ),
              const OrDivider(), // Custom "OR" divider widget
              const SizedBox(
                height: 25,
              ),
              ElevatedButton(
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.black,
                  backgroundColor: Colors.white,
                  disabledForegroundColor: Colors.grey.withOpacity(0.38),
                  disabledBackgroundColor:
                      Colors.grey.withOpacity(0.12), // Outer border color
                  side: const BorderSide(
                    color: Colors.grey,
                    width: 1.0,
                  ), // Border width and color
                  minimumSize: const Size(double.infinity, 55),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10), // Rounded corners
                  ),
                ),
                onPressed: _signInWithGoogle, // Call the Google sign-in method
                child: const Text(
                  'Mag-sign in gamit ang Google',
                  style: TextStyle(fontSize: 18), // Set the font size here
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class OrDivider extends StatelessWidget {
  const OrDivider({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Row(
      children: const [
        Expanded(
          child: Divider(
            thickness: 1,
            color: Colors.grey,
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 16.0),
          child: Text('OR'),
        ),
        Expanded(
          child: Divider(
            thickness: 1,
            color: Colors.grey,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import '../services/firestore_service.dart';
import 'profile_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final FirestoreService _firestoreService = FirestoreService();

  bool _isLoading = false;
  bool _isLoginSuccessful = true;

  void _forgotPassword(BuildContext context) async {
    // Implement forgot password functionality
    // Navigate to password reset screen
  }

  void _checkUserProfile(BuildContext context, User user) async {
    var userProfile = await _firestoreService.getUserProfile(user.uid);
    if (userProfile.exists) {
      Navigator.pushReplacementNamed(context, '/home');
    } else {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => ProfileScreen(user: user)),
      );
    }
  }

  void _login() async {
    setState(() {
      _isLoading = true;
    });

    try {
      UserCredential userCredential =
      await FirebaseAuth.instance.signInWithEmailAndPassword(
        email: emailController.text,
        password: passwordController.text,
      );

      setState(() {
        _isLoading = false;
        _isLoginSuccessful = true;
      });

      if (userCredential.user!.emailVerified) {
        _checkUserProfile(context, userCredential.user!);
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Please verify your email first.'),
          ),
        );
      }
    } catch (e) {
      setState(() {
        _isLoading = false;
        _isLoginSuccessful = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to sign in: $e')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Image.asset(
              'assets/images/bhc_logo.png',
              width: 150,
              height: 150,
              fit: BoxFit.contain,
            ),
            SizedBox(height: 20),
            AnimatedContainer(
              duration: Duration(milliseconds: 300),
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: _isLoginSuccessful ? Colors.transparent : Colors.red.withOpacity(0.3),
                borderRadius: BorderRadius.circular(10),
              ),
              child: Column(
                children: [
                  TextField(
                    controller: emailController,
                    decoration: InputDecoration(labelText: 'Email'),
                  ),
                  TextField(
                    controller: passwordController,
                    decoration: InputDecoration(
                      labelText: 'Password',
                      suffixIcon: IconButton(
                        icon: Icon(Icons.visibility),
                        onPressed: () {
                          // Implement password visibility toggle
                        },
                      ),
                    ),
                    obscureText: true,
                  ),
                ],
              ),
            ),
            SizedBox(height: 20),
            _isLoading
                ? CircularProgressIndicator()
                : ElevatedButton(
              onPressed: _login,
              child: Text('Login'),
            ),
            SizedBox(height: 10),
            TextButton(
              onPressed: () {
                _forgotPassword(context);
              },
              child: Text('Forgot Password?'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pushReplacementNamed(context, '/register');
              },
              child: Text('Create Account'),
            ),
          ],
        ),
      ),
    );
  }
}

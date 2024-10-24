import 'package:flutter/material.dart';
import 'package:mauzoApp/presentation/login_empty_state_screen/LoginPage.dart'; // Ensure the correct path to your LoginPage
import 'package:shared_preferences/shared_preferences.dart'; // Import the shared_preferences package

class LogoutPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Logout"),
      ),
      body: Center(
        child: ElevatedButton(
          onPressed: () {
            // Call your logout function here
            _logout(context);
          },
          child: Text("Logout"),
        ),
      ),
    );
  }

  Future<void> _logout(BuildContext context) async {
    // Clear user session data
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.remove('userToken'); // Replace 'userToken' with your actual key

    // After logging out, navigate to the login page
    Navigator.pushAndRemoveUntil(
      context,
      MaterialPageRoute(builder: (context) => LoginPage()), 
      (Route<dynamic> route) => false, // Remove all previous routes
    );
  }
}

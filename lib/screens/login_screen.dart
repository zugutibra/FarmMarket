import 'package:flutter/material.dart';
import 'package:untitled/screens/buyer_registration_screen.dart';
import 'package:untitled/screens/farmer_registration_screen.dart';
import '../services/api_service.dart';
import 'buyer_screen.dart';

class LoginScreen extends StatefulWidget {
  @override
  _LoginScreenState createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final ApiService apiService = ApiService();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  String email = '', password = '';

  Future<void> _login() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      final response = await apiService.login(email, password);
      if (response.containsKey('id')) {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Login Successful!"))
        );
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => BuyerScreen()),
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text("Error: ${response['error']}"))
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Login")),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              TextFormField(
                decoration: InputDecoration(labelText: "Email"),
                onSaved: (value) => email = value!,
              ),
              TextFormField(
                decoration: InputDecoration(labelText: "Password"),
                obscureText: true,
                onSaved: (value) => password = value!,
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: _login,
                child: Text("Login"),
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => FarmerRegistrationScreen()),
                  );
                },
                child: Text("Farmer Registration"),
              ),
              ElevatedButton(
                onPressed: (){
                  Navigator.push(
                    context,
                    MaterialPageRoute(builder: (context) => BuyerRegistrationScreen()),
                  );
                },
                child: Text("Buyer Registration"),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
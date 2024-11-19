import 'dart:convert';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;

class ApiService {
  final String baseUrl = "http://10.0.2.2:8000/api";

  Future<Map<String, dynamic>> registerFarmer(Map<String, dynamic> data) async {
    try {
      final response = await http.post(
        Uri.parse('$baseUrl/farmers/'),
        headers: {"Content-Type": "application/json"},
        body: jsonEncode(data),
      );
      print("Response status: ${response.statusCode}");
      print("Response body: ${response.body}");
      return jsonDecode(response.body);
    } catch (e) {
      print("Error during POST request: $e");
      throw e;
    }
  }

  Future<Map<String, dynamic>> addProduct(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/add_product/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> getAllProducts() async {
    final response = await http.get(
      Uri.parse('$baseUrl/products/'),
      headers: {"Content-Type": "application/json"},
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> registerBuyer(Map<String, dynamic> data) async {
    final response = await http.post(
      Uri.parse('$baseUrl/buyers/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode(data),
    );
    return jsonDecode(response.body);
  }

  Future<Map<String, dynamic>> login(String email, String password) async {
    print("Making POST request to $baseUrl/login/ with data: $email, $password");
    final response = await http.post(
      Uri.parse('$baseUrl/login/'),
      headers: {"Content-Type": "application/json"},
      body: jsonEncode({"email": email, "password": password}),
    );
    print("Response body: ${response.body}");
    print("Response status: ${response.statusCode}");

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      // Check the role of the user
      if (data['role'] == 'farmer') {
        print("Logged in as Farmer with ID: ${data['id']}");
      } else if (data['role'] == 'buyer') {
        print("Logged in as Buyer with ID: ${data['id']}");
      }
      return data; // Return user data
    } else if (response.statusCode == 401) {
      throw Exception("Invalid credentials");
    } else {
      throw Exception("Failed to login. Status code: ${response.statusCode}");
    }
  }

}


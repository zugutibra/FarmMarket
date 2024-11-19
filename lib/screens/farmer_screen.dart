import 'package:flutter/material.dart';

class FarmerScreen extends StatelessWidget{
  const FarmerScreen({super.key});


  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Text("Welcome Farmer"),
        ),
      ),
    );
  }
}
import 'package:flutter/material.dart';

class BuyerScreen extends StatelessWidget{
  const BuyerScreen({super.key});


  @override
  Widget build(BuildContext context){
    return SafeArea(
      child: Scaffold(
        body: Container(
          child: Text("Welcome Buyer"),
        ),
      ),
    );
  }
}
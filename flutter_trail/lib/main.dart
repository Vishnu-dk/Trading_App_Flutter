import 'package:flutter/material.dart';
import 'package:flutter_trail/home.dart';

void main() {
  runApp(const MainApp());
}



class MainApp extends StatelessWidget {
  const MainApp({super.key});
  String onPressedfuction(){
    return "Button Clicked";
  }
  
  void handlePress(){
    String message=onPressedfuction();
    print(message);
  }
  @override
  Widget build(BuildContext context) {
    return   MaterialApp(
      home: HomeScreen()
      );
    
  }
}





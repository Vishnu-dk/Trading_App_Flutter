

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:frontend/screens/completed_tasks.dart';
import 'package:frontend/screens/homepage.dart';
import 'package:frontend/screens/login.dart';
import 'package:frontend/screens/signup.dart';
import 'package:frontend/screens/task_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    final storage=const FlutterSecureStorage();

    Future<bool> checkingLoginStatus()async{
      String?token= await storage.read(key: "jwt_token");
      return token!=null;
    };

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
     
      initialRoute: "/login",
      routes: {
        "/home":(context)=>Homepage(),
        "/task_screen":(context)=>TaskScreen(),
        "/completed_tasks":(context)=>CompletedTasks(),
        "/login":(context)=>Login(),
        "/signup":(context)=>Signup(),

      },

      home: FutureBuilder(
        future: checkingLoginStatus(), 
        builder: (context,snapshot){
          if(snapshot.connectionState==ConnectionState.waiting){
            return Scaffold(
              body: Center(
                child: CircularProgressIndicator(),
              ),
            );
          }
          if(snapshot.data==true){
            return Homepage();
          }else{
            return Login();
          }
        }
        ),

      
    );
  }
}


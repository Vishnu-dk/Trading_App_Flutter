
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:http/http.dart' as http;

final String baseUrl= "http://localhost:8000";

final storage =const FlutterSecureStorage() ;


void handleUnauthorizedTocken(BuildContext context) async{
     await storage.delete(key: "jwt_token");
     if(context.mounted){
        Navigator.pushNamedAndRemoveUntil(context, "/login",(route)=>false);
    }
}

class AuthService{

  Future<String>signup(String email,String password,String username) async{
    final response= await http.post(Uri.parse('$baseUrl/signup'),
                                        headers: {"Content-Type":"application/json"},
                                        body: jsonEncode({"email":email ,
                                                          "password":password,
                                                          "username":username}
                                                        ));
   if(response.statusCode==200){
    return "User Created";
   }
   if(response.statusCode==400){
    return "User Already Exits ! Try Different Username/Email";
   }
   return "SignUp Failed !";
  }

  Future<bool> login(String email,String password) async{
    final response = await http.post(Uri.parse('$baseUrl/login'),
                                        headers: {"Content-Type":"application/json"},
                                        body: jsonEncode({"email":email ,
                                                          "password":password}
                                                        ));
    if(response.statusCode==200){
      final data =jsonDecode(response.body);
      await storage.write(key: "jwt_token", value: data["access_token"]);
      return true;
    }
    
    return false;

  }
  
  Future<void> logOut() async{
      await storage.delete(key: "jwt_tocken");
  }


}
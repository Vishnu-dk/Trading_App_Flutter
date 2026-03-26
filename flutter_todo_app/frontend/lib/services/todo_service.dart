
import 'dart:convert';

import 'package:flutter/material.dart';

import 'package:frontend/services/auth_service.dart';
import 'package:http/http.dart' as http;


class TodoService {


  Future<List<dynamic>> fetchTask(BuildContext context) async{

    String?token = await storage.read(key: "jwt_token") ;

    final response = await http.get(Uri.parse('$baseUrl/all_task'),headers: {"Authorization":"Bearer $token","Content-Type":"application/json",});

    if(response.statusCode==200){
      return jsonDecode(response.body);
    }else if(response.statusCode==401){
      if(context.mounted){
        handleUnauthorizedTocken(context);
      }
      throw Exception("Session Expired");
    }else if(response.statusCode==404){
      return [];
    }
    else{
      throw Exception("Failed to load");
    }

  }

  Future<List<dynamic>> fetchCompletedTask(BuildContext context) async{
    String?token = await storage.read(key: "jwt_token") ;

    final response = await http.get(Uri.parse('$baseUrl/completed_task'),headers: {"Authorization":"Bearer $token","Content-Type":"application/json",});

    if(response.statusCode==200){
      return jsonDecode(response.body);
    }else if(response.statusCode==401){
      if(context.mounted){
        handleUnauthorizedTocken(context);
      }
      throw Exception("Session Expired");
    }else if(response.statusCode==404){
      return [];
    }
    else{
      throw Exception("Failed to load");
    }

  }
  Future<String>addTask(BuildContext context,String title,String description) async{
    String?token = await storage.read(key: "jwt_token") ;
    final response= await http.post(Uri.parse('$baseUrl/add_task'), headers: {"Authorization":"Bearer $token","Content-Type":"application/json",},
                                        body: jsonEncode({"title":title ,"description":description}));
    if(response.statusCode==200){
     return "Task Added";
    }else if(response.statusCode==401){
       if(context.mounted){
         handleUnauthorizedTocken(context);
       }
       throw Exception("Session Expired");
     }
    if(response.statusCode==400){
     return "Duplicate Task Title ! Try Different Title";
    }
    return "Task Adding Failed !";
  }

  Future<String>deleteTask(BuildContext context,String title) async{
    String?token = await storage.read(key: "jwt_token") ;
    final response= await http.delete(Uri.parse('$baseUrl/delete_task'),headers: {"Authorization":"Bearer $token","Content-Type":"application/json",},
                                        body: jsonEncode({"title":title }));
   if(response.statusCode==200){
    return "Task Deleted";
   }else if(response.statusCode==401){
      if(context.mounted){
        handleUnauthorizedTocken(context);
      }
      throw Exception("Session Expired");
    }
   if(response.statusCode==400){
    return "Duplicate Task Title ! Try Different Title";
   }
   return "Task Adding Failed !";
  }



  Future<String>editTask(BuildContext context,String?oldtitle,String?title,String?description) async{
    String?token = await storage.read(key: "jwt_token") ;
    final response= await http.put(Uri.parse('$baseUrl/edit_task'),headers: {"Authorization":"Bearer $token","Content-Type":"application/json",},
                                        body: jsonEncode({"oldtitle":oldtitle,
                                                          "title":title ,
                                                          "description":description
                                                        }));
    if(response.statusCode==200){
     return "Task Updated";
    }else if(response.statusCode==401){
       if(context.mounted){
         handleUnauthorizedTocken(context);
       }
       throw Exception("Session Expired");
    }
    return "Task Adding Failed !";
  } 





  Future<String>finishTask(BuildContext context,String title, bool?isCompleted) async{
    String?token = await storage.read(key: "jwt_token") ;
    final response= await http.put(Uri.parse('$baseUrl/edit_task'),headers: {"Authorization":"Bearer $token","Content-Type":"application/json",},
                                        body: jsonEncode({
                                                          "oldtitle":title,
                                                          "title":title,
                                                          "isCompleted":true}
                                                        ));

    if(response.statusCode==200){
     return "Task Completed";
    }else if(response.statusCode==401){
       if(context.mounted){
         handleUnauthorizedTocken(context);
       }
       throw Exception("Session Expired");
    }
    return "Task Adding Failed !";
  }
  
}



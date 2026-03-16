import 'package:flutter/material.dart';



class DisplayApp extends StatefulWidget{
  const DisplayApp({super.key});
  @override
  State<DisplayApp> createState()=> _DisplayAppState();
}

class _DisplayAppState extends State<DisplayApp>{




  int _count=0;
  String _displayText="Press the button to view message";
  String getMessage(){
    if(_count==0){
    return "U havent Clicked";
    }
    else{
      String suffix=(_count==1)?"time":"times" ;
      return " u have clicked $_count $suffix";
    }
  }


  void handlePress(){
  setState((){
      _count++;
  });
 }

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Display App"),
      ),
      body: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade300), onPressed: ()=>{Navigator.pop(context)}, child: const Text("Go BACK")),

              const Text("Welcome to flutter",
              style: TextStyle(fontSize: 25,fontWeight: FontWeight.bold,color: Colors.black),
              ),
              Text(_displayText),
              const SizedBox(height: 20),
              ElevatedButton(onPressed:handlePress, 
              child:  Text("Update")),
              Text(getMessage()),


            ],
          ),
        ),
    ) ;
  }
}


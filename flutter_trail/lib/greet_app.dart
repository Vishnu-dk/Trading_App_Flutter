import 'package:flutter/material.dart';

class GreetingApp extends StatefulWidget{
  const GreetingApp({super.key});
  @override
  State<GreetingApp> createState()=> _GreetMessage();
}

class _GreetMessage extends State<GreetingApp>{
  late TextEditingController _nameController;
  String _message ="Enter you name bellow:";
  String _messagereturn="";

  @override
  void initState(){
    super.initState();
    _nameController=TextEditingController();
  }
  @override
  void dispose(){
    _nameController.dispose();
    super.dispose();
  }

  void updateGreeting(){
    setState(() {
      if(_nameController.text.isEmpty){
         _messagereturn= "Enter Your name";
      }
      else{
         _messagereturn="Great Day ${_nameController.text}";
      }
    });
  }

  @override
  Widget build(BuildContext context){
    return  Scaffold(
      appBar: AppBar(
        title: const Text("Greet App"),
        
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ElevatedButton(style: ElevatedButton.styleFrom(backgroundColor: Colors.red.shade300), onPressed: ()=>{Navigator.pop(context)}, child: const Text("Go BACK")),
            Text(_message,style: const TextStyle(fontSize: 20)),
            const SizedBox(height: 20),
            TextField(
              controller: _nameController, 
              decoration: const InputDecoration(labelText:"Enter Name",border: OutlineInputBorder()),),
            const SizedBox(height: 20),
            ElevatedButton(onPressed: updateGreeting, child: const Text("Print Greet Msg")),
            Text(_messagereturn,style: const TextStyle(fontSize: 20)),



          ],
        ),),
    ); 
  }
}




import 'package:flutter/material.dart';
import 'package:flutter_trail/completed_task.dart';
import 'package:flutter_trail/display_app.dart';
import 'package:flutter_trail/greet_app.dart';
import 'package:flutter_trail/task_list.dart';


final List<Map<String,dynamic>>pendingTask=[{"name":"Learn Flutter" ,"isSelected":false},{"name": "Learn Dart","isSelected":false},{"name": "Learn MERN","isSelected":false},{"name": "Go to Gym","isSelected":false}];

List<Map<String,dynamic>>globalTaskComponent=[];
class HomeScreen extends StatelessWidget{

  
  const HomeScreen({super.key});
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("HomePage"),
        backgroundColor: Colors.amberAccent,
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children:[
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ElevatedButton(onPressed:()=>{Navigator.push(context,MaterialPageRoute(builder: (context)=>const DisplayApp()))},child: const Text("Go to DisplayAPP"),)],),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ElevatedButton(onPressed:()=>{Navigator.push(context,MaterialPageRoute(builder: (context)=>const GreetingApp()))},child: const Text("Go to GreetAPP"),)],),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ElevatedButton(onPressed:()=>{Navigator.push(context,MaterialPageRoute(builder: (context)=>const TaskListScreen()))},child: const Text("Go to TaskList"),)],),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [ElevatedButton(onPressed:()=>{Navigator.push(context,MaterialPageRoute(builder: (context)=> CompletedTasksPage(tasks:globalTaskComponent)))},child: const Text("Go to Completed Task List"),)],),

]       ),
    );
  }
}


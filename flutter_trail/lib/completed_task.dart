import 'package:flutter/material.dart';



class CompletedTasksPage extends StatelessWidget{

  final List<Map<String,dynamic>>tasks;
  const CompletedTasksPage({super.key , required this.tasks});

  String getTaskCount(){
  int count=tasks.where((item)=>item["isSelected"]==true).length;
  return count==0? "No Task Completed":"Task Completed : $count";
  }
  @override
  Widget build(BuildContext context){
    return Scaffold(
      appBar: AppBar(
        title: const Text("Completed TASKS"),
      ),
      body:Column(
        children: [
          Padding(
            padding: const EdgeInsetsGeometry.all(16.0),
            child: Text(getTaskCount(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold))),
          Expanded(child: 
            tasks.isEmpty?Text("No Task Left"):
            ListView.builder(
              itemCount:tasks.length,
              itemBuilder: (context,index){
                bool isSelected=tasks[index]["isSelected"];
                return ListTile(
                    leading: CircleAvatar(child: Text("${index+1}"),backgroundColor:isSelected?Colors.green:Colors.grey,),
                    title: Text(tasks[index]["name"]),
                  );
              }
           ),),])
    );
  }
}
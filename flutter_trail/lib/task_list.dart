import 'package:flutter/material.dart';
import 'package:flutter_trail/completed_task.dart';
import 'package:flutter_trail/home.dart';

class TaskListScreen extends StatefulWidget{
  const TaskListScreen({super.key});
  @override
  State<TaskListScreen> createState() =>_TaskListScreenState();
}

class _TaskListScreenState extends State<TaskListScreen>{
  
  late TextEditingController _inputController;

  @override
  void initState() {
    super.initState();
    _inputController=TextEditingController();

  }

  @override
  void dispose() {
    _inputController.dispose();
    super.dispose();
  }



  void toggleSeletion(int index){
    setState(() {
      pendingTask[index]["isSelected"]=!pendingTask[index]["isSelected"];
    });
  }

  void _showfeedback(String message,{bool isUndo=false,int?index, Map<String,dynamic>?deletedTask}){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        behavior: SnackBarBehavior.floating,
        backgroundColor: isUndo?Colors.redAccent:Colors.blueGrey,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10), 
        ),
        duration:  Duration(seconds: 2),
        action: isUndo?
          SnackBarAction(
            label: "Undo",
            onPressed: (){
              setState(() {
                pendingTask.insert(index!, deletedTask!);
              });
            }
          ):null
        )
    );
  }

  void addTask(){
    setState(() {
      if(_inputController.text.isNotEmpty){
      pendingTask.add({
        "name":_inputController.text,
        "isSelected":false
      });
      _inputController.clear();}
    });
    _showfeedback("New TASK added");
  }
  
  void deleteTask(int index){
    final deletedItem=pendingTask[index];
    final deletedIndex=index;

    setState(() {
      pendingTask.removeAt(index);
    });
    _showfeedback( "TASK ${deletedItem["name"]} deleted",isUndo: true,index: deletedIndex,deletedTask: deletedItem);
  }

  void _showDoneConfirmation(int index){
    showDialog(
      context: context, 
      builder: (context)=>AlertDialog(
        title: const Text("Mark as Done"),
        content: Text("Do you want to mark '${pendingTask[index]["name"]}' as Done ?"),
        actions: [
          TextButton(
            onPressed: ()=>Navigator.pop(context),
            child: const Text("Cancel")),
          ElevatedButton(
            onPressed: ()=>{
              Navigator.pop(context),
              _completedTask(index)
            }, 
            child: Text("Done"))      
        ],
      ));
  }


  void _completedTask(int index){
    setState(() {
      var task=pendingTask.removeAt(index);
      globalTaskComponent.add(task);

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text("Task Moved to completed"),
          behavior: SnackBarBehavior.floating,
          action: SnackBarAction(
            label: "View", 
            onPressed: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>CompletedTasksPage(tasks:globalTaskComponent)));
            }
            ),
        )
      );
    });
  }

  String getTaskCount(){
    int count=pendingTask.where((item)=>item["isSelected"]==true).length;
    return count==0? "No Item Selected":"No of Item selected : $count";
  }
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        title: const Text("List Task"),
      ),
      body:Column(
        children: [
          Padding(
            padding: const EdgeInsetsGeometry.all(16.0),
            child: Text(getTaskCount(),style: TextStyle(fontSize: 18,fontWeight: FontWeight.bold))),
          Expanded(child: 
            pendingTask.isEmpty?Text("No Task Left"):
            ListView.builder(
              itemCount:pendingTask.length,
              itemBuilder: (context,index){
                bool isSelected=pendingTask[index]["isSelected"];
                return ListTile(
                    leading: CircleAvatar(child: Text("${index+1}"),backgroundColor:isSelected?Colors.green:Colors.grey,),
                    title: Text(pendingTask[index]["name"]),
                    trailing:  IconButton(onPressed: ()=>deleteTask(index), icon: Icon(Icons.delete)) ,
                    onTap: () => {toggleSeletion(index),_showDoneConfirmation(index)},
                  );
              }
           ),),
          Padding(
            padding: const EdgeInsetsGeometry.all(20.0),
            child:
              Row(
                children:[ 
                  Expanded(
                    child: 
                      TextField(controller:_inputController,decoration: InputDecoration(labelText: "Enter task to add"),onSubmitted: (value) => addTask(),),
                  ),
                  const SizedBox(),
                  ElevatedButton(onPressed: addTask, child: const Icon(Icons.add))
                ]    
              ) 
            )

        ],
        
      )
       
    );
  }
}

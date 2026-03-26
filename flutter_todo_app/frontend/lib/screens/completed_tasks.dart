import 'package:flutter/material.dart';
import 'package:frontend/services/todo_service.dart';

List<String> todo=["buy","sell","eat","wait","where"];

class CompletedTasks extends StatefulWidget{
  const CompletedTasks({super.key});

  @override
  State<CompletedTasks> createState() =>_CompletedTasks();
}

class _CompletedTasks extends State<CompletedTasks>{
  

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
      
              
        title:Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 10),
          child:  Text("Completed Task"),),
        titleTextStyle: TextStyle(fontWeight: FontWeight.w500,color: Colors.white,fontSize: 28),
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
      ),
      body: FutureBuilder<List<dynamic>>
            (future: TodoService().fetchCompletedTask(context), 
              builder: (context,snapshot){
                if(snapshot.connectionState==ConnectionState.waiting){
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }else if(snapshot.hasError){
                  return Center(
                    child: Text("Error Task Loading"),
                  );
                }else if(!snapshot.hasData||snapshot.data!.isEmpty){
                  return Center(
                    child: Text("No Task Yet ! "),
                  );
                }
                final tasks=snapshot.data!;
                
                return ListView.builder(
                  itemCount: tasks.length,
                  padding: EdgeInsets.all(10),
                  itemBuilder: (context,index){
                    final task=tasks[index];
                    
                    return  todoListBar(index, task['title'],task['description']);
                  }
                  );
              }
            ),    );
  }
}


Widget todoListBar (int index,String title,String descrition){
  return Card(
    
    margin: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    elevation: 3,
    child: ExpansionTile(
      tilePadding: EdgeInsets.all(20),
      key: PageStorageKey(title),
      leading: CircleAvatar(backgroundColor: Colors.blue.shade900,child: Text("${index+1}", style: TextStyle(color: Colors.white),),),
      title: Text(title,style: TextStyle(fontWeight:FontWeight.bold,fontSize: 18),),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children:[Icon(Icons.expand_more)],
      ),
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text("Description:", style: TextStyle(fontWeight: FontWeight.bold)),
              const SizedBox(height: 4),
              Text( descrition!="" ?descrition:"No Description", style: const TextStyle(color: Colors.black87)),
            ],),),],
    ),
  );
}
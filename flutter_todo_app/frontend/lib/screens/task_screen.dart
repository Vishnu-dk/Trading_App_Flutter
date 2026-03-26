


import 'package:flutter/material.dart';
import 'package:frontend/services/todo_service.dart';

List<String> todo=["buy","sell","eat","wait","where"];

class TaskScreen extends StatefulWidget{
  const TaskScreen({super.key});

  @override
  State<TaskScreen> createState() =>_Task_Screen();
}

class _Task_Screen extends State<TaskScreen>{

  TextEditingController _titlecontroller=TextEditingController();
  TextEditingController _descriptionController=TextEditingController();


  bool isEditing=false;
  String?orginalTitle;

  Key _futureBuilderKry=UniqueKey();

  void refresh(){
    setState(() {
      _futureBuilderKry=UniqueKey();
    
    });
  }

  @override
  Widget build(BuildContext context) {

    void handleSaveTask()async{
      String success;
      if(isEditing&&orginalTitle!=null){
        success=await TodoService().editTask(context,orginalTitle, _titlecontroller.text,_descriptionController.text);
      }else{
         success=await TodoService().addTask(context,_titlecontroller.text,_descriptionController.text);
      }
      if (success=="Task Added"||success=="Task Updated"){
        setState(() {
          _titlecontroller.clear();
          _descriptionController.clear();
          ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(success))
        );
        });
      }
      else{
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(success))
        );
      }}



    void cancelEdit(){
        setState(() {
          isEditing=false;
          orginalTitle=null;
          _titlecontroller.clear();
          _descriptionController.clear();
        });
    }

    return Scaffold(
      appBar: AppBar(      
        title:Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 10),
          child:  Text("Tasks to be completed"),),
        titleTextStyle: TextStyle(fontWeight: FontWeight.w500,color: Colors.white,fontSize: 28),
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
        ),
      body: FutureBuilder<List<dynamic>>
            (future: TodoService().fetchTask(context), 
            key: _futureBuilderKry,
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
                    final task=tasks[index];      ;   
                    return  todoListBar(context,index, task['title'],task['description'],task['isCompleted'],
                    refresh,
                    (){
                      setState(() {
                        isEditing=true;
                        orginalTitle=task['title'];
                        _titlecontroller.text=task['title'];
                        _descriptionController.text=task['description'];
              
                      });
                    });
                  }
                  );
              }
        ),
      bottomNavigationBar: Padding(
          padding: EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
          child: Container(
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              boxShadow: [BoxShadow(color: Colors.black12,blurRadius: 10)],
            ),
            child:Row(
              children: [
                Expanded(
                  child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: _titlecontroller, 
                      decoration: InputDecoration(
                        labelText: "Tilte",isDense:true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                      ),
                    ),
                    SizedBox(height: 8,),
                    TextField(
                      controller: _descriptionController,
                      decoration: InputDecoration(
                        labelText: "Description",isDense:true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)
                        )
                       
                      ),
                    )
                  ],

                ),
                  ),
                SizedBox(width: 2,),
                if(isEditing)
                  IconButton(
                    onPressed: cancelEdit, 
                    icon: Icon(Icons.close ,color: Colors.red,)),
                
                ElevatedButton(
                  onPressed: handleSaveTask, 
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.all(15),
                    shape: CircleBorder(),
                    backgroundColor: isEditing? Colors.orange: Colors.blueAccent,
                    
                  ),
                  
                  child: Icon(Icons.add,color: Colors.white,)
                  )

              ],
            ) ,
          ),

        ),
    );
  }
}


Widget todoListBar (BuildContext context, int index,String title,String descrition,bool isCompleted,VoidCallback onRefresh,VoidCallback onEdit){
  return Card(
    
    margin: EdgeInsets.symmetric(horizontal: 16,vertical: 8),
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
    elevation: 3,
    child:  ExpansionTile(
      key: PageStorageKey(title),
      tilePadding: EdgeInsets.all(20),
      leading: CircleAvatar(backgroundColor: Colors.blue.shade900,child: Text("${index+1}", style: TextStyle(color: Colors.white),),),
      title: Text(title,style: TextStyle(fontWeight:FontWeight.bold,fontSize: 18),),
      
      trailing:Row(
        mainAxisSize: MainAxisSize.min,
        children: [
            IconButton(onPressed: (){handleDCompetedTask(context,title,true,onRefresh);} , icon: Icon(Icons.check,color: Colors.blueGrey)),

            IconButton(onPressed:onEdit , icon: Icon(Icons.edit_outlined,color: Colors.grey,)),
            IconButton(onPressed: (){handleDeleteTask(context,title,onRefresh);}, icon: Icon(Icons.delete_outline,color: Colors.red,)),
            Icon(Icons.expand_more)
        ]
      ) ,
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

void handleDeleteTask(BuildContext context,title,VoidCallback onRefresh)async{
  String success=await TodoService().deleteTask(context,title);
  if (success=="Task Deleted"){
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success))  
    );
    onRefresh();   
  }
  else{
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success))
    );
  }}

void handleDCompetedTask(BuildContext context,title,isCompleted,VoidCallback onRefresh)async{
  String success=await TodoService().finishTask(context,title,isCompleted);
  if (success=="Task Completed"){
    
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success))
      
    );
     onRefresh();
  }
  else{
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success))
    );
  }}

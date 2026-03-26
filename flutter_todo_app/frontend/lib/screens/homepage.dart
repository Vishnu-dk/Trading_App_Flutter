import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';


class Homepage extends StatelessWidget{


  const Homepage({super.key});

  @override
  Widget build(BuildContext context) {

    return Scaffold(
    
      appBar: AppBar(
        centerTitle: true,        
        title:Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            Padding(
          padding: EdgeInsetsGeometry.symmetric(vertical: 10),
          child: Text("ToDO List"),),
          
          ],
        ),
        actions: [
          Padding(
            padding: EdgeInsets.symmetric(vertical: 8,horizontal: 10),
            child: IconButton(
            
                onPressed: ()async{
                  await AuthService().logOut();
                  if(context.mounted){
                    Navigator.pushNamedAndRemoveUntil(context, "/login",(route)=>false);
                  }
                }, 
                icon: Text("Logout",style: TextStyle(color: Colors.white),),
                
            
            ),
          )
          
        ],
        titleTextStyle: TextStyle(fontWeight: FontWeight.w500,color: Colors.white,fontSize: 28),
        backgroundColor: Colors.blue.shade900,
        foregroundColor: Colors.white,
      ),
      body: Center(
        child: FractionallySizedBox(
          widthFactor: 0.75, 
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
            
              IntrinsicHeight( 
                child: Flex(
                  direction: MediaQuery.of(context).size.width < 600
                      ? Axis.vertical
                      : Axis.horizontal,
                  children: [
                    _buildSmallBox("Stats", Icons.analytics, Colors.blue.shade50),
                    const SizedBox(width: 16, height: 16), // Gap between boxes
                    _buildSmallBox("Profile", Icons.person, Colors.white),
                  ],
                ),
              ),

              const SizedBox(height: 20), 
              IntrinsicHeight( 
                child: Flex(
                  direction: Axis.vertical,
                  children: [
                    _buildHorizontalBox(context,"Ready to stay organized?","Create New Task","Click Here to Start", Icons.analytics, Colors.blue.shade900,"task_screen"),
                    const SizedBox(width: 16, height: 16), // Gap between boxes
                    _buildHorizontalBox(context,"Wanna See Your Progress ?","Completed Tasks","Click Here to View", Icons.analytics, Colors.blue.shade700,"completed_tasks"),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


Widget _buildSmallBox(String title, IconData icon, Color color) {
  return Expanded(
    child: Container(
      
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
        border: Border.all(color: Colors.blue.shade100),
      ),
      child: Column(
        children: [
          Icon(icon, size: 40, color: Colors.blue.shade900),
          const SizedBox(height: 10),
          Text(title, style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18)),
        ],
      ),
    ),
  );
}
Widget _buildHorizontalBox(BuildContext context, String tag, String title,String label, IconData?icon, Color?color,String function) {
  return Expanded(
    
    child: Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: color, // Matching your AppBar
            borderRadius: BorderRadius.circular(25),
            boxShadow: [
              BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))
            ],
          ),
      child: Column(
        children: [
           Text(
                tag,
                style: TextStyle(color: Colors.white70, fontSize: 16),
              ),
              const SizedBox(height: 10),
               Text(
                title,
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold
                ),
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: () =>Navigator.pushNamed(context, '/$function'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.white,
                  foregroundColor: Colors.blue.shade900,
                  minimumSize: const Size(200, 50), // Makes button substantial
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                ),
                child:  Text(label, style: TextStyle(fontWeight: FontWeight.bold)),
              ),
        ],
      ),
    ),
  );
}
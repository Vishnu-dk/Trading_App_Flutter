

import 'package:flutter/material.dart';
import 'package:frontend/services/auth_service.dart';

class Signup extends StatefulWidget{
  const Signup({super.key});

  @override
  State<StatefulWidget> createState() =>_Signup();

}



class _Signup extends State<Signup>{



  @override
  Widget build(BuildContext context) {
      final TextEditingController _emailController=TextEditingController();
      final TextEditingController _passwordController=TextEditingController();
      final TextEditingController _usernameController=TextEditingController();

      void handleSignup()async{
        String success=await AuthService().signup(_emailController.text,_passwordController.text,_usernameController.text);
        if (success=="User Created"){
          Navigator.pushReplacementNamed(context, "/home");
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(success))
          );
        }
        else{
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(success))
          );
        }
      }


      return Scaffold(
        body: Center(
          child: FractionallySizedBox(
            widthFactor: MediaQuery.of(context).size.width < 800 ? .65 : .4,
            heightFactor: MediaQuery.of(context).size.width < 800 ? .5 : .6,
            child: Container(
              decoration: BoxDecoration(
                boxShadow: [
                  BoxShadow(color: Colors.black26, blurRadius: 10, offset: Offset(0, 4))
                ],
                borderRadius: BorderRadius.circular(15),
                color: Colors.white, // Changed to white for better input visibility
              ),
              // Child is now at the very end of the Container
              child: Column(
                mainAxisAlignment: MainAxisAlignment.start, // Start from top
                children: [
                  Container(
                    width: double.infinity,
                    padding: const EdgeInsets.symmetric(vertical: 20),
                    decoration: const BoxDecoration(
                      color: Colors.blueAccent,
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(15),
                        topRight: Radius.circular(15),
                      ),
                    ),
                    child: const Text(
                      "Sign Up",
                      style: TextStyle(fontSize: 28, color: Colors.white, fontWeight: FontWeight.bold),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        TextField(
                          controller: _emailController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.email),
                            labelText:"Email", 
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                            )
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextField(
                          controller: _usernameController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            labelText:"UserName", 
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                            )
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        TextField(
                          controller: _passwordController,
                          decoration: InputDecoration(
                            prefixIcon: Icon(Icons.lock),
                            labelText:"Password", 
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)
                            )
                          ),
                        ),
                        SizedBox(
                          height: 16,
                        ),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.blueAccent,
                              foregroundColor: Colors.white,
                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10))
                            ),
                            onPressed: handleSignup, 
                            child: Text("SIGN UP" ,style: TextStyle(fontWeight: FontWeight.bold),)
                            ),
                        )
                      ],
                    ),
                  ),
                  SizedBox(height: 16,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text("Already Signed Up ? "),
                      InkWell(
                        onTap: () {
                          Navigator.pushNamed(context, "/login");
                        },
                        
                        child: Text("Click To Login", style: TextStyle(
                          color: Colors.blueAccent,
                          fontWeight: FontWeight.w500,
                          decoration: TextDecoration.underline
                          
                        ),),
                      )
                    ],
                  )
  
                ],
              ),
            ),
          ),
        ),
      );
      
  } 
} 
  

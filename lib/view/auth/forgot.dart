import 'package:flutter/material.dart';
import 'package:project2/utils/app_constant.dart';
import 'package:project2/view/auth/login.dart';

class ForgotPasswordScreen extends StatefulWidget {
  const ForgotPasswordScreen({super.key});

  @override
  State<ForgotPasswordScreen> createState() => _ForgotPasswordScreenState();
}

class _ForgotPasswordScreenState extends State<ForgotPasswordScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 50.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            IconButton(
              icon: Icon(Icons.arrow_back),
              onPressed: () {
               Navigator.pop(context);
              },
            ),
            SizedBox(height: 30),
            Text(
              'Forget Password',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 30),
            TextFormField(
              maxLength: 10,
              validator: (value){
                if(value!.isEmpty){
                  return 'enter your number';
                }else{
                  return null;
                }
              },
              decoration: InputDecoration(
                labelText: 'UserId',
                hintText: 'Your Phone Number',
                border: OutlineInputBorder(),
              ),
            ),

            SizedBox(height: 20),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: InkWell(
                onTap: () {
                  // Handle send email logic
                  //final email = emailController.text;
                  //print("Sending email to $email");
                },
                child:  Container(
                  height: 50,
                  width: 330,
                  decoration: BoxDecoration(
                      color: AppConstant.appSecondaryColor,
                      borderRadius: BorderRadius.circular(10)
                  ),

                  child: Center(child: Text('Send',style: TextStyle(color: Colors.white,fontSize: 20,fontFamily: 'sens-serif'),)),
                )
              ),
            ),
            Spacer(),
            Center(
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text("Already have account? "),
                  GestureDetector(
                    onTap: () {
                      // Navigate to login screen
                      Navigator.push(context, MaterialPageRoute(builder: (context){
                      return Login();
                      }));
                    },
                    child: Text(
                      "Log in",
                      style: TextStyle(
                        color: Colors.orange,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

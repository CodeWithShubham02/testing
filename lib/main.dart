import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:project2/controller/auth_controller.dart';
import 'package:project2/view/auth/login.dart';
import 'package:project2/view/dashboard_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'demo_screen.dart';

void main() async{
  // WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  // FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]).then((_) {
    runApp( MyApp());
  });

}

class MyApp extends StatelessWidget {
   MyApp({super.key});

   Future<bool> isLoggedIn() async {
     final prefs = await SharedPreferences.getInstance();
     final uid = prefs.getString('uid');
     return uid != null && uid.isNotEmpty;
   }
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {


    return GetMaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Peak Me',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      home:  FutureBuilder<bool>(
        future: isLoggedIn(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Scaffold(
              body: Center(child: CircularProgressIndicator()),
            );
          }

          if (snapshot.hasData && snapshot.data == true) {
            // User is logged in → Go to Dashboard
            return DashboardScreen(); // Replace with your dashboard widget
          } else {
            // Not logged in → Go to Login screen
            return Login();
          }
        },
      ),
    );
  }
}


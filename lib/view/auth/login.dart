import 'dart:io';
import 'dart:math';

import 'package:device_info_plus/device_info_plus.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project2/model/user_model.dart';
import 'package:project2/utils/app_constant.dart';
import 'package:project2/view/auth/forgot.dart';
import 'package:project2/view/dashboard_screen.dart';

import '../../controller/auth_controller.dart';
import '../../controller/get_device_token_controller.dart';
import '../../controller/otp_controller.dart';

class Login extends StatefulWidget {
   Login({super.key});

  @override
  State<Login> createState() => _LoginState();
}

class _LoginState extends State<Login> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();
  final GetDeviceTokenController token=Get.put(GetDeviceTokenController());
  final AuthService _authService=Get.put(AuthService());
  late String userId;
  late String password;
  late String userOtp;

  String _deviceInfo = '';

  //genrate otp
  String genrateOtp(){
    var random=Random();
    int otp=1000+random.nextInt(9999);
    return otp.toString();
  }
  //genrate IMEI id
  Future<void> _getDeviceInfo() async {
    final DeviceInfoPlugin deviceInfoPlugin = DeviceInfoPlugin();

    String info = '';

    if (Platform.isAndroid) {
      // Request runtime permission
      var status = await Permission.phone.request();
      // var camera = await Permission.camera.request();
      // var photos = await Permission.photos.request();
      // var location = await Permission.location.request();


      if (status.isGranted) {
        AndroidDeviceInfo androidInfo = await deviceInfoPlugin.androidInfo;
        info = androidInfo.id.toString();
      } else {
        info = 'Phone permission not granted';
      }
    } else if (Platform.isIOS) {
      IosDeviceInfo iosInfo = await deviceInfoPlugin.iosInfo;
      info = '''
      NAME: ${iosInfo.name}
      SYSTEM NAME: ${iosInfo.systemName}
      SYSTEM VERSION: ${iosInfo.systemVersion}
      MODEL: ${iosInfo.model}
      IDENTIFIER FOR VENDOR: ${iosInfo.identifierForVendor}
      ''';
    }

    setState(() {
      _deviceInfo = info;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    _getDeviceInfo();

  }
  String responseMsg = '';

  void requestOtp() async {
    final mobile = userId.trim();
    final upassword = password.trim();

    if (mobile.isNotEmpty && upassword.isNotEmpty) {
      final result = await OtpService.getOtp(
        mobile: mobile,
        upassword: upassword,
      );

      setState(() {
        if(result.success==1){
          Get.snackbar("Send OTP", 'please enter the 4 digit otp!!',
            backgroundColor: AppConstant.appSnackBarBackground, // Background color of the snackbar
            colorText: Colors.black, // Color of the title and message text
            snackPosition: SnackPosition.TOP, // Position of the snackbar (TOP or BOTTOM)
            margin: const EdgeInsets.all(10), // Margin around the snackbar
            borderRadius: 10, // Border radius of the snackbar
            animationDuration: const Duration(milliseconds: 500), // Animation duration
            duration: const Duration(seconds: 3), // Duration the snackbar is displayed
            icon: const Icon(Icons.message, color: Colors.white), // Optional icon
            shouldIconPulse: true, // Whether the icon should pulse
            isDismissible: true, // Whether the snackbar can be dismissed by swiping
            dismissDirection: DismissDirection.horizontal,);
          showCustomBottomSheet(userId,token.userToken.toString(),result.message.toString());
        }else{
          Get.snackbar("Oops!", 'your userId and password does not exist in my database so please connect to the office, Thank You!!',
            backgroundColor: AppConstant.appSnackBarBackground, // Background color of the snackbar
            colorText: Colors.black, // Color of the title and message text
            snackPosition: SnackPosition.TOP, // Position of the snackbar (TOP or BOTTOM)
            margin: const EdgeInsets.all(10), // Margin around the snackbar
            borderRadius: 10, // Border radius of the snackbar
            animationDuration: const Duration(milliseconds: 500), // Animation duration
            duration: const Duration(seconds: 3), // Duration the snackbar is displayed
            icon: const Icon(Icons.message, color: Colors.black), // Optional icon
            shouldIconPulse: true, // Whether the icon should pulse
            isDismissible: true, // Whether the snackbar can be dismissed by swiping
            dismissDirection: DismissDirection.horizontal,);
        }
        });
    } else {
      setState(() {
        responseMsg = 'Please enter both fields';
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,

      body: SingleChildScrollView(
        child: Form(
          key: _formKey,
          child: SafeArea(
              child: Stack(
                children: [
                  SizedBox(

                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24.0, vertical: 16),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Column(
                            children: [
                              SizedBox(height: 30),
                              Container(
                                height: 200,
                                child: Image.asset(
                                  'assets/logo/logo.png', fit: BoxFit.cover,),
                              ),
                              SizedBox(height: 10),
                              Text(_deviceInfo.toString()),

                              Divider(thickness: 2, height: 40),
                              Row(
                                children: [
                                  Text(
                                    'Login ',
                                    style:
                                    TextStyle(fontSize: 20,
                                        fontWeight: FontWeight.bold,
                                        fontFamily: AppConstant.appFontFamily),
                                  ),
                                  SizedBox(width: 5,),
                                  Icon(Icons.login_rounded,
                                    color: Colors.blueAccent,)


                                ],
                              ),
                              SizedBox(height: 16),
                              TextFormField(
                                onChanged: (value){
                                  userId=value;
                                },
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'enter your password';
                                  }else{
                                    return null;
                                  }
                                },
                                decoration: InputDecoration(
                                  labelText: 'UserId',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              SizedBox(height: 16),
                              TextFormField(
                                keyboardType: TextInputType.number,
                                maxLength: 10,
                                onChanged: (value){
                                  password=value;
                                },
                                validator: (value){
                                  if(value!.isEmpty){
                                    return 'enter your password';
                                  }else{
                                    return null;
                                  }
                                },

                                obscureText: true,
                                decoration: InputDecoration(
                                  labelText: 'Password',
                                  border: OutlineInputBorder(),
                                ),
                              ),
                              Align(
                                alignment: Alignment.centerRight,
                                child: TextButton(
                                  onPressed: () {
                                    Navigator.push(context, MaterialPageRoute(builder: (context){
                                      return ForgotPasswordScreen();
                                    }));
                                  },
                                  child: Text("Forgot Password?"),
                                ),
                              ),
                              SizedBox(height: 10),
                              InkWell(
                                onTap: (){
                                  if(_formKey.currentState!.validate()) {
                                    requestOtp();

                                  }else{
                                    Get.snackbar("Error", 'please enter the all field..',
                                      backgroundColor:AppConstant.appSnackBarBackground, // Background color of the snackbar
                                      colorText: Colors.black, // Color of the title and message text
                                      snackPosition: SnackPosition.TOP, // Position of the snackbar (TOP or BOTTOM)
                                      margin: const EdgeInsets.all(10), // Margin around the snackbar
                                      borderRadius: 10, // Border radius of the snackbar
                                      animationDuration: const Duration(milliseconds: 500), // Animation duration
                                      duration: const Duration(seconds: 3), // Duration the snackbar is displayed
                                      icon: const Icon(Icons.error, color: Colors.black), // Optional icon
                                      shouldIconPulse: true, // Whether the icon should pulse
                                      isDismissible: true, // Whether the snackbar can be dismissed by swiping
                                      dismissDirection: DismissDirection.horizontal,);
                                  }
                                },
                                child: Container(
                                  height: 50,
                                  width: 330,
                                  decoration: BoxDecoration(
                                      color: Colors.orangeAccent,
                                      borderRadius: BorderRadius.circular(10)
                                  ),

                                  child: Center(child: Text('Send Otp',style: TextStyle(color: Colors.white,fontSize: 20,fontFamily: 'sens-serif'),)),
                                ),
                              ),

                            ],
                          ),
                          Text(
                            'AppConstant.appSnackBarBackground',
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              )
          ),
        ),
      ),
    );
  }


  void showCustomBottomSheet(
      String userId,String userDiviceToken,String newOtp) {
    Get.bottomSheet(
      Container(
        height: Get.height / 0.5,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.vertical(top: Radius.circular(10.0),),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.all(18.0),
                child: Column(
                  children: [
                    Text('Send To :  +91-${userId.toString()}'),
                    Text('Send To : - ${newOtp}'),
                    // Text('Token: ${userDiviceToken.toString()}')
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(
                    horizontal: 20.0, vertical: 20.0),
                child: Container(
                  height: 55.0,
                  child: TextFormField(
                    onChanged: (value) {
                      userOtp = value;
                    },
                    textInputAction: TextInputAction.next,
                    keyboardType: TextInputType.number,
                    maxLength: 4,
                    decoration: InputDecoration(

                        labelText: 'Enter Otp ',
                        contentPadding: EdgeInsets.symmetric(horizontal: 10.0),
                        hintStyle: TextStyle(fontSize: 12),
                        border: OutlineInputBorder()
                    ),
                  ),
                ),
              ),

              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Material(
                  child: Container(
                    width: Get.width / 2.0,
                    height: Get.height / 10,

                    decoration: BoxDecoration(
                        color: AppConstant.appSecondaryColor,
                        borderRadius: BorderRadius.circular(10.0)),
                    child: TextButton(
                      child: Text(
                        'Submit',
                        style: TextStyle(color: Colors.white,),
                      ),
                      onPressed: () async {
                        String otp=userOtp;
                        String message='';
                        late String name;
                        if (otp==newOtp) {

                            final result = await AuthService.login(
                              mobile: userId.trim(),
                              password: password.trim(),
                              userToken: token.userToken.toString(), // Normally from FCM
                              teamho: otp.toString(),
                              imeiNumber:_deviceInfo.toString(),
                              context: context// Get from device_info
                            );
                            print(message.toString());
                         Get.snackbar("Login success!", 'you are login successfully.!',
                           backgroundColor:AppConstant.appSnackBarBackground, // Background color of the snackbar
                           colorText: Colors.black, // Color of the title and message text
                           snackPosition: SnackPosition.BOTTOM, // Position of the snackbar (TOP or BOTTOM)
                           margin: const EdgeInsets.all(10), // Margin around the snackbar
                           borderRadius: 10, // Border radius of the snackbar
                           animationDuration: const Duration(milliseconds: 500), // Animation duration
                           duration: const Duration(seconds: 3), // Duration the snackbar is displayed
                           icon: const Icon(Icons.account_circle_outlined, color: Colors.black), // Optional icon
                           shouldIconPulse: true, // Whether the icon should pulse
                           isDismissible: true, // Whether the snackbar can be dismissed by swiping
                           dismissDirection: DismissDirection.horizontal,

                         );

                        } else {
                          Get.snackbar("Error", 'Your OTP does not match please check the otp!!',
                            backgroundColor: AppConstant.appSnackBarBackground, // Background color of the snackbar
                            colorText: Colors.black, // Color of the title and message text
                            snackPosition: SnackPosition.BOTTOM, // Position of the snackbar (TOP or BOTTOM)
                            margin: const EdgeInsets.all(10), // Margin around the snackbar
                            borderRadius: 10, // Border radius of the snackbar
                            animationDuration: const Duration(milliseconds: 500), // Animation duration
                            duration: const Duration(seconds: 3), // Duration the snackbar is displayed
                            icon: const Icon(Icons.error, color: Colors.black), // Optional icon
                            shouldIconPulse: true, // Whether the icon should pulse
                            isDismissible: true, // Whether the snackbar can be dismissed by swiping
                            dismissDirection: DismissDirection.horizontal,

                          );
                        }
                      },
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      backgroundColor: Colors.transparent,
      isDismissible: true,
      enableDrag: true,
      elevation: 6,
    );
  }
}


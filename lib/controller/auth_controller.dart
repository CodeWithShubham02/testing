import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:project2/model/user_model.dart';
import 'package:project2/view/auth/forgot.dart';
import 'package:project2/view/dashboard_screen.dart';
import 'package:project2/view/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';


class AuthService {
  static const String apiUrl = 'https://fms.bizipac.com/ws/userauth.php?';
  static Future<Map<String, dynamic>> login({
    required String mobile,
    required String password,
    required String userToken,
    required String teamho,
    required String imeiNumber,
    required context
  }) async {
     try {
        final response = await http.post(
         Uri.parse(apiUrl),
         body: {
          'mobile': mobile,
          'password': password,
          'user_token': userToken,
          'teamho': teamho,
          'imei_number': imeiNumber,
        },
      );
      print('response the body ------------------------');

      print(response.body);
        print('response the body ------------------------');
      if (response.statusCode == 200) {
        //final data = json.decode(response.body);
        final Map<String, dynamic> data = json.decode(response.body);
        if (data['success'] == 1 && data['data'] != null) {
          final user = UserModel.fromJson(data['data'][0]);
            final SharedPreferences prefs = await SharedPreferences.getInstance();
            await prefs.setString('uid', user.uid);
            await prefs.setString('name', user.name);
            await prefs.setString('mobile', user.mobile);
            await prefs.setString('rolename', user.rolename);
            await prefs.setString('roleId', user.roleId);
            await prefs.setString('branchId', user.branchId);
            await prefs.setString('branch_name', user.branch_name);
            await prefs.setString('authId', user.authId);
            await prefs.setString('image', user.image);
            await prefs.setString('address', user.address);

          // Navigator.push(
          //   context,
          //   MaterialPageRoute(
          //     builder: (context) => ProfileScreen(userModel: user),
          //   ),
          // );
          Get.offAll(()=>DashboardScreen());
          return {
            'success': true,
            'user': user,
            'message': data['message']
          };

        } else {
          return {
            'success': false,
            'message': data['message'] ?? 'Invalid response'
          };
        }
      } else {
        return {'success': false, 'message': 'Server error'};
      }
    } catch (e) {
      return {'success': false, 'message': 'Error: $e'};
    }
  }




}

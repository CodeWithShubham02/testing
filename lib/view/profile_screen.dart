import 'package:flutter/material.dart';
import 'package:project2/model/user_model.dart';
import 'package:project2/utils/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {

   ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  String name = '';
  String mobile = '';
  String uid = '';
  String rolename = '';
  String roleId = '';
  String branchId = '';
  String branch_name='';
  String authId = '';
  String image = '';
  String address = '';

  void loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? '';
      mobile = prefs.getString('mobile') ?? '';
      uid = prefs.getString('uid') ?? '';
      rolename = prefs.getString('rolename') ?? '';
      roleId = prefs.getString('roleId') ?? '';
      branchId = prefs.getString('branchId') ?? '';
      branch_name = prefs.getString('branch_name') ?? '';
      authId = prefs.getString('authId') ?? '';
      image = prefs.getString('image') ?? '';
      address = prefs.getString('address') ?? '';
    });
  }
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    loadUserData();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:AppConstant.appInsideColor,
        title: const Text('Profile',style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),),
          iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            // User image
            CircleAvatar(
              radius: 50,
              backgroundColor: AppConstant.appInsideColor,
              child: Icon(Icons.person_3,color: Colors.white,size: 50,),
            ),
            const SizedBox(height: 16),

            // Basic info
            Text(
              name.toString(),
              style: const TextStyle(fontSize: 22, fontWeight: FontWeight.bold,color: Colors.black),
            ),
            
            const SizedBox(height: 20),

            // Information Cards
            buildInfoCard("User ID", uid.toString(),Icon(Icons.perm_identity)),
            buildInfoCard("Mobile", mobile.toString(),Icon(Icons.phone_android_outlined)),
            buildInfoCard("Address", address.toString(),Icon(Icons.location_on_outlined)),
            buildInfoCard("Branch Name", branch_name.toString(),Icon(Icons.dashboard)),
            buildInfoCard("Role Name", rolename.toString(),Icon(Icons.open_in_full)),
            buildInfoCard("Auth ID", authId.toString() ?? "N/A",Icon(Icons.key)),

          ],
        ),
      ),
    );
  }

  Widget buildInfoCard(String title, String value,Widget IconData) {
    return Card(
      margin: const EdgeInsets.symmetric(vertical: 6),
      child: ListTile(
        leading:  IconData,
        title: Text(title),
        subtitle: Text(value),
      ),
    );
  }
}

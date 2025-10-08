import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project2/view/auth/login.dart';
import 'package:project2/view/received_lead_screen.dart';
import 'package:project2/view/search_lead_screen.dart';
import 'package:project2/view/today_transferd_lead_screen.dart';
import 'package:project2/view/widget/drawer_widget.dart';
import 'package:project2/view/profile_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../demo_screen.dart';


class DashboardScreen extends StatefulWidget {

   DashboardScreen({super.key, });

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {

  String name = '';
  String mobile = '';
  String uid='';

  void loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      name = prefs.getString('name') ?? '';
      mobile = prefs.getString('mobile') ?? '';
      uid = prefs.getString('uid') ?? '';
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
          iconTheme: IconThemeData(color: Colors.white),
        backgroundColor:Color(0xFF043feb),
        title: Text("Peak Me",style: TextStyle(color: Colors.white),),
        actions: [
          IconButton(onPressed: (){
            Get.to(()=>ProfileScreen(
            ));
          }, icon: Icon(Icons.person,color: Colors.white,)),
          IconButton(onPressed: ()async{
            showDialog(context: context, builder: (_)=>
            AlertDialog(
              title: Text("Logout",style: TextStyle(fontSize: 20),),
              content: Text("are you sure you want to logout of your account?"),
              actions: [
                IconButton(onPressed: () async{
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                 Navigator.pop(context);
                }, icon: Text('No')),
                IconButton(onPressed: () async{
                  final prefs = await SharedPreferences.getInstance();
                  await prefs.clear();
                  Get.offAll(() => Login());
                },icon: Text('Yes'),),
              ],
              elevation: 10,
              backgroundColor: Colors.white70,
            ),
            );
          }, icon: Icon(Icons.logout,color: Colors.white))
        ],
      ),
      drawer: AdminDrawerWidget(),
      body: SingleChildScrollView(
        child: Container(
          color: Colors.white24,
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 100,
                      width: 150,
                      decoration: BoxDecoration(
                        color:  Color(0xFFCCE5FF),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      padding: EdgeInsets.all(16),
                      child: InkWell(
                        onTap: (){
                          Get.to(()=>ReceivedLeadScreen());
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.dashboard, size: 30, color: Colors.black87),
                            SizedBox(height: 12),
                            Text(
                              "Received All Lead",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 100,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Color(0xFFCCE5FF),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      padding: EdgeInsets.all(16),
                      child: InkWell(
                        onTap: (){
                          Get.snackbar("Working mode...", "coming soon..",
                            backgroundColor: Colors.white,);

                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.transfer_within_a_station_outlined, size: 30, color: Colors.black87),
                            SizedBox(height: 12),
                            Text(
                              "Transfer Lead",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 100,
                      width: 150,
                      decoration: BoxDecoration(
                        color: Color(0xFFCCE5FF),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      padding: EdgeInsets.all(16),
                      child: InkWell(
                        onTap: (){
                          Get.to(()=>SearchLeadScreen());
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.search, size: 30, color: Colors.black87),
                            SizedBox(height: 12),
                            Text(
                              "Search Lead",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 100,
                      width: 150,
                      decoration: BoxDecoration(
                        color:  Color(0xFFCCE5FF),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      padding: EdgeInsets.all(16),
                      child: InkWell(
                        onTap: (){
                          Get.snackbar("Working mode...", "coming soon..",
                          backgroundColor: Colors.white,);
                         // Get.to(()=>ImeiScreen());
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.card_travel_outlined, size: 22, color: Colors.black87),
                            SizedBox(height: 10),
                            Text(
                              "Onfield Prepaid \n Card",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 100,
                      width: 150,
                      decoration: BoxDecoration(
                        color:  Color(0xFFCCE5FF),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      padding: EdgeInsets.all(16),
                      child: InkWell(
                        onTap: (){
                          Get.snackbar("Working mode...", "coming soon..",
                            backgroundColor: Colors.white,);
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.file_copy_outlined, size: 22, color: Colors.black87),
                            SizedBox(height: 10),
                            Text(
                              "Today's Collected Lead",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Container(
                      height: 100,
                      width: 150,
                      decoration: BoxDecoration(
                        color:  Color(0xFFCCE5FF),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color:  Color(0xFFCCE5FF),
                            blurRadius: 1,
                            offset: Offset(1, 4),
                          )
                        ],
                      ),
                      padding: EdgeInsets.all(16),
                      child: InkWell(
                        onTap: (){
                          Get.to(()=>TodayTransferredScreen(uid:uid.toString()));
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.transfer_within_a_station_outlined, size: 22, color: Colors.black87),
                            SizedBox(height: 10),
                            Text(
                              "Today's Transfer Lead",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 11,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 10,),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      height: 100,
                      width: 150,
                      decoration: BoxDecoration(
                        color:  Color(0xFFCCE5FF),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.shade300,
                            blurRadius: 6,
                            offset: Offset(0, 4),
                          )
                        ],
                      ),
                      padding: EdgeInsets.all(16),
                      child: InkWell(
                        onTap: (){
                          Get.to(()=>ProfileScreen());
                        },
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(Icons.person, size: 30, color: Colors.black87),
                            SizedBox(height: 12),
                            Text(
                              "Profile",
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                fontSize: 12,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),

                  ],
                ),
                SizedBox(height: 10,)
              ],
            ),
          ),
        ),
      ),

    );
  }
}

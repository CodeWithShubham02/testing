import 'dart:convert';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:http/http.dart' as http;
import 'package:package_info_plus/package_info_plus.dart';
import 'package:project2/controller/receivedLead_controller.dart';
import 'package:project2/model/new_lead_model.dart';
import 'package:project2/view/dashboard_screen.dart';
import 'package:project2/view/lead_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import '../utils/app_constant.dart';

class ReceivedLeadScreen extends StatefulWidget {
  const ReceivedLeadScreen({super.key});

  @override
  State<ReceivedLeadScreen> createState() => _ReceivedLeadScreenState();
}

class _ReceivedLeadScreenState extends State<ReceivedLeadScreen> {

  ReceivedLeadController receivedLeadController=ReceivedLeadController();
  late Future<List<Lead>> leads;

  late String total='';

  String uid = '';
  String branchId = '';
  String appVersion='40';
  String appType='';


  Future<void> loadUserData() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

   // appVersion = packageInfo.version;
    appType = Platform.isIOS ? 'ios' : 'android';
    uid = prefs.getString('uid') ?? '';
    branchId = prefs.getString('branchId') ?? '';
  }


  void launchCaller(String number) async {
    final Uri callUri = Uri(scheme: 'tel', path: number);
    if (await canLaunchUrl(callUri)) {
      await launchUrl(callUri);
    } else {
      print('Could not launch call');
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //loadUserData();
    loadUserData().then((_) {
      setState(() {
        leads = receivedLeadController.fetchLeads(
          uid: uid,
          start: 0,
          end: 10,
          branchId: branchId,
          app_version: '40',
          appType: appType,
        );
      });
    });

  }
  @override
  Widget build(BuildContext context) {
    print("Shubham UID :${total.toString()}");

    return Scaffold(
      appBar: AppBar(
        backgroundColor:AppConstant.appInsideColor,
        title: Text('Lead Received ${total.toString()}',style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),),
          iconTheme: IconThemeData(color: Colors.white)
      ),
      body:leads == null
          ? const Center(child: CircularProgressIndicator())
          : FutureBuilder<List<Lead>>(
        future: leads,
        builder: (context, snapshot) {

          if (snapshot.connectionState == ConnectionState.waiting) {
            print('shubha : '+snapshot.data.toString());
            return const Center(child: CircularProgressIndicator());
          } else if (snapshot.hasError) {
            print('shubha : '+snapshot.data.toString());
            return Center(child: Text('Error: ${snapshot.error}'));
          } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
            return const Center(child: Text('No leads found.'));
          } else {
            List<Lead> leadsList = snapshot.data!;


            return ListView.builder(
              itemCount: leadsList.length,
              itemBuilder: (context, index) {
                final lead = leadsList[index];
                
                total=leadsList.length.toString();
                return Card(
                  color: Colors.white70,
                  elevation: 2,
                  margin: EdgeInsets.all(6),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              lead.customerName.toUpperCase() ?? '',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            CircleAvatar(
                                backgroundColor: AppConstant.appInsideColor,
                                child: IconButton(onPressed: (){
                                  print('hello');
                                  // Step 1: Launch phone call
                                  launchCaller(lead.mobile);
                                  print('hello');
                                }, icon: Icon(Icons.call,color: AppConstant.appTextColor,)))
                          ],
                        ),
                        Divider(),
                        Row(
                          children: [
                            CircleAvatar(backgroundColor:AppConstant.appInsideColor,child: Icon(Icons.location_on, color:Colors.white)),
                            SizedBox(width: 10),
                            Expanded( // Fixes overflow
                              child: Text(
                                lead.clientname,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 2,
                              ),
                            ),
                            Text("N/A", style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                          CircleAvatar(
                          backgroundColor:AppConstant.appInsideColor,
                          child: Icon(
                            Icons.date_range,  color:Colors.white,
                          ),
                        ),
                            const SizedBox(width: 8),
                            Text(lead.leadDate, style: const TextStyle(fontSize: 16)),
                            const Spacer(),
                            Text(lead.apptime, style: const TextStyle(color: Colors.grey)),
                          ],
                        ),
                        const SizedBox(height: 8),
                        Row(
                          children: [
                            CircleAvatar(backgroundColor:AppConstant.appInsideColor,child: Icon(Icons.location_on, color:Colors.white)),
                            SizedBox(width: 10),
                            Expanded( // Fixes overflow
                              child: Text(
                                lead.resAddress,
                                overflow: TextOverflow.ellipsis,
                                maxLines: 4,
                              ),
                            ),

                          ],
                        ),
                        SizedBox(height: 8,),
                        ElevatedButton(
                          onPressed: () {
                           // Get.snackbar("Name", lead.customerName);

                            Get.to(()=>LeadDetailScreen(lead:lead));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstant.appInsideColor,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                          ),
                          child: const Center(
                            child: Text('More Details', style: TextStyle(color: Colors.white,fontSize: 15,)),
                          ),
                        )

                      ],
                    ),
                  ),
                );
              },
            );
          }
        },
      ),
    );
  }
}

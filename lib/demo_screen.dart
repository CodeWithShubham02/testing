import 'dart:io';
import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:package_info_plus/package_info_plus.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:project2/controller/getlead_controller.dart';
import 'package:project2/utils/app_constant.dart';
import 'package:project2/view/lead_detail_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'handler/EncryptionHandler.dart';
import 'model/new_lead_model.dart';

class ImeiScreen extends StatefulWidget {
  @override
  _ImeiScreenState createState() => _ImeiScreenState();
}

class _ImeiScreenState extends State<ImeiScreen> {

  LeadReceivedController receivedAllLeadController=LeadReceivedController();
  late Future<List<Lead>> leads;

  late String total='';

  String uid = '';
  String branchId = '';
  String appVersion='';
  String appType='';


  Future<void> loadUserData() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    final SharedPreferences prefs = await SharedPreferences.getInstance();

    // appVersion = packageInfo.version;
    appType = Platform.isIOS ? 'ios' : 'android';
    appVersion = packageInfo.version;
    uid = prefs.getString('uid') ?? '';
    branchId = prefs.getString('branchId') ?? '';
  }




  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    //loadUserData();
    loadUserData().then((_) {
      setState(() {
        leads =receivedAllLeadController.fetchLeads(
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

                //total=leadsList.length.toString();
                // final decryptedResponse = EncryptionHelper.decryptData(lead.customerName);
                // print(decryptedResponse);
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
                              lead.customerName ?? '',
                              style: TextStyle(fontWeight: FontWeight.bold),
                            ),
                            CircleAvatar(
                                backgroundColor: AppConstant.appInsideColor,
                                child: IconButton(onPressed: (){}, icon: Icon(Icons.call,color: AppConstant.appTextColor,)))
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

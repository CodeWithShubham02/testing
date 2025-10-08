import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/lead_detail_controller.dart';
import '../model/lead_detail_model.dart';
import '../utils/app_constant.dart';

class SearchLeadScreen extends StatefulWidget {
  const SearchLeadScreen({super.key});

  @override
  State<SearchLeadScreen> createState() => _SearchLeadScreenState();
}

class _SearchLeadScreenState extends State<SearchLeadScreen> {
  late String? leadid="";
  Future<LeadResponse?>? _futureLead;

  String mobile = '';
  String uid='';
  Future<void> loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid') ?? '';
    mobile= prefs.getString('mobile')?? '';
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
        backgroundColor: AppConstant.appInsideColor,
        title:  Text('Search Lead',
          style: TextStyle(color: Colors.white,fontSize: 17),
        ),
          iconTheme: IconThemeData(color: Colors.white),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Column(
              children: [
                Text("Mobile : ${uid.toString() + mobile.toString()}"),
                SizedBox(height: 16),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: TextFormField(
                    keyboardType: TextInputType.number,
                    maxLength: 10,
                    onChanged: (value){
                     leadid=value;
                    },
                    validator: (value){
                      if(value!.isEmpty){
                        return 'mobile/leadId';
                      }else{
                        return null;
                      }
                    },
                    decoration: InputDecoration(
                      labelText: 'Enter leadId..',
                      suffixIcon: IconButton(onPressed: (){
                        setState(() {
                          if(leadid != null){
                            if(leadid?.length==7){
                              _futureLead = LeadDetailsController.fetchLeadById(leadid.toString());
                            }else{
                              print("user uid : ${mobile+uid}");
                              print("hello ssg");
                            }

                          }else{
                           // print("Mobile no : ${leadid}");
                          }


                        });
                      }, icon: Icon(Icons.search)),
                      border: OutlineInputBorder(),
                    ),
        
                  ),
                ),
        
                SingleChildScrollView(
                  child: Column(
                    children: [
                      _futureLead==null?Text(""): FutureBuilder<LeadResponse?>(
                        future: _futureLead,
                        builder: (context, snapshot) {
                          if (snapshot.connectionState == ConnectionState.waiting) {
                            return const Center(child: CircularProgressIndicator());
                          }
                          if (snapshot.hasData && snapshot.data!.data.isNotEmpty) {
                            final lead = snapshot.data!.data[0]; // Get the first item
                            final String? callDate = lead.callDate;
                            print("Shubham id :$callDate");
                            return Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${lead.leadId}", style: const TextStyle(fontWeight: FontWeight.bold)),
                                      Text(" ${lead.customerName.toUpperCase()}",style: const TextStyle(fontWeight: FontWeight.bold)),
                                    ],
                                  ),
                                  Divider(),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text("${lead.product}", style: const TextStyle(fontWeight: FontWeight.normal)),
                                      Text(" ${lead.source.toUpperCase()}",style: const TextStyle(fontWeight: FontWeight.normal)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(callDate.toString(), style: const TextStyle(fontWeight: FontWeight.normal)),
                                      Text(" ${lead.empName.toUpperCase()}",overflow:TextOverflow.ellipsis,maxLines:2,style: const TextStyle(fontWeight: FontWeight.normal)),
                                    ],
                                  ),
                                  Divider(),
                                  Text(" ${lead.doc.toUpperCase()}",overflow:TextOverflow.ellipsis,maxLines:2,style: const TextStyle(fontWeight: FontWeight.normal)),
                                  Divider(),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(lead.logo.toString(), style: const TextStyle(fontWeight: FontWeight.normal)),
                                      Text(" ${lead.athenaLeadId.toUpperCase()}",overflow:TextOverflow.ellipsis,maxLines:2,style: const TextStyle(fontWeight: FontWeight.normal)),
                                    ],
                                  ),
                                  const SizedBox(height: 8),
                                  const SizedBox(height: 8),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: [
                                      Text(lead.city.toString(), style: const TextStyle(fontWeight: FontWeight.normal)),
                                      Text(" ${lead.appLoc.toUpperCase()}",overflow:TextOverflow.ellipsis,maxLines:2,style: const TextStyle(fontWeight: FontWeight.normal)),
                                    ],
                                  ),
                                  Divider(),
                                  Text("Dox To Callect, Doc By client :", style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                                  Text("${lead.doc.toUpperCase()}",overflow:TextOverflow.ellipsis,maxLines:2,style: const TextStyle(fontWeight: FontWeight.normal)),
                                  Divider(),
                                  const SizedBox(height: 12),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        onPressed: (){},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:AppConstant.appInsideColor,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        ),
                                        child:   Text('Transfer Lead', style: TextStyle(color: Colors.white,fontSize: 15,fontWeight:FontWeight.bold)),
                                      ),
                                      ElevatedButton(
                                        onPressed: (){
                                          //Get.to(()=>RefixLeadScreen(leadId:lead.leadId.toString(),customer_name:lead.customerName.toString()));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppConstant.appInsideColor,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        ),
                                        child:   Text('Reflix', style: TextStyle(color: Colors.white,fontSize: 15,fontWeight:FontWeight.bold)),
                                      ),

                                    ],
                                  ),
                                  SizedBox(height: 12,),
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                    children: [
                                      ElevatedButton(
                                        onPressed: (){
                                          //Get.to(()=>PostponeLeadScreen(leadId:lead.leadId.toString(),customer_name:lead.customerName.toString(),location:lead.location));
                                        },
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor: AppConstant.appInsideColor,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        ),
                                        child:   Text('Postponed', style: TextStyle(color: Colors.white,fontSize: 15,fontWeight:FontWeight.bold)),
                                      ),
                                      ElevatedButton(
                                        onPressed: (){},
                                        style: ElevatedButton.styleFrom(
                                          backgroundColor:AppConstant.appInsideColor,
                                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                                        ),
                                        child:   Text('Select Documents', style: TextStyle(color: Colors.white,fontSize: 15,fontWeight:FontWeight.bold)),
                                      ),
                                    ],
                                  ),
                                  ElevatedButton(
                                    onPressed: (){},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor:  Colors.green,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                    ),
                                    child: const  Center(child: Text('Status', style: TextStyle(color: Colors.black,fontSize: 15,fontWeight:FontWeight.bold))),
                                  ),
                                  ElevatedButton(
                                    onPressed: (){},
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: AppConstant.appInsideColor,
                                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                                    ),
                                    child: const  Center(child: Text('Generate Submission Result', style: TextStyle(color: Colors.white,fontSize: 15,fontWeight:FontWeight.normal))),
                                  ),
                                ],

                              ),
                            );
                          } else {
                            return const Center(child: Text("No lead found."));
                          }
                        },
                      )
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

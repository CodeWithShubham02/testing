import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:project2/controller/lead_detail_controller.dart';
import 'package:project2/model/lead_detail_model.dart';
import 'package:project2/model/new_lead_model.dart';
import 'package:project2/view/postponed_lead_screen.dart';
import 'package:project2/view/refix_lead_screen.dart';

import '../utils/app_constant.dart';

class LeadDetailScreen extends StatefulWidget {
  Lead lead;
   LeadDetailScreen({super.key, required this.lead});

  @override
  State<LeadDetailScreen> createState() => _LeadDetailScreenState();
}

class _LeadDetailScreenState extends State<LeadDetailScreen> {

  Future<LeadResponse?>? _futureLead;
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _futureLead = LeadDetailsController.fetchLeadById(widget.lead.leadId);

  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor:AppConstant.appInsideColor,
        title: Text('Lead Details ',style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold,color: Colors.white),),
          iconTheme: IconThemeData(color: Colors.white),
      ),
      body: FutureBuilder<LeadResponse?>(
      future: _futureLead,
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        }
        if (snapshot.hasData && snapshot.data!.data.isNotEmpty) {
          final lead = snapshot.data!.data[0]; // Get the first item
          final String? callDate = lead.callDate;
          print("Shubham id :$callDate");
          return SingleChildScrollView(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    height: 60,
                    width: MediaQuery.of(context).size.width,

                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text("Lead Id -",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),),
                            SizedBox(width: 5,),
                            Text("${lead.leadId}", style: const TextStyle(fontWeight: FontWeight.normal,fontSize: 14,color: Colors.red)),
                          ],
                        ),
                    ),
                  ),
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

                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(lead.logo.toString(), style: const TextStyle(fontWeight: FontWeight.normal)),
                      Text(" ${lead.athenaLeadId.toUpperCase()}",overflow:TextOverflow.ellipsis,maxLines:4,style: const TextStyle(fontWeight: FontWeight.normal)),
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
                  Text("Doc To Callect, Doc By client :", style: const TextStyle(fontWeight: FontWeight.bold,fontSize: 16)),
                  Text("${lead.doc.toUpperCase()}",overflow:TextOverflow.ellipsis,maxLines:10,style: const TextStyle(fontWeight: FontWeight.normal)),
                  Divider(),
                  const SizedBox(height: 12),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.all(1.0),
                        child: Container(
                          width: MediaQuery.of(context).size.width*0.9,
                          child: ElevatedButton(
                              onPressed: (){},
                            style: ElevatedButton.styleFrom(
                              backgroundColor:AppConstant.appBattonBack,

                              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                            ),
                              child:   Text('Transfer Lead'.toUpperCase(), style: TextStyle(color: Colors.white,fontSize: 15,fontWeight:FontWeight.normal)),
                          ),
                        ),
                      ),
            
            
                    ],
                  ),
                  SizedBox(height: 5,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: (){
                            Get.to(()=>PostponeLeadScreen(leadId:lead.leadId.toString(),customer_name:lead.customerName.toString(),location:lead.location));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: AppConstant.appBattonBack,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                          child:   Text('Postponed', style: TextStyle(color: Colors.white,fontSize: 15,fontWeight:FontWeight.normal)),
                        ),
                      ),
                      SizedBox(width: 10,),
                      Expanded(
                        child: ElevatedButton(

                          onPressed: (){
                            Get.to(()=>RefixLeadScreen(leadId:lead.leadId.toString(),customer_name:lead.customerName.toString()));
                          },
                          style: ElevatedButton.styleFrom(

                            backgroundColor: AppConstant.appBattonBack,
                            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                          ),
                          child:   Text('Reflix', style: TextStyle(color: Colors.white,fontSize: 15,fontWeight:FontWeight.normal)),
                        ),
                      ),
            
                    ],
                  ),
                  lead.client_mobile_app=="1"?
                    lead.clientId=="11"?
                    ElevatedButton(
                      onPressed: (){},
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  AppConstant.appBattonBack,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                      child: const  Center(child: Text('Start Biometric', style: TextStyle(color: Colors.white,fontSize: 15,fontWeight:FontWeight.normal))),
                    ):
                    lead.clientId=="89"?
                    ElevatedButton(
                      onPressed: (){},
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  AppConstant.appBattonBack,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                      child: const  Center(child: Text('Add Details',
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.white,fontSize: 15,fontWeight:FontWeight.normal,fontFamily: 'impact',))),
                    ):
                    lead.clientId=="38"?
                    ElevatedButton(
                      onPressed: (){},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstant.appBattonBack,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                      child: const  Center(child: Text('Open App', style: TextStyle(color: Colors.white,fontSize: 15,fontWeight:FontWeight.normal))),
                    ):
                    lead.clientId=="28"?
                    ElevatedButton(
                      onPressed: (){},
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  AppConstant.appBattonBack,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                      child: const  Center(child: Text('Opennxt Assisted', style: TextStyle(color: Colors.white,fontSize: 15,fontWeight:FontWeight.normal))),
                    ):
                    ElevatedButton(
                      onPressed: (){},
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  AppConstant.appBattonBack,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                      child: const  Center(child: Text('Open Client App', style: TextStyle(color: Colors.white,fontSize: 15,fontWeight:FontWeight.normal))),
                    ):
                  lead.client_mobile_app=="2"?
                    lead.fiData=="1"?
                    ElevatedButton(
                      onPressed: (){},
                      style: ElevatedButton.styleFrom(
                        backgroundColor: AppConstant.appBattonBack,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                      child: const  Center(child: Text('Select Doc', style: TextStyle(color: Colors.white,fontSize: 15,fontWeight:FontWeight.normal))),
                    ):
                    ElevatedButton(
                      onPressed: (){},
                      style: ElevatedButton.styleFrom(
                        backgroundColor:  AppConstant.appBattonBack,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                      ),
                      child: const  Center(child: Text('Field Invest', style: TextStyle(color: Colors.white,fontSize: 15,fontWeight:FontWeight.normal))),
                    ):
                  lead.client_mobile_app=="3"?
                  ElevatedButton(
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  AppConstant.appBattonBack,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    ),
                    child: const  Center(child: Text('Open fi url', style: TextStyle(color: Colors.white,fontSize: 15,fontWeight:FontWeight.normal))),
                  ):ElevatedButton(
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppConstant.appBattonBack,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    ),
                    child: const  Center(child: Text('Select doc', style: TextStyle(color: Colors.white,fontSize: 15,fontWeight:FontWeight.normal))),
                  ),
                  ElevatedButton(
                    onPressed: (){},
                    style: ElevatedButton.styleFrom(
                      backgroundColor:  Colors.green,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(5)),
                    ),
                    child: const  Center(child: Text('Status', style: TextStyle(color: Colors.white,fontSize: 15,fontWeight:FontWeight.normal))),
                  ),
                  lead.clientId==49?
                    Text("Message (Bank Bazar staus ${lead.surrogate})"):Text(''),
            
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
            ),
          );
        } else {
          return const Center(child: Text("No lead found."));
        }
      },
    ),

    );
  }
}

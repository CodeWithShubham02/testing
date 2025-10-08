import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/date_time_patterns.dart';
import 'package:project2/model/lead_detail_model.dart';
import 'package:project2/services/manage_http_response.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/refix_lead_controller.dart';
import '../model/reason_item_model.dart';
import '../model/time_slot_model.dart';
import '../services/reasom_services.dart';
import '../services/timeslot_service.dart';
import '../utils/app_constant.dart';

class RefixLeadScreen extends StatefulWidget {
  final String leadId;
  final String customer_name;
   RefixLeadScreen({super.key, required this.leadId, required this.customer_name});

  @override
  State<RefixLeadScreen> createState() => _RefixLeadScreenState();
}

class _RefixLeadScreenState extends State<RefixLeadScreen> {

  //fetch reason start code
  List<ReasonItem> reasons = [];
  String? selectedReason;
  final TextEditingController remark=TextEditingController();
  void loadReasons() async {
    try {
      final fetchedReasons = await ReasonService.fetchReasons(widget.leadId);
      setState(() {
        reasons = fetchedReasons;
      });
    } catch (e) {
      print("Error loading reasons: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Failed to load reasons")),
      );
    }
  }
  //end fetch reason code here

  //start time slot dropdown
  List<Timeslot> timeslotList = [];
  String? selectedTimeslot;
  void loadTimeslots() async {
    try {
      final data = await TimeslotService.fetchTimeSlots();
      setState(() {
        timeslotList = data;
      });
    } catch (e) {
      print("Error fetching timeslots: $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Failed to load timeslots")),
      );
    }
  }
  //end timeslot dropdown
  String currentDate = "";

  Future<void> dateTime() async {
    DateTime? datePickerd = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2025),
      lastDate: DateTime(2030),
    );

    if (datePickerd != null) {
      setState(() {
        currentDate =
        '${datePickerd.day}-${datePickerd.month}-${datePickerd.year}';
      });
    }
  }
  String _location = '';
  String uid = '';
  Future<void> loadUserData() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    uid = prefs.getString('uid') ?? '';
  }
  @override
  void initState() {
    super.initState();
    loadReasons();
    loadTimeslots();
    loadUserData();
  }
  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(
          backgroundColor: AppConstant.appInsideColor,
          title:  Text(widget.customer_name.toString(),
            style: TextStyle(color: Colors.white,fontSize: 17),
          ),
          iconTheme: IconThemeData(color: Colors.white),
      ),
      body:SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Select that date and time  you want to Refix Appointment : *',style: TextStyle(color: Colors.red,fontSize: 14,fontWeight: FontWeight.bold,fontFamily: 'RaleWay'),),
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: ElevatedButton(
                  onPressed: () async{
                    dateTime();
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                  ),
                  child: Container(
                width: 150,
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Text('Select Date',style: TextStyle(color: Colors.black,fontWeight: FontWeight.bold,fontFamily: 'Roleway'),),
                    SizedBox(width: 10,),
                    Icon(Icons.date_range_outlined,color: AppConstant.appInsideColor,),
                  ],
                ),
              )),
            ),

            currentDate.isEmpty?SizedBox():Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                readOnly: true,
                decoration: InputDecoration(
                  hintText: currentDate,
                  hintStyle: TextStyle(color: Colors.black,fontWeight: FontWeight.bold),
                  border: OutlineInputBorder()
                ),
              ),
            ),

            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Choose Time Slot :',style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold,fontFamily: 'RaleWay'),),
            ),
            timeslotList.isEmpty
                ? const Center(child: CircularProgressIndicator())
                : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Expanded(
                        child: DropdownButtonFormField<String>(
                                      value: selectedTimeslot,
                                      items: timeslotList.map((slot) {
                        return DropdownMenuItem<String>(
                          value: slot.timeslot,
                          child: Text(slot.timeslot),
                        );
                                      }).toList(),
                                      onChanged: (value) {
                        setState(() {
                          selectedTimeslot = value;
                        });
                                      },
                                      decoration: const InputDecoration(
                        labelText: "Time slot",
                        labelStyle: TextStyle(fontSize: 14),
                        border: OutlineInputBorder(),
                                      ),
                                    ),
                      ),
                    ],
                  ),
                ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Select that location at where you want to Refix Appointment : *',style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold,fontFamily: 'RaleWay'),),
            ),
            Column(
              children: [
                RadioListTile<String>(
                  title: Text('Office'),
                  value: 'Office',
                  groupValue: _location,
                  onChanged: (value) {
                    setState(() {
                      _location = value!;
                    });
                  },
                ),
                RadioListTile<String>(
                  title: Text('Residence'),
                  value: 'Residence',
                  groupValue: _location,
                  onChanged: (value) {
                    setState(() {
                      _location = value!;
                    });
                  },
                ),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Select reason for Refix Appointment : *',style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold,fontFamily: 'RaleWay'),),
            ),
            reasons.isEmpty?CircularProgressIndicator()
                : Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                  Expanded(
                    child: DropdownButtonFormField<String>(

                      hint: Text('Select Reason',style: TextStyle(fontSize: 14,fontWeight: FontWeight.normal),),
                      value: selectedReason,
                      items: reasons.map((item) {
                        return DropdownMenuItem<String>(
                          value: item.reason,
                          child: Text(item.reason,style: TextStyle(fontSize: 11.5,color: Colors.black,fontWeight: FontWeight.bold),),

                        );
                      }).toList(),
                      onChanged: (value) {
                        setState(() {
                          selectedReason = value;
                        });
                      },
                      decoration:  InputDecoration(


                        border: OutlineInputBorder(
                        ),
                      ),
                    ),
                  ),
                                ],
                              ),
                ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text('Enter remarks for Refix Appointment : ',style: TextStyle(color: Colors.black,fontSize: 14,fontWeight: FontWeight.bold,fontFamily: 'RaleWay'),),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                controller: remark,
                decoration: InputDecoration(
                  hint: Text("Enter here remark?"),
                  border: OutlineInputBorder()
                ),
              ),
            ),

          ],
        ),
      ),
      bottomNavigationBar: Container(
        width: 416,
        height: 50,
        
        clipBehavior: Clip.hardEdge,
        decoration:const BoxDecoration(

        ),
        child: ElevatedButton(
            onPressed: () async{

                if (_location.isEmpty || selectedReason == null || currentDate.isEmpty) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text("Please fill all required fields")),
                  );
                  return;
                }
                final response = await RefixLeadService.submitRefixLead(
                  loginId: uid.toString(), // example
                  leadId: widget.leadId,
                  newDate: currentDate, // must be "dd-MM-yyyy"
                  newTime: selectedTimeslot ?? "",
                  location: _location,
                  reason: selectedReason!,
                  remark: remark.toString(), // could be controller.text
                  // You can fetch GPS if needed
                );

                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(content: Text(response.message)),
                );// All required fields filled
                if (response.success == 1) {
                  Navigator.pop(context);
                }

        },
            style: ElevatedButton.styleFrom(
              backgroundColor:AppConstant.appInsideColor,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(1)),
            ),
            child: Center(
              child: Text("Refix Appointment",style: TextStyle(color: Colors.white,fontSize: 16),),
            ))
      ),
    );
  }
}

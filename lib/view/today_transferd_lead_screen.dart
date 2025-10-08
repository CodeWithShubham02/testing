import 'package:flutter/material.dart';
import 'package:project2/utils/app_constant.dart';
import 'package:shared_preferences/shared_preferences.dart';

import '../controller/today_transfer_controller.dart';
import '../model/today_transfer_lead_model.dart';

class TodayTransferredScreen extends StatefulWidget {
  final String uid;
   TodayTransferredScreen({super.key, required this.uid});

  @override
  State<TodayTransferredScreen> createState() => _TodayTransferredScreenState();
}

class _TodayTransferredScreenState extends State<TodayTransferredScreen> {
  late Future<TodayTransferredResponse?> _future;

  @override
  void initState() {
    super.initState();

    _future = fetchTodayTransferred(widget.uid); // <-- Change UID as needed
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: AppConstant.appInsideColor,
          title: const Text('Today\'s Transfers',style: TextStyle(color: Colors.white),)),
      body: FutureBuilder<TodayTransferredResponse?>(
        future: _future,
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const Center(child: CircularProgressIndicator());
          }
          if (snapshot.hasError || snapshot.data == null || !snapshot.data!.success) {
            return const Center(child: Text('No data found or API failed.'));
          }
          final dataList = snapshot.data!.data;
          print('-------SGS');
          print(dataList.toString());

          return  ListView.builder(
            itemCount: dataList.length,
            itemBuilder: (context, index) {
              final item = dataList[index];
              return  item==''?Center(child: Text("no data",style: TextStyle(color: Colors.black),)):Card(
                elevation: 5,
                color: Colors.white,
                margin: const EdgeInsets.all(8),
                child: ListTile(
                  title: Text(item.customerName,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 15),maxLines: 1,overflow: TextOverflow.ellipsis,),
                  subtitle: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Divider(),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                        Text(
                              "Executive :",
                              style: TextStyle(fontSize: 14),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          SizedBox(width: 10,),
                          Expanded( // Fixes overflow
                            child: Text(
                              item.executive,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),

                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Total Transfered :",
                            style: TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          SizedBox(width: 10,),
                          Expanded( // Fixes overflow
                            child: Text(
                              item.totalTransfered.toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),

                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Total Refixed :",
                            style: TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          SizedBox(width: 10,),
                          Expanded( // Fixes overflow
                            child: Text(
                              item.totalRefixed.toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),

                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Total Postponed :",
                            style: TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          SizedBox(width: 10,),
                          Expanded( // Fixes overflow
                            child: Text(
                              item.totalPostponed.toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),

                        ],
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Text(
                            "Total Collected :",
                            style: TextStyle(fontSize: 14),
                            overflow: TextOverflow.ellipsis,
                            maxLines: 1,
                          ),
                          SizedBox(width: 10,),
                          Expanded( // Fixes overflow
                            child: Text(
                              item.totalCollected.toString(),
                              overflow: TextOverflow.ellipsis,
                              maxLines: 3,
                            ),
                          ),

                        ],
                      ),
                    ],
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}

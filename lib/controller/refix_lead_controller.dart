import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/refix_lead_model.dart';


class RefixLeadService {
  static Future<RefixLeadResponse> submitRefixLead({
    required String loginId,
    required String leadId,
    required String newDate,       // format: dd-MM-yyyy
    required String newTime,       // format: HH:mm
    required String location,
    required String reason,
    required String remark,

  }) async {
    final Uri url = Uri.parse("https://fms.bizipac.com/ws/refixlead.php?loginid=$loginId&leadid=$leadId&newdate=$newDate&location=$location&reason=$reason&newtime=$newTime&remark=$remark");

    final response = await http.post(url);
      print('-------------------------shubham----------');
      print(response.body);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        return RefixLeadResponse.fromJson(jsonData);
      } else {
        return RefixLeadResponse(success: 0, message: "Server error: ${response.statusCode}");
      }

  }
}

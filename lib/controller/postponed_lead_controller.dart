import 'dart:convert';
import 'package:http/http.dart' as http;
import '../model/postponed_lead_model.dart'; // adjust path as needed

Future<PostponeLeadResponse> postponeLead({
  required String loginId,
  required String leadId,

  required String remark,
  required String location,
  required String reason,
  required String newDate,  // Optional, currently not used in PHP
  required String newTime,  // Optional, currently not used in PHP
}) async {
  final uri = Uri.parse("https://fms.bizipac.com/ws/postponedlead.php");

  final response = await http.post(
    uri,
    body: {
      "loginid": loginId,
      "leadid": leadId,
      "remark": remark,
      "location": location,
      "reason": reason,
      "newdate": newDate,
      "newtime": newTime,
    },
  );

  if (response.statusCode == 200) {
    final jsonResponse = json.decode(response.body);
    return PostponeLeadResponse.fromJson(jsonResponse);
  } else {
    throw Exception("Failed to postpone lead");
  }
}

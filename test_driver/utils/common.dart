import 'dart:convert';

import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';

Future<bool> getWaterPrecipitationAmountInInches(String zip_code) async {
  final dateTo = DateFormat('yyyy-MM-dd').format(DateTime.now()).toString();
  final dateFrom = DateFormat('yyyy-MM-dd').format(DateTime.now().subtract(Duration(days: 6))).toString();
  final headers = {
    'x-apikey': '66uDJB56vxrn21s20bIRV4:5Tbtvh57snQ864pkNs1oIG'
  };
  final request = http.Request('GET', Uri.parse('https://rc.api.scotts.com/water/v1/waterGuest/$zip_code?dateFrom=$dateFrom&dateTo=$dateTo&source=scottsprogram.com&sourceService=LS&transId=f2129f64-35f7-47e2-8557-6f60fe2817e4'));

  request.headers.addAll(headers);

  final response = await request.send();
  var total_precip = 0.00;
  if (response.statusCode == 200) {
    final data = await response.stream.bytesToString();
    final Map<String,dynamic> waterData  = json.decode(data.trim());
    for(var precipitation in waterData['precipitations']) {
      total_precip += precipitation['precipAmount'];
    }
  }
  return (1 - total_precip < 1) ? true : false;
}
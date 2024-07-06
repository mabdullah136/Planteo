import 'dart:convert';
import 'dart:developer';
import 'package:http/http.dart' as http;
import 'package:planteo/utils/exports.dart'; // Replace with your actual imports
import 'package:get/get.dart';

class LocationController extends GetxController {
  final long = ''.obs;
  final lat = ''.obs;
  final isLoading = false.obs;

  RxList<HerbsModel> recommendations = RxList<HerbsModel>();
  @override
  onInit() {
    super.onInit();
    sendLocation();
  }

  Future<void> sendLocation() async {
    log('Sending location');
    try {
      if (lat.isEmpty || long.isEmpty) {
        log('Latitude or longitude is empty');
        return; // Exit early if latitude or longitude is empty
      }

      final body = {
        'latitude': lat.value,
        'longitude': long.value,
        // 'latitude': '31.4219983',
        // 'longitude': '74.256',
      };

      final response = await http.post(
        Uri.parse('$baseUrl/herb/suggest_plants/'),
        body: body,
      );
      log('response of recommendations${response.body}');

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final herbsModel = HerbsModel.fromJson(jsonData);
        final herbModels = herbsModel.data
            .map(
                (datum) => HerbsModel(status: herbsModel.status, data: [datum]))
            .toList();
        recommendations.assignAll(herbModels);

        log('Location sent');
        update();
      } else {
        log('Failed to send location: ${response.statusCode}');
      }
    } catch (e) {
      log('Failed to send location: $e');
      Get.snackbar('Error', 'Failed to send location');
    }
  }
}

import 'dart:developer';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:planteo/models/herb_details.dart';
import 'package:planteo/utils/exports.dart';

class HerbsController extends GetxController {
  final isLoading = false.obs;

  Stream<HerbsModel> getHerbs() async* {
    try {
      isLoading(true);
      final url = Uri.parse('$baseUrl/herb/list/');

      final response = await http.get(url);
      // log(response.body);
      if (response.statusCode == 200) {
        final herbs = herbsModelFromJson(response.body);
        yield herbs;
      } else {
        // Handle the error case
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      log(e.toString());
    } finally {
      isLoading(false);
    }
  }

  Stream<HerbDetailModel> getHerbDetail(String id) async* {
    try {
      isLoading(true);
      final body = {'id': id};
      final url = Uri.parse('$baseUrl/herb/detail/');
      final response = await http.post(url, body: body);
      log(response.body);
      if (response.statusCode == 200) {
        final herbDetail = herbDetailModelFromJson(response.body);
        yield herbDetail;
      } else {
        // Handle the error case
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
      log(e.toString());
    } finally {
      isLoading(false);
    }
  }
}

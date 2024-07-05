import 'dart:convert';
import 'dart:developer';

import 'package:planteo/models/garden_detail_model.dart';
import 'package:planteo/models/garden_model.dart';
import 'package:planteo/utils/exports.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GardenController extends GetxController {
  final gardenNameController = TextEditingController();
  final gardenHeightController = TextEditingController();
  final gardenWidthController = TextEditingController();

  final isLoading = false.obs;

  RxList<Garden> gardens = RxList<Garden>();
  @override
  void onInit() {
    super.onInit();
    getGardens();
  }

  Future<void> getGardens() async {
    try {
      isLoading(true);
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response =
          await http.get(Uri.parse('$baseUrl/herb/list/garden/'), headers: {
        'Authorization': 'JWT $token',
      });
      log(response.body);
      if (response.statusCode == 200) {
        log('Gardens fetched successfully');
        final List<dynamic> jsonData = jsonDecode(response.body);
        final List<Garden> gardenList =
            jsonData.map((garden) => Garden.fromJson(garden)).toList();
        gardens.assignAll(gardenList);
      } else {
        gardens.clear();
        log('Failed to get gardens: ${response.statusCode}');
      }
    } catch (e) {
      log('Failed to get gardens: $e');
      Get.snackbar('Error', 'Failed to get gardens');
    } finally {
      isLoading(false);
    }
  }

  createGarden() async {
    try {
      if (gardenNameController.text.isEmpty ||
          gardenHeightController.text.isEmpty ||
          gardenWidthController.text.isEmpty) {
        Get.snackbar('Error', 'Please fill all the fields');
        return;
      }
      if (gardenHeightController.text.contains('.') ||
          gardenWidthController.text.contains('.') ||
          gardenHeightController.text.contains(',') ||
          gardenWidthController.text.contains(',') ||
          gardenHeightController.text.contains('-') ||
          gardenWidthController.text.contains('-')) {
        Get.snackbar('Error', 'Please enter a valid number');
        return;
      }
      isLoading(true);
      final body = {
        'name': gardenNameController.text,
        'length': gardenHeightController.text,
        'width': gardenWidthController.text,
      };
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await http.post(
        Uri.parse('$baseUrl/herb/create/garden/'),
        headers: {
          'Authorization': 'JWT $token',
        },
        body: body,
      );
      if (response.statusCode == 201) {
        // Get.snackbar('Success', 'Garden created successfully');
        gardenNameController.clear();
        gardenHeightController.clear();
        gardenWidthController.clear();
        getGardens();
      } else {
        log('Failed to create garden: ${response.statusCode}');
      }
    } catch (e) {
      log('Failed to create garden: $e');
      Get.snackbar('Error', 'Failed to create garden');
    }
  }

  updateGarden(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final body = {
        "name": gardenNameController.text,
      };
      final response = await http.put(
        Uri.parse('$baseUrl/herb/update/garden/$id/'),
        headers: {
          'Authorization': 'JWT $token',
        },
        body: body,
      );

      if (response.statusCode == 200) {
        // Get.snackbar('Success', 'Garden updated successfully');
        getGardens();
        gardenNameController.clear();
      } else {
        log('Failed to update garden: ${response.statusCode}');
      }
    } catch (e) {
      log('Failed to update garden: $e');
      Get.snackbar('Error', 'Failed to update garden');
    }
  }

  deleteGarden(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await http.delete(
        Uri.parse('$baseUrl/herb/delete/garden/$id/'),
        headers: {
          'Authorization': 'JWT $token',
        },
      );

      if (response.statusCode == 204) {
        // Get.snackbar('Success', 'Garden deleted successfully');
        getGardens();
      } else {
        log('Failed to delete garden: ${response.statusCode}');
      }
    } catch (e) {
      log('Failed to delete garden: $e');
      Get.snackbar('Error', 'Failed to delete garden');
    }
  }

  var gardenDetails = <GardenDetail>[].obs;

  Future<void> fetchGardenDetails(String id) async {
    isLoading(true);
    try {
      log('Fetching garden details');
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await http.get(
        Uri.parse('$baseUrl/herb/gardens/$id/details/'),
        headers: {'Authorization': 'JWT $token'},
      );
      log("dasjfas${response.body}");
      if (response.statusCode == 200) {
        gardenDetails.value = gardenDetailFromJson(response.body);
      } else {
        log('Failed to load garden details');
        gardenDetails.clear();
      }
    } catch (e) {
      log('Error: $e');
    } finally {
      isLoading(false);
    }
  }

  createGardenDetail(GardenDetail detail) async {
    try {
      isLoading(true);
      final body = {
        'row_no': detail.rowNo.toString(),
        'column_no': detail.columnNo.toString(),
        'garden': detail.garden.toString(),
        'herb': detail.id.toString(),
      };

      log(body.toString());
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await http.post(
        Uri.parse('$baseUrl/herb/add/'),
        headers: {
          'Authorization': 'JWT $token',
        },
        body: body,
      );
      log(response.body);
      if (response.statusCode == 201) {
        // Get.snackbar('Success', 'Garden detail created successfully');
        gardenNameController.clear();
        gardenHeightController.clear();
        gardenWidthController.clear();
        // fetchGardenDetails(detail.garden.toString());
      } else {
        log('Failed to create garden detail: ${response.statusCode}');
      }
    } catch (e) {
      log('Failed to create garden detail from catch: $e');
      Get.snackbar('Error', 'Failed to create garden detail');
    } finally {
      isLoading(false);
    }
  }

  deleteGardenDetail(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final response = await http.delete(
        Uri.parse('$baseUrl/herb/gardens/plant/$id/delete/'),
        headers: {
          'Authorization': 'JWT $token',
        },
      );
      if (response.statusCode == 204) {
        // Get.snackbar('Success', 'Garden detail deleted successfully');
        // fetchGardenDetails(detail.garden.toString());
      } else {
        log('Failed to delete garden detail: ${response.statusCode}');
      }
    } catch (e) {
      log('Failed to delete garden detail: $e');
      Get.snackbar('Error', 'Failed to delete garden detail');
    }
  }
}

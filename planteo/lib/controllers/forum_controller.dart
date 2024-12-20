import 'dart:developer';
import 'dart:io';

import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:planteo/models/forum_details.dart';
import 'package:planteo/models/forum_model.dart';
import 'package:planteo/utils/exports.dart';
import 'package:http/http.dart' as http;
import 'package:rxdart/rxdart.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForumController extends GetxController {
  final isLoading = false.obs;

  final imgpath = ''.obs;

  final forumDetail = <ForumModel>[].obs;
  final forumSearchController = TextEditingController();

  final titleController = TextEditingController();
  final descriptionController = TextEditingController();

  final feebackController = TextEditingController();
  final _searchQuery = BehaviorSubject<String>();

  Stream<String> get searchQueryStream => _searchQuery.stream;

  @override
  void onInit() {
    super.onInit();
    // Add a listener to the TextEditingController to update the search query
    _searchQuery.add('');
    forumSearchController.addListener(() {
      _searchQuery.add(forumSearchController.text);
    });
  }

  checkPermission() async {
    final status = await Permission.camera.status;
    if (status.isDenied) {
      await Permission.camera.request();
    }
  }

  pickImage(context) async {
    final PermissionStatus status = await Permission.camera.request();
    await checkPermission();
    if (status.isGranted) {
      // Show picker dialog
      try {
        final img = await ImagePicker()
            .pickImage(source: ImageSource.camera, imageQuality: 100);

        if (img == null) {
          return;
        }

        imgpath.value = img.path;
        log(img.path);
        // sendImage(channel, img.path, username, secondUserId);
        // VxToast.show(context, msg: "Image selected");
        Get.snackbar('', 'Image Selected');
      } on PlatformException catch (e) {
        Get.snackbar("Error", e.toString());
      }
    } else {
      if (status.isPermanentlyDenied) {
        // Guide user to app settings
        openAppSettings();
      }
      // Handle denied or permanently denied
      Get.snackbar("Error", "Permission denied");
    }
  }

  // Stream<List<ForumModel>> getForum() async* {
  //   try {
  //     isLoading(true);
  //     final url = forumSearchController.text.isNotEmpty
  //         ? Uri.parse(
  //             '$baseUrl/user/listofequery/?search=${forumSearchController.text}')
  //         : Uri.parse('$baseUrl/user/listofequery/');

  //     final response = await http.get(url);
  //     if (response.statusCode == 200) {
  //       final List<ForumModel> forum = forumModelFromJson(response.body);
  //       yield forum;
  //     } else {
  //       // Handle the error case
  //     }
  //   } catch (e) {
  //     Get.snackbar('Error', e.toString());
  //   } finally {
  //     isLoading(false);
  //   }
  // }
  Stream<List<ForumModel>> getForum() async* {
    log('getForum');
    await for (final query in _searchQuery) {
      log('query: $query');
      try {
        isLoading(true);
        final url = query.isNotEmpty
            ? Uri.parse('$baseUrl/user/listofequery/?search=$query')
            : Uri.parse('$baseUrl/user/listofequery/');

        log('url: $url');

        final response = await http.get(url);
        log('response${response.statusCode}');
        if (response.statusCode == 200) {
          final List<ForumModel> forum = forumModelFromJson(response.body);
          yield forum;
        } else {
          final List<ForumModel> forum = [];
          yield forum;
        }
      } catch (e) {
        Get.snackbar('Error', e.toString());
      } finally {
        isLoading(false);
      }
    }
  }

  likeFeedback(String feedback) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final url = Uri.parse('$baseUrl/user/feedback/like/');
      final response = await http.post(url,
          headers: {'Authorization': 'JWT $token'},
          body: {'feedback_info': feedback});
      log(response.body);

      if (response.statusCode == 200) {
        // Get.snackbar('Success', 'Feedback liked successfully');
      } else {
        Get.snackbar('Error', 'Something went wrong');
      }
    } catch (e) {
      log(e.toString());
    }
  }

  Stream<List<ForumModel>> getForumBySearch() async* {
    log(forumSearchController.text.toString());
    try {
      log(forumSearchController.text);
      isLoading(true);
      final query = forumSearchController.text;
      final url = Uri.parse('$baseUrl/user/listofequery/?search=$query');

      final response = await http.get(url);

      if (response.statusCode == 200) {
        final List<ForumModel> forum = forumModelFromJson(response.body);
        yield forum;
      } else {
        // Handle the error case
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    } finally {
      isLoading(false);
    }
  }

  createForum() async {
    try {
      if (titleController.text.isEmpty) {
        Get.snackbar('Error', 'Title is required');
      } else if (descriptionController.text.isEmpty) {
        Get.snackbar('Error', 'Description is required');
      } else {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        // Prepare the request
        final url = Uri.parse('$baseUrl/user/createquery/');
        final request = http.MultipartRequest('POST', url);
        request.headers['Authorization'] = 'JWT $token';
        request.fields['subject'] = titleController.text;
        request.fields['description'] = descriptionController.text;

        // Add the image data if available
        if (imgpath.value.isNotEmpty && File(imgpath.value).existsSync()) {
          var file = await http.MultipartFile.fromPath('image', imgpath.value);
          request.files.add(file);
        }

        // Send the request
        final streamedResponse = await request.send();

        // Handle the response
        final response = await http.Response.fromStream(streamedResponse);

        if (response.statusCode == 201) {
          // Get.snackbar('Success', 'Forum created successfully');
          titleController.clear();
          descriptionController.clear();
          imgpath.value = '';
        } else {
          Get.snackbar('Error', 'Something went wrong');
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while creating forum');
    }
  }

  Stream<ForumDetail> getForumDetail(int id) async* {
    try {
      isLoading(true);
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final url = Uri.parse('$baseUrl/user/queries/${id.toString()}/');
      final response =
          await http.get(url, headers: {'Authorization': 'JWT $token'});
      log(response.body);
      if (response.statusCode == 200) {
        final forumDetail = forumDetailFromJson(response.body);
        yield forumDetail;
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

  likeForum(int id) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final url = Uri.parse('$baseUrl/user/likequery/');
      final response = await http.post(url,
          headers: {'Authorization': 'JWT $token'},
          body: {'query_id': id.toString()});

      log(response.body);
      if (response.statusCode == 200) {
        // Get.snackbar('Success', 'Forum liked successfully');
        getForumDetail(id);
      } else {
        Get.snackbar('Error', 'Something went wrong');
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while liking forum');
    }
  }

  createFeedback(int id) async {
    try {
      if (feebackController.text.isEmpty) {
        Get.snackbar('Error', 'Feedback is required');
      } else {
        final prefs = await SharedPreferences.getInstance();
        final token = prefs.getString('token');
        // Prepare the request
        final url = Uri.parse('$baseUrl/user/createfeedback/');
        final response = await http.post(url, headers: {
          'Authorization': 'JWT $token'
        }, body: {
          'info': id.toString(),
          'feedback_text': feebackController.text
        });

        log(response.body);
        if (response.statusCode == 201) {
          // Get.snackbar('Success', 'Feedback created successfully');
          feebackController.clear();
          getForumDetail(id);
        } else {
          Get.snackbar('Error', 'Something went wrong');
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'An error occurred while creating feedback');
    }
  }

  @override
  void onClose() {
    forumSearchController.dispose();
    _searchQuery.close();
    super.onClose();
  }

  // Stream<ForumDetailModel> getForumDetail(String id) async* {
  //   try {
  //     isLoading(true);
  //     final body = {'id': id};
  //     final url = Uri.parse('$baseUrl/forum/detail/');
  //     final response = await http.post(url, body: body);
  //     log(response.body);
  //     if (response.statusCode == 200) {
  //       final forumDetail = forumDetailModelFromJson(response.body);
  //       yield forumDetail;
  //     } else {
  //       // Handle the error case
  //     }
  //   } catch (e) {
  //     Get.snackbar('Error', e.toString());
  //     log(e.toString());
  //   } finally {
  //     isLoading(false);
  //   }
  // }
}

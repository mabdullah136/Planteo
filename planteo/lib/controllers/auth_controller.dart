import 'dart:convert';
import 'dart:developer';

import 'package:image_picker/image_picker.dart';
import 'package:planteo/services/notification_services.dart';
import 'package:planteo/utils/exports.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class AuthController extends GetxController {
  final emailController = TextEditingController();
  final passwordController = TextEditingController();
  final confirmPasswordController = TextEditingController();
  final nameController = TextEditingController();
  final otpController = TextEditingController();
  final phoneController = TextEditingController();
  final bioController = TextEditingController();
  final firstNameController = TextEditingController();
  final lastNameController = TextEditingController();

  final isLocalImageSelected = ''.obs;

  final _name = ''.obs;
  final _token = ''.obs;
  final _email = ''.obs;
  final image = ''.obs;
  final _bio = ''.obs;

  get name => _name.value;
  get token => _token.value;
  get email => _email.value;
  // get image => _image.value;
  get bio => _bio.value;

  final picLoading = false.obs;

  @override
  void onInit() {
    getUserDetails();
    super.onInit();
  }

  pickImage(context) async {
    try {
      picLoading.value = true;
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final img = await ImagePicker().pickImage(source: ImageSource.gallery);
      if (img == null) {
        return;
      }
      isLocalImageSelected.value = img.path;
      final url = Uri.parse('$baseUrl/user/update/');
      final request = http.MultipartRequest('POST', url)
        ..files.add(await http.MultipartFile.fromPath('image', img.path))
        ..headers['Authorization'] = 'JWT $token';
      final response = await request.send();
      if (response.statusCode == 200) {
        // Get.snackbar('Success', 'Image uploaded successfully');
        getUserDetails();
      } else {
        Get.snackbar('Error', 'Something went wrong');
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    } finally {
      picLoading.value = false;
    }
  }

  signUP() async {
    try {
      if (nameController.text.isEmpty) {
        Get.snackbar('Error', 'Name is required');
      } else if (emailController.text.isEmpty) {
        Get.snackbar('Error', 'Email is required');
      } else if (passwordController.text.isEmpty) {
        Get.snackbar('Error', 'Password is required');
      } else {
        final url = Uri.parse('$baseUrl/user/create/');
        final data = {
          'username': nameController.text.trim(),
          'email': emailController.text.trim().toLowerCase(),
          'password': passwordController.text,
        };

        final response = await http.post(url, body: data);
        if (response.statusCode == 201) {
          // Get.snackbar('Success', 'User created successfully');
          Get.to(() => const LoginScreen());
        } else {
          Get.snackbar('Error', 'Something went wrong');
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    }
  }

  login() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      if (emailController.text.isEmpty) {
        Get.snackbar('Error', 'Email is required');
      } else if (passwordController.text.isEmpty) {
        Get.snackbar('Error', 'Password is required');
      } else {
        final url = Uri.parse('$baseUrl/user/login/');
        String? fcmToken;
        await NotificationService().getFCMToken().then((value) {
          fcmToken = value;
          return value;
        });
        final data = {
          'email': emailController.text.trim().toLowerCase(),
          'password': passwordController.text,
          'fcm_token': fcmToken ?? '',
        };

        log(data.toString());

        final response = await http.post(url, body: data);
        log(response.body);
        if (response.statusCode == 200) {
          prefs.setString('token', jsonDecode(response.body)['token']);
          _token.value = jsonDecode(response.body)['token'];
          // Get.snackbar('Success', 'Login successful');
          getUserDetails();
          clearControllers();
          // Get.offAll(() => const Home());
          Get.offAll(() => const Home());
        } else {
          Get.snackbar('Error', jsonDecode(response.body)['error']);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
      log(e.toString());
    }
  }

  getUserDetails() async {
    try {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final url = Uri.parse('$baseUrl/user/update/');
      final response = await http.post(url, headers: {
        'Authorization': 'JWT $token',
      });
      log(response.body);
      if (response.statusCode == 200) {
        _name.value = jsonDecode(response.body)['first_name'].toString();
        firstNameController.text = jsonDecode(response.body)['first_name'];
        if (jsonDecode(response.body)['last_name'] != null &&
            jsonDecode(response.body)['last_name'].toString() != '') {
          _name.value += ' ${jsonDecode(response.body)['last_name']}';
          lastNameController.text = jsonDecode(response.body)['last_name'];
        }
        _email.value = jsonDecode(response.body)['email'];
        emailController.text = jsonDecode(response.body)['email'];
        if (jsonDecode(response.body)['phone'] != null) {
          phoneController.text = jsonDecode(response.body)['phone'];
        }
        if (jsonDecode(response.body)['image'] != null) {
          image.value = jsonDecode(response.body)['image'];
          update();
          // image = jsonDecode(response.body)['image'];
        } else {
          image.value = '';
        }
        _bio.value = jsonDecode(response.body)['bio'];
      } else {
        // Get.snackbar('Error', 'Something went wrong');
        Get.snackbar('Error', jsonDecode(response.body)['error']);
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    }
  }

  forgotPassword() async {
    try {
      passwordController.clear();
      if (emailController.text.isEmpty) {
        Get.snackbar('Error', 'Email is required');
      } else {
        final url = Uri.parse('$baseUrl/user/send-otp/');
        final data = {
          'email': emailController.text.trim().toLowerCase(),
        };

        final response = await http.post(url, body: data);
        log(response.body);
        if (response.statusCode == 201) {
          Get.to(() => const OTPScreen());
        } else {
          Get.snackbar('Error', jsonDecode(response.body)['error']);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    }
  }

  verifyOTP() async {
    try {
      if (otpController.text.isEmpty) {
        Get.snackbar('Error', 'OTP is required');
      } else {
        final url = Uri.parse('$baseUrl/user/verify-otp/');
        final data = {
          'email': emailController.text.trim().toLowerCase(),
          'otp': otpController.text,
        };

        final response = await http.post(url, body: data);
        if (response.statusCode == 200) {
          Get.to(() => const ResetPasswordScreen());
        } else {
          Get.snackbar('Error', jsonDecode(response.body)['error']);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    }
  }

  resetPassword() async {
    try {
      if (passwordController.text.isEmpty) {
        Get.snackbar('Error', 'Password is required');
      } else if (confirmPasswordController.text.isEmpty) {
        Get.snackbar('Error', 'Confirm Password is required');
      } else if (passwordController.text != confirmPasswordController.text) {
        Get.snackbar('Error', 'Passwords do not match');
      } else {
        final url = Uri.parse('$baseUrl/user/forget-password/');
        final data = {
          'email': emailController.text.trim().toLowerCase(),
          'password': passwordController.text,
        };

        final response = await http.put(url, body: data);
        if (response.statusCode == 200) {
          Get.snackbar('Success', 'Password reset successful');
          Get.to(() => const LoginScreen());
        } else {
          Get.snackbar('Error', jsonDecode(response.body)['error']);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
    }
  }

  clearControllers() {
    emailController.clear();
    passwordController.clear();
    confirmPasswordController.clear();
    nameController.clear();
    otpController.clear();
  }

  logout() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.remove('token');
    Get.offAll(() => const LoginScreen());
  }

  updateProfile() async {
    try {
      if (firstNameController.text.isEmpty) {
        Get.snackbar('Error', 'First name required');
        return;
      }
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final token = prefs.getString('token');
      final body = {
        'first_name': firstNameController.text,
        'last_name': lastNameController.text,
        // 'email': emailController.text,
        'phone': phoneController.text
      };
      final url = Uri.parse('$baseUrl/user/update/');
      final response = await http.post(url, body: body, headers: {
        'Authorization': 'JWT $token',
      });
      if (response.statusCode == 200) {
        Get.snackbar('Success', 'Record updated successfully');
      } else {
        Get.snackbar('Error', 'Something went wrong');
      }
    } catch (e) {
      Get.snackbar('Error', e.toString());
    }
  }
}

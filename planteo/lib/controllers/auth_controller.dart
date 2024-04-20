import 'dart:convert';
import 'dart:developer';

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

  final _name = ''.obs;
  final _token = ''.obs;
  final _email = ''.obs;
  final _image = ''.obs;
  final _bio = ''.obs;

  get name => _name.value;
  get token => _token.value;
  get email => _email.value;
  get image => _image.value;
  get bio => _bio.value;

  @override
  void onInit() {
    getUserDetails();
    super.onInit();
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
          Get.snackbar('Success', 'User created successfully');
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
        final data = {
          'email': emailController.text.trim().toLowerCase(),
          'password': passwordController.text,
        };

        final response = await http.post(url, body: data);
        if (response.statusCode == 200) {
          prefs.setString('token', jsonDecode(response.body)['token']);
          _token.value = jsonDecode(response.body)['token'];
          Get.snackbar('Success', 'Login successful');
          getUserDetails();
          clearControllers();
          Get.offAll(() => const Home());
        } else {
          Get.snackbar('Error', jsonDecode(response.body)['error']);
        }
      }
    } catch (e) {
      Get.snackbar('Error', 'Something went wrong');
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
          _image.value = jsonDecode(response.body)['image'];
        } else {
          _image.value = '';
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
}

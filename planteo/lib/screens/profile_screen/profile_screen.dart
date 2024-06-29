import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:planteo/utils/exports.dart';

class ProfileSettingScreen extends StatelessWidget {
  const ProfileSettingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());
    log(controller.name);
    return Scaffold(
      appBar: AppBar(
        title: const Text('My Profile'),
        actions: [
          IconButton(
            onPressed: () {
              controller.logout();
            },
            icon: const Icon(Icons.logout_rounded),
            tooltip: 'Logout',
          ),
        ],
      ),
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(10000),
                  child: CachedNetworkImage(
                    imageUrl: 'https://via.placeholder.com/150',
                    placeholder: (context, url) =>
                        const CircularProgressIndicator(),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                    width: 100,
                    fit: BoxFit.cover,
                  ),
                ),
                const SizedBox(
                  height: 10,
                ),
                const Text(
                  // controller.name,
                  'John Doe',
                  style: TextStyle(
                    fontSize: 16,
                    fontFamily: bold,
                  ),
                ),
                const Text(
                  // controller.email,
                  'johndoe@gmail.com',
                  style: TextStyle(
                    fontSize: 14,
                    fontFamily: regular,
                    color: greyColor,
                  ),
                ),
                const SizedBox(
                  height: 20,
                ),
                InputField(
                  title: 'First Name',
                  hintText: 'Enter your First Name',
                  controller: controller.firstNameController,
                ),
                const SizedBox(
                  height: 20,
                ),
                InputField(
                  title: 'Last Name',
                  hintText: 'Enter Last Name',
                  controller: controller.lastNameController,
                ),
                const SizedBox(
                  height: 20,
                ),
                // InputField(
                //   title: 'Email',
                //   hintText: 'Enter your email',
                //   controller: controller.emailController,
                // ),
                // const SizedBox(
                //   height: 20,
                // ),
                InputField(
                  title: 'Phone',
                  hintText: 'Enter your phone number',
                  controller: controller.phoneController,
                ),
                const SizedBox(
                  height: 20,
                ),
                const SizedBox(
                  height: 20,
                ),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      controller.updateProfile();
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: kPrimaryColor,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                      padding: const EdgeInsets.all(20),
                    ),
                    child: const Text(
                      'Update',
                      style: TextStyle(
                        color: whiteColor,
                        fontFamily: medium,
                        fontSize: 16,
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

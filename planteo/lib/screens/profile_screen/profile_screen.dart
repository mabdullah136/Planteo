import 'dart:developer';
import 'dart:io';

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
        title: const Text(
          'My Profile',
          style: TextStyle(
            fontSize: 28,
            fontFamily: regular,
            color: greenColor,
          ),
        ),
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
                InkWell(
                  onTap: () {
                    controller.pickImage(context);
                  },
                  child: Obx(() {
                    return ClipRRect(
                      borderRadius: BorderRadius.circular(10000),
                      child: controller.isLocalImageSelected.value.isEmpty
                          ? Image.network(
                              '$baseUrl${controller.image}',
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                              errorBuilder: (context, error, stackTrace) {
                                return const Icon(Icons.person, size: 100);
                              },
                              loadingBuilder:
                                  (context, child, loadingProgress) {
                                if (loadingProgress == null) return child;
                                return const CircularProgressIndicator();
                              },
                            )
                          : Image.file(
                              File(controller.isLocalImageSelected.value),
                              width: 100,
                              height: 100,
                              fit: BoxFit.cover,
                            ),
                      // child: CachedNetworkImage(
                      //   imageUrl: '$baseUrl${controller.image}',
                      //   placeholder: (context, url) =>
                      //       const CircularProgressIndicator(),
                      //   errorWidget: (context, url, error) =>
                      //       const Icon(Icons.person, size: 100),
                      //   width: 100,
                      //   height: 100,
                      //   fit: BoxFit.cover,
                      // ),
                    );
                  }),
                ),
                const SizedBox(
                  height: 10,
                ),
                Obx(
                  () => Text(
                    controller.name,
                    // 'John Doe',
                    style: const TextStyle(
                      fontSize: 16,
                      fontFamily: bold,
                    ),
                  ),
                ),
                Obx(
                  () => Text(
                    controller.email,
                    // 'johndoe@gmail.com',
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: regular,
                      color: greyColor,
                    ),
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

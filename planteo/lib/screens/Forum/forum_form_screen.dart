import 'package:flutter/material.dart';
import 'package:planteo/controllers/forum_controller.dart';
import 'package:planteo/utils/exports.dart';

class ForumFormScreen extends StatelessWidget {
  const ForumFormScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForumController());
    return Scaffold(
      appBar: AppBar(
          title: const Text(
            'Create Forum',
            style: TextStyle(
              fontSize: 28,
              fontFamily: regular,
              color: greenColor,
            ),
          ),
          automaticallyImplyLeading: false,
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: greenColor,
            ),
          )),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            //image picker,
            const SizedBox(
              height: 20,
            ),
            InkWell(
              onTap: () {
                controller.pickImage(context);
              },
              child: Container(
                height: 200,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Center(
                  child: Icon(
                    Icons.add_a_photo,
                    size: 50,
                    color: greenColor,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InputField(
                title: 'Title',
                hintText: 'Enter title here',
                controller: controller.titleController),
            const SizedBox(
              height: 20,
            ),
            InputField(
                title: 'Description',
                hintText: 'Enter description here',
                
                controller: controller.descriptionController),
            const SizedBox(
              height: 20,
            ),

            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.createForum();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(20),
                ),
                child: const Text(
                  'Submit',
                  style: TextStyle(
                      color: whiteColor, fontFamily: medium, fontSize: 16),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:planteo/controllers/herbs_controller.dart';
import 'package:planteo/controllers/location_controller.dart';
import 'package:planteo/utils/exports.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final herbsController = Get.put(HerbsController());
    final locationController = Get.put(LocationController());

    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Plant list',
          style: TextStyle(
            fontSize: 28,
            fontFamily: regular,
            color: greenColor,
          ),
        ),
        actions: [
          IconButton(
            onPressed: () {
              Get.to(const ProfileSettingScreen());
            },
            icon: const Icon(
              Icons.person,
              color: greenColor,
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Text(
                'Recommended Plants',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: semiBold,
                  color: greenColor,
                ),
              ),
              locationController.recommendations.isEmpty
                  ? const Text('No Recommendations')
                  : ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: locationController.recommendations.length,
                      itemBuilder: (context, index) {
                        final herb = locationController
                            .recommendations[index].data[index];
                        log(herb.toString());
                        return PlantListItem(
                          id: herb.id,
                          image: herb.image,
                          title: herb.commonName,
                          subtitle: herb.description,
                          icon: Icons.arrow_forward_ios_rounded,
                          color: Colors
                              .primaries[index % Colors.primaries.length]
                              .shade200,
                        );
                      },
                    ),
              const SizedBox(height: 20), // Add spacing between lists
              const Text(
                'All Plants',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: semiBold,
                  color: greenColor,
                ),
              ),
              StreamBuilder<HerbsModel>(
                stream: herbsController.getHerbs(),
                builder: (context, snapshot) {
                  if (!snapshot.hasData) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  } else {
                    return ListView.builder(
                      shrinkWrap: true,
                      physics: const NeverScrollableScrollPhysics(),
                      itemCount: snapshot.data!.data.length,
                      itemBuilder: (context, index) {
                        final herb = snapshot.data!.data[index];
                        return PlantListItem(
                          id: herb.id,
                          image: herb.image,
                          title: herb.commonName,
                          subtitle: herb.description,
                          icon: Icons.arrow_forward_ios_rounded,
                          color: Colors
                              .primaries[index % Colors.primaries.length]
                              .shade200,
                        );
                      },
                    );
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

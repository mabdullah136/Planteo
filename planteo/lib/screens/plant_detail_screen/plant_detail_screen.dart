import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:planteo/controllers/herbs_controller.dart';
import 'package:planteo/utils/exports.dart';

class PlantDetailScreen extends StatelessWidget {
  final int id;
  const PlantDetailScreen({super.key, required this.id});

  @override
  Widget build(BuildContext context) {
    final herbController = Get.find<HerbsController>();
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: StreamBuilder(
          stream: herbController.getHerbDetail(id.toString()),
          builder: (context, snapshot) {
            if (!snapshot.hasData) {
              return const Center(
                child: CircularProgressIndicator(),
              );
            } else {
              final herbDetail = snapshot.data;
              return Stack(
                children: [
                  CachedNetworkImage(
                    imageUrl: '$baseUrl${herbDetail!.data.image}',
                    width: double.infinity,
                    fit: BoxFit.cover,
                    placeholder: (context, url) =>
                        const Center(child: CircularProgressIndicator()),
                    errorWidget: (context, url, error) =>
                        const Icon(Icons.error),
                  ),
                  Positioned(
                    top: 40,
                    left: 20,
                    child: Container(
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        borderRadius: BorderRadius.circular(100),
                      ),
                      padding: const EdgeInsets.only(
                          left: 11, right: 5, top: 8, bottom: 8),
                      child: IconButton(
                        onPressed: () {
                          Get.back();
                        },
                        icon: const Icon(
                          Icons.arrow_back_ios,
                          color: greenColor,
                        ),
                      ),
                    ),
                  ),
                  Positioned(
                    bottom: 0,
                    child: Container(
                      width: MediaQuery.of(context).size.width,
                      height: MediaQuery.of(context).size.height * 0.5,
                      decoration: const BoxDecoration(
                        color: whiteColor,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(33),
                        ),
                      ),
                      child: SingleChildScrollView(
                        child: Padding(
                          padding: const EdgeInsets.all(16),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                herbDetail.data.commonName,
                                style: const TextStyle(
                                  fontSize: 32,
                                  fontFamily: medium,
                                  color: greenColor,
                                ),
                              ),
                              Text(
                                herbDetail.data.scientificName,
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontFamily: regular,
                                  color: greyColor,
                                ),
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              const Text(
                                'Description',
                                style: TextStyle(
                                  fontSize: 20,
                                  fontFamily: bold,
                                  color: darkGreenColor,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              Text(
                                herbDetail.data.description,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: regular,
                                  color: descriptionColor,
                                ),
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Divider(
                                color: greyColor,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              const Text(
                                'Optimal Soil Ph Range: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: semiBold,
                                  color: darkGreenColor,
                                ),
                              ),
                              Text(
                                herbDetail.data.optimalSoilPhRange,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: regular,
                                  color: darkGreenColor,
                                ),
                              ),
                              const Text(
                                'Soil Type Preferences: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: semiBold,
                                  color: darkGreenColor,
                                ),
                              ),
                              Text(
                                herbDetail.data.soilTypePreferences,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: regular,
                                  color: darkGreenColor,
                                ),
                              ),
                              const Text(
                                'Light Requirements: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: semiBold,
                                  color: darkGreenColor,
                                ),
                              ),
                              Text(
                                herbDetail.data.lightRequirements,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: regular,
                                  color: darkGreenColor,
                                ),
                              ),
                              const Text(
                                'Water Requirements: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: semiBold,
                                  color: darkGreenColor,
                                ),
                              ),
                              Text(
                                herbDetail.data.waterRequirements,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: regular,
                                  color: darkGreenColor,
                                ),
                              ),
                              const Text(
                                'Nutrient Requirements: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: semiBold,
                                  color: darkGreenColor,
                                ),
                              ),
                              Text(
                                herbDetail.data.nutrientRequirements,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: regular,
                                  color: darkGreenColor,
                                ),
                              ),
                              const Text(
                                'Temperature Range: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: semiBold,
                                  color: darkGreenColor,
                                ),
                              ),
                              Text(
                                herbDetail.data.temperatureRange,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: regular,
                                  color: darkGreenColor,
                                ),
                              ),
                              const Text(
                                'Humidity Tolerance: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: semiBold,
                                  color: darkGreenColor,
                                ),
                              ),
                              Text(
                                herbDetail.data.humidityTolerance,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: regular,
                                  color: darkGreenColor,
                                ),
                              ),
                              const Text(
                                'Planting Depth And Spacing: ',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: semiBold,
                                  color: darkGreenColor,
                                ),
                              ),
                              Text(
                                herbDetail.data.plantingDepthAndSpacing,
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontFamily: regular,
                                  color: darkGreenColor,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              );
            }
          },
        ),
      ),
    );
  }
}

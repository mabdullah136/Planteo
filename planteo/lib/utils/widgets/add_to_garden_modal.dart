import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:planteo/controllers/herbs_controller.dart';
import 'package:planteo/controllers/location_controller.dart';
import 'package:planteo/models/garden_detail_model.dart';
import 'package:planteo/utils/exports.dart';

void showAddToGardenDialog(
    BuildContext context, Function(GardenDetail) onPlantSelected) {
  final controller = Get.put(HerbsController());
  final locationController = Get.put(LocationController());
  final blockSize = MediaQuery.of(context).size.width * 0.2;

  locationController.sendLocation();
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      actionsPadding: const EdgeInsets.all(10),
      backgroundColor: Colors.white,
      elevation: 0,
      title: const Text(
        'Select Plants',
        style: TextStyle(
          fontSize: 16,
          fontFamily: semiBold,
          color: greenColor,
        ),
      ),
      content: SizedBox(
        height: MediaQuery.of(context).size.height * 0.7,
        child: Column(
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
            const SizedBox(height: 10),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.25,
              width: MediaQuery.of(context).size.width * 0.8,
              child: Obx(() => locationController.recommendations.isEmpty
                  ? const Text('No Recommendations')
                  : GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1,
                      ),
                      itemCount: locationController.recommendations.length,
                      itemBuilder: (context, index) {
                        final herb =
                            locationController.recommendations[index].data[0];
                        log(locationController.recommendations.toString());
                        return GestureDetector(
                          onTap: () {
                            onPlantSelected(GardenDetail(
                              id: herb.id,
                              rowNo: 0,
                              columnNo: 0,
                              plantName: herb.commonName,
                              icons: herb.icons,
                              garden: 0,
                              herb: 0,
                            ));
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 2.0,
                                ),
                              ],
                            ),
                            width: blockSize,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: baseUrl + herb.icons,
                                  width: 40,
                                  height: 40,
                                ),
                                Text(
                                  herb.commonName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    )),
            ),
            const SizedBox(height: 20),
            const Text(
              'All Plants',
              style: TextStyle(
                fontSize: 16,
                fontFamily: semiBold,
                color: greenColor,
              ),
            ),
            SizedBox(
              height: MediaQuery.of(context).size.height * 0.35,
              width: MediaQuery.of(context).size.width * 0.8,
              child: StreamBuilder<HerbsModel>(
                stream: controller.getHerbWithIcons(),
                builder: (context, snapshot) {
                  if (snapshot.hasData) {
                    return GridView.builder(
                      gridDelegate:
                          const SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: 3,
                        mainAxisSpacing: 10,
                        crossAxisSpacing: 10,
                        childAspectRatio: 1,
                      ),
                      itemCount: snapshot.data!.data.length,
                      itemBuilder: (context, index) {
                        final herb = snapshot.data!.data[index];
                        return GestureDetector(
                          onTap: () {
                            onPlantSelected(GardenDetail(
                              id: herb.id,
                              rowNo: 0,
                              columnNo: 0,
                              plantName: herb.commonName,
                              icons: herb.icons,
                              garden: 0,
                              herb: 0,
                            ));
                            Navigator.pop(context);
                          },
                          child: Container(
                            margin: const EdgeInsets.all(5),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              border: Border.all(color: Colors.white),
                              borderRadius: BorderRadius.circular(10),
                              boxShadow: const [
                                BoxShadow(
                                  color: Colors.grey,
                                  blurRadius: 2.0,
                                ),
                              ],
                            ),
                            width: blockSize,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                CachedNetworkImage(
                                  imageUrl: baseUrl + herb.icons,
                                  width: 40,
                                  height: 40,
                                ),
                                const SizedBox(
                                  height: 0,
                                ),
                                Text(
                                  herb.commonName,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  style: const TextStyle(
                                    color: Colors.black,
                                    fontSize: 10,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        );
                      },
                    );
                  } else {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

import 'package:planteo/controllers/garden_controller.dart';
import 'package:planteo/screens/garden_screen/garden_screen.dart';
import 'package:planteo/utils/exports.dart';

class AddGarden extends StatelessWidget {
  const AddGarden({super.key});

  @override
  Widget build(BuildContext context) {
    final gardenController = Get.put(GardenController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Add Garden',
          style: TextStyle(
            fontSize: 28,
            fontFamily: regular,
            color: greenColor,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => showDialog(
          context: context,
          builder: (context) => AlertDialog(
            backgroundColor: Colors.white,
            elevation: 0,
            title: const Text('Add Garden'),
            content: SizedBox(
              height: 240,
              child: Column(
                children: [
                  TextFormField(
                    controller: gardenController.gardenNameController,
                    decoration: InputDecoration(
                      labelText: 'Garden Name',
                      hintText: 'Enter garden name',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: greenColor,
                          width: 2,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: greenColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: gardenController.gardenHeightController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Garden Length',
                      hintText: 'Enter garden length',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: greenColor,
                          width: 2,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: greenColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: gardenController.gardenWidthController,
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      labelText: 'Garden Width',
                      hintText: 'Enter garden width',
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: greenColor,
                          width: 2,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        borderSide: const BorderSide(
                          color: greenColor,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  Navigator.pop(context);
                },
                child: const Text('Cancel'),
              ),
              TextButton(
                onPressed: () {
                  gardenController.createGarden();
                  Navigator.pop(context);
                },
                child: const Text('Save'),
              ),
            ],
          ),
        ),
        heroTag: 'add_garden',
        backgroundColor: greenColor,
        foregroundColor: Colors.white,
        child: const Icon(Icons.add),
      ),
      body: Obx(
        () => gardenController.isLoading.value
            ? const Center(child: CircularProgressIndicator())
            : gardenController.gardens.isEmpty
                ? const Center(child: Text('No gardens found'))
                : ListView.builder(
                    itemCount: gardenController.gardens.length,
                    itemBuilder: (context, index) {
                      final garden = gardenController.gardens[index];
                      return Container(
                        padding: const EdgeInsets.all(8.0),
                        decoration: BoxDecoration(
                          border: Border(
                            bottom: BorderSide(
                              color: greyColor.withOpacity(0.5),
                              width: 0.5,
                            ),
                          ),
                        ),
                        child: ListTile(
                          onTap: () {
                            Get.to(GardenGridScreen(
                              height: int.parse(garden.length),
                              width: int.parse(garden.width),
                              gardenId: garden.id,
                            ));
                          },
                          title: Text(garden.name,
                              style: const TextStyle(fontSize: 20)),
                          subtitle: Text(
                            'Size: ${garden.length}x ${garden.width}',
                            style: const TextStyle(color: greyColor),
                          ),
                          trailing: IconButton(
                            onPressed: () {},
                            icon: PopupMenuButton<String>(
                              icon: const Icon(Icons.more_vert_rounded),
                              color: Colors.white,
                              surfaceTintColor: Colors.white,
                              onSelected: (value) {
                                if (value == 'edit') {
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title:
                                                const Text('Edit Garden Name'),
                                            content: TextFormField(
                                              controller: gardenController
                                                  .gardenNameController,
                                              decoration: InputDecoration(
                                                labelText: 'Garden Name',
                                                hintText: 'Enter garden name',
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  borderSide: const BorderSide(
                                                    color: greenColor,
                                                    width: 2,
                                                  ),
                                                ),
                                                border: OutlineInputBorder(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0),
                                                  borderSide: const BorderSide(
                                                    color: greenColor,
                                                    width: 2,
                                                  ),
                                                ),
                                              ),
                                            ),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Cancel'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  gardenController
                                                      .updateGarden(garden.id);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Save'),
                                              ),
                                            ],
                                          ));
                                } else if (value == 'delete') {
                                  // Handle delete action
                                  showDialog(
                                      context: context,
                                      builder: (context) => AlertDialog(
                                            title: const Text(
                                                'Are you sure to delete?'),
                                            actions: [
                                              TextButton(
                                                onPressed: () {
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('No'),
                                              ),
                                              TextButton(
                                                onPressed: () {
                                                  gardenController
                                                      .deleteGarden(garden.id);
                                                  Navigator.pop(context);
                                                },
                                                child: const Text('Yes'),
                                              ),
                                            ],
                                          ));
                                }
                              },
                              itemBuilder: (context) => [
                                const PopupMenuItem(
                                  value: 'edit',
                                  child: Text('Edit'),
                                ),
                                const PopupMenuItem(
                                  value: 'delete',
                                  child: Text('Delete'),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
                  ),
      ),
    );
  }
}

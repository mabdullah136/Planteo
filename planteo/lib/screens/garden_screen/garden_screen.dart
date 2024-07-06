import 'dart:developer';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:planteo/controllers/garden_controller.dart';
import 'package:planteo/models/garden_detail_model.dart';
import 'package:planteo/utils/exports.dart';
import 'package:planteo/utils/widgets/add_to_garden_modal.dart';

class GardenGridScreen extends StatefulWidget {
  final int width;
  final int height;
  final int gardenId;

  const GardenGridScreen({
    super.key,
    this.width = 4,
    this.height = 4,
    this.gardenId = 0,
  });

  @override
  _GardenGridScreenState createState() => _GardenGridScreenState();
}

class _GardenGridScreenState extends State<GardenGridScreen> {
  late List<List<GardenDetail?>> _grid;
  final GardenController gardenController = GardenController();
  final double blockSize = 50.0;
  bool _isInitialLoad = true;

  @override
  void initState() {
    super.initState();
    _initializeGrid();

    // log('Garden ID: ${widget.gardenId}');
    if (_isInitialLoad) {
      _fetchGardenDetails();
      _isInitialLoad = false;
    }
  }

  void _initializeGrid() {
    _grid = List.generate(
      widget.height,
      (i) => List.generate(widget.width, (j) => null),
    );
  }

  Future<void> _fetchGardenDetails() async {
    await gardenController.fetchGardenDetails(widget.gardenId.toString());
    setState(() {
      for (var detail in gardenController.gardenDetails) {
        _grid[detail.rowNo][detail.columnNo] = detail;
      }
    });
  }

  Future<void> _createGardenDetail(GardenDetail detail) async {
    await gardenController.createGardenDetail(detail);
  }

  Future<void> _deleteGardenDetail(int id) async {
    await gardenController.deleteGardenDetail(id);
  }

  void _toggleTree(int x, int y) {
    if (_grid[y][x] != null) {
      final id = _grid[y][x]!.id;
      showDialog(
          context: context,
          builder: ((context) {
            return AlertDialog(
              backgroundColor: Colors.white,
              surfaceTintColor: Colors.white,
              title: const Text('Remove Plant'),
              content:
                  const Text('Are you sure you want to remove this plant?'),
              actions: [
                Row(
                  children: [
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      child: const Text('Cancel'),
                    ),
                    const Spacer(),
                    TextButton(
                      onPressed: () {
                        Get.to(() => PlantDetailScreen(id: id));
                      },
                      child: const Text('Details'),
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.pop(context);
                        log(id.toString());
                        _deleteGardenDetail(id).then((_) {
                          setState(() {
                            _grid[y][x] = null;
                            log('Tree at $x, $y is removed');
                          });
                        });
                      },
                      child: const Text('Remove',
                          style: TextStyle(color: Colors.red)),
                    ),
                  ],
                )
              ],
            );
          }));

      // _deleteGardenDetail(id).then((_) {
      //   setState(() {
      //     _grid[y][x] = null;
      //     log('Tree at $x, $y is removed');
      //   });
      // });
    } else {
      showAddToGardenDialog(context, (selectedPlant) {
        final newDetail = GardenDetail(
          id: selectedPlant.id,
          rowNo: y,
          columnNo: x,
          plantName: selectedPlant.plantName,
          icons: selectedPlant.icons,
          garden: widget.gardenId,
          herb: selectedPlant.herb,
        );
        _createGardenDetail(newDetail).then((_) {
          setState(() {
            _grid[y][x] = newDetail;
            log('Tree at $x, $y is planted');
          });
        });
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromARGB(255, 207, 125, 96),
      appBar: AppBar(
        title: const Text(
          'Digital Garden',
          style: TextStyle(
            fontSize: 28,
            fontFamily: regular,
            color: whiteColor,
          ),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: whiteColor,
          ),
        ),
        backgroundColor: const Color.fromARGB(255, 207, 125, 96),
      ),
      body: Obx(() {
        if (gardenController.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return SizedBox(
            height: double.infinity,
            width: MediaQuery.of(context).size.width,
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: SizedBox(
                  width: widget.width * blockSize,
                  height: widget.height * blockSize,
                  child: InteractiveViewer(
                    panEnabled: true,
                    scaleEnabled: true,
                    minScale: 0.5,
                    maxScale: 4.0,
                    child: GridView.builder(
                      gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                        crossAxisCount: widget.width,
                        mainAxisSpacing: 1,
                        crossAxisSpacing: 1,
                        childAspectRatio: blockSize / blockSize,
                      ),
                      itemCount: widget.width * widget.height,
                      // physics: const NeverScrollableScrollPhysics(),
                      itemBuilder: (context, index) {
                        int x = index % widget.width;
                        int y = index ~/ widget.width;
                        return GestureDetector(
                          onTap: () => _toggleTree(x, y),
                          child: Container(
                            decoration: BoxDecoration(
                              color: _grid[y][x] != null
                                  ? Colors.transparent
                                  // : const Color.fromARGB(255, 207, 125, 96),
                                  : Colors.lightGreen,
                              border: Border.all(color: Colors.white),
                            ),
                            width: blockSize,
                            height: blockSize,
                            child: Center(
                              child: _grid[y][x] != null
                                  ? CachedNetworkImage(
                                      imageUrl: '$baseUrl${_grid[y][x]!.icons}',
                                    )
                                  : const Text(
                                      '+',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontWeight: FontWeight.normal,
                                        fontSize: 24,
                                      ),
                                    ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          );
        }
      }),
    );
  }
}

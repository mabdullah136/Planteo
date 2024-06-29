// ignore_for_file: library_private_types_in_public_api

import 'dart:developer';

import 'package:flutter/material.dart';

class GardenGridScreen extends StatefulWidget {
  int width;
  int height;

  GardenGridScreen({
    super.key,
    this.width = 4,
    this.height = 4,
  });

  @override
  _GardenGridScreenState createState() => _GardenGridScreenState();
}

class _GardenGridScreenState extends State<GardenGridScreen> {
  late List<List<bool>> _grid;
  late int width;
  late int height;

  @override
  void initState() {
    super.initState();
    _grid = List.generate(
      widget.height,
      (i) => List.generate(widget.width, (j) => false),
    );
  }

  void _toggleTree(int x, int y) {
    setState(() {
      _grid[y][x] = !_grid[y][x];
      log('Tree at $x, $y is ${_grid[y][x] ? 'planted' : 'removed'}');
    });
  }

  final blockSize = 50.0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.brown[200],
      appBar: AppBar(
        title: Text('Garden (${widget.width} x ${widget.height})',
            style: const TextStyle(color: Colors.white)),
        backgroundColor: Colors.brown[200],
      ),
      //floating action button to change the size of the garden,
      floatingActionButton: FloatingActionButton(
        child: const Icon(Icons.settings),
        onPressed: () {
          showDialog(
              context: context,
              builder: (context) => AlertDialog(
                    title: const Text('Change Garden Size'),
                    content: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        TextField(
                          decoration: const InputDecoration(labelText: 'Width'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => width = int.parse(value),
                          // onChanged: (value) {
                          //   setState(() {
                          //     widget.width = int.parse(value);
                          //   });
                          // },
                        ),
                        TextField(
                          decoration:
                              const InputDecoration(labelText: 'Height'),
                          keyboardType: TextInputType.number,
                          onChanged: (value) => height = int.parse(value),
                          // onChanged: (value) {
                          //   setState(() {
                          //     widget.height = int.parse(value);
                          //   });
                          // },
                        ),
                      ],
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
                          setState(() {
                            widget.width = width;
                            widget.height = height;
                            _grid = List.generate(
                              widget.height,
                              (i) => List.generate(widget.width, (j) => false),
                            );
                          });
                          // setState(() {
                          //   _grid = List.generate(
                          //     widget.height,
                          //     (i) => List.generate(widget.width, (j) => false),
                          //   );
                          // });
                          Navigator.pop(context);
                        },
                        child: const Text('Save'),
                      ),
                    ],
                  ));
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: SizedBox(
            width: widget.width * blockSize,
            height: widget.height * blockSize,
            child: GridView.builder(
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: widget.width,
                mainAxisSpacing: 1,
                crossAxisSpacing: 1,
                childAspectRatio: blockSize / blockSize,
              ),
              itemCount: widget.width * widget.height,
              itemBuilder: (context, index) {
                int x = index % widget.width;
                int y = index ~/ widget.width;
                return GestureDetector(
                  onTap: () => _toggleTree(x, y),
                  child: Container(
                    decoration: BoxDecoration(
                      color: _grid[y][x] ? Colors.green : Colors.brown[400],
                      border: Border.all(color: Colors.white),
                    ),
                    width: blockSize,
                    height: blockSize,
                    child: Center(
                      child: Text(
                        '${index + 1}',
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
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
    );
  }
}

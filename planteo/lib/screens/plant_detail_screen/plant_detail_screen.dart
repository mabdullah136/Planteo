import 'package:flutter/material.dart';
import 'package:planteo/utils/exports.dart';

class PlantDetailScreen extends StatelessWidget {
  const PlantDetailScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: (Stack(
          children: [
            Image.asset(
              pdetail,
              width: double.infinity,
              fit: BoxFit.cover,
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
                child: const Padding(
                  padding: EdgeInsets.all(16),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Alexandra',
                        style: TextStyle(
                          fontSize: 32,
                          fontFamily: medium,
                          color: greenColor,
                        ),
                      ),
                      Text(
                        'Create an Aepod',
                        style: TextStyle(
                          fontSize: 18,
                          fontFamily: regular,
                          color: greyColor,
                        ),
                      ),
                      SizedBox(
                        height: 20,
                      ),
                      Text(
                        'Description',
                        style: TextStyle(
                          fontSize: 20,
                          fontFamily: bold,
                          color: darkGreenColor,
                        ),
                      ),
                      SizedBox(
                        height: 10,
                      ),
                      Text(
                        'Monstera deliciosa is a species of flowering plant native to tropical forests of southern Mexico, south to Panama. It has been introduced to many tropical areas, and has become a mildly invasive species in Hawaii, Seychelles, Ascension Island and the Society Islands.',
                        style: TextStyle(
                          fontSize: 16,
                          fontFamily: regular,
                          color: descriptionColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        )),
      ),
    );
  }
}

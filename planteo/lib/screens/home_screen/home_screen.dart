import 'package:planteo/utils/exports.dart';
import 'package:planteo/utils/lists.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
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
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Expanded(
              child: ListView.builder(
                  itemCount: 4,
                  itemBuilder: (context, index) {
                    return PlantListItem(
                      image: homeScreenList[index]['image'] as String,
                      title: homeScreenList[index]['title'] as String,
                      subtitle: homeScreenList[index]['subtitle'] as String,
                      icon: homeScreenList[index]['icon'] as IconData,
                      color: homeScreenList[index]['color'] as Color,
                    );
                  }),
            ),
          ],
        ),
      ),
    );
  }
}

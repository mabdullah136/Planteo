import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:planteo/controllers/forum_controller.dart';
import 'package:planteo/models/forum_model.dart';
import 'package:planteo/screens/Forum/forum_detail_screen.dart';
import 'package:planteo/screens/Forum/forum_form_screen.dart';
import 'package:planteo/utils/exports.dart';

class ForumScreen extends StatelessWidget {
  const ForumScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final herbsController = Get.put(ForumController());
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forum',
          style: TextStyle(
            fontSize: 28,
            fontFamily: regular,
            color: greenColor,
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Get.to(const ForumFormScreen());
        },
        backgroundColor: greenColor,
        child: const Icon(
          Icons.add,
          color: whiteColor,
        ),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
              decoration: BoxDecoration(
                color: greenColor.withOpacity(0.1),
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.search,
                    color: greenColor,
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: TextFormField(
                      controller: herbsController.forumSearchController,
                      onChanged: (value) {
                        // The search query is already being updated in the controller
                      },
                      decoration: const InputDecoration(
                        hintText: 'Search',
                        border: InputBorder.none,
                        // contentPadding: EdgeInsets.zero,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            Expanded(
              child: StreamBuilder<List<ForumModel>>(
                stream: herbsController.getForum(),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(
                      child: CircularProgressIndicator(),
                    );
                  }
                  if (!snapshot.hasData || snapshot.data!.isEmpty) {
                    return const Center(
                      child: Text('No data found'),
                    );
                  } else {
                    return ListView.builder(
                      itemCount: snapshot.data!.length,
                      itemBuilder: (context, index) {
                        final herb = snapshot.data![index];
                        return ForumListItem(
                          id: herb.id,
                          img: herb.image,
                          title: herb.subject,
                          subtitle: herb.description ?? '',
                          icon: Icons.arrow_forward_ios_rounded,
                        );
                      },
                    );
                  }
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class ForumListItem extends StatelessWidget {
  final String title, subtitle;
  final String? img;
  final int id;
  final IconData icon;
  const ForumListItem({
    super.key,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.id,
    required this.img,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        InkWell(
          onTap: () {
            Get.to(ForumDetailScreen(id: id));
          },
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 8.0),
            child: Container(
              padding: const EdgeInsets.only(right: 20),
              width: double.infinity,
              decoration: const BoxDecoration(
                borderRadius: BorderRadius.all(
                  Radius.circular(20),
                ),
              ),
              child: Row(
                children: [
                  ClipRRect(
                    borderRadius: const BorderRadius.all(
                      Radius.circular(10),
                    ),
                    child: CachedNetworkImage(
                      imageUrl: img ?? 'https://via.placeholder.com/150',
                      width: 50,
                      height: 60,
                      placeholder: (context, url) =>
                          const Center(child: CircularProgressIndicator()),
                      errorWidget: (context, url, error) =>
                          const Icon(Icons.error),
                      fit: BoxFit.cover,
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          title,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 18,
                            fontFamily: regular,
                            color: blackColor,
                          ),
                        ),
                        Text(
                          subtitle,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 14,
                            fontFamily: regular,
                            color: greyColor,
                          ),
                        ),
                      ],
                    ),
                  ),
                  Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: greyColor.withOpacity(0.1),
                      backgroundBlendMode: BlendMode.luminosity,
                      borderRadius: const BorderRadius.all(
                        Radius.circular(100),
                      ),
                    ),
                    child: Icon(
                      icon,
                      color: blackColor,
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
        const Divider(),
      ],
    );
  }
}

import 'dart:developer';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:planteo/utils/exports.dart';

class PlantListItem extends StatelessWidget {
  final String image, title, subtitle;
  final int id;
  final IconData icon;
  final Color color;
  const PlantListItem({
    super.key,
    required this.image,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.id,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        log('$baseUrl$image');
        Get.to(PlantDetailScreen(id: id));
      },
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 8.0),
        child: Container(
          padding: const EdgeInsets.only(right: 20),
          width: double.infinity,
          height: 120,
          decoration: BoxDecoration(
            color: color,
            borderRadius: const BorderRadius.all(
              Radius.circular(20),
            ),
          ),
          child: Row(
            children: [
              ClipRRect(
                borderRadius: const BorderRadius.all(
                  Radius.circular(20),
                ),
                child: CachedNetworkImage(
                  imageUrl: '$baseUrl$image',
                  width: 100,
                  height: 120,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
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
                        fontFamily: medium,
                        color: whiteColor,
                      ),
                    ),
                    Text(
                      subtitle,
                      maxLines: 2,
                      textAlign: TextAlign.start,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        fontSize: 14,
                        fontFamily: medium,
                        color: whiteColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                width: 10,
              ),
              Container(
                padding: const EdgeInsets.all(16),
                decoration: BoxDecoration(
                  color: whiteColor.withOpacity(0.5),
                  backgroundBlendMode: BlendMode.luminosity,
                  borderRadius: const BorderRadius.all(
                    Radius.circular(100),
                  ),
                ),
                child: Icon(
                  icon,
                  color: whiteColor,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

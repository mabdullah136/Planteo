import 'package:cached_network_image/cached_network_image.dart';
import 'package:planteo/controllers/forum_controller.dart';
import 'package:planteo/utils/exports.dart';

class ForumDetailScreen extends StatefulWidget {
  final id;
  const ForumDetailScreen({super.key, required this.id});

  @override
  State<ForumDetailScreen> createState() => _ForumDetailScreenState();
}

class _ForumDetailScreenState extends State<ForumDetailScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = Get.put(ForumController());
    return Scaffold(
        appBar: AppBar(
          backgroundColor: kPrimaryColor,
          title: const Text(
            'Forum Detail',
            style: TextStyle(
              fontSize: 28,
              fontFamily: regular,
              color: whiteColor,
            ),
          ),
          leading: IconButton(
            onPressed: () {
              Get.back();
            },
            icon: const Icon(
              Icons.arrow_back_ios,
              color: whiteColor,
            ),
          ),
        ),
        body: StreamBuilder(
            stream: controller.getForumDetail(widget.id),
            builder: (context, snapshot) {
              if (!snapshot.hasData) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else {
                final forum = snapshot.data;
                return Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(
                          top: 16, left: 16, right: 16, bottom: 80),
                      child: ListView(
                        children: [
                          ForumPost(
                            image: forum!.queryDetail.image,
                            subject: forum.queryDetail.subject,
                            description: forum.queryDetail.description,
                            upload_date: forum.queryDetail.uploadDate,
                          ),
                          const SizedBox(
                            height: 20,
                          ),
                          Container(
                            padding: const EdgeInsets.all(16),
                            width: double.infinity,
                            decoration: const BoxDecoration(
                              color: kPrimaryColor,
                            ),
                            child: const Text('Answers',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontFamily: regular,
                                  color: whiteColor,
                                )),
                          ),
                          ListView.builder(
                            shrinkWrap: true,
                            physics: const NeverScrollableScrollPhysics(),
                            itemCount: forum.feedback.length,
                            itemBuilder: (context, index) {
                              return Container(
                                margin: const EdgeInsets.only(top: 10),
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  color: Colors.grey[200],
                                ),
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      forum.feedback[index].feedbackText,
                                      style: const TextStyle(
                                        fontSize: 16,
                                        fontFamily: light,
                                        color: greyColor,
                                      ),
                                    )
                                  ],
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    ),
                    Positioned(
                      bottom: 0,
                      left: 0,
                      right: 0,
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: TextFormField(
                          controller: controller.feebackController,
                          keyboardType: TextInputType.multiline,
                          textCapitalization: TextCapitalization.sentences,
                          decoration: InputDecoration(
                            hintText: 'Enter your answer here',
                            border: const OutlineInputBorder(
                              borderRadius: BorderRadius.all(
                                Radius.circular(10),
                              ),
                            ),
                            suffixIcon: InkWell(
                                onTap: () {
                                  setState(() {
                                    controller.createFeedback(widget.id);
                                  });
                                },
                                child: const Icon(Icons.send_rounded,
                                    color: kPrimaryColor)),
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              }
            }));
  }
}

class ForumPost extends StatelessWidget {
  final String image, subject, description, upload_date;
  const ForumPost({
    super.key,
    required this.image,
    required this.subject,
    required this.description,
    required this.upload_date,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey[200],
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              CachedNetworkImage(
                imageUrl: image,
                width: 60,
                height: 60,
                placeholder: (context, url) =>
                    const Center(child: CircularProgressIndicator()),
                errorWidget: (context, url, error) => const Icon(Icons.error),
                fit: BoxFit.cover,
              ),
              const SizedBox(
                width: 10,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    subject,
                    style: const TextStyle(
                      fontSize: 20,
                      fontFamily: regular,
                      color: blackColor,
                    ),
                  ),
                  Text(
                    upload_date,
                    style: const TextStyle(
                      fontSize: 14,
                      fontFamily: regular,
                      color: greyColor,
                    ),
                  ),
                ],
              )
            ],
          ),
          const SizedBox(
            height: 20,
          ),
          Text(
            description,
            style: const TextStyle(
              fontSize: 16,
              fontFamily: light,
              color: greyColor,
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Row(
            children: [
              const Icon(
                Icons.thumb_up,
                color: greenColor,
              ),
              const SizedBox(
                width: 10,
              ),
              const Text(
                '12',
                style: TextStyle(
                  fontSize: 16,
                  fontFamily: regular,
                  color: blackColor,
                ),
              ),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: whiteColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(
                  Icons.image,
                  color: greenColor,
                  size: 30,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

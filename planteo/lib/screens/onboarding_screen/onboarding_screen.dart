import 'package:planteo/utils/exports.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.58,
            width: double.infinity,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const SizedBox(
                  height: 50,
                ),
                Image.asset(
                  logo,
                ),
              ],
            ),
          ),
          Container(
            height: MediaQuery.of(context).size.height * 0.42,
            width: MediaQuery.of(context).size.height * 2,
            clipBehavior: Clip.antiAlias,
            decoration: const BoxDecoration(
              image: DecorationImage(
                  image: AssetImage(onBoarding), fit: BoxFit.cover),
            ),
            child: Column(
              children: [
                const Spacer(),
                const Spacer(),
                const Text(
                  'Are You Ready',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontFamily: bold,
                  ),
                ),
                const Text(
                  'To Protect Your',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 32,
                    fontFamily: bold,
                  ),
                ),
                const Text(
                  'Garden?',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    color: yellowColor,
                    fontSize: 32,
                    fontFamily: bold,
                  ),
                ),
                const Spacer(),
                ElevatedButton(
                  onPressed: () {
                    Get.to(const LoginScreen());
                  },
                  style: ElevatedButton.styleFrom(
                    shape: const CircleBorder(),
                    padding: const EdgeInsets.all(20),
                    backgroundColor: kPrimaryLightColor,
                  ),
                  child: const Icon(
                    Icons.arrow_forward_rounded,
                    color: whiteColor,
                    size: 40,
                  ),
                ),
                const SizedBox(height: 30),
                Row(
                  children: [
                    const Spacer(),
                    Container(
                      height: 8,
                      width: 16,
                      decoration: const BoxDecoration(
                        color: kPrimaryLightColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      height: 8,
                      width: 16,
                      decoration: const BoxDecoration(
                        color: whiteColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    const SizedBox(width: 5),
                    Container(
                      height: 8,
                      width: 16,
                      decoration: const BoxDecoration(
                        color: whiteColor,
                        shape: BoxShape.rectangle,
                        borderRadius: BorderRadius.all(Radius.circular(10)),
                      ),
                    ),
                    const Spacer(),
                  ],
                ),
                const Spacer(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

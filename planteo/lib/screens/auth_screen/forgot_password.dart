import 'package:planteo/utils/exports.dart';

class ForgotPassword extends StatelessWidget {
  const ForgotPassword({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_rounded),
          onPressed: () {
            Get.back();
          },
          color: blackColor,
        ),
      ),
      body: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              'Forgot Password',
              style: TextStyle(
                fontSize: 32,
                fontFamily: semiBold,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text(
                'You can recover your password by enter your registered email address',
                style: TextStyle(
                  color: greyColor,
                  fontFamily: regular,
                ),
                textAlign: TextAlign.center),
            const SizedBox(
              height: 20,
            ),
            InputField(
              title: 'Email',
              hintText: 'Enter your registered Email',
              controller: controller.emailController,
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.forgotPassword();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(20),
                ),
                child: const Text(
                  'Continue',
                  style: TextStyle(
                      color: whiteColor, fontFamily: medium, fontSize: 16),
                ),
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

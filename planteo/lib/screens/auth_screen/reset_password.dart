import 'package:planteo/utils/exports.dart';

class ResetPasswordScreen extends StatelessWidget {
  const ResetPasswordScreen({super.key});

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
              'Reset Password',
              style: TextStyle(
                fontSize: 32,
                fontFamily: semiBold,
                color: kPrimaryColor,
              ),
            ),
            const Spacer(),
            PasswordInput(
                title: 'Password',
                hintText: 'Enter Password',
                controller: controller.passwordController),
            const SizedBox(
              height: 40,
            ),
            PasswordInput(
                title: 'Confirm Password',
                hintText: 'Enter Password again',
                controller: controller.confirmPasswordController),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.resetPassword();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(20),
                ),
                child: const Text(
                  'Reset',
                  style: TextStyle(
                      color: whiteColor, fontFamily: medium, fontSize: 16),
                ),
              ),
            ),
            const Spacer(),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

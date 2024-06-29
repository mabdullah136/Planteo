import 'package:planteo/utils/exports.dart';

class SignUpScreen extends StatelessWidget {
  const SignUpScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.find<AuthController>();
    return Scaffold(
      body: Container(
        padding: const EdgeInsets.all(16),
        width: double.infinity,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Spacer(),
            const Text(
              'Sign Up',
              style: TextStyle(
                fontSize: 32,
                fontFamily: semiBold,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: MediaQuery.of(context).size.width,
              child: ElevatedButton.icon(
                onPressed: () {},
                style: ElevatedButton.styleFrom(
                  elevation: 0.2,
                  backgroundColor: whiteColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(20),
                ),
                icon: Image.asset(google, width: 20, height: 20),
                label: const Text(
                  '  Google',
                  style: TextStyle(
                    color: blackColor,
                    fontFamily: medium,
                    fontSize: 16,
                  ),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const SizedBox(
              width: double.infinity,
              child: Text(
                'Or',
                textAlign: TextAlign.center,
                style: TextStyle(
                  fontSize: 16,
                  color: greyColor,
                  fontFamily: regular,
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            InputField(
              title: 'Name',
              hintText: 'Enter Name',
              controller: controller.nameController,
            ),
            const SizedBox(
              height: 20,
            ),
            InputField(
              title: 'Email',
              hintText: 'Enter Email',
              controller: controller.emailController,
            ),
            const SizedBox(
              height: 20,
            ),
            PasswordInput(
              title: 'Password',
              hintText: 'Enter Password',
              controller: controller.passwordController,
            ),
            const SizedBox(
              height: 10,
            ),
            const SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'I agree to the ',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: blackColor,
                      fontFamily: regular,
                    ),
                  ),
                  Text(
                    'Terms & Conditions',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: purpleColor,
                      fontFamily: regular,
                    ),
                  ),
                  Text(
                    ' and',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: blackColor,
                      fontFamily: regular,
                    ),
                  ),
                  Text(
                    ' Privacy Policy',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 12,
                      color: purpleColor,
                      fontFamily: regular,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.signUP();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: kPrimaryColor,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  padding: const EdgeInsets.all(20),
                ),
                child: const Text(
                  'Create Account',
                  style: TextStyle(
                      color: whiteColor, fontFamily: medium, fontSize: 16),
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  const SizedBox(
                    width: 10,
                  ),
                  const Text(
                    'Don\'t have an account?  ',
                    style: TextStyle(
                      fontSize: 14,
                      color: blackColor,
                      fontFamily: regular,
                    ),
                  ),
                  InkWell(
                    onTap: () {
                      Get.to(() => const LoginScreen());
                    },
                    child: const Text(
                      'Sign In',
                      style: TextStyle(
                        fontSize: 14,
                        color: purpleColor,
                        fontFamily: regular,
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const Spacer(),
          ],
        ),
      ),
    );
  }
}

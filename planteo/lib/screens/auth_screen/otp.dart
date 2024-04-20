import 'package:planteo/utils/exports.dart';

class OTPScreen extends StatelessWidget {
  const OTPScreen({super.key});

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
              'Enter OTP',
              style: TextStyle(
                fontSize: 32,
                fontFamily: semiBold,
                color: kPrimaryColor,
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            const Text('Enter the OTP sent to your registered email address',
                style: TextStyle(
                  color: greyColor,
                  fontFamily: regular,
                ),
                textAlign: TextAlign.center),
            const SizedBox(
              height: 20,
            ),
            OtpTextField(
              numberOfFields: 6,
              borderColor: greyColor,
              //set to true to show as box or false to show as dash
              showFieldAsBox: true,
              //runs when a code is typed in
              onCodeChanged: (String code) {
                //handle validation or checks here
              },
              //runs when every textfield is filled
              onSubmit: (String verificationCode) {
                controller.otpController.text = verificationCode;
                controller.verifyOTP();
              }, // end onSubmit
            ),
            const SizedBox(
              height: 40,
            ),
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () {
                  controller.verifyOTP();
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

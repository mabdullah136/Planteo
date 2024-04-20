import 'package:planteo/utils/exports.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(AuthController());
    checkAuth() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();
      final String? token = prefs.getString('token');
      if (token == null) {
        Get.off(const OnboardingScreen());
      } else {
        Get.off(const Home());
      }
    }

    checkAuth();
    return Scaffold(
      body: Center(child: Image.asset(logo, width: 300, height: 300)),
    );
  }
}

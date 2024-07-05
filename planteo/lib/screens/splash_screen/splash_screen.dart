import 'package:planteo/services/location_services.dart';
import 'package:planteo/services/notification_services.dart';
import 'package:planteo/utils/exports.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SplashScreen extends StatelessWidget {
  const SplashScreen({super.key});

  @override
  Widget build(BuildContext context) {
    checkAuth() async {
      final SharedPreferences prefs = await SharedPreferences.getInstance();

      await NotificationService().getFCMToken();
      await LocationServices.getLocation();
      final String? token = prefs.getString('token');
      if (token == null) {
        Get.off(const OnboardingScreen());
      } else {
        Timer(const Duration(seconds: 3), () {
          Get.off(const Home());
        });
      }
    }

    checkAuth();
    return Scaffold(
      body: Center(
        child: Image.asset(
          logo,
          width: 300,
          height: 300,
        ),
      ),
    );
  }
}

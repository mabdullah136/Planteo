import 'package:planteo/utils/exports.dart';

class HomeController extends GetxController {
  final currentNavIndex = 0.obs;
  get counter => currentNavIndex.value;
  set counter(value) => currentNavIndex.value = value;

  void increment() {
    counter++;
  }
}

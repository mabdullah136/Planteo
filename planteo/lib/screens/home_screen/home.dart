// import 'package:flutter/cupertino.dart';
// import 'package:flutter/services.dart';
// import 'package:planteo/utils/exports.dart';

// class Home extends StatelessWidget {
//   const Home({super.key});

//   @override
//   Widget build(BuildContext context) {
//     //init home controller
//     var controller = Get.put(HomeController());

//     var navbarItem = [
//       const BottomNavigationBarItem(
//           icon: Icon(CupertinoIcons.chat_bubble_text), label: 'Messages'),
//       const BottomNavigationBarItem(
//           icon: Icon(Icons.person_add_alt_outlined), label: 'Requests'),
//       const BottomNavigationBarItem(
//           icon: Icon(Icons.contact_page_outlined), label: 'Contacts'),
//       const BottomNavigationBarItem(
//           icon: Icon(Icons.settings_outlined), label: 'Settings'),
//     ];

//     var navBody = [
//       const HomeScreen(),
//       const HomeScreen(),
//       const HomeScreen(),
//       const ProfileSettingScreen(),
//     ];

//     return PopScope(
//       onPopInvoked: (didPop) {
//         if (didPop) {
//           if (controller.currentNavIndex.value != 0) {
//             controller.currentNavIndex.value = 0;
//           } else {
//             Get.dialog(
//               AlertDialog(
//                 title: const Text('Exit App'),
//                 content: const Text('Are you sure you want to exit the app?'),
//                 actions: [
//                   TextButton(
//                     onPressed: () {
//                       Get.back();
//                     },
//                     child: const Text('No'),
//                   ),
//                   TextButton(
//                     onPressed: () {
//                       SystemNavigator.pop();
//                     },
//                     child: const Text('Yes'),
//                   ),
//                 ],
//               ),
//             );
//           }
//         }
//       },
//       child: Scaffold(
//         body: Column(
//           children: [
//             Obx(
//               () => Expanded(
//                 child: navBody.elementAt(controller.currentNavIndex.value),
//               ),
//             ),
//           ],
//         ),
//         bottomNavigationBar: Obx(
//           () => Theme(
//             data: ThemeData(
//               splashColor: Colors.transparent,
//               highlightColor: Colors.transparent,
//             ),
//             child: BottomNavigationBar(
//               elevation: 0,
//               unselectedLabelStyle: const TextStyle(
//                 fontFamily: medium,
//                 fontSize: 12,
//               ),
//               useLegacyColorScheme: false,
//               enableFeedback: false,
//               currentIndex: controller.currentNavIndex.value,
//               type: BottomNavigationBarType.fixed,
//               selectedItemColor: kPrimaryColor,
//               // selectedIconTheme: const IconThemeData(color: secondaryFontColor),
//               unselectedItemColor: Colors.grey[500],
//               selectedLabelStyle: const TextStyle(
//                 fontFamily: medium,
//                 fontSize: 12,
//               ),
//               backgroundColor: whiteColor,
//               items: navbarItem,
//               onTap: (value) {
//                 controller.currentNavIndex.value = value;
//               },
//             ),
//           ),
//         ),
//       ),
//     );
//   }
// }

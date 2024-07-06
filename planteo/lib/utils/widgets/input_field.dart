import 'package:planteo/utils/exports.dart';

class InputField extends StatelessWidget {
  final String title, hintText;
  final TextEditingController controller;
  const InputField(
      {super.key,
      required this.title,
      required this.hintText,
      required this.controller});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          color: greyColor,
          fontFamily: regular,
        ),
        label: Text(title),
        labelStyle: const TextStyle(
          color: greyColor,
          fontFamily: regular,
        ),
        border: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
        ),
        focusedBorder: const OutlineInputBorder(
          borderRadius: BorderRadius.all(Radius.circular(20)),
          borderSide: BorderSide(color: kPrimaryColor),
        ),
      ),
    );
  }
}

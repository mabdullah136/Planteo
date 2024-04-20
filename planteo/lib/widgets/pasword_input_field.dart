import 'package:planteo/utils/exports.dart';

class PasswordInput extends StatefulWidget {
  final String title, hintText;
  final TextEditingController controller;
  const PasswordInput({super.key, required this.title, required this.hintText, required this.controller});

  @override
  State<PasswordInput> createState() => _PasswordInputState();
}

class _PasswordInputState extends State<PasswordInput> {
  var _obscureText = true;
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _obscureText,
      decoration: InputDecoration(
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: greyColor,
          fontFamily: regular,
        ),
        suffixIcon: _obscureText
            ? InkWell(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: const Icon(Icons.visibility_off_outlined),
              )
            : InkWell(
                onTap: () {
                  setState(() {
                    _obscureText = !_obscureText;
                  });
                },
                child: const Icon(Icons.visibility_outlined),
              ),
        label:  Text(widget.title),
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

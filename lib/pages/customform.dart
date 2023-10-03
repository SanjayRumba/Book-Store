import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomForm extends StatelessWidget {
  String? labelText;
  String? hintText;
  int? minLine, maxLine;
  List<TextInputFormatter>? inputFormatter;
  bool obsecureText;
  TextInputType? keyboardType;
  Function(String)? onChanged;
  String? Function(String?)? validator;
  Widget? suffixIcon;
  Function()? suffixOnPressed;
  Function()? suffixOffPressed;
  Widget? prefixIcon;
  bool showSuffix;
  bool enabled;
  String? initialValue; // New parameter to support initial value

  CustomForm({
    Key? key,
    this.showSuffix = false,
    this.suffixOffPressed,
    this.labelText,
    this.enabled=true,
    this.obsecureText = false,
    this.hintText,
    this.inputFormatter,
    this.keyboardType,
    this.onChanged,
    this.validator,
    this.suffixIcon,
    this.suffixOnPressed,
    this.minLine,
    this.maxLine,
    this.prefixIcon,
    this.initialValue, // Initialize the new parameter
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: Center(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
          child: SizedBox(
            width: MediaQuery.of(context).size.width * 0.9,
            child: TextFormField(
              autofocus: true,
              textAlign: TextAlign.start,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              initialValue: initialValue, // Use the initialValue here
              decoration: InputDecoration(
                border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                prefixIcon: prefixIcon,
                prefixIconConstraints: const BoxConstraints(minWidth: 40.0),
                hintText: hintText,
                hintStyle: const TextStyle(fontSize: 16),
                labelStyle: const TextStyle(fontSize: 16),
                contentPadding: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                suffixIcon: showSuffix
                    ? GestureDetector(
                        onTap: obsecureText ? suffixOnPressed : suffixOffPressed,
                        child: suffixIcon,
                      )
                    : null,
              ),
              obscureText: obsecureText,
              keyboardType: keyboardType,
              inputFormatters: inputFormatter,
              onChanged: onChanged,
              enabled: enabled,
              validator: validator,
            ),
          ),
        ),
      ),
    );
  }
}

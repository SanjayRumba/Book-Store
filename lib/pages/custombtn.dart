import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  Function()? onPressed;
  String? text;
  bool isloading;
  CustomButton({Key? key, this.onPressed, this.text, this.isloading = false, Color? primary})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 50,
      width: MediaQuery.of(context).size.width * 0.95,
      child: Padding(
        padding: const EdgeInsets.only(left: 20),
        child: ElevatedButton(
            style: ElevatedButton.styleFrom(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            onPressed: onPressed,
            child: isloading
                ? CircularProgressIndicator(
                    color: Colors.white,
                  )
                : Text(text!)
            // Text(text ??"login") we can assign login as default value like this.
            ),
            
      ),
    );
  }
}

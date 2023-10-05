import 'package:book_shop/pages/OtpVerificationScreen.dart';
import 'package:book_shop/pages/custombtn.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/services.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ForgotPassword extends StatefulWidget {
  const ForgotPassword({Key? key}) : super(key: key);

  @override
  _ForgotPasswordState createState() => _ForgotPasswordState();
}

class _ForgotPasswordState extends State<ForgotPassword> {
  String? phone;
  final _formkey = GlobalKey<FormState>();
  bool isSendingOTP = false; // Track if OTP is being sent

  void _showDialog(String title, String message) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          content: Text(message),
          actions: <Widget>[
            TextButton(
              child: const Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void sendOtp() async {
    if (_formkey.currentState!.validate()) {
      setState(() {
        isSendingOTP = true;
      });

      try {
        await FirebaseAuth.instance.verifyPhoneNumber(
          phoneNumber: '+977$phone',
          verificationCompleted: (PhoneAuthCredential credential) async {
            await FirebaseAuth.instance.signInWithCredential(credential);
            setState(() {
              isSendingOTP = false;
            });
            _showDialog('Success', 'OTP verification successful.');
          },
          verificationFailed: (FirebaseAuthException e) {
            setState(() {
              isSendingOTP = false;
            });
            _showDialog('Verification Failed', 'Error: ${e.message}');
          },
          codeSent: (String verificationId, int? resendToken) {
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => OtpVerificationScreen(
                  verificationId: verificationId,
                  phone: int.parse(phone!),
                ),
              ),
            );
            setState(() {
              isSendingOTP = false;
            });
          },
          codeAutoRetrievalTimeout: (String verificationId) {},
        );
      } catch (e) {
        setState(() {
          isSendingOTP = false;
        });
        _showDialog('Error', 'An error occurred: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Forgot Password',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Padding(
        padding: const EdgeInsets.only(top: 50, right: 10, left: 10),
        child: Form(
          key: _formkey,
          child: Column(
            children: [
              TextFormField(
                decoration: const InputDecoration(
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(12.0)),
                    borderSide: BorderSide(
                      width: 1,
                      color: Color.fromARGB(255, 207, 198, 198),
                    ),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(
                      width: 1,
                      color: Color.fromARGB(255, 207, 198, 198),
                    ),
                  ),
                  prefixIcon: Icon(
                    Icons.phone,
                    color: Colors.grey,
                  ),
                  hintText: "Phone",
                ),
                keyboardType: TextInputType.phone,
                inputFormatters: [
                  LengthLimitingTextInputFormatter(10),
                ],
                validator: ((value) {
                  if (value!.isEmpty) {
                    return "Phone number is required";
                  } else if (value.length != 10) {
                    return "Phone number must have exactly 10 digits";
                  }
                  return null;
                }),
                onChanged: (value) {
                  setState(() {
                    phone = value;
                  });
                },
              ),
              const SizedBox(height: 10),
              ElevatedButton(
                onPressed: isSendingOTP ? null : sendOtp,
                child: Text(isSendingOTP ? 'Sending OTP...' : 'Send OTP'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

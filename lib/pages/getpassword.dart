import 'package:book_shop/apiservices/apibloc.dart';
import 'package:book_shop/apiservices/apistate.dart';
import 'package:book_shop/pages/custombtn.dart';
import 'package:book_shop/pages/customform.dart';
import 'package:book_shop/pages/login.dart';
import 'package:book_shop/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class GetPassword extends StatefulWidget {
  GetPassword({Key? key}) : super(key: key);

  @override
  State<GetPassword> createState() => _GetPasswordState();
}

class _GetPasswordState extends State<GetPassword> {
  final _formKey = GlobalKey<FormState>();
  bool isNPasswordVisible = false;
  bool isConPasswordVisible = false;
  String? newPassword, confirmPassword;

  Future<void> _submitData() async {
    try {
      final success = await BlocProvider.of<ApiBloc>(context).api.changeOtpPw(
        newPassword: newPassword,
        confirmPassword: confirmPassword,
      );

      if (success) {
        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(builder: (BuildContext context) => const LoginForm()),
          (route) => false,
        );
      }
    } catch (e) {
      print("Error submitting data: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: BlocBuilder<ApiBloc, ApiState>(
        builder: (context, state) {
          if (state is LoadedState) {
            if (state.isSuccessful) {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => const LoginForm()),
              );
            } else {
              // Handle error if needed
            }
          }
          return Padding(
            padding: const EdgeInsets.only(top: 50),
            child: SingleChildScrollView(
              child: Form(
                key: _formKey,
                child: SafeArea(
                  child: Column(
                    children: [
                      const Text(
                        "Insert new password",
                        style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                        textAlign: TextAlign.center,
                      ),
                      const SizedBox(height: 10),
                      CustomForm(
                        hintText: "  New Password",
                        obsecureText: !isNPasswordVisible,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isNPasswordVisible = !isNPasswordVisible;
                            });
                          },
                          icon: Icon(isNPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password field must be filled up";
                          } else if (!RegExp(r'\d').hasMatch(value)) {
                            return "Password must contain at least one digit";
                          } else if (!RegExp(r'\W').hasMatch(value)) {
                            return "Password must contain at least one symbol";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            newPassword = value;
                          });
                        },
                      ),
                      const SizedBox(
                        height: 4,
                      ),
                      CustomForm(
                        hintText: "  Re-Password",
                        obsecureText: !isConPasswordVisible,
                        suffixIcon: IconButton(
                          onPressed: () {
                            setState(() {
                              isConPasswordVisible = !isConPasswordVisible;
                            });
                          },
                          icon: Icon(isConPasswordVisible ? Icons.visibility_outlined : Icons.visibility_off),
                        ),
                        validator: (value) {
                          if (value!.isEmpty) {
                            return "Password field must be filled up";
                          } else if (newPassword != value) {
                            return "Passwords do not match";
                          }
                          return null;
                        },
                        onChanged: (value) {
                          setState(() {
                            confirmPassword = value;
                          });
                        },
                      ),
                      SizedBox(
                        height: MediaQuery.of(context).size.height * 0.05,
                      ),
                      CustomButton(
                        primary: primary,
                        text: "Change",
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            _submitData();
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

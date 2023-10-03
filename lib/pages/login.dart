import 'package:book_shop/apiservices/apibloc.dart';
import 'package:book_shop/apiservices/apievent.dart';
import 'package:book_shop/apiservices/apistate.dart';
import 'package:book_shop/pages/BottomNav.dart';
import 'package:book_shop/pages/custombtn.dart';
import 'package:book_shop/pages/customform.dart';
import 'package:book_shop/pages/forgetpassword.dart';
import 'package:book_shop/pages/signup.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class LoginForm extends StatefulWidget {
  const LoginForm({Key? key}) : super(key: key);

  @override
  State<LoginForm> createState() => _LoginFormState();
}

class _LoginFormState extends State<LoginForm> {
  final _formKey = GlobalKey<FormState>();
  String? email, password;
  bool isVisible = false;
  bool rememberMe = false;
  TextEditingController emailController = TextEditingController();

  saveValueToSharedPreference() async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isLogin', true);
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ApiBloc, ApiState>(
      listener: (context, state) {
        if (state is LoadedState) {
          if (state.response) {
            // Successful login
            saveValueToSharedPreference();
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => BottomNav()),
            );
          } else {
            // Show a snackbar with login failure message
            const snackBar = SnackBar(
              content: Text('Login failed. Please check your credentials.'),
            );
            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }
      },
      child: Scaffold(
        body: Form(
          key: _formKey,
          child: Column(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.1,
              ),
              Center(
                child: SizedBox(
                    height: 60,
                    width: 60,
                    child: Image.asset("assets/images/profile.png")),
              ),
              const SizedBox(
                height: 10,
              ),
              const Center(
                child: Text(
                  "Admin Login",
                  style: TextStyle(
                    fontSize: 20.0,
                  ),
                ),
              ),
              SizedBox(height: MediaQuery.of(context).size.height * 0.05),
              CustomForm(
                prefixIcon: Icon(Icons.mail),
                hintText: "Email",
                onChanged: (value) {
                  setState(() {
                    email = value;
                  });
                },
              ),
              CustomForm(
                prefixIcon: Icon(Icons.lock),
                hintText: "Password",
                obsecureText: !isVisible,
                onChanged: (value) {
                  setState(() {
                    password = value;
                  });
                },
                showSuffix: true, // Set this to true for suffix icon visibility toggle
                suffixIcon: Icon(
                  isVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.grey,
                ),
                suffixOnPressed: () {
                  setState(() {
                    isVisible = !isVisible;
                  });
                },
              ),
              SizedBox(height: 10),
              Padding(
                padding: const EdgeInsets.only(left: 20,right: 20,bottom:10 ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Row(
                      children: [
                        Checkbox(
                          value: rememberMe,
                          onChanged: (value) {
                            setState(() {
                              rememberMe = value!;
                            });
                          },
                        ),
                        Text('Remember Me'),
                      ],
                    ),
                    TextButton(
                      onPressed: () {
                        Navigator.push(context,MaterialPageRoute(builder: (context) => ForgotPassword()),
                      );
                      },
                      child: Text('Forgot Password?'),
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(right: 10),
                child: CustomButton(
                  onPressed: () async {
                    // Add validation for non-empty email and password fields
                    if (_formKey.currentState!.validate() &&
                        email != null &&
                        email!.isNotEmpty &&
                        password != null &&
                        password!.isNotEmpty) {
                      BlocProvider.of<ApiBloc>(context).add(
                        LoginEvents(email: email, password: password),
                      );
                    } else {
                      // Show an error message when email or password is empty
                      const snackBar = SnackBar(
                        content: Text('Please enter both email and password.'),
                      );
                      ScaffoldMessenger.of(context).showSnackBar(snackBar);
                    }
                  },
                  text: "Login",
                ),
              ),

              // Padding(
              //   padding: const EdgeInsets.only(top: 30),
              //   child: Row(
              //     children: const [
              //       Flexible(
              //         child: Divider(
              //           thickness: 0.5,
              //           color: Colors.black,
              //         ),
              //       ),
              //       SizedBox(
              //         width: 20,
              //       ),
              //       Text(
              //         "Or",
              //         style: TextStyle(
              //           color: Colors.black,
              //           fontSize: 16,
              //           fontFamily: "Andika",
              //         ),
              //       ),
              //       SizedBox(
              //         width: 20,
              //       ),
              //       Flexible(
              //         child: Divider(
              //           thickness: 0.5,
              //           color: Colors.black,
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
              // Padding(
              //   padding: const EdgeInsets.only(top: 30, left: 130, bottom: 20),
              //   child: Row(
              //     children: [
              //       const Text(
              //         "Don't have an account? ",
              //         style: TextStyle(
              //           fontSize: 16,
              //           fontFamily: "Andika",
              //         ),
              //       ),
              //       InkWell(
              //         onTap: () {
              //           Navigator.push(
              //             context,
              //             MaterialPageRoute(
              //               builder: (context) => SignupPage(),
              //             ),
              //           );
              //         },
              //         child: const Text(
              //           "Sign in",
              //           style: TextStyle(
              //             fontSize: 16,
              //             fontFamily: "Andika",
              //             color: Color(0xFF3173BF),
              //           ),
              //         ),
              //       ),
              //     ],
              //   ),
              // ),
            ],
          ),
        ),
      ),
    );
  }
}

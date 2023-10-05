import 'dart:io';

import 'package:book_shop/apiservices/apibloc.dart';
import 'package:book_shop/apiservices/apievent.dart';
import 'package:book_shop/apiservices/apistate.dart';
import 'package:book_shop/pages/custombtn.dart';
import 'package:book_shop/pages/customform.dart';
import 'package:book_shop/pages/helper.dart';
import 'package:book_shop/pages/login.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';

class SignupPage extends StatefulWidget {
  const SignupPage({Key? key}) : super(key: key);

  @override
  State<SignupPage> createState() => _SignupPageState();
}

class _SignupPageState extends State<SignupPage> {
  final _formKey = GlobalKey<FormState>();
  bool isVisible = false;
  bool loader = false;
  String? password, email, cPassword, selectedGender,image;
  String? fullName, dropDownValue, address;
  int? phone;
  File? file1;
  String? imagePath = "";
  List<String> gList = ["male", "Female", "Others"];

  @override
  Widget build(BuildContext context) {
    return BlocListener<ApiBloc, ApiState>(
      listener: (context, state) {
        if (state is LoadingState) {
          loadingBlur(true);
        }
        if (state is LoadedState) {
          loadingBlur(false);
          if (state.response) {
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => const LoginForm()),
            );
          } else {
            const snackBar = SnackBar(
              content: Text('Failed to register'),
            );

            ScaffoldMessenger.of(context).showSnackBar(snackBar);
          }
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        body: SingleChildScrollView(
          child: Stack(
            alignment: Alignment.bottomCenter,
            children: [
              signupUi(),
              loader ? Helper.backdropFilter(context) : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  signupUi() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          Center(
            child: SizedBox(
              height: 60,
              width: 60,
              child:InkWell(
                onTap: (){
                  pickImage();
                },
              
              child: imagePath!.isEmpty?Image.asset(
                "assets/images/profile.png"):
                CircleAvatar(
                  radius: 40,
                  backgroundImage: NetworkImage(imagePath!),
                )
            )),
          ),
          const SizedBox(
            height: 10,
          ),
          const Center(
            child: Text(
              "Create an account",
              style: TextStyle(
                fontSize: 20.0,
                fontFamily: "Andika",
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomForm(
            hintText: " Full Name",
            prefixIcon: const Icon(Icons.person),
            validator: ((value) {
              if (value!.isEmpty) {
                return "Field is required to be filled";
              } else if (!RegExp("(?=.*[A-Z])").hasMatch(value)) {
                return "Full name must contain at least one uppercase letter";
              }
              return null;
            }),
            onChanged: (value) {
              setState(() {
                fullName = value;
              });
            },
          ),
          CustomForm(
            inputFormatter: [LengthLimitingTextInputFormatter(10)],
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(Icons.phone_outlined),
            hintText: "Phone",
            validator: ((value) {
              if (value!.isEmpty) {
                return "Field is required to be filled";
              } else if (value.length < 10) {
                return "Phone number must have 10 digits";
              }
              return null;
            }),
            onChanged: (value) {
              setState(() {
                phone = int.parse(value);
              });
            },
          ),
          CustomForm(
            hintText: " Address",
            prefixIcon: const Icon(Icons.location_on),
            validator: ((value) {
              if (value!.isEmpty) {
                return "Field is required to be filled";
              } else if (!RegExp("(?=.*[A-Z])").hasMatch(value)) {
                return "Address must contain at least one uppercase letter";
              }
              return null;
            }),
            onChanged: (value) {
              setState(() {
                address = value;
              });
            },
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(
              left: 20,
            ),
            child: Container(
              height: 55,
              width: MediaQuery.of(context).size.width * 0.9,
              child: DropdownButtonFormField(
                decoration: InputDecoration(
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  hintText: "Select gender",
                  prefixIcon: Icon(Icons.people_outlined),
                  hintStyle: TextStyle(fontFamily: "Andika", fontSize: 16),
                ),
                value: selectedGender,
                items: gList
                    .map(
                      (e) => DropdownMenuItem(
                        child: Text(
                          e,
                          style: const TextStyle(fontSize: 16),
                        ),
                        value: e,
                      ),
                    )
                    .toList(),
                onChanged: (value) {
                  selectedGender = value as String;
                },
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          CustomForm(
            validator: ((value) {
              if (value!.isEmpty ||
                  !RegExp(
                          r"^[a-zA-Z0-9.a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                      .hasMatch(value)) {
                return "Enter a valid email!";
              }
              return null;
            }),
            hintText: "Email",
            prefixIcon: const Padding(
              padding: EdgeInsets.all(10),
              child: FaIcon(Icons.email),
            ),
            onChanged: (value) {
              setState(() {
                email = value;
              });
            },
          ),
          CustomForm(
            obsecureText: isVisible ? true : false,
            suffixIcon: isVisible
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isVisible = false;
                      });
                    },
                    icon: const Icon(Icons.visibility),
                  )
                : IconButton(
                    onPressed: () {
                      setState(() {
                        isVisible = true;
                      });
                    },
                    icon: const Icon(Icons.visibility_off),
                  ),
            validator: ((value) {
              if (value!.isEmpty) {
                return "Password field must be filled";
              } else if (!RegExp("(?=.*[A-Z])").hasMatch(value)) {
                return "Password must contain at least one uppercase letter";
              } else if (!RegExp((r'\d')).hasMatch(value)) {
                return "Password must contain at least one digit";
              } else if (!RegExp((r'\W')).hasMatch(value)) {
                return "Password must contain at least one symbol";
              } else {
                return null;
              }
            }),
            onChanged: (value) {
              setState(() {
                password = value;
              });
            },
            hintText: "Password",
            prefixIcon: const Padding(
              padding: EdgeInsets.all(10),
              child: FaIcon(FontAwesomeIcons.lock),
            ),
          ),
          CustomForm(
            obsecureText: isVisible ? true : false,
            suffixIcon: isVisible
                ? IconButton(
                    onPressed: () {
                      setState(() {
                        isVisible = false;
                      });
                    },
                    icon: const Icon(Icons.visibility),
                  )
                : IconButton(
                    onPressed: () {
                      setState(() {
                        isVisible = true;
                      });
                    },
                    icon: const Icon(Icons.visibility_off),
                  ),
            validator: ((value) {
              if (value!.isEmpty) {
                return "Password field must be filled";
              } else if (value != password) {
                return "Password doesn't match";
              }
              return null;
            }),
            onChanged: (value) {
              setState(() {
                cPassword = value;
              });
            },
            hintText: "Confirm Password",
            prefixIcon: const Padding(
              padding: EdgeInsets.all(10),
              child: FaIcon(FontAwesomeIcons.lock),
            ),
          ),
          const SizedBox(
            height: 15,
          ),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: CustomButton(
              text: "Sign Up",
              onPressed: () async {
                if (_formKey.currentState!.validate()) {
                  BlocProvider.of<ApiBloc>(context).add(
                    SignupEvent(
                      fullname: fullName,
                      phone: phone,
                      address: address,
                      gender: selectedGender,
                      email: email,
                      password: password,
                      repassword: cPassword,
                      image: imagePath
                    ),
                  );
                }
              },
            ),
          ),
          
        ],
      ),
    );
  }

  void loadingBlur(bool value) {
    setState(() {
      loader = value;
    });
  }
    void pickImage() async {
    int? contact = phone;
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    file1 = File(image.path);
    setState(() {
      file1;
    });
    List<String> extension = image.name.split('.');
    final storageRef = FirebaseStorage.instance.ref();
    var mountainsRef = storageRef.child('$contact.${extension[1]}');

    try {
      loadingBlur(true);
      // Upload the file to Firebase Storage
      await mountainsRef.putFile(file1!);
      // Get the download URL of the uploaded file
      final downloadURL =
          await storageRef.child('$contact.${extension[1]}').getDownloadURL();
      if (!mounted) return;

      setState(() {
        imagePath = downloadURL;
      });
     // updateImageInFirebase();
      // Save the image path to shared preferences
    } catch (e) {
      loadingBlur(false);
      print(e);
    }
    Future.delayed(const Duration(milliseconds: 2000), () {
      loadingBlur(false);
    });
  }
}

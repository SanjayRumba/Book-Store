import 'dart:io';

import 'package:book_shop/apiservices/apibloc.dart';
import 'package:book_shop/apiservices/apievent.dart';
import 'package:book_shop/apiservices/apistate.dart';
import 'package:book_shop/pages/BottomNav.dart';
import 'package:book_shop/pages/customform.dart';
import 'package:book_shop/pages/settings.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart'; // Import the flutter_spinkit package

class AddBooks extends StatefulWidget {
  AddBooks({Key? key}) : super(key: key);

  @override
  State<AddBooks> createState() => _AddBooksState();
}

class _AddBooksState extends State<AddBooks> {
  late String imagePath = "";
  String? userId = "";
  File? file1;
  ImagePicker image = ImagePicker();

  final _formKey = GlobalKey<FormState>();
  bool loader = false;
  String? bookName, selectedCategory;
  String? author, dropDownValue, photo;
  double? oldPrice, newPrice;
  List<String> cList = [
    "Poetry",
    "Novel",
    "Fiction",
    "Story",
    "Thriller",
    "Horror Fiction",
    "History Fiction",
    "Textbook",
    "Comic",
    "Mystery",
    "Fantasy",
    "True Crime",
    "Biographics",
    "Romance",
    "Cookbooks",
    "Essay"
  ];

  bool saving = false; // Added saving variable

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
            Fluttertoast.showToast(
              msg: "Successfully added",
              toastLength: Toast.LENGTH_LONG,
              gravity: ToastGravity.SNACKBAR,
              timeInSecForIosWeb: 1,
              backgroundColor: Colors.green,
              textColor: Colors.white,
              fontSize: 16.0,
            );
            Navigator.push(
                context, MaterialPageRoute(builder: (context) => const BottomNav()));
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
              addBookUi(),
              saving
                  ? Container(
                      child: Center(
                        child: SpinKitCircle(
                          color: Colors.blue, // Set the color of the circular progress indicator
                          size: 50.0, // Set the size of the circular progress indicator
                        ),
                      ),
                    )
                  : SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  addBookUi() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: EdgeInsets.only(top: 60, left: 10),
            child: InkWell(
              onTap: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) => Settings()));
              },
              child: Icon(
                Icons.arrow_back_ios,
                color: Colors.black,
                size: 25,
              ),
            ),
          ),
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.05,
          ),
          Center(
            child: SizedBox(
              height: 60,
              width: 60,
              child: InkWell(
                onTap: () {
                  pickImage();
                },
                child: imagePath.isEmpty
                    ? Image.asset("assets/images/profile.png")
                    : CircleAvatar(
                        radius: 40,
                        backgroundImage: NetworkImage(imagePath),
                      ),
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          const Center(
            child: Text(
              "Add Book Details",
              style: TextStyle(
                fontSize: 20.0,
              ),
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          CustomForm(
            hintText: "Book Name",
            prefixIcon: const Icon(Icons.book_outlined),
            validator: ((value) {
              if (value!.isEmpty) {
                return "Field is required to be filled";
              } else if (!RegExp("(?=.*[A-Z])").hasMatch(value)) {
                return "Book name must contain at least one uppercase letter\n";
              }
              return null;
            }),
            onChanged: (value) {
              setState(() {
                bookName = value;
              });
            },
          ),
          CustomForm(
            prefixIcon: const Icon(Icons.person),
            hintText: "Author",
            validator: ((value) {
              if (value!.isEmpty) {
                return "Field is required to be filled";
              }
              return null;
            }),
            onChanged: (value) {
              setState(() {
                author = value;
              });
            },
          ),
          CustomForm(
            keyboardType: TextInputType.number,
            hintText: "Old Price",
            prefixIcon: const Icon(Icons.price_change),
            validator: ((value) {
              if (value!.isEmpty) {
                return "Field is required to be filled";
              }
              return null;
            }),
            onChanged: (value) {
              setState(() {
                oldPrice = double.parse(value);
              });
            },
          ),
          CustomForm(
            keyboardType: TextInputType.number,
            hintText: "New Price",
            prefixIcon: const Icon(Icons.price_change),
            validator: ((value) {
              if (value!.isEmpty) {
                return "Field is required to be filled";
              }
              return null;
            }),
            onChanged: (value) {
              setState(() {
                newPrice = double.parse(value);
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
                  border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                  hintText: "Select Category",
                  prefixIcon: Icon(Icons.people_outlined),
                  hintStyle: TextStyle(fontFamily: "Andika", fontSize: 16),
                ),
                value: selectedCategory,
                items: cList
                    .map((e) => DropdownMenuItem(child: Text(e, style: const TextStyle(fontSize: 16)), value: e))
                    .toList(),
                onChanged: (value) {
                  setState(() {
                    selectedCategory = value as String;
                  });
                },
              ),
            ),
          ),
          const SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 150, top: 20),
            child: SizedBox(
              height: 50,
              width: 180,
              child: ElevatedButton(
                onPressed: () {
                  if (_formKey.currentState!.validate()) {
                    try {
                      setState(() {
                        saving = true; // Set saving to true when saving starts
                      });

                      BlocProvider.of<ApiBloc>(context).add(AddBookEvent(
                        bookName: bookName,
                        category: selectedCategory,
                        author: author,
                        newPrice: newPrice,
                        oldPrice: oldPrice,
                        imageUrl: imagePath,
                      ));
                    } catch (e) {
                      loadingBlur(false);
                      setState(() {
                        saving = false; // Set saving to false when saving fails
                      });
                    }
                  }
                },
                child: Text(
                  'Save',
                  style: TextStyle(color: Colors.white, fontSize: 15),
                ),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue[900],
                  padding: EdgeInsets.symmetric(horizontal: 40.0, vertical: 16.0),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(
            height: 25,
          ),
        ],
      ),
    );
  }

  loadingBlur(bool value) {
    setState(() {
      loader = value;
    });
  }

  void pickImage() async {
    String? name = bookName;
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    file1 = File(image.path);
    setState(() {
      file1;
    });
    List<String> extension = image.name.split('.');
    final storageRef = FirebaseStorage.instance.ref();
    var mountainsRef = storageRef.child('$name.${extension[1]}');

    try {
      loadingBlur(true);
      // Upload the file to Firebase Storage
      await mountainsRef.putFile(file1!);
      // Get the download URL of the uploaded file
      final downloadURL = await storageRef.child('$name.${extension[1]}').getDownloadURL();
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

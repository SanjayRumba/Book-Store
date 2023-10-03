import 'dart:io';
import 'package:book_shop/apiservices/apibloc.dart';
import 'package:book_shop/apiservices/apievent.dart';
import 'package:book_shop/apiservices/apistate.dart';
import 'package:book_shop/pages/BottomNav.dart';
import 'package:book_shop/pages/custombtn.dart';
import 'package:book_shop/pages/customform.dart';
import 'package:book_shop/pages/helper.dart';
import 'package:book_shop/pages/khaltihomepage.dart';
import 'package:book_shop/pages/login.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

class OrderPageEsewa extends StatefulWidget {
  String? Book;
  double? price;
  OrderPageEsewa({Key? key,this.Book,this.price}) : super(key: key);

  @override
  _OrderPageEsewaState createState() => _OrderPageEsewaState();
}

class _OrderPageEsewaState extends State<OrderPageEsewa> {
    String referenceId = "";
    
  final _formKey = GlobalKey<FormState>();
  bool isVisible = false;
  bool loader = false;
  String? email;
  String? fullName, address;
  int? phone;
  File? file1;
  String? bookName;
  String? imagePath = "";
  DateTime? fromDate;
  DateTime? toDate;
  int? quantity = 0;
  double? price = 0.0;
  double? total = 0.0;
  String totalAmount="0.0";

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
              MaterialPageRoute(builder: (context) => const BottomNav()),
            );
          } else {
            const snackBar = SnackBar(
              content: Text('Failed to place order'),
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
              paymentUi(),
              loader ? Helper.backdropFilter(context) : const SizedBox(),
            ],
          ),
        ),
      ),
    );
  }

  paymentUi() {
    return Form(
      key: _formKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.1,
          ),
          const SizedBox(
            height: 10,
          ),
          
          const Center(
            child: Text(
              "Order Form",
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
              initialValue: widget.Book,
              
            enabled: false,
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
          CustomForm(
            validator: ((value) {
              if (value!.isEmpty ||
                  !RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
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
            // inputFormatter: [LengthLimitingTextInputFormatter(10)],
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(Icons.phone_outlined),
            hintText: "Quantity",
            validator: ((value) {
              if (value!.isEmpty) {
                return "Field is required to be filled";
              } else if (value.length < 0) {
                return "Quantity must be atleat one";
              }
              return null;
            }),
            onChanged: (value) {
              if(value.isEmpty){
              totalAmount="0.0";
              }else{
                 
                quantity = int.parse(value);
                 double total=(quantity ?? 0) * (widget.price ?? 0.0);
                totalAmount=total.toString();
                
              }
                setState(() {
                  totalAmount;
               });
             
             

            },
          ),
            CustomForm(
            initialValue: widget.price.toString(),
            enabled: false,
            keyboardType: TextInputType.phone,
            prefixIcon: const Icon(Icons.phone_outlined),
            onChanged: (value) {
              setState(() {
                price = double.parse(value);
              });
            },
          ),
          SizedBox(
            height: 10,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25, right: 25),
            child: Row(
              children: [
                Expanded(
                  child: InkWell(
                    onTap: () {
                      selectDates(context, "From");
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "From Date",
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: fromDate == null
                          ? Text(
                              'Select Date',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            )
                          : Text(
                              DateFormat('yyyy-MM-dd').format(fromDate!),
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: InkWell(
                    onTap: () {
                      selectDates(context, "To");
                    },
                    child: InputDecorator(
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                        labelText: "To Date",
                        prefixIcon: Icon(Icons.calendar_today),
                      ),
                      child: toDate == null
                          ? Text(
                              'Select Date',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.grey[600],
                              ),
                            )
                          : Text(
                              DateFormat('yyyy-MM-dd').format(toDate!),
                              style: TextStyle(
                                fontSize: 16,
                              ),
                            ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          SizedBox(
            height: 10,
          ),
          Row(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Stack(
                            alignment: Alignment.center,
                            children: <Widget>[
                              InkWell(
                                onTap: () {
                                  if (!loader) {
                                    payWithKhaltiInApp();
                                  }
                                },
                                child: Container(
                                  height: 100,
                                  width: 200,
                                  child: Image.asset("assets/images/khalti.jpg"),
                                ),
                              ),
                              if (loader)
                                  Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      CircularProgressIndicator(),
                                      SizedBox(height: 10),
                                      Text('Processing Payment...'),
                                    ],
                                  ),
                              ],

                          ),

                
              ),
            Padding(
            padding: const EdgeInsets.only(left: 25),
            child: Row(
          children: [
            Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left:90,top: 10),
                  child: Text("TOTAL",style: TextStyle(fontWeight: FontWeight.bold),),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 10,left: 30),
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.black12,
                    height: 30,
                    width: 50,
                    child: Text("${totalAmount}")),
                )
              ],
            ),
          ],
            ),
          ),
        ]
        ),
        
          // Padding(
          //   padding: const EdgeInsets.only(left: 25),
          //   child: SizedBox(
          //     height: 100,
          //     width: 100,
          //     child: InkWell(
          //       onTap: () {
          //         pickImage();
          //       },
          //       child: imagePath!.isEmpty
          //           ? Image.asset("assets/images/screenshot.png")
          //           : Container(
          //               height: 200,
          //               width: 200,
          //               decoration: BoxDecoration(
          //                 border: Border.all(),
          //               ),
          //               child: Image.network(imagePath!),
          //             ),
          //     ),
          //   ),
          // ),
          SizedBox(height: 15),
          Padding(
            padding: const EdgeInsets.only(right: 20),
            child: CustomButton(
              text: "Place Order",
              onPressed: () async {
                if (_formKey.currentState!.validate() &&
                    fromDate != null &&
                    toDate != null) {
                  BlocProvider.of<ApiBloc>(context).add(
                    OrderEvent(
                      fullName: fullName,
                      phone: phone,
                      quantity: quantity,
                      address: address,
                      email: email,
                      fromDate: fromDate,
                      toDate: toDate,
                      image: imagePath,
                    ),
                  );
                } else {
                  const snackBar = SnackBar(
                    content: Text(
                        'Please fill in all required fields and select both From and To dates.'),
                  );
                  ScaffoldMessenger.of(context).showSnackBar(snackBar);
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

  Future<void> selectDates(BuildContext context, String type) async {
    final DateTime? pickedDate = await showDatePicker(
      context: context,
      initialDate:
          type == "From" ? (fromDate ?? DateTime.now()) : (toDate ?? DateTime.now()),
      firstDate: DateTime.now(),
      lastDate: DateTime(2101),
    );
    if (pickedDate != null) {
      setState(() {
        if (type == "From") {
          fromDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day); // Set the time to midnight
          if (toDate != null && fromDate!.isAfter(toDate!)) {
            toDate = fromDate;
          }
        } else {
          toDate = DateTime(pickedDate.year, pickedDate.month, pickedDate.day); // Set the time to midnight
          if (fromDate != null && toDate!.isBefore(fromDate!)) {
            fromDate = toDate;
          }
        }
      });
    }
  }

  // void pickImage() async {
  //   int? contact = phone;
  //   final image = await ImagePicker().pickImage(source: ImageSource.gallery);

  //   if (image == null) return;

  //   file1 = File(image.path);
  //   setState(() {
  //     file1;
  //   });
  //   List<String> extension = image.name.split('.');
  //   final storageRef = FirebaseStorage.instance.ref();
  //   var mountainsRef = storageRef.child('$contact.${extension[1]}');

  //   try {
  //     loadingBlur(true);
  //     // Upload the file to Firebase Storage
  //     await mountainsRef.putFile(file1!);
  //     // Get the download URL of the uploaded file
  //     final downloadURL =
  //         await storageRef.child('$contact.${extension[1]}').getDownloadURL();
  //     if (!mounted) return;

  //     setState(() {
  //       imagePath = downloadURL;
  //     });
  //     // updateImageInFirebase();
  //     // Save the image path to shared preferences
  //   } catch (e) {
  //     loadingBlur(false);
  //     print(e);
  //   }
  //   Future.delayed(const Duration(milliseconds: 2000), () {
  //     loadingBlur(false);
  //   });
  // }
  void payWithKhaltiInApp() {
  setState(() {
    loader = true; // Start loading
  });

  KhaltiScope.of(context).pay(
    config: PaymentConfig(
      amount: 1000, //in paisa
      productIdentity: 'Product Id',
      productName: 'Product Name',
      mobileReadOnly: false,
    ),
    preferences: [
      PaymentPreference.khalti,
    ],
    onSuccess: (success) {
      setState(() {
        referenceId = success.idx;
      });
      

      // Handle success, e.g., show a success dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Payment Successful'),
            actions: [
              SimpleDialogOption(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  // Add a 2-second delay before stopping loading
                  Future.delayed(const Duration(seconds: 1), () {
                    setState(() {
                      loader = false; // Stop loading
                    });
                  });
                },
              ),
            ],
          );
        },
      );
    },
    onFailure: (failure) {
      // Handle failure, e.g., show an error dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Payment Failed'),
            content: Text('Error: ${failure.message}'),
            actions: [
              SimpleDialogOption(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  // Add a 2-second delay before stopping loading
                  Future.delayed(const Duration(seconds: 1), () {
                    setState(() {
                      loader = false; // Stop loading
                    });
                  });
                },
              ),
            ],
          );
        },
      );
    },
    onCancel: () {
      // Handle cancel, e.g., show a cancel dialog
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('Payment Canceled'),
            actions: [
              SimpleDialogOption(
                child: const Text('OK'),
                onPressed: () {
                  Navigator.pop(context);
                  // Add a 2-second delay before stopping loading
                  Future.delayed(const Duration(seconds: 1), () {
                    setState(() {
                      loader = false; // Stop loading
                    });
                  });
                },
              ),
            ],
          );
        },
      );
    },
  );
}


}

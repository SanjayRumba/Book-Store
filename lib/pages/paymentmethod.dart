// import 'dart:io';
// import 'package:book_shop/model/AdminProfileData.dart';
// import 'package:book_shop/model/BooksData.dart';
// import 'package:book_shop/pages/AdminProfile.dart';
// import 'package:book_shop/pages/custombtn.dart';
// import 'package:book_shop/pages/khaltihomepage.dart';
// import 'package:book_shop/pages/orderPageEsewa.dart';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:khalti_flutter/khalti_flutter.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:cloud_firestore/cloud_firestore.dart';

// class PaymentMethod extends StatefulWidget {
//   @override
//   _PaymentMethodState createState() => _PaymentMethodState();
// }

// class _PaymentMethodState extends State<PaymentMethod> {
//   late final String phoneNumber;
//   String referenceId = "";
//   bool isLoading = false;

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20.0),
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           crossAxisAlignment: CrossAxisAlignment.stretch,
//           children: [
//             Expanded(
//               child: Column(
//                 mainAxisAlignment: MainAxisAlignment.center,
//                 children: [
//                   Image.asset('assets/images/cashond.jpg', height: 160, width: 160),
//                   Text("Contact the owner for details"),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   InkWell(
//                     onTap: () {
//                       _launchPhoneCall("9813304635"); // Replace with the actual phone number
//                     },
//                     child: Text("9813304635", style: TextStyle(decoration: TextDecoration.underline, color: Colors.blue)),
//                   ),
//                   SizedBox(
//                     height: 10,
//                   ),
//                   CustomButton(
//                     text: 'Tap the number above',
//                     onPressed: () {
//                       // Set isLoading to true when the button is pressed.
//                       setState(() {
//                         isLoading = true;
//                       });
//                     },
//                   ),
//                 ],
//               ),
//             ),
//             Expanded(
//               child: Stack(
//                 alignment: Alignment.center,
//                 children: [
//                   Column(
//                     mainAxisSize: MainAxisSize.max,
//                     crossAxisAlignment: CrossAxisAlignment.center,
//                     mainAxisAlignment: MainAxisAlignment.center,
//                     children: [
//                       Image.asset('assets/images/cashond.jpg', height: 160, width: 160),
//                       SizedBox(
//                         height: 10,
//                       ),
//                       CustomButton(
//                         text: 'Pay through Khalti',
//                         onPressed: () {
//                           setState(() {
//                             isLoading = true;
//                           });
//                           // Create a BooksData object or fetch it from your data source
//                           BooksData bookData = BooksData(
//                             id: 'your_book_id',
//                             bookName: 'Your Book Name',
//                             // Add other necessary fields
//                           );
//                           payWithKhaltiInApp(bookData); // Pass the BooksData instance
//                         },
//                       ),
//                       // Text(referenceId),
//                     ],
//                   ),
//                   // Circular Progress Indicator (Initially hidden)
//                   // if (isLoading) CircularProgressIndicator(),
//                 ],
//               ),
//             )
//           ],
//         ),
//       ),
//     );
//   }

//   payWithKhaltiInApp(BooksData bookData) {
//     KhaltiScope.of(context).pay(
//       config: PaymentConfig(
//         amount: bookData.newPrice?.toInt() ?? 1000, // Use the newPrice from BooksData as the amount
//         productIdentity: bookData.id ?? '', // Use the id from BooksData as the productIdentity
//         productName: bookData.bookName ?? '', // Use the bookName from BooksData as the productName
//         mobileReadOnly: false,
//       ),
//       preferences: [
//         PaymentPreference.khalti,
//       ],
//       onSuccess: (PaymentSuccessModel success) {
//         // Pass the success and bookData to the new function
//         onPaymentSuccess(success, bookData);
//       },
//       onFailure: onFailure,
//       onCancel: onCancel,
//     );
//   }

//   void onPaymentSuccess(PaymentSuccessModel success, BooksData bookData) {
//     CollectionReference orders = FirebaseFirestore.instance.collection('order');
//     Map<String, dynamic> orderData = {
//       'amount': bookData.newPrice?.toInt() ?? 0, // Use the newPrice from BooksData as the amount
//       'productIdentity': bookData.id ?? '', // Use the id from BooksData as the productIdentity
//       'productName': bookData.bookName ?? '', // Use the bookName from BooksData as the productName
//       'timestamp': FieldValue.serverTimestamp(), // Timestamp of the payment
//       // Add any other payment-related data you want to store
//     };

//     // Add the payment data to Firestore
//     orders
//         .add(orderData)
//         .then((DocumentReference docRef) {
//           setState(() {
//             referenceId = success.idx;
//             isLoading = false; // Hide the circular progress indicator
//           });
//           print('Order data stored with ID: ${docRef.id}');
//         })
//         .catchError((error) {
//           debugPrint('Error storing order data: $error');
//           setState(() {
//             isLoading = false; // Hide the circular progress indicator on error
//           });
//         });

//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text('Payment Successful'),
//           actions: [
//             SimpleDialogOption(
//               child: const Text('OK'),
//               onPressed: () {
//                 Navigator.pop(context);
//               },
//             )
//           ],
//         );
//       },
//     );
//   }

//   void onFailure(PaymentFailureModel failure) {
//     debugPrint(
//       failure.toString(),
//     );
//   }

//   void onCancel() {
//     debugPrint('Cancelled');
//   }

//   _launchPhoneCall(String phoneNumber) async {
//     final url = 'tel:$phoneNumber';
//     if (await canLaunch(url)) {
//       await launch(url);
//     } else {
//       throw 'Could not launch $url';
//     }
//   }
// }

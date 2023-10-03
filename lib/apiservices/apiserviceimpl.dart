import 'package:book_shop/model/BooksData.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/AdminProfileData.dart';
import '../model/orderdata.dart';
import 'apiservice.dart';

class ApiServiceImpl extends ApiService {
  static bool success = false;
  bool notRegistered = false;

  @override
  Future<bool> signupDataToFirebase({
    String? fullname,
    String? address,
    String? gender,
    int? phone,
    String? email,
    String? password,
    String? repassword,
    String? image,
  }) async {
    var data = {
      "fullname": fullname,
      "address": address,
      "gender": gender,
      "phone": phone,
      "repassword": repassword,
      "email": email,
      "password": password,
      "image":image,
    };
    try {
      await FirebaseFirestore.instance
          .collection("Signup")
          .add(data)
          .then((value) {
        success = true;
      });
    } catch (e) {
      success = false;
      print(e);
    }
    return success;
  }

  @override
  Future<bool> checkCredientialforLogin({String? email, String? password}) async {
    try {
      var snapshot = await FirebaseFirestore.instance
          .collection("Signup")
          .where("email", isEqualTo: email)
          .where("password", isEqualTo: password)
          .get();

      return snapshot.docs.isNotEmpty;
    } catch (e) {
      print(e);
      return false;
    }
  }

  @override
  Future<List<BooksData>?> getBooksDetails() async {
    try {
      var response = await FirebaseFirestore.instance.collection('Book').get();
      final user = response.docs;
      List<BooksData> bookList = [];
      if (user.isNotEmpty) {
        for (var booksData in user) {
          bookList.add(BooksData.fromJson(booksData.data()));
        }
      }
      return bookList;
    } catch (e) {
      print(e);
      return null;
    }
  }
  
@override
  Future<List<AdminProfileData>?> getAdminProfileDetails() async {
    try {
      var response = await FirebaseFirestore.instance.collection('Signup').get();
      final user = response.docs;
      List<AdminProfileData> profileList = [];
      if (user.isNotEmpty) {
        for (var profileData in user) {
          profileList.add(AdminProfileData.fromJson(profileData.data()));
        }
      }
      return profileList;
    } catch (e) {
      print(e);
      return null;
    }
  }
  
  @override
  Future<bool> saveBookDataToFirestore({String? category, String? bookName, String? author, double? oldPrice, double? newPrice, String? imageUrl}) async {
    var data = {

      "category":category,
          "bookname":bookName,
          "author":author,
          "oldPrice":oldPrice,
          "newPrice":newPrice,
          "imageUrl":imageUrl,
    };

 await FirebaseFirestore.instance
        .collection("Book")
        .where("bookName", isEqualTo: bookName)
        .get()
        .then((value) async {
      if (value.docs.isNotEmpty) {
        Fluttertoast.showToast(
            msg: "Book already Exist, please enter new one",
            toastLength: Toast.LENGTH_SHORT,
            gravity: ToastGravity.TOP,
            timeInSecForIosWeb: 1,
            backgroundColor:Colors.red,
            textColor: Colors.white,
            fontSize: 16.0);
      } else {
        try {
          await FirebaseFirestore.instance
              .collection("Book")
              .add(data)
              .then((value) {
            success = true;
          });
        } catch (e) {
          success = false;
          print(e);
        }
      }
    });
    return success;
  }
  @override
  Future<bool> saveOrderDataToFirebase({fullName, String? address, int? quantity, int? phone, String? email, String? image, DateTime? fromDate, DateTime? toDate})async {
   var data = {

          "fullName":fullName,
          "address":address,
          "quantity":quantity,
          "phone":phone,
          "email":email,
          "imageFile":image, 
          "fromDate":fromDate, 
          "toDate":toDate,
    };
    try {
      await FirebaseFirestore.instance
          .collection("Order")
          .add(data)
          .then((value) {
        success = true;
      });
    } catch (e) {
      success = false;
      print(e);
    }
    return success;
  }
  
  @override
  Future<List<OrderData>?> getOrderDetails() async{
    try {
      var response = await FirebaseFirestore.instance.collection('Order').get();
      final user = response.docs;
      List<OrderData> orderList = [];
      if (user.isNotEmpty) {
        for (var orderData in user) {
          orderList.add(OrderData.fromJson(orderData.data()));
        }
      }
      return orderList;
    } catch (e) {
      print(e);
      return null;
    }
  }
  
  @override
  Future<bool> changeOtpPw({String? newPassword, String? confirmPassword})async {
    bool success=false;
    try{
      var userId=await getIdForForgotPw();
      var phone= await getPhoneFromSPForOtp();
      var response ={
        "Password":newPassword,
        "Repassword":confirmPassword
      };
      var querySnapshot=await FirebaseFirestore.instance.collection("Signup").where("Phone",isEqualTo: phone).get();
      if(querySnapshot.docs.isNotEmpty){
        var user=querySnapshot.docs.first;
        await FirebaseFirestore.instance.collection('Signup').doc(userId).update(response);
        success=true;
        
      }else{
        Fluttertoast.showToast(msg: "admin doesnt exist for the given number",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.CENTER,
        timeInSecForIosWeb: 1,
        backgroundColor: Colors.red,
        textColor: Colors.white,
        fontSize: 16.0
        );
      }
    }
    catch(e){
      print("Error changing password:$e");
      success=false;
    }
    return success;
  }

  getPhoneFromSPForOtp()async{
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    String? phone=prefs.getString("PhoneOtp") ?? "";
    return phone;
  }

  getIdForForgotPw()async{
    var phone=await getPhoneFromSPForOtp();
    var user;
    if(phone!=null && phone.isNotEmpty){
      var response=await
      FirebaseFirestore.instance.collection('Signup').where("Phone",isEqualTo: phone).get();
      if(response.docs.isNotEmpty){
        user=response.docs.first;
      }
      return user?.id ?? "";
    }
  }





  
  @override
  Future<bool> changePassword({String? newPassword, String? currentPassword, String? confirmPassword}) {
    // TODO: implement changePassword
    throw UnimplementedError();
  }
  
}


import 'package:cloud_firestore/cloud_firestore.dart';

class OrderData {
  String? fullName;
  String? address;
  int? quantity;
  int? phone;
  int? price;
  String? email;
  String? image;
  Timestamp? fromDate;
  Timestamp? toDate;


  OrderData(
      {this.fullName,
      this.address,
      this.quantity,
      this.phone,
      this.email,
      this.price,
      this.image, 
      this.fromDate, 
      this.toDate,});

  OrderData.fromJson(Map<String, dynamic> json) {
    fullName = json['fullName'];
    address = json['address'];
    quantity = json['quantity'];
    phone = json['phone'];
    email = json['email'];
    image=json['image'];
    fromDate=json['fromDate'];
    price=json['price'];
    toDate=json['toDate'];
   
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['fullName'] = this.fullName;
    data['address'] = this.address;
    data['quantity'] = this.quantity;
    data['phone'] = this.phone;
    data['email'] = this.email;
    data['image'] = this.image;
    data['price']=this.price;
    data['fromDate'] = this.fromDate;
    data['toDate'] = this.toDate;

    return data;
  }
}

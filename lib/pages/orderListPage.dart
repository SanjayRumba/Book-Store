import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import '../model/orderdata.dart';

class OrderListPage extends StatelessWidget {
Future<List<OrderData>> fetchOrdersFromFirestore() async {
  List<OrderData> orders = [];

  try {
    QuerySnapshot querySnapshot = await FirebaseFirestore.instance
        .collection('orders') // Replace 'orders' with your Firestore collection name
        .get();

    querySnapshot.docs.forEach((doc) {
      var data = doc.data() as Map<String, dynamic>;
      orders.add(OrderData(
        fullName: data['fullName'], // Replace with the actual field name for full name
        address: data['address'], // Replace with the actual field name for address
        quantity: data['quantity'], // Replace with the actual field name for quantity
        phone: data['phone'], // Replace with the actual field name for phone
        email: data['email'], // Replace with the actual field name for email
        fromDate: data['fromDate'], // Replace with the actual field name for from date
        toDate: data['toDate'], // Replace with the actual field name for to date
      ));
    });
  } catch (e) {
    print('Error fetching orders: $e');
  }

  return orders;
}

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(   
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            height: MediaQuery.of(context).size.height * 0.08,
          ),
          Padding(
            padding: const EdgeInsets.only(left: 25,),
            child: Text("Order List",style: TextStyle(fontSize: 25),),
          ),
          Expanded(
            child: FutureBuilder<List<OrderData>>(
              future: fetchOrdersFromFirestore(),
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.waiting) {
                  return Center(child: CircularProgressIndicator());
                } else if (snapshot.hasError) {
                  return Center(child: Text('Error: ${snapshot.error}'));
                } else {
                  List<OrderData> orderList = snapshot.data!;
                  return ListView.builder(
                    itemCount: orderList.length,
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                        child: OrderCard(orderData: orderList[index]),
                      );
                    },
                  );
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}

class OrderCard extends StatelessWidget {
  final OrderData orderData;

  OrderCard({required this.orderData});

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 4,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Padding(
        padding: const EdgeInsets.all(15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Name: ${orderData.fullName}",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            SizedBox(height: 8),
            Text(
              "Address: ${orderData.address}",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              "Quantity: ${orderData.quantity}",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              "Phone: ${orderData.phone}",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              "Email: ${orderData.email}",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              "From Date: ${_formatDate(orderData.fromDate)}",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
            SizedBox(height: 8),
            Text(
              "To Date: ${_formatDate(orderData.toDate)}",
              style: TextStyle(fontSize: 16, color: Colors.grey),
            ),
          ],
        ),
      ),
    );
  }

  String _formatDate(Timestamp? timestamp) {
    if (timestamp == null) return '';

    // Convert the Timestamp to DateTime and format the date
    DateTime dateTime = timestamp.toDate();
    return '${dateTime.year}-${dateTime.month.toString().padLeft(2, '0')}-${dateTime.day.toString().padLeft(2, '0')}';
  }
}

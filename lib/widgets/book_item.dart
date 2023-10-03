import 'dart:math';
import 'package:book_shop/pages/paymentmethod.dart';
import 'package:book_shop/theme/colors.dart';
import 'package:flutter/material.dart';
import 'avatar_image.dart';
import 'package:book_shop/model/BooksData.dart';

class BookItem extends StatelessWidget {
  BookItem({Key? key, required this.book, required this.onDelete, required this.onEdit})
      : super(key: key);
  final BooksData book;
  final VoidCallback onDelete;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    double _width = 90, _height = 135;
    return Container(
      margin: EdgeInsets.only(bottom: 10),
      padding: EdgeInsets.only(top: 15),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                padding: EdgeInsets.only(bottom: 50, right: 40),
                width: _width,
                height: _height,
                decoration: BoxDecoration(
                  color: primary,
                  borderRadius: BorderRadius.circular(15),
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(1, 1), // changes position of shadow
                    ),
                  ],
                ),
                child: Container(
                  width: _width / 2,
                  height: _height / 2,
                  decoration: BoxDecoration(
                    color: Color(Random().nextInt(0xffffffff)).withAlpha(0xff),
                    borderRadius: BorderRadius.only(topLeft: Radius.circular(15)),
                  ),
                ),
              ),
              Container(
                width: _width,
                height: _height,
                padding: EdgeInsets.all(8),
                child: AvatarImage(
                  book.imageUrl ?? "",
                  isSVG: false,
                  radius: 8,
                ),
              )
            ],
          ),
          SizedBox(width: 18),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  book.bookName ?? "",
                  style: TextStyle(fontSize: 17, fontWeight: FontWeight.w600),
                ),
                SizedBox(height: 8),
                Text(
                  book.author ?? "",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 8),
                Text(
                  book.category ?? "",
                  style: TextStyle(fontSize: 14, color: Colors.grey),
                ),
                SizedBox(height: 8),
                RichText(
                  text: TextSpan(
                    children: [
                      TextSpan(
                        text: "\$${book.newPrice?.toStringAsFixed(2) ?? ''}",
                        style: TextStyle(
                          fontSize: 14,
                          color: primary,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                      if (book.oldPrice != null && book.oldPrice! > book.newPrice!)
                        TextSpan(
                          text: "   \$${book.oldPrice?.toStringAsFixed(2) ?? ''}",
                          style: TextStyle(
                            color: Colors.grey,
                            fontSize: 14,
                            decoration: TextDecoration.lineThrough,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                
                Row(
                  children: [
                //     ElevatedButton(
                //   onPressed: () {
                //     showDialog(
                //       context: context,
                //       builder: (context) => AlertDialog(
                //         title: Text('Buy Now'),
                //         content: Text('Do you wanna buy ${book.bookName}.'),
                //         actions: [
                //           TextButton(
                //             onPressed: () => Navigator.pop(context),
                //             child: Text('Cancel'),
                //           ),
                //           TextButton(
                //             onPressed: () {
                //               Navigator.push(
                //                 context,
                //                 MaterialPageRoute(builder: (context) => PaymentMethod()),
                //               );
                //             },
                //             child: Text('Confirm'),
                //           ),
                //         ],
                //       ),
                //     );
                //   },
                //   style: ElevatedButton.styleFrom(
                //     primary: primary,
                //   ),
                //   child: Text(
                //     'Buy Now',
                //     style: TextStyle(color: Colors.white),
                //   ),
                // ),
                SizedBox(
                  width: 10,
                ),
                    ElevatedButton(
                      onPressed: onEdit, // Call the onEdit callback when the Edit button is pressed
                      style: ElevatedButton.styleFrom(
                        primary: primary,
                      ),
                      child: Text(
                        'Edit',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                    SizedBox(width: 8),
                    ElevatedButton(
                      onPressed: onDelete, // Call the onDelete callback when the Delete button is pressed
                      style: ElevatedButton.styleFrom(
                        primary: Colors.red,
                      ),
                      child: Text(
                        'Delete',
                        style: TextStyle(color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

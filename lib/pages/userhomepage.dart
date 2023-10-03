import 'dart:math';
import 'package:book_shop/pages/orderpagekhalti.dart';
import 'package:book_shop/pages/paymentmethod.dart';
import 'package:book_shop/pages/search.dart';
import 'package:book_shop/theme/colors.dart';
import 'package:book_shop/widgets/avatar_image.dart';
import 'package:flutter/material.dart';
import 'package:book_shop/model/BooksData.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';
import 'package:badges/badges.dart';

class BookItem extends StatelessWidget {
  BookItem({Key? key, required this.book}) : super(key: key);
  final BooksData book;

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
                      offset: Offset(1, 1),
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
                ElevatedButton(
                  onPressed: () async {
                    showDialog(
                      context: context,
                      barrierDismissible: false,
                      builder: (BuildContext context) {
                        bool isProcessing = false;

                        return StatefulBuilder(
                          builder: (BuildContext context, setState) {
                            return AlertDialog(
                              content: isProcessing
                                  ? Row(
                                      children: [
                                        CircularProgressIndicator(),
                                        SizedBox(width: 16),
                                        Text('Processing...'),
                                      ],
                                    )
                                  : Text('Do you want to buy ${book.bookName}.',style: TextStyle(fontWeight: FontWeight.bold),),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Cancel'),
                                ),
                                ElevatedButton(
                                  onPressed: isProcessing
                                      ? null
                                      : () async {
                                          setState(() {
                                            isProcessing = true;
                                          });

                                          // Simulate a 2-second delay or perform your actual processing here
                                          await Future.delayed(Duration(seconds: 2));

                                          setState(() {
                                            isProcessing = false;
                                          });

                                          // Close the dialog
                                          Navigator.pop(context);

                                          // Navigate to the OrderPageEsewa or perform other actions here
                                          Navigator.push(
                                            context,
                                            MaterialPageRoute(
                                              builder: (context) => OrderPageEsewa(
                                                Book: book.bookName,
                                                price: book.newPrice,
                                              ),
                                            ),
                                          );
                                        },
                                        style: ElevatedButton.styleFrom(
                                          primary: Colors.white,
                                          onPrimary: Colors.blue
                                        ),
                                  child: Text('Confirm'),
                                ),
                              
                              ],
                            );
                          },
                        );
                      },
                    );
                  },
                  style: ElevatedButton.styleFrom(
                    primary: primary,
                  ),
                  child: Text(
                    'Buy Now',
                    style: TextStyle(color: Colors.white),
                  ),
                ),

              ],
            ),
          ),
        ],
      ),
    );
  }
}

class UserHomepage extends StatefulWidget {
  const UserHomepage({Key? key}) : super(key: key);

  @override
  State<UserHomepage> createState() => _UserHomepageState();
}

class _UserHomepageState extends State<UserHomepage> with TickerProviderStateMixin {
  int activeIndex = 0;
  final imageList = [
    "assets/images/pic1.jpg",
    "assets/images/pic2.jpg",
    "assets/images/pic3.jpg",
  ];
  String searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Container(
            height: 400,
            width: MediaQuery.of(context).size.width,
            color: Colors.cyan[600],
            child: Row(
              children: [
                Padding(
                  padding: const EdgeInsets.only(left: 20, top: 100),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Hello There!",
                        style: TextStyle(color: Colors.white60, fontSize: 30),
                      ),
                      Text(
                        "User",
                        style: TextStyle(color: Colors.white60, fontSize: 30),
                      ),
                    ],
                  ),
                ),
                Spacer(),
                Padding(
                  padding: const EdgeInsets.only(bottom: 170, right: 20),
                  child: CircleAvatar(
                    radius: 40,
                    backgroundImage: AssetImage("assets/images/profile.png"),
                  ),
                )
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 200),
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(20),
                  topRight: Radius.circular(20),
                ),
                color: Colors.white,
              ),
              height: double.infinity,
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(
                        top: 18.0, left: 10, right: 10,),
                    child: SizedBox(
                      height: 55,
                      child: TextFormField(
                        onTap: () {
                          FocusScope.of(context).requestFocus(FocusNode());
                          Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) => SearchBooks()));
                        },
                        decoration: InputDecoration(
                          suffixIcon: const Icon(Icons.search),
                          hintText: 'Search your services',
                          hintStyle: const TextStyle(
                            fontSize: 15,
                            letterSpacing: 1,
                          ),
                          border: OutlineInputBorder(
                            borderSide: const BorderSide(
                                width: 0.5,
                                color: Color.fromARGB(255, 154, 159, 156)),
                            borderRadius: BorderRadius.circular(10.0),
                          ),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: 10,),
                  Padding(
                    padding: const EdgeInsets.only(left: 8.0, right: 8),
                    child: Column(
                      children: [
                        CarouselSlider.builder(
                          options: CarouselOptions(
                            height: 200,
                            viewportFraction: 1,
                            autoPlay: true,
                            autoPlayInterval: const Duration(seconds: 3),
                            onPageChanged: (index, reason) =>
                                setState(() => activeIndex = index),
                          ),
                          itemCount: imageList.length,
                          itemBuilder: (context, index, realIndex) {
                            final imageLists = imageList[index];
                            return buildImage(imageLists, index);
                          },
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        buildIndicator(),
                      ],
                    ),
                  ),
                  const Padding(
                    padding: EdgeInsets.only(left: 20),
                    child: Text(
                      "OUR BOOKS",
                      style: TextStyle(
                        fontSize: 16,
                        color: Color.fromARGB(255, 23, 22, 22),
                        letterSpacing: 1,
                      ),
                    ),
                  ),
                  Expanded(
                    child: SingleChildScrollView(
                      child: _buildBookList("Book"),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget buildImage(String imageLists, int index) => Container(
        height: 400,
        width: MediaQuery.of(context).size.width,
        margin: const EdgeInsets.symmetric(horizontal: 12),
        child: Image.asset(imageLists, fit: BoxFit.cover),
      );

  Widget buildIndicator() => AnimatedSmoothIndicator(
        activeIndex: activeIndex,
        count: imageList.length,
        effect: JumpingDotEffect(dotWidth: 8, dotHeight: 8, spacing: 20, activeDotColor: primary!),
      );

  Widget _buildBookList(String collectionName) {
    return StreamBuilder<QuerySnapshot>(
      stream: FirebaseFirestore.instance.collection(collectionName).snapshots(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return Center(
            child: Text('Error: ${snapshot.error}'),
          );
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return Center(
            child: CircularProgressIndicator(),
          );
        }

        List<BooksData> books = snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          return BooksData.fromJson(data);
        }).toList();

        List<BooksData> filteredBooks = books.where((book) {
          return book.bookName?.toLowerCase().contains(searchQuery.toLowerCase()) ?? false;
        }).toList();

        return ListView.builder(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: filteredBooks.length,
          itemBuilder: (context, index) {
            final bookData = filteredBooks[index];
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: BookItem(book: bookData),
            );
          },
        );
      },
    );
  }
}

class CustomBookContainer extends StatelessWidget {
  final BooksData bookData;

  const CustomBookContainer({required this.bookData});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Container(
        height: 120,
        child: Row(
          children: [
            Image.network(
              bookData.imageUrl ?? "",
              fit: BoxFit.cover,
              width: 90,
              height: double.infinity,
            ),
            SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(bookData.bookName ?? "", style: TextStyle(fontWeight: FontWeight.bold)),
                  Text("Author: ${bookData.author ?? ""}"),
                  Text("Category: ${bookData.category ?? ""}"),
                  Text(
                    "\$${bookData.newPrice ?? ""}",
                    style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                  ),
                  if (bookData.oldPrice != null && bookData.oldPrice! > 0)
                    Text(
                      "\$${bookData.oldPrice}",
                      style: TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

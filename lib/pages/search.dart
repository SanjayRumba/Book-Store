import 'package:book_shop/pages/orderpagekhalti.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_shop/pages/paymentmethod.dart';

class BookCard extends StatelessWidget {
  final Map<String, dynamic> bookData;

  BookCard({required this.bookData});

  @override
  Widget build(BuildContext context) {
    final String author = bookData['author'] ?? 'N/A';
    final String bookName = bookData['bookname'] ?? 'N/A';
    final String category = bookData['category'] ?? 'N/A';
    final String imageUrl = bookData['imageUrl'] ?? 'N/A';
    final String newPrice = bookData['newPrice'].toStringAsFixed(2) ?? 'N/A';
    final String oldPrice = bookData['oldPrice'].toStringAsFixed(2) ?? 'N/A';

    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Card(
        child: Container(
          height: 150,
          child: Row(
            children: [
              Image.network(
                imageUrl ?? "",
                fit: BoxFit.cover,
                width: 90,
                height: double.infinity,
              ),
              SizedBox(width: 8),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(bottom: 1),
                        child: Text(bookName ?? "", style: TextStyle(fontWeight: FontWeight.bold)),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top:2 ),
                        child: Text("Author: $author"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text("Category: $category"),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 2),
                        child: Text(
                          "\$$newPrice",
                          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16),
                        ),
                      ),
                      if (double.tryParse(oldPrice) != null && double.tryParse(oldPrice)! > 0)
                        Padding(
                          padding: const EdgeInsets.only(top: 2),
                          child: Text(
                            "\$$oldPrice",
                            style: TextStyle(color: Colors.grey, decoration: TextDecoration.lineThrough),
                          ),
                        ),
                      Padding(
                        padding: const EdgeInsets.only(top: 5),
                        child: ElevatedButton(
                          onPressed: () {
                            // Show an alert dialog when Buy Now is clicked
                            _showBuyNowAlert(context, bookName);
                          },
                          child: Text("Buy Now"),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showBuyNowAlert(BuildContext context, String bookName) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Buy $bookName'),
          content: Text('Do you want to buy $bookName?'),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Buy'),
              onPressed: () {
                // Add your logic to handle the purchase here
                // You can call a function to initiate the purchase process.
                // For example, you might open a payment gateway.
                Navigator.of(context).pop(); // Close the alert dialog
                // Navigate to the payment method page
                Navigator.push(context, MaterialPageRoute(builder: (context) => OrderPageEsewa()));
              },
            ),
          ],
        );
      },
    );
  }
}

class SearchBooks extends StatefulWidget {
  const SearchBooks({Key? key}) : super(key: key);

  @override
  State<SearchBooks> createState() => _SearchBooksState();
}

class _SearchBooksState extends State<SearchBooks> {
  final FirebaseFirestore _firestore = FirebaseFirestore.instance;
  TextEditingController _searchController = TextEditingController();
  List<Map<String, dynamic>> _searchResults = [];

  void _performSearch(String searchText) async {
    if (searchText.isEmpty) {
      setState(() {
        _searchResults.clear();
      });
      return;
    }

    // Search for books
    QuerySnapshot<Map<String, dynamic>> booksQuerySnapshot = await _firestore
        .collection('Book')
        .where('bookname', isGreaterThanOrEqualTo: searchText)
        .where('bookname', isLessThan: searchText + 'z')
        .get();

    List<Map<String, dynamic>> combinedResults = [];
    combinedResults.addAll(booksQuerySnapshot.docs.map((doc) => doc.data() as Map<String, dynamic>).toList());

    setState(() {
      _searchResults = combinedResults;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Search Books',
          style: TextStyle(color: Colors.black),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios),
        ),
        iconTheme: const IconThemeData(color: Colors.black),
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(
              top: 18.0,
              left: 10,
              right: 10,
            ),
            child: SizedBox(
              height: 55,
              child: TextFormField(
                controller: _searchController,
                onChanged: (value) => _performSearch(value),
                decoration: InputDecoration(
                  suffixIcon: const Icon(Icons.search),
                  hintText: 'Search books',
                  hintStyle: const TextStyle(
                    fontSize: 15,
                    letterSpacing: 1,
                  ),
                  border: OutlineInputBorder(
                    borderSide: const BorderSide(
                      width: 0.5,
                      color: Color.fromARGB(255, 154, 159, 156),
                    ),
                    borderRadius: BorderRadius.circular(10.0),
                  ),
                ),
              ),
            ),
          ),
          Expanded(
            child: NotificationListener<ScrollNotification>(
              onNotification: (notification) {
                if (notification is OverscrollNotification) {
                  if (notification.overscroll > 0) {
                    // Scrolling down, clear the search text
                    _searchController.clear();
                  }
                }
                return false;
              },
              child: ListView.builder(
                itemCount: _searchResults.length,
                itemBuilder: (context, index) {
                  final searchData = _searchResults[index];
                  return BookCard(bookData: searchData);
                },
              ),
            ),
          ),
        ],
      ),
    );
  }
}

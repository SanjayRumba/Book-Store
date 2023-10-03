import 'package:book_shop/pages/EditBookScreen.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_shop/widgets/book_item.dart';
import 'package:badges/badges.dart';
import 'package:book_shop/theme/colors.dart';
import 'package:book_shop/model/BooksData.dart';
import 'package:fluttertoast/fluttertoast.dart';

class BookPage extends StatefulWidget {
  @override
  _BookPageState createState() => _BookPageState();
}

class _BookPageState extends State<BookPage> {
  String _searchQuery = "";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: appBgColor,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: Container(
                alignment: Alignment.centerLeft,
                child: Icon(Icons.vertical_distribute_rounded, color: primary),
              ),
            ),
            IconButton(
              icon: Icon(Icons.search_rounded, color: primary),
              onPressed: _showSearch,
            ),
            SizedBox(width: 15),
            BadgePositioned(
              position: BadgePosition.topEnd(top: -10, end: -10),
              child: Icon(Icons.shopping_bag_rounded, color: primary),
            ),
          ],
        ),
      ),
      body: Column(
        children: [
          Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 20, top: 10),
                child: Row(
                  children: [
                    Text("Latest Books", style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                ),
              ),
              Container(
                margin: EdgeInsets.only(left: 15, right: 15, top: 10, bottom: 10),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade200,
                  boxShadow: [
                    BoxShadow(
                      color: shadowColor.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 1,
                      offset: Offset(1, 1), // changes position of shadow
                    ),
                  ],
                ),
              ),
            ],
          ),
          Expanded(
            child: _buildBookList("Book"), // Fetch 'New Books' from Firestore
          ),
        ],
      ),
    );
  }

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

        // Add a null check for snapshot.data
        if (snapshot.data == null) {
          return Center(
            child: Text('No data available.'),
          );
        }

        List<BooksData> books = snapshot.data!.docs.map((DocumentSnapshot document) {
          Map<String, dynamic> data = document.data() as Map<String, dynamic>;
          data['id'] = document.id; // Assign document ID to 'id' field in BooksData
          return BooksData.fromJson(data);
        }).toList();

        // Filter books based on the search query
        List<BooksData> filteredBooks = books.where((book) {
          return (book.bookName != null && book.bookName!.toLowerCase().contains(_searchQuery.toLowerCase()));
        }).toList();

        return ListView.builder(
          itemCount: filteredBooks.length,
          itemBuilder: (context, index) {
            return BookItem(
              book: filteredBooks[index],
              onDelete: () {
                _deleteBook(filteredBooks[index].id!); // Delete book by ID
              },
               onEdit: () {  
                 _editBook(filteredBooks[index]);
               },
            );
          },
        );
      },
    );
  }

void _deleteBook(String bookId) async {
  // Show an alert dialog to confirm the deletion
  showDialog(
    context: context,
    builder: (context) => AlertDialog(
      title: Text('Delete Book'),
      content: Text('Are you sure you want to delete this book?'),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: Text('Cancel'),
        ),
        TextButton(
          onPressed: () async {
            try {
              await FirebaseFirestore.instance.collection('Book').doc(bookId).delete();
              Navigator.pop(context); // Close the dialog
              Fluttertoast.showToast(
                msg: 'Book deleted successfully',
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                backgroundColor: Colors.green,
                textColor: Colors.white,
              );
            } catch (e) {
              print('Error deleting book: $e');
            }
          },
          child: Text('Delete'),
        ),
      ],
    ),
  );
}


  void _showSearch() {
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: Text('Search Books'),
          content: TextFormField(
            onChanged: (value) {
              setState(() {
                _searchQuery = value;
              });
            },
            decoration: InputDecoration(
              hintText: 'Search your Books',
              hintStyle: const TextStyle(
                fontSize: 15,
                color: Color.fromARGB(255, 23, 22, 22),
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
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: Text('Search'),
            ),
          ],
        );
      },
    );
  }
    void _editBook(BooksData book) {
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => EditBookPage(book: book)),
    );
  }
}

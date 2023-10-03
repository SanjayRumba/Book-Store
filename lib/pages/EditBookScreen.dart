import 'dart:io';
import 'package:book_shop/pages/custombtn.dart';
import 'package:book_shop/pages/customform.dart';
import 'package:flutter/material.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:book_shop/model/BooksData.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';

class EditBookPage extends StatefulWidget {
  final BooksData book;

  EditBookPage({required this.book});

  @override
  _EditBookPageState createState() => _EditBookPageState();
}

class _EditBookPageState extends State<EditBookPage> {
  TextEditingController _bookNameController = TextEditingController();
  TextEditingController _authorController = TextEditingController();
  TextEditingController _categoryController = TextEditingController();
  TextEditingController _oldPriceController = TextEditingController();
  TextEditingController _newPriceController = TextEditingController();
  late String imagePath;
  File? newImageFile;

  @override
  void initState() {
    super.initState();
    imagePath = widget.book.imageUrl ?? "";
    _bookNameController.text = widget.book.bookName ?? '';
    _authorController.text = widget.book.author ?? '';
    _categoryController.text = widget.book.category ?? '';
    _oldPriceController.text = widget.book.oldPrice?.toString() ?? '';
    _newPriceController.text = widget.book.newPrice?.toString() ?? '';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(height: MediaQuery.of(context).size.height * 0.05),
            Text(
              'Edit Book',
              style: TextStyle(fontSize: 24,),
            ),
            Center(
              child: InkWell(
                onTap: () {
                  pickImage();
                },
                child: imagePath.isEmpty
                    ? Image.asset("assets/images/profile.png", height: 100, width: 100)
                    : CircleAvatar(
                  radius: 50,
                  backgroundImage: NetworkImage(imagePath),
                ),
              ),
            ),
            SizedBox(height: 20),
            CustomForm(
              hintText: "Book Name",
              prefixIcon: const Icon(Icons.book_outlined),
              initialValue: widget.book.bookName,
              onChanged: (value) {
                _bookNameController.text = value;
              },
            ),
            CustomForm(
              hintText: "Author",
              prefixIcon: const Icon(Icons.person),
              initialValue: widget.book.author,
              onChanged: (value) {
                _authorController.text = value;
              },
            ),
            CustomForm(
              prefixIcon: Icon(Icons.people_outlined),
              hintText: "Category",
              initialValue: widget.book.category,
              onChanged: (value) {
                _categoryController.text = value;
              },
            ),
            CustomForm(
              prefixIcon: const Icon(Icons.price_change),
              keyboardType: TextInputType.number,
              hintText: "Old Price",
              initialValue: widget.book.oldPrice?.toString(),
              onChanged: (value) {
                _oldPriceController.text = value;
              },
            ),
            CustomForm(
              prefixIcon: const Icon(Icons.price_change),
              keyboardType: TextInputType.number,
              hintText: "New Price",
              initialValue: widget.book.newPrice?.toString(),
              onChanged: (value) {
                _newPriceController.text = value;
              },
            ),
            SizedBox(height: 16),
            CustomButton(
              text: "Update",
              onPressed: _updateBook,
            )
            // ElevatedButton(
            //   onPressed: _updateBook,
            //   child: Text('Update Book'),
            // ),
          ],
        ),
      ),
    );
  }

  void _updateBook() async {
    String bookId = widget.book.id!; // Assuming your BooksData class has a field named 'id'

    try {
      double? oldPrice = double.tryParse(_oldPriceController.text);
      double? newPrice = double.tryParse(_newPriceController.text);

      if (bookId != null) {
        if (newImageFile != null) {
          String imageUrl = await _uploadImageToStorage(newImageFile!);
          await FirebaseFirestore.instance.collection('Book').doc(bookId).update({
            'bookname': _bookNameController.text,
            'author': _authorController.text,
            'category': _categoryController.text,
            'oldPrice': oldPrice,
            'newPrice': newPrice,
            'imageUrl': imageUrl,
          });
        } else {
          await FirebaseFirestore.instance.collection('Book').doc(bookId).update({
            'bookname': _bookNameController.text,
            'author': _authorController.text,
            'category': _categoryController.text,
            'oldPrice': oldPrice,
            'newPrice': newPrice,
          });
        }

        // Show a toast message to indicate that the book was updated successfully
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Book updated successfully')),
        );

        // Close the Edit Book page after updating the book
        Navigator.pop(context);
      }
    } catch (e) {
      print('Error updating book: $e');
    }
  }

  Future<String> _uploadImageToStorage(File imageFile) async {
    String fileName = DateTime.now().millisecondsSinceEpoch.toString();
    Reference storageRef = FirebaseStorage.instance.ref().child('images/$fileName');
    UploadTask uploadTask = storageRef.putFile(imageFile);
    TaskSnapshot storageSnapshot = await uploadTask.whenComplete(() {});
    String downloadUrl = await storageSnapshot.ref.getDownloadURL();
    return downloadUrl;
  }

  void pickImage() async {
    final image = await ImagePicker().pickImage(source: ImageSource.gallery);

    if (image == null) return;

    setState(() {
      newImageFile = File(image.path);
    });
  }
}

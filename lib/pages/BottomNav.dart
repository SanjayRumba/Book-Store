import 'package:book_shop/model/BooksData.dart';
import 'package:book_shop/pages/AdminProfile.dart';
import 'package:book_shop/pages/orderListPage.dart';
import 'package:book_shop/pages/book_page.dart';
import 'package:book_shop/pages/home_page.dart';
import 'package:book_shop/pages/settings.dart';
import 'package:flutter/material.dart';

class BottomNav extends StatefulWidget {
  const BottomNav({Key? key}) : super(key: key);

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  @override
  int selectedTab = 0;
  List<Widget> pages = [
    Homepage(),
    BookPage(),
    OrderListPage(),
    AdminProfilePage(),
    Settings(),
  ];

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
        child: Scaffold(
          body: pages[selectedTab],
          bottomNavigationBar: BottomNavigationBar(
              type: BottomNavigationBarType.fixed,
              currentIndex: selectedTab,
              selectedItemColor: Colors.cyan[600],
              unselectedItemColor: const Color(0xffa9a9a9),
              onTap: (index) {
                setState(() {
                  selectedTab = index;
                });
              },
              items: const [
                BottomNavigationBarItem(icon: Icon(Icons.home), label: "Home"),
                 BottomNavigationBarItem(
                    icon: Icon(Icons.book_outlined), label: "Books"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.production_quantity_limits), label: "Orders"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.person), label: "Profile"),
                BottomNavigationBarItem(
                    icon: Icon(Icons.settings), label: "Setting")
              ]),
        ),
        onWillPop: () => _onBackButtonPressed(context));
  }

  Future<bool> _onBackButtonPressed(BuildContext context) async {
    bool? exitApp = await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          content: Text(
            "Do you want to exit",
            style: TextStyle( fontSize: 16),
          ),
          actions: [
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(false);
                },
                child: Text(
                  "No",
                  style: TextStyle( fontSize: 16),
                )),
            TextButton(
                onPressed: () {
                  Navigator.of(context).pop(true);
                },
                child: Text(
                  "Yes",
                  style: TextStyle( fontSize: 16),
                )),
          ],
        );
      },
    );
    return exitApp ?? false;
  }
}

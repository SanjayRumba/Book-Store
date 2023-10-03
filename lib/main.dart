import 'package:book_shop/apiservices/apibloc.dart';
import 'package:book_shop/firebase_options.dart';
import 'package:book_shop/pages/Splashscrren.dart';
import 'package:book_shop/pages/addbook.dart';
import 'package:book_shop/pages/book_page.dart';
import 'package:book_shop/pages/bottonnavforuser.dart';
import 'package:book_shop/pages/home_page.dart';
import 'package:book_shop/pages/khaltihomepage.dart';
import 'package:book_shop/pages/orderListPage.dart';
import 'package:book_shop/pages/orderpagekhalti.dart';
import 'package:book_shop/pages/paymentmethod.dart';
import 'package:book_shop/pages/signup.dart';
import 'package:book_shop/pages/userhomepage.dart';
import 'package:book_shop/theme/colors.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:khalti_flutter/khalti_flutter.dart';

import 'pages/BottomNav.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ApiBloc(),
      child: KhaltiScope(
        publicKey: "test_public_key_af80070fce3b4c0884b5e6f443654816",
        enabledDebugging: true,
        builder: (context, navKey) {
          return MaterialApp(
            debugShowCheckedModeBanner: false,
            theme: ThemeData(
              appBarTheme: AppBarTheme(color: Color(0xFF56328c)),
              primarySwatch: Colors.blue,
            ),
            home: SplashScreen(),
            navigatorKey: navKey,
            localizationsDelegates: const [KhaltiLocalizations.delegate],
          );
        },
      ),
    );
  }
}

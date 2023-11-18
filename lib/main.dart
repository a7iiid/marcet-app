import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:raed/viwe/bottomNavigetor.dart';
import 'category/addproduct.dart';
import 'firebase_options.dart';
import '/viwe/home.dart';
import '/viwe/sign%20up.dart';
import 'viwe/login_page.dart';
import 'category/addcategory.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );
  //await FirebaseAuth.instance.useAuthEmulator('localhost', 9099);

  runApp(MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  void initState() {
    FirebaseAuth.instance.authStateChanges().listen((User? user) {
      if (user == null) {
        print('User is currently signed out!');
      } else {
        print('User is signed in!');
      }
    });
    // TODO: implement initState
    super.initState();
  }

  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: FirebaseAuth.instance.currentUser == null
          ? log_in()
          : bottomNavigetor(),
      theme: ThemeData(
          appBarTheme: AppBarTheme(color: Colors.indigo),
          floatingActionButtonTheme:
              FloatingActionButtonThemeData(backgroundColor: Colors.indigo),
          bottomNavigationBarTheme:
              BottomNavigationBarThemeData(backgroundColor: Colors.indigo)),
      routes: {
        '/home': (context) => home(),
        '/sign up': (context) => signup(),
        '/bottomNavigetor': (context) => bottomNavigetor(),
        '/log in': (context) => log_in(),
        '/addcetgory': (context) => addcategory(),
        //'/addproduct':(context) => addproduct(),
      },
    );
  }
}

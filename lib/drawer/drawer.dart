import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

class Mydrawer extends StatefulWidget {
  const Mydrawer({Key? key}) : super(key: key);

  @override
  State<Mydrawer> createState() => _MydrawerState();
}

class _MydrawerState extends State<Mydrawer> {
  @override
  Widget build(BuildContext context) {
    return Drawer(
      child: Column(children: [
        Stack(
          children: [
            Container(
              padding: EdgeInsetsDirectional.only(top: 10),
              width: double.infinity,
              height: 200,
              decoration: BoxDecoration(
                  image: DecorationImage(image: AssetImage('assiste/logo.png')),
                  color: Colors.blue),
              child: Container(
                alignment: Alignment.bottomLeft,
              ),
            ),
          ],
        ),
        SizedBox(
          height: 10,
        ),
        Card(
          child: ListTile(
            title: FirebaseAuth.instance.currentUser != null
                ? Text('Sign out')
                : Text('Log In'),
            onTap: () async {
              {
                FirebaseAuth.instance.currentUser != null
                    ? await FirebaseAuth.instance.signOut()
                    : null;
                Navigator.pushNamedAndRemoveUntil(
                    context, '/log in', (route) => false);
              }
            },
          ),
        ),
        Expanded(
            child: Column(
          mainAxisAlignment: MainAxisAlignment.end,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Text('''
            Palestine - Jenin - Qabatiya
            +970-599-076-528
            
            ''',textAlign:TextAlign.center,style: TextStyle(fontWeight: FontWeight.w500,fontSize: 15), ),
            SizedBox(
              height: 10,
            ),
          ],
        ))
      ]),
    );
  }
}

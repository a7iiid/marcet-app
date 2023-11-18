import 'package:flutter/material.dart';

import '../drawer/drawer.dart';

class setting extends StatefulWidget {
  const setting({Key? key}) : super(key: key);

  @override
  State<setting> createState() => _settingState();
}

class _settingState extends State<setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          actions: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Icon(Icons.person),
            )
          ],
          title: Text('Setting'),
        ),
        drawer: Mydrawer(),
       body: Column(
          children: [
            Container(
              color: Colors.blue,
              height: 200,
              child: Center(
                child: CircleAvatar(
                  radius: 60,
                 // backgroundImage: NetworkImage(user.profileImage),
                ),
              ),
            ),
            SizedBox(height: 20),
            Text(
              'user.name',
              style: TextStyle(
                fontSize: 24,
                fontWeight: FontWeight.bold,
              ),
            ),
            SizedBox(height: 10),
            Text(
              'user.email',
              style: TextStyle(
                fontSize: 18,
                color: Colors.grey,
              ),
            ),
            SizedBox(height: 20),
            ElevatedButton(
              onPressed: () {
                // Add action when the user clicks a button, e.g., to edit the profile.
              },
              child: Text('Edit Profile'),
            ),
          ],
        ));
  }
}

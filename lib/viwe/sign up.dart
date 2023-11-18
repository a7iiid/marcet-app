import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import '/widget.dart';

class signup extends StatefulWidget {
  const signup({Key? key}) : super(key: key);

  @override
  State<signup> createState() => _signupState();
}

class _signupState extends State<signup> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  TextEditingController repassword = TextEditingController();
  var key = GlobalKey<FormState>();
  TextEditingController name = TextEditingController();
  TextEditingController phone = TextEditingController();


  addUser() async {
    DocumentReference users = FirebaseFirestore.instance.collection('users').doc(email.text);
    // Call the user's CollectionReference to add a new user
    await users
        .set({
          'full_name': name.text, // John Doe
          'email': email.text, // Stokes and Sons
          'phone': phone.text ,
         'password': password.text,
          'admin':0


        })
        .then((value) => print("User Added"))
        .catchError((error) => print("Failed to add user: $error"));
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("sign up"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pushNamed(context, '/log in');
          },
        ),
        backgroundColor: Colors.cyan,
        elevation: 20,
        primary: true,
      ),
      body: Form(
        key: key,
        child: ListView(
          children: [
            const SizedBox(
              height: 20,
            ),
            Column(
              children: [
                Container(
                  width: 120,
                  height: 120,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(70),
                      color: Colors.grey,
                      image: const DecorationImage(
                          image: NetworkImage(
                              'https://cdn.pixabay.com/photo/2016/12/27/13/10/logo-1933884_640.png'))),
                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Column(
                children: [
                  TextFormField(
                      decoration: InputDecoration(
                        label: Text('Name'),
                        hintText: 'Full Name',
                        icon: const Icon(Icons.person),
                      ),
                      controller: name,
                      obscureText: false,
                      validator: (val) {
                        if (val!.isEmpty || val == null)
                          return 'Enter Name';
                        else
                          return null;
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                      label: Text('Phone'),
                      hintText: '05********',
                      icon: const Icon(Icons.phone_android_outlined),
                    ),
                    keyboardType: TextInputType.phone,
                    controller: phone,
                    validator: (val) {
                      if (val!.length != 10) return 'Enter Phone Number ';
                    },
                    obscureText: false,
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                      decoration: InputDecoration(
                        label: Text('Email'),
                        hintText: 'you@Eample.com',
                        icon: const Icon(Icons.email),
                      ),
                      controller: email,
                      obscureText: false,
                      keyboardType: TextInputType.emailAddress,
                      validator: (val) {

                        if (val == null || val!.isEmpty){
                          RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+.[a-zA-Z]")
                              .hasMatch(email.text);
                          return 'enter Email';}

                        return null;
                      }),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(decoration: InputDecoration(
                    label:Text( 'Password'),
                    hintText: '*****',
                    icon: const Icon(Icons.lock),

                  ),

                    controller: password,
                    obscureText: true,

                    keyboardType: TextInputType.visiblePassword,
                    validator: (val) {
                      if (val!.length < 8 || val!.isEmpty)
                        return "The password is weak";
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextFormField(
                    decoration: InputDecoration(
                    label: Text('Password'),
                    hintText: '*****',
                    icon: const Icon(Icons.lock),
                  ),

                    controller: repassword,
                    obscureText: true,

                   keyboardType: TextInputType.visiblePassword,
                    validator: (val) {
                      if (val!.length < 8)
                        return 'The password is weak';
                      else if (val!.isEmpty)
                        return 'Enter password';
                      else if (password.text != val)
                        return 'Not symmetrical';
                      return null;
                    },
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  Container(
                    width: 200,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(100))),
                    child: ElevatedButton(
                        onPressed: () async {
                          if (key.currentState!.validate()) {
                            try {
                              await addUser();
                              final credential = await FirebaseAuth.instance
                                  .createUserWithEmailAndPassword(
                                email: email.text,
                                password: password.text,
                              );
                              credential.user!.sendEmailVerification();

                              //Navigator.pushNamed(context, '/log_in');
                             await AwesomeDialog(
                                      context: context,
                                      dialogType: DialogType.success,
                                      autoHide: Duration(seconds: 2),
                                      title: 'success')
                                  .show();
                              await FirebaseAuth.instance.signOut();
                              Navigator.of(context).pushReplacementNamed('/log in');

                            }
                            on FirebaseAuthException catch (e) {
                              if (e.code == 'weak-password') {
                                AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.warning,
                                    autoHide: Duration(seconds: 2),
                                    title: 'Password',
                                    desc: 'The password provided is too weak.')
                                    .show();

                              } else if (e.code == 'email-already-in-use') {
                                AwesomeDialog(
                                    context: context,
                                    dialogType: DialogType.warning,
                                    autoHide: Duration(seconds: 2),
                                    title: 'Email',
                                desc: 'The email address is already in use by another account.')
                                    .show();
                              }
                            }
                          }
                        },
                        child: const Text('SIGN UP')),
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

import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'home.dart';

class log_in extends StatefulWidget {
  const log_in({Key? key}) : super(key: key);

  @override
  State<log_in> createState() => _log_inState();
}

class _log_inState extends State<log_in> {
  TextEditingController email = TextEditingController();
  TextEditingController password = TextEditingController();
  var key = GlobalKey<FormState>();
  Future signInWithGoogle() async {
    // Trigger the authentication flow
    final GoogleSignInAccount? googleUser = await GoogleSignIn().signIn();
    if(googleUser==null)
      return ;

    // Obtain the auth details from the request
    final GoogleSignInAuthentication? googleAuth = await googleUser?.authentication;

    // Create a new credential
    final credential = GoogleAuthProvider.credential(
      accessToken: googleAuth?.accessToken,
      idToken: googleAuth?.idToken,
    );

    // Once signed in, return the UserCredential
    FirebaseAuth.instance.signInWithCredential(credential);
   Navigator.pushReplacementNamed(context, '/bottomNavigetor');
  }
  final emailkey=GlobalKey();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Log in"),
        centerTitle: true,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back_ios_new),
          onPressed: () {
            Navigator.pushReplacementNamed(context, '/bottomNavigetor');
          },
        ),
        backgroundColor: Colors.grey,
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
                          image: AssetImage('assiste/logo.png'))),

                ),
              ],
            ),
            const SizedBox(
              height: 40,
            ),
            Center(
              child: Container(
                margin: const EdgeInsets.all(10),
                padding: const EdgeInsets.all(20),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(20),
                  color: Colors.white60,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3), // changes position of shadow
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    TextFormField(key: emailkey,
                      validator: (value) {
                        RegExp(r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                            .hasMatch(email.text);
                        if (value!.isEmpty || value == null)
                          return 'Enter Email';
                        return null;
                      },
                      controller: email,
                      maxLines: 1,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          icon: const Icon(Icons.email),
                          hintText: 'you@Exampel.com',
                          label: const Text("Email")),
                      keyboardType: TextInputType.emailAddress,
                      inputFormatters: [
                        FilteringTextInputFormatter.singleLineFormatter
                      ],
                      autofocus: true,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    TextFormField(
                      validator: (value) {
                        if (value!.isEmpty || value == null)
                          return 'Enter password';
                        return null;
                      },
                      controller: password,
                      maxLines: 1,
                      decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(30)),
                          icon: const Icon(Icons.lock),
                          hintText: '******',
                          label: const Text("Password")),
                      obscureText: true,
                      keyboardType: TextInputType.visiblePassword,
                    ),
                    const SizedBox(
                      height: 30,
                    ),
                    Container(
                      width: double.infinity,
                      child: MaterialButton(
                        onPressed: () async {
                          if (key.currentState!.validate()) {
                            try {
                              final credential = await FirebaseAuth.instance
                                  .signInWithEmailAndPassword(
                                      email: email.text,
                                      password: password.text);
                              if(credential.user!.emailVerified){

                               await AwesomeDialog(context: context,
                                    animType: AnimType.rightSlide,
                                    title: 'success',
                                    dialogType: DialogType.success,
                                    autoHide: Duration(seconds: 1)

                                ).show();


                              Navigator.pushReplacementNamed(context, '/bottomNavigetor');}
                              else{
                                credential.user!.sendEmailVerification();
                                AwesomeDialog(context: context,
                                  animType: AnimType.bottomSlide,
                                  title: 'Verify',
                                  dialogType: DialogType.warning,
                                  desc: 'verify email '

                                ).show();
                                await FirebaseAuth.instance.signOut();
                              }
                            } on FirebaseAuthException catch (e) {
                              if (e.code == 'user-not-found') {
                                AwesomeDialog(context: context,
                                    animType: AnimType.bottomSlide,
                                    title: 'user',
                                    dialogType: DialogType.error,
                                    desc: 'user not found'

                                ).show();

                                //print();
                              } else if (e.code == 'wrong-password') {
                                AwesomeDialog(context: context,
                                    animType: AnimType.bottomSlide,
                                    title: 'Password',
                                    dialogType: DialogType.error,
                                    desc: 'wrong password '

                                ).show();

                                print('Wrong password provided for that user.');
                              } else
                                AwesomeDialog(context: context,
                                    animType: AnimType.bottomSlide,
                                    title: 'Error',
                                    dialogType: DialogType.error,
                                    desc: 'Chick Email or Password '

                                ).show();
                            }
                          }
                        },
                        child: const Text('log in'),
                        height: 40,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(70)),
                        color: Colors.blue,
                      ),
                    ),
                    TextButton(
                        onPressed: () async {
                          if(emailkey.currentState == null){
                          await FirebaseAuth.instance.sendPasswordResetEmail(email: email.text);
                          AwesomeDialog(
                            context: context,
                            autoHide: Duration(seconds: 3),
                            desc: 'chick email',
                            title: 'success',
                            dialogType: DialogType.success
                          ).show();
                          }
                          else{
                            AwesomeDialog(
                                context: context,
                                autoHide: Duration(seconds: 2),
                                desc: 'enter email',
                                title: 'Email',
                                dialogType: DialogType.warning
                            ).show();

                          }
                        },
                        child: const Text(
                          "Forget password?",
                          selectionColor: Colors.blue,
                        )),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("Don't have account"),
                        TextButton(
                          onPressed: () {
                            Navigator.pushReplacementNamed(context, '/sign up');
                          },
                          child: const Text(
                            "Sign up ",
                            style: TextStyle(fontWeight: FontWeight.bold),
                            selectionColor: Colors.blue,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(
                      height: 10,
                    ),
                    Center(
                      child: Container(
                        width: 40,
                        height: 40,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(70),
                            color: Colors.grey),
                        child: InkWell(
                          child: Image.asset(
                            'assiste/icon google.png',
                          ),
                          onTap: () {
                            signInWithGoogle();

                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter/material.dart';
import 'package:path/path.dart';

class addcategory extends StatefulWidget {
  const addcategory({Key? key}) : super(key: key);

  @override
  State<addcategory> createState() => _addcategoryState();
}

class _addcategoryState extends State<addcategory> {
  TextEditingController name = TextEditingController();
  var Key = GlobalKey<FormState>();
  File? file;
  String? url;

  getimge() async {
    final ImagePicker picker = ImagePicker();
    //final XFile? image = await picker.pickImage(source: ImageSource.gallery);
    final XFile? photo = await picker.pickImage(source: ImageSource.camera);
    if (photo != null) {
      file = File(photo!.path);
      var imagename = basename(photo!.path);

      var uplode = FirebaseStorage.instance.ref('/category/$imagename');
      await uplode.putFile(file!);
      url = await uplode.getDownloadURL();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add Cetgory"),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          if (Key.currentState!.validate() && url != null) {
            DocumentReference query = FirebaseFirestore.instance
                .collection('catogery')
                .doc(name.text);
            query.set({'name': name.text, 'imege': url});
          }
        },
        child: Icon(Icons.add_circle_outline),
      ),
      body: Form(
        key: Key,
        child: ListView(
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextFormField(
                validator: (value) {
                  if (value!.isEmpty || value == null) return 'Enter name';
                  return null;
                },
                controller: name,
                maxLines: 1,
                decoration: InputDecoration(
                    border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(30)),
                    icon: const Icon(Icons.add_circle_outline),
                    hintText: 'category name',
                    label: const Text("category name")),
                keyboardType: TextInputType.visiblePassword,
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                child: Text('add photo ', style: TextStyle(fontSize: 30)),
                onPressed: () async {
                  await getimge();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}

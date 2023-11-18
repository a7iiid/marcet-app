import 'dart:io';
import 'dart:ui';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/material.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart';
import 'package:raed/category/categoryviwe.dart';
import 'package:raed/viwe/home.dart';
import 'prodactviwe.dart';

class addproduct extends StatefulWidget {
  final String categoryId;

  const addproduct({Key? key, required this.categoryId}) : super(key: key);

  @override
  State<addproduct> createState() => _addproductState();
}

class _addproductState extends State<addproduct> {
  TextEditingController name = TextEditingController();
  TextEditingController prise = TextEditingController();

  TextEditingController des = TextEditingController();

  var Key = GlobalKey<FormState>();
  bool pubiulr=false;

  File? file;

  List<String> url = [];

  List<XFile> selectedImages = [];

  final ImagePicker picker = ImagePicker();

  selectMultimages() async {
    final List<XFile> Images = await picker.pickMultiImage();
    if (Images.isNotEmpty && Images != null) {
      selectedImages.addAll(Images);
      selectedImages.forEach((element) async {
        file = File(element!.path);
        var imagename = basename(element!.path);
        var uplode = FirebaseStorage.instance.ref('/product/$imagename');
        await uplode.putFile(file!);
        url.add(await uplode.getDownloadURL());
      });

      //setState(() {});
    }
    setState(() {});
    return null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Add product "),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          if (Key.currentState!.validate() && url != null) {
            DocumentReference query = await FirebaseFirestore.instance
                .collection('catogery')
                .doc(widget.categoryId);
            await query.collection(widget.categoryId).add({
              'name': name.text,
              'des': des.text,
              'prise': prise.text,
              'image':url
            });
            if(pubiulr){
              CollectionReference query=FirebaseFirestore.instance.collection('pubiulr');
              query.add({
                'name': name.text,
                'des': des.text,
                'prise': prise.text,
                'image':url
              });
            }
            Navigator.pushReplacementNamed(context, '/home');


          }
        },
        child: Icon(Icons.add_circle_outline),
      ),
      body: Form(
        key: Key,
        child: ListView(
          shrinkWrap: true,
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
                    hintText: 'product name',
                    label: const Text("product name")),
                keyboardType: TextInputType.visiblePassword,
              ),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty || value == null) return 'Enter description';
                return null;
              },
              controller: des,
              decoration: InputDecoration(
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(30)),
                  icon: const Icon(Icons.add_circle_outline),
                  hintText: 'description product',
                  label: const Text("description product")),
            ),
            SizedBox(
              height: 10,
            ),
            TextFormField(
              validator: (value) {
                if (value!.isEmpty || value == null) return 'Enter prise';
                return null;
              },
              controller: prise,
              decoration: InputDecoration(
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(30)),
                icon: const Icon(Icons.add_circle_outline),
                hintText: 'prise product',
                label: const Text("prise product"),
              ),
              keyboardType: TextInputType.number,
            ),
            CheckboxListTile(value: pubiulr,
                onChanged: (value) =>
                setState(() {
                  pubiulr=value as bool;
                }),title: Text('نشر في الصفحة الرئيسية')),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextButton(
                child: Text('اضف الصور ', style: TextStyle(fontSize: 30)),
                onPressed: () async {
                  await selectMultimages();
                },
              ),
            ),

            selectedImages.isEmpty
                ? Card(
                    color: Colors.blue,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20)),
                    child: Container(
                      height: 50,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.grey.withOpacity(0.5),
                            spreadRadius: 5,
                            blurRadius: 7,
                            offset: const Offset(
                                0, 3), // changes position of shadow
                          ),
                        ],
                      ),
                    ),
                  )
                : FlutterCarousel.builder(
                    itemBuilder: (context, index, realIndex) {
                      return Card(
                        color: Colors.blue,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20)),
                        child: Container(
                          height: 50,
                          decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(20),
                            boxShadow: [
                              BoxShadow(
                                color: Colors.grey.withOpacity(0.5),
                                spreadRadius: 5,
                                blurRadius: 7,
                                offset: const Offset(
                                    0, 3), // changes position of shadow
                              ),
                            ],
                          ),
                          child: Image.file(File(selectedImages![index].path)),
                        ),
                      );
                    },
                    itemCount: selectedImages.length,
                    options: CarouselOptions(
                      aspectRatio: 16 / 9,
                      viewportFraction: 0.8,
                      enableInfiniteScroll: true,
                      autoPlayInterval: const Duration(seconds: 3),
                      autoPlayAnimationDuration:
                          const Duration(milliseconds: 800),
                      autoPlayCurve: Curves.easeOutCubic,
                      enlargeCenterPage: false,
                      scrollDirection: Axis.horizontal,
                      disableCenter: true,
                      showIndicator: true,
                    ),
                  ),
          ],
        ),
      ),
    );
  }
}

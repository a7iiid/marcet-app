import 'package:flutter/material.dart';

Textfilde({
  required String text,
  required String hint,
  required TextEditingController controller,
   bool obscore=false,
  required Icon icon,
  required String type,
  required Function valdit,

}) =>
    TextFormField(
      controller: controller,
      validator: (v)=> valdit as String,
      decoration: InputDecoration(
        hintText: hint,
        label: Text(text),
        icon: icon,


      ),
      obscureText: obscore,
      keyboardType:  type=='1'? TextInputType.phone : type =='2'? TextInputType.visiblePassword: TextInputType.emailAddress,


    );



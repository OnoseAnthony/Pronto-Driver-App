import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:fronto_rider/constants.dart';

buildPhoneNumberTextField(
    String hintText, TextEditingController controller, Widget prefixIcon) {
  return Container(
    child: TextFormField(
      keyboardType: TextInputType.number,
      onChanged: (val) {},
      controller: controller,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        new LengthLimitingTextInputFormatter(10),
      ],
      validator: (val) => val.isEmpty ? 'Field Cannot be empty' : null,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        isDense: true,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    ),
  );
}

buildEmailTextField(String hintText, TextEditingController controller,
    TextInputType textInputType) {
  return Container(
    child: TextFormField(
      minLines: textInputType == TextInputType.multiline ? 6 : null,
      // any number you need (It works as the rows for the textarea)
      maxLines: null,
      keyboardType: textInputType,
      onChanged: (val) {},
      controller: controller,
      validator: (val) => val.isEmpty ? 'Field Cannot be empty' : null,
      decoration: InputDecoration(
        isDense: true,
        hintText: hintText,
        hintStyle: TextStyle(
          fontSize: 14,
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: kPrimaryColor),
        ),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: Colors.black),
        ),
      ),
    ),
  );
}

buildVerifyPhoneNumberField(TextEditingController controller, context) {
  return Container(
    width: 35,
    height: 35,
    decoration: BoxDecoration(
      color: kWhiteColor,
      borderRadius: BorderRadius.circular(3),
      boxShadow: [
        BoxShadow(
          color: Colors.black26,
          blurRadius: 0.25,
        )
      ],
    ),
    child: TextFormField(
      onChanged: (val) {},
      keyboardType: TextInputType.number,
      controller: controller,
      inputFormatters: [
        FilteringTextInputFormatter.digitsOnly,
        new LengthLimitingTextInputFormatter(1),
      ],
      validator: (val) => val.isEmpty ? 'Field Cannot be empty' : null,
      decoration: InputDecoration(
        contentPadding: EdgeInsets.only(left: 15, bottom: 10),
        hintStyle: TextStyle(color: Colors.grey[400], fontSize: 12),
        border: InputBorder.none,
      ),
    ),
  );
}

buildTextField(String hintText, TextEditingController controller) {
  return Container(
    child: TextFormField(
      keyboardType: TextInputType.text,
      onChanged: (val) {},
      controller: controller,
      validator: (val) => val.isEmpty ? 'Field Cannot be empty' : null,
      inputFormatters: [],
      decoration: InputDecoration(
          isDense: true,
          hintText: hintText,
          hintStyle: TextStyle(
            fontSize: 14,
          ),
          contentPadding: EdgeInsets.only(top: 15.0, bottom: 5.0)),
    ),
  );
}

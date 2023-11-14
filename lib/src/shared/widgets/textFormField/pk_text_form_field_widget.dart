import 'package:flutter/material.dart';

class PKTextFormFieldWidget extends TextFormField {
  PKTextFormFieldWidget({
    super.key,
    super.controller,
    String? labelText,
    String? hintText,
    String? validatorText,
  }) : super(
            validator: (value) {
              if (value == null || value.isEmpty) {
                return validatorText ?? 'Please enter some text';
              }
              return null;
            },
            decoration: InputDecoration(
              filled: true,
              fillColor: Color(0xffeaf7fb),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(
                  color: Color(0xff13333f),
                ),
              ),
              labelText: labelText,
              hintText: hintText,
            ),
            onChanged: (String value) {
              controller?.text = value;
            });
}

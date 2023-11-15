import 'package:flutter/material.dart';

class PKTextFormFieldWidget extends TextFormField {
  PKTextFormFieldWidget({
    super.key,
    super.controller,
    String? labelText,
    String? hintText,
    String? validatorText,
    bool? enabled = true,
    int? maxLength,
    int? minLength,
    bool? isToUpperCase,
  }) : super(
          validator: (value) {
            if (value == null ||
                value.isEmpty ||
                value.length < (minLength ?? 0)) {
              return validatorText ?? 'Por favor, preencha o texto.';
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
          maxLength: maxLength,
          onChanged: (String value) {
            if (isToUpperCase != null && isToUpperCase) {
              controller?.text = value.toUpperCase();
            } else
              controller?.text = value;
          },
          enabled: enabled,
        );
}

import 'package:blogger/utils/global_variables.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.controller,
      this.isBodyField = false,
      required this.fieldHint});
  final TextEditingController controller;
  final bool isBodyField;
  final String fieldHint;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: isBodyField ? 300.h : 70.h,
      width: MediaQuery.of(context).size.width,
      child: TextFormField(
        textAlignVertical: TextAlignVertical.top,
        controller: controller,
        cursorColor: primaryColor,
        maxLines: isBodyField ? null : 1,
        minLines: isBodyField ? null : 1,
        expands: isBodyField,
        decoration: InputDecoration(
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14).r,
                borderSide: const BorderSide(color: Colors.grey)),
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14).r,
                borderSide: BorderSide(color: Colors.grey.shade300)),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14).r,
                borderSide: const BorderSide(color: primaryColor)),
            focusedErrorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14).r,
                borderSide: const BorderSide(color: Colors.red)),
            errorBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(14).r,
                borderSide: const BorderSide(color: Colors.red)),
            labelText: fieldHint,
            helperText: ' ',
            floatingLabelAlignment: FloatingLabelAlignment.start,
            floatingLabelBehavior: FloatingLabelBehavior.always),
        validator: (value) {
          if (value == null || value.isEmpty) {
            return '*Required';
          }
          return null;
        },
        autovalidateMode: AutovalidateMode.onUserInteraction,
      ),
    );
  }
}

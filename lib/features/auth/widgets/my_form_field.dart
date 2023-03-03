import 'package:flutter/material.dart';

class MyFormField extends StatelessWidget {
  final String? label;
  final String? hint;
  final Widget? prefixIcon;
  final IconButton? suffixIcon;
  final bool? isPassword;
  final Function(String)? onSubmit;
  final Function(String)? validator;
  final TextEditingController? controller;
  final TextInputType? keyboardType;
  final bool? isAutoFocus;
  final Function()? onTap;
  final bool? readOnly ;
  const MyFormField({
    Key? key,
    this.label,
    this.hint,
    this.prefixIcon,
    this.suffixIcon,
    this.isPassword,
    this.onSubmit,
    this.validator,
    this.controller,
    this.keyboardType,
    this.isAutoFocus,
    this.onTap,
    this.readOnly,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Material(
        color: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10),side: const BorderSide(color: Colors.grey)),
          child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 8),
              child: TextFormField(
                validator: (value) => validator!(value!),
                controller: controller,
                onTap: onTap,
                readOnly: readOnly ?? false,
                keyboardType: keyboardType,
                autofocus: isAutoFocus ?? false,
                obscureText: isPassword ?? false,
                onFieldSubmitted: (value) => onSubmit!(value) ?? "",
                decoration: InputDecoration(
                  errorStyle: const TextStyle(
                    color: Colors.blue,
                    fontSize: 15,
                  ),
                  hintStyle: TextStyle(color: Colors.grey.shade400),
                  hintText: hint,
                  labelText: label,
                  prefixIcon: prefixIcon,
                  prefixIconConstraints: const BoxConstraints(
                    minWidth: 110,
                    minHeight: 40,
                  ),
                  suffixIcon: suffixIcon,
                  border: InputBorder.none,
                ),
              ))),
    );
  }
}

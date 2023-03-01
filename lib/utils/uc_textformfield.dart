import 'package:big_red/services/custom_enums.dart';
import 'package:flutter/material.dart';
import 'package:validators/validators.dart';

class UcTextFormField extends StatelessWidget {
  final TextEditingController? textController;
  final String labelText;
  final String? hintText;
  final String? initialValue;
  final bool? readOnly;
  final TextInputType? keyboardType;
  final bool haveValidator;
  final ValidatorType? validatorType;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final Function()? onTap;
  final Function(String)? onChanged;
  const UcTextFormField({
    Key? key,
    required this.textController,
    required this.labelText,
    this.initialValue,
    this.readOnly,
    this.keyboardType,
    this.hintText,
    required this.haveValidator,
    this.validatorType,
    this.prefixIcon,
    this.suffixIcon,
    this.onTap,
    this.onChanged,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: textController,
      initialValue: initialValue,
      readOnly: readOnly ?? false,
      decoration: InputDecoration(
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        labelText: labelText,
        hintText: hintText,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: (value) {
        if (haveValidator) {
          if (validatorType == ValidatorType.name) {
            if (value == null || value.isEmpty || !isValidName(value.trim())) {
              return 'Please enter valid name';
            }
            return null;
          } else if (validatorType == ValidatorType.phone) {
            if (!(value == null || value.isEmpty || value == '')) {
              if (!isPhoneNumber(value)) {
                return 'Please enter valid contact number';
              }
              return null;
            }
            return null;
          } else if (validatorType == ValidatorType.email) {
            if (isEmail(value!)) {
              return 'Please enter valid email';
            }
            return null;
          }
        }
        return null;
      },
      onTap: onTap,
      onChanged: onChanged,
    );
  }

  bool isValidName(String value) {
    return RegExp(r'^[a-zA-Z ]+$').hasMatch(value);
  }

  bool isPhoneNumber(String value) {
    return RegExp(r'^[0-9]+$').hasMatch(value);
  }
}

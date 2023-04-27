import 'package:dropdown_button2/dropdown_button2.dart';
import 'package:flutter/material.dart';

class CustomDropDown extends StatefulWidget {
  final String dropdownFor;
  final List<DropdownMenuItem<dynamic>> items;
  final Function(dynamic) onChanged;
  final dynamic value;
  const CustomDropDown(
      {Key? key,
      required this.dropdownFor,
      required this.items,
      required this.onChanged,
      required this.value})
      : super(key: key);

  @override
  State<CustomDropDown> createState() => _CustomDropDownState();
}

class _CustomDropDownState extends State<CustomDropDown> {
  @override
  Widget build(BuildContext context) {
    final bool isDark = Theme.of(context).brightness == Brightness.dark;
    return DropdownButtonFormField2(
      decoration: InputDecoration(
        //Add isDense true and zero Padding.
        //Add Horizontal padding using buttonPadding and Vertical padding by increasing buttonHeight instead of add Padding here so that The whole TextField Button become clickable, and also the dropdown menu open under The whole TextField Button.
        isDense: true,
        contentPadding: EdgeInsets.zero,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15),
        ),
        //Add more decoration as you want here
        //Add label If you want but add hint outside the decoration to be aligned in the button perfectly.
      ),
      isExpanded: true,
      hint: Text(
        'Select ${widget.dropdownFor}',
        style: const TextStyle(fontSize: 14),
      ),
      items: widget.items,
      validator: (value) {
        if (value == null) {
          return 'Please select ${widget.dropdownFor}..';
        }
        return null;
      },
      onChanged: (value) {
        widget.onChanged(value);
      },
      buttonStyleData: ButtonStyleData(
        height: 50,
        width: 160,
        padding: const EdgeInsets.only(left: 14, right: 14),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(14),
          border: Border.all(
            color: Colors.grey,
          ),
          color: isDark ? const Color.fromARGB(230, 43, 43, 42) : Colors.white,
        ),
        elevation: 2,
      ),
      iconStyleData: const IconStyleData(
        icon: Icon(
          Icons.arrow_drop_down,
        ),
        iconSize: 30,
      ),
      dropdownStyleData: DropdownStyleData(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(15),
        ),
      ),
      menuItemStyleData: const MenuItemStyleData(
        height: 40,
        padding: EdgeInsets.only(left: 14, right: 14),
      ),
    );
  }
}

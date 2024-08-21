import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:opulencia/theme/styles.dart';
import 'package:opulencia/utils/strings/strings.dart';

// ignore: must_be_immutable
class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  Widget? prefixIconData;
  Widget? suffix;
  Function()? onTap;
  bool? readOnly;
  bool hasTitle;
  bool hasPrefix;
  String? title;
  TextInputType? keyboardType;
  int? maxLines = 1;
  void Function(String)? onChanged;
  void Function(String)? onFieldSubmitted;
  List<TextInputFormatter>? inputFormatters;
  bool isRequired;
  String? Function(String?)? validator;
  bool? enabled;
  int? maxLength;
  final FocusNode? focusNode;

  MyTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.prefixIconData,
    this.suffix,
    this.onTap,
    this.readOnly,
    this.maxLines,
    this.title,
    this.hasTitle = false,
    this.hasPrefix = false,
    this.keyboardType = TextInputType.name,
    this.onChanged,
    this.onFieldSubmitted,
    this.inputFormatters,
    this.isRequired = false,
    this.validator,
    this.maxLength,
    this.focusNode,
    this.enabled = true,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        hasTitle
            ? Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    Text(
                      title ?? "",
                      style: Styles.mediumText(context),
                    ),
                    isRequired
                        ? Text(
                            "*",
                            style: Styles.mediumText(context)
                                .copyWith(color: Colors.red),
                          )
                        : const SizedBox(),
                  ],
                ),
              )
            : const SizedBox(),
        TextFormField(
          maxLength: maxLength,
          enabled: enabled,
          validator: validator,
          inputFormatters: inputFormatters,
          onFieldSubmitted: onFieldSubmitted,
          onChanged: onChanged,
          keyboardType: keyboardType,
          focusNode: focusNode,
          onTapOutside: (event) {
            FocusScope.of(context).unfocus();
          },
          maxLines: maxLines,
          readOnly: readOnly ?? false,
          style: TextStyle(
              fontSize: 16,
              color: !enabled!
                  ? const Color(0xFF6E8596)
                  : Theme.of(context).canvasColor,
              fontFamily: Strings.appFont),
          cursorColor: Theme.of(context).primaryColor,
          controller: controller,
          onTap: onTap,
          decoration: InputDecoration(
            counter: const SizedBox(
              width: 0,
              height: 0,
            ),
            contentPadding: EdgeInsets.symmetric(
                horizontal: prefixIconData == null ? 0 : 10, vertical: 15),
            fillColor: Colors.white10,
            filled: true,
            hintText: hintText,
            prefixIconConstraints:
                BoxConstraints.tight(Size(!hasPrefix ? 10 : 45, 45)),
            suffixIcon: suffix ?? const SizedBox(),
            prefixIcon: Padding(
                padding: EdgeInsets.all(prefixIconData == null ? 0 : 12.0),
                child: prefixIconData),
            hintStyle: TextStyle(
              color: Theme.of(context).canvasColor.withOpacity(0.5),
              fontWeight: FontWeight.w600,
            ),
            errorStyle: Styles.smallText(context)
                .copyWith(color: Colors.redAccent, fontWeight: FontWeight.w400),
            errorBorder: OutlineInputBorder(
              gapPadding: 0,
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(color: Colors.red),
            ),
            focusedBorder: OutlineInputBorder(
              gapPadding: 0,
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Styles.primary),
            ),
            disabledBorder: OutlineInputBorder(
              gapPadding: 0,
              borderRadius: BorderRadius.circular(15),
              borderSide:
                  BorderSide(color: const Color(0xFF6E8596).withOpacity(0.5)),
            ),
            border: OutlineInputBorder(
              gapPadding: 0,
              borderRadius: BorderRadius.circular(15),
              borderSide: BorderSide(color: Styles.primary),
            ),
            enabledBorder: OutlineInputBorder(
              gapPadding: 0,
              borderRadius: BorderRadius.circular(15),
              borderSide: const BorderSide(
                color: Color(0xFF6E8596),
              ),
            ),
          ),
        ),
      ],
    );
  }
}

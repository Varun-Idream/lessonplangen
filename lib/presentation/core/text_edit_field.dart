import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:lessonplan/util/constants/color_constants.dart';
import 'package:lessonplan/util/constants/constants.dart';

class TextEditField extends StatelessWidget {
  const TextEditField({
    super.key,
    this.onSaved,
    this.onChanged,
    this.validator,
    this.keyboardType,
    this.hintText = '',
    this.errorText = '',
    this.iconData,
    this.padding,
    this.labelText = '',
    this.obscureText = false,
    this.suffixIcon,
    this.isFirst = false,
    this.isLast = false,
    this.style,
    this.textAlign,
    this.suffix,
    this.prefixText,
    required this.controller,
    required this.enabled,
    this.maxLength,
    this.fillColor,
    this.hintTextColor,
    this.filled = false,
    this.textSize,
    this.labelStyle,
    this.isRequired = false,
    this.inputDecoration,
    this.contentPadding = const EdgeInsets.all(18.0),
    this.inputFormatters,
    this.textFieldMaxHeight,
    this.enabledBorderColor = ColorConstants.lightGrey,
  });

  final FormFieldSetter<String>? onSaved;
  final ValueChanged<String>? onChanged;
  final FormFieldValidator<String>? validator;
  final TextInputType? keyboardType;
  final String hintText;
  final String errorText;
  final TextAlign? textAlign;
  final String labelText;
  final TextStyle? style;
  final IconData? iconData;
  final Widget? padding;
  final bool obscureText;
  final bool isFirst;
  final bool isLast;
  final Widget? suffixIcon;
  final Widget? suffix;
  final String? prefixText;
  final TextEditingController controller;
  final bool enabled;
  final int? maxLength;
  final Color? fillColor;
  final Color? hintTextColor;
  final bool filled;
  final double? textSize;
  final TextStyle? labelStyle;
  final bool isRequired;
  final InputDecoration? inputDecoration;
  final EdgeInsetsGeometry? contentPadding;
  final List<TextInputFormatter>? inputFormatters;
  final double? textFieldMaxHeight;
  final Color enabledBorderColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      constraints: const BoxConstraints(
        maxHeight: 100,
      ),
      child: Row(
        children: [
          SizedBox(
            width: 90,
            child: RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: labelText,
                    style: labelStyle?.copyWith(
                      fontFamily: 'Inter',
                    ),
                  ),
                  const WidgetSpan(
                    child: SizedBox(
                      width: 5,
                    ),
                  ),
                  if (isRequired)
                    WidgetSpan(
                      child: Text(
                        "*",
                        style: TextStyles.textRegular14.copyWith(
                          color: ColorConstants.primaryRed,
                        ),
                      ),
                    )
                ],
              ),
            ),
          ),
          const SizedBox(width: 20),
          Expanded(
            child: Material(
              textStyle: const TextStyle(fontFamily: 'Inter'),
              color: Colors.transparent,
              child: TextFormField(
                keyboardType: keyboardType ?? TextInputType.text,
                onSaved: onSaved,
                enabled: enabled,
                controller: controller,
                onChanged: onChanged,
                maxLength: maxLength,
                textDirection: TextDirection.ltr,
                validator: validator,
                onFieldSubmitted: (value) {},
                style: style ??
                    const TextStyle(color: ColorConstants.primaryBlack),
                obscureText: obscureText,
                textAlign: textAlign ?? TextAlign.start,
                inputFormatters: inputFormatters,
                cursorColor: Colors.black87,
                decoration: inputDecoration ??
                    InputDecoration(
                      contentPadding: contentPadding,
                      counterText: "",
                      hintText: hintText,
                      hintStyle: TextStyles.textRegular16.copyWith(
                        color: hintTextColor ?? ColorConstants.lightGrey,
                      ),
                      prefixText: prefixText,
                      focusedBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: const BorderSide(
                          color: ColorConstants.darkBlue,
                        ),
                      ),
                      enabledBorder: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: BorderSide(
                          color: enabledBorderColor,
                        ),
                      ),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(6.0),
                        borderSide: const BorderSide(
                          color: ColorConstants.lightGrey,
                        ),
                      ),
                      filled: filled,
                      fillColor: fillColor,
                    ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:my_lawn/extensions/remove_symbols_make_lower_case_key.dart';

/// A flexible text input field with sane defaults and a few extras.
class TextInputField extends StatelessWidget {
  final String labelText;
  final String hintText;
  final String errorText;
  final FocusNode focusNode;
  final String initialValue;
  final Widget prefixIcon;
  final Widget suffixIcon;
  final TextCapitalization textCapitalization;
  final List<TextInputFormatter> textInputFormatters;
  final TextInputAction textInputAction;
  final TextInputType textInputType;
  final bool obscureText;
  final Function(String) onChanged;
  final Function() onSubmitted;
  final Function() onTap;
  final EdgeInsets padding;
  final FormFieldValidator<String> validator;
  final bool autovalidate;
  final TextEditingController controller;
  final bool enabled;
  final Color disabledColor;
  final bool autofocus;
  final bool autocorrect;
  final bool maxLengthEnforced;
  final int maxLength;
  final TextStyle labelStyle;

  TextInputField({
    Key key,
    this.labelText,
    this.hintText,
    this.errorText,
    this.focusNode,
    this.prefixIcon,
    this.suffixIcon,
    this.initialValue,
    this.textCapitalization = TextCapitalization.words,
    this.textInputFormatters,
    this.textInputAction = TextInputAction.next,
    this.textInputType = TextInputType.text,
    this.obscureText = false,
    this.onChanged,
    this.onSubmitted,
    this.onTap,
    this.padding = const EdgeInsets.only(bottom: 16),
    this.validator,
    this.autovalidate = false,
    this.controller,
    this.enabled = true,
    this.disabledColor,
    this.autofocus = false,
    this.autocorrect = true,
    this.maxLengthEnforced = true,
    this.maxLength,
    this.labelStyle,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final textField = Padding(
      padding: padding,
      child: TextFormField(
        key: Key(
            labelText.removeNonCharsMakeLowerCaseMethod(identifier: '_input')),
        autocorrect: autocorrect,
        focusNode: focusNode,
        initialValue: initialValue,
        textInputAction: textInputAction,
        keyboardType: textInputType,
        textCapitalization: textCapitalization,
        decoration: InputDecoration(
          labelText: labelText,
          hintText: hintText,
          errorText: errorText,
          counterText: '',
          prefixIcon: prefixIcon,
          prefixIconConstraints: BoxConstraints(maxHeight: 24),
          suffixIcon: suffixIcon,
          suffixIconConstraints: BoxConstraints(maxHeight: 24),
          labelStyle: labelStyle,
        ),
        obscureText: obscureText,
        inputFormatters: textInputFormatters,
        enabled: enabled,
        onChanged: onChanged,
        style: theme.textTheme.subtitle1.copyWith(
          color: enabled
              ? theme.textTheme.subtitle1.color
              : disabledColor ?? theme.disabledColor,
        ),
        maxLength: maxLength,
        maxLengthEnforced: maxLengthEnforced,
        validator: validator,
        autovalidateMode:
            autovalidate ? AutovalidateMode.always : AutovalidateMode.disabled,
        controller: controller,
        autofocus: autofocus,
      ),
    );

    final maybeTappableTextfield = onTap == null
        ? textField
        : InkWell(
            child: textField,
            onTap: onTap,
          );

    return maybeTappableTextfield;
  }
}

Widget ObscurityToggle({
  bool isObscured,
  Function(bool isObscured) onTap,
}) =>
    GestureDetector(
      child: Icon(
        isObscured ? Icons.visibility : Icons.visibility_off,
      ),
      onTap: () => onTap?.call(!isObscured),
    );

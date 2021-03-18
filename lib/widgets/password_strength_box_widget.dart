import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';

/// The password strength box shows whether a
/// given password meets password guidelines.
class PasswordStrengthBox extends StatelessWidget {
  final String password;
  final Function(bool isValid) onUpdated;

  final hasEightCharacters;
  final hasLowercaseLetter;
  final hasUppercaseLetter;
  final hasSpecialCharacter;
  final hasDigit;

  /// Creates a password strength box for the given [password],
  /// with an optional [onUpdated] callback to get back results.
  PasswordStrengthBox({this.password, this.onUpdated})
      : hasEightCharacters = password.length >= 8,
        hasLowercaseLetter = password.contains(RegExp(r'[a-z]+')),
        hasUppercaseLetter = password.contains(RegExp(r'[A-Z]+')),
        hasSpecialCharacter = password.contains(RegExp(r'[\W_]+')),
        hasDigit = password.contains(RegExp(r'\d+')) {
    onUpdated?.call(hasEightCharacters &&
        hasLowercaseLetter &&
        hasUppercaseLetter &&
        hasSpecialCharacter &&
        hasDigit);
  }

  Widget _buildPasswordStrengthItem(
    BuildContext context, {
    bool isValid,
    String text,
  }) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.only(left: 8, top: 4),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Padding(
            padding: EdgeInsets.all(isValid ? 0 : 2),
            child: Icon(
              Icons.check,
              color: isValid ? theme.primaryColor : theme.disabledColor,
              size: isValid ? 20 : 16,
            ),
          ),
          SizedBox(width: 4),
          Text(text)
        ],
      ),
    );
  }

  Widget _buildPasswordStrengthBox(BuildContext context) {
    final theme = Theme.of(context);

    return Container(
      color: Styleguide.nearBackground(theme),
      padding: const EdgeInsets.fromLTRB(24, 16, 24, 16),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'Password Strength',
            style: theme.textTheme.subtitle1,
          ),
          SizedBox(height: 4),
          _buildPasswordStrengthItem(
            context,
            isValid: hasEightCharacters,
            text: 'At least 8 characters',
          ),
          _buildPasswordStrengthItem(
            context,
            isValid: hasLowercaseLetter,
            text: 'One lowercase letter',
          ),
          _buildPasswordStrengthItem(
            context,
            isValid: hasUppercaseLetter,
            text: 'One uppercase letter',
          ),
          _buildPasswordStrengthItem(
            context,
            isValid: hasSpecialCharacter,
            text: 'One special character',
          ),
          _buildPasswordStrengthItem(
            context,
            isValid: hasDigit,
            text: 'One digit',
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) => _buildPasswordStrengthBox(context);
}

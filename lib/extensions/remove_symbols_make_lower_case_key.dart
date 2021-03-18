import 'package:flutter/material.dart';

extension RemoveNonCharsMakeLowerCaseMethod on String {
  String removeNonCharsMakeLowerCaseMethod({String identifier = ''}) {
    return (this != null)
        ? (this?.toLowerCase()?.replaceAll(RegExp(r'[^\w]'), '_') ?? '') +
            identifier
        : UniqueKey().toString() + identifier;
  }
}

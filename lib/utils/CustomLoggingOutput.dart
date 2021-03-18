import 'dart:developer';

import 'package:logger/logger.dart';

/// Default implementation of [LogOutput].
///
/// It sends everything to the system console.
class CustomLoggingOutput extends LogOutput {
  @override
  void output(OutputEvent event) {
    event.lines.forEach(log);
  }
}

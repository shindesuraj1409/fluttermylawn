import 'package:my_lawn/data/back_button_state.dart';
import 'package:my_lawn/models/app_model.dart';
import 'package:flutter/widgets.dart';

import 'package:bus/bus.dart';

mixin ProgressTrackerMixin<T extends StatefulWidget> on State<T> {
  bool _inProgress = false;

  bool get inProgress => _inProgress;

  void trackProgress(Function function) async {
    try {
      beginProgress();
      await function();
    } finally {
      endProgress();
    }
  }

  void beginProgress() {
    busPublish<AppModel, BackButtonState>(data: BackButtonState.Disabled);
    try {
      setState(() => _inProgress = true);
    } catch (_) {
      // Do nothing.
    }
  }

  void endProgress() {
    try {
      setState(() => _inProgress = false);
    } catch (_) {
      // Do nothing.
    }
    busPublish<AppModel, BackButtonState>(data: BackButtonState.Enabled);
  }
}

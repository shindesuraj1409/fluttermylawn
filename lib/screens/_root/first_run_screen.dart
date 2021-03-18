import 'package:flutter/material.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/app_data.dart';
import 'package:my_lawn/models/app_model.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';

import 'package:navigation/navigation.dart';
import 'package:bus/bus.dart';

class FirstRunScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) => BasicScaffold(
        child: Center(
          child: FractionallySizedBox(
            widthFactor: 0.75,
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Text(
                  'First Run Screen!\n\nGreetings and Privacy Policy, perhaps?',
                  textAlign: TextAlign.center,
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 32.0),
                  child: OutlineButton(
                    child: Text('Continue'),
                    onPressed: () {
                      busPublish<AppModel, AppData>(
                        publisher: (data) =>
                            AppData(appData: data, isFirstRun: false),
                      );
                      registry<Navigation>().push('/');
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
}

import 'package:flutter/material.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/widgets/circle_image_progress_spinner_widget.dart';
import 'package:my_lawn/screens/profile/update_lawn_profile/progress_images.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:navigation/navigation.dart';

enum Status { inProgress, gotUpdates, noUpdates }

class ModifyLawnProfileLoadingScreen extends StatefulWidget {
  @override
  _ModifyLawnProfileLoadingScreenState createState() =>
      _ModifyLawnProfileLoadingScreenState();
}

class _ModifyLawnProfileLoadingScreenState
    extends State<ModifyLawnProfileLoadingScreen> {
  Status _status = Status.inProgress;

  String _statusTitle = 'HANG TIGHT';
  String _statusDescription = 'Creating Product Recommendations';
  double _statusTitleTopPadding = 24;
  double _statusTitleBottomPadding = 16;

  int quantity = 2;
  final _updateSubscription = true;

  Widget _progressCreation(ThemeData theme) {
    delayedFuture();
    return Padding(
      padding: const EdgeInsets.only(top: 168.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _status == Status.inProgress
              ? CircleImageProgressSpinner(image: 'assets/icons/loading.png')
              : CompletedImage(theme: theme),
          Padding(
            padding: EdgeInsets.only(
                top: _statusTitleTopPadding, bottom: _statusTitleBottomPadding),
            child: Text(
              _statusTitle,
              style: theme.textTheme.bodyText2.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _statusDescription,
              style: theme.textTheme.headline2.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
        ],
      ),
    );
  }

  Future<dynamic> delayedFuture() {
    return Future.delayed(Duration(seconds: 3), () {
      switch (_status) {
        case Status.inProgress:
          setState(() {
            _status = Status.gotUpdates;
            _statusTitle = 'YOU ARE ALL SET';
            _statusDescription = _status == Status.noUpdates
                ? 'No Change to Your Products'
                : 'Got [$quantity] Product ${quantity < 1 ? 'Update' : 'Updates'}!';
            _statusTitleTopPadding = 35;
            _statusTitleBottomPadding = 9;
          });
          break;
        case Status.gotUpdates:
          registry<Navigation>()
              .pushReplacement('/profile/update_plan_screen', arguments: {
            'title': _updateSubscription
                ? 'Update Subscription'
                : 'Update Recommendations',
            'description': _updateSubscription
                ? 'Here are your new product recommendations!'
                : 'Here are the new recommendations in your remaining subscription.'
          });
          break;
        case Status.noUpdates:
          registry<Navigation>().popTo('/profile');
          break;
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BasicScaffoldWithAppBar(
      appBarBackgroundColor: theme.colorScheme.primary,
      backgroundColor: theme.colorScheme.primary,
      appBarElevation: 0,
      leading: _status == Status.noUpdates
          ? IconButton(
              icon: Image.asset(
                'assets/icons/cancel.png',
                color: theme.colorScheme.onPrimary,
              ),
              onPressed: () => registry<Navigation>().popTo('/profile'),
            )
          : SizedBox(),
      child: Center(
        child: _progressCreation(theme),
      ),
    );
  }
}

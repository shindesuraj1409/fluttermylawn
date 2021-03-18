import 'package:flutter/material.dart';
import 'package:my_lawn/data/activity_type.dart';

const _activityMessages = <ActivityType, String>{
  ActivityType.waterLawn:
      'Water deeply and infrequently to grow deep, healthy roots.',
  ActivityType.aerateLawn:
      'Aerate the lawn when your grass is in its peeking growing period.',
  ActivityType.cleanDeckPatio:
      'Get simple tips that help keep your driveway and walkways looking great.',
  ActivityType.dethatchLawn:
      'Dethatch your lawn when the thatch layer is > ¾ inch thick.',
  ActivityType.mowLawn:
      'Limit yourself to cutting just the top ⅓ of the grass blades or less.',
  ActivityType.mulchBeds:
      'For best results, mulch should be 2 to 3 inches deep.',
  ActivityType.overseedLawn:
      'For your [cool]-season grass, the best time to overseed your lawn is in the [fall].',
  ActivityType.tuneUpMower:
      'Proper maintenance in the fall or winter makes starting your lawn mower in the spring a snap.',
};

class LikeWidget extends StatelessWidget {
  const LikeWidget({
    @required this.activityType,
    Key key,
  }) : super(key: key);

  final ActivityType activityType;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 16),
      child: _activityMessages.keys.contains(activityType)
          ? _buildContent(context)
          : const SizedBox(),
    );
  }

  Widget _buildContent(BuildContext context) {
    final theme = Theme.of(context);
    return Row(
      children: <Widget>[
        Image.asset(
          'assets/icons/stroke.png',
          width: 50,
          height: 50,
          key: Key('create_task_screen_thumbsup_icon'),
        ),
        const SizedBox(width: 16),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                _activityMessages[activityType],
                style: theme.textTheme.headline3,
              ),

            ],
          ),
        ),
      ],
    );
  }
}

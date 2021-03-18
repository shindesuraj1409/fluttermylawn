import 'package:bus/bus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/lawn_data.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/models/subscription_model.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/services/analytic/screen_state_action/my_subscription_screen/state.dart';
import 'package:my_lawn/widgets/badge_widget.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:my_lawn/extensions/lawn_data_extension.dart';
import 'package:navigation/navigation.dart';

class RenewSubscriptionScreen extends StatelessWidget {
  Widget _buildLawnProfile(BuildContext context) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return BlocBuilder<AuthenticationBloc, AuthenticationState>(
      cubit: registry<AuthenticationBloc>(),
      builder: (context, state) {
        final _lawnData = state.lawnData;
        return Padding(
          padding: const EdgeInsets.fromLTRB(
            16,
            28,
            16,
            16,
          ),
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.only(left: 12),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Stack(
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(bottom: 8),
                          child: _lawnData.grassTypeImageUrl != null
                              ? Image.network(
                                  _lawnData.grassTypeImageUrl,
                                  width: 72,
                                  height: 72,
                                )
                              : Image.asset(
                                  'assets/images/grass_type_placeholder.png',
                                  width: 72,
                                  height: 72,
                                ),
                        ),
                        Positioned.fill(
                          top: null,
                          child: Container(
                            decoration: BoxDecoration(
                                color: theme.primaryColor,
                                borderRadius:
                                    BorderRadius.all(Radius.circular(3))),
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  '${_lawnData.lawnSqFt}',
                                  style: textTheme.bodyText1.copyWith(
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                                Text(
                                  ' sqft',
                                  style: textTheme.bodyText2.copyWith(
                                    color: theme.colorScheme.onPrimary,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.fromLTRB(
                          18,
                          8,
                          0,
                          24,
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: <Widget>[
                            _buildGrassType(context, _lawnData),
                            _buildGrassQuality(context, _lawnData),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                height: 52,
                child: FractionallySizedBox(
                  widthFactor: 1,
                  child: OutlineButton(
                    child: Text('UPDATE LAWN PROFILE'),
                    onPressed: () {
                      registry<Navigation>().push('/profile/editlawn');
                    },
                    borderSide: BorderSide(
                      color: Theme.of(context).primaryColor,
                    ),
                  ),
                ),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildGrassType(
    BuildContext context,
    LawnData lawnData,
  ) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            lawnData.grassType ?? 'Unknown Grass Type',
            style: textTheme.headline6.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 4),
          child: Text(
            '${lawnData.lawnAddress.city}, ${lawnData.lawnAddress.state} ${lawnData.lawnAddress.zip}',
            style: textTheme.bodyText2,
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(bottom: 26),
          child: Text(
            'Spreader type: ${lawnData.spreader.shortString}',
            style: textTheme.bodyText2,
          ),
        ),
      ],
    );
  }

  Widget _buildGrassQuality(
    BuildContext context,
    LawnData lawnData,
  ) {
    return IntrinsicHeight(
      child: Row(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildGrassQualityText(
            context,
            'Thickness',
            lawnData.thickness.string,
          ),
          Expanded(
            flex: 1,
            child: VerticalDivider(),
          ),
          _buildGrassQualityText(
            context,
            'Color',
            lawnData.color.string,
          ),
          Expanded(
            flex: 1,
            child: VerticalDivider(),
          ),
          _buildGrassQualityText(
            context,
            'Weeds',
            lawnData.weeds.string,
          ),
        ],
      ),
    );
  }

  Widget _buildGrassQualityText(
    BuildContext context,
    String qualityTitle,
    String qualityValue,
  ) {
    final textTheme = Theme.of(context).textTheme;
    return Expanded(
      flex: 2,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(
              bottom: 4,
            ),
            child: Text(
              qualityTitle,
              style: textTheme.bodyText2,
            ),
          ),
          Text(
            qualityValue,
            style: textTheme.bodyText1,
          ),
        ],
      ),
    );
  }

  Widget _buildCurrentPlan(BuildContext context) {
    return busStreamBuilder<SubscriptionModel, SubscriptionData>(
        builder: (context, model, data) {
      final shipments = List.of(data.shipments);
      return Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.only(
              top: 16,
              left: 16,
            ),
            child: Text(
              'Current Plan',
              style: Theme.of(context).textTheme.headline5,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(vertical: 16),
            child: SizedBox(
              width: 144,
              height: 200,
              child: ListView.builder(
                scrollDirection: Axis.horizontal,
                shrinkWrap: true,
                itemCount: shipments.length + 2,
                itemBuilder: (context, index) =>
                    index == 0 || index == shipments.length + 1
                        ? Container(
                            width: 16,
                          )
                        : SizedBox(
                            width: 144,
                            height: 200,
                            child: Card(
                              elevation: 2,
                              margin: EdgeInsets.fromLTRB(0, 2, 12, 2),
                              child: Padding(
                                padding: const EdgeInsets.fromLTRB(8, 12, 8, 8),
                                child: _buildShipmentCard(
                                  context,
                                  shipments[index - 1],
                                ),
                              ),
                            ),
                          ),
              ),
            ),
          ),
        ],
      );
    });
  }

  Widget _buildShipmentCard(
    BuildContext context,
    SubscriptionShipment shipment,
  ) {
    final theme = Theme.of(context);
    final textTheme = theme.textTheme;
    return Container(
      child: Column(
        children: <Widget>[
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 8,
            ),
            child: Row(
              children: [
                Image.network(
                  shipment.products.first.thumbnailImage,
                  frameBuilder: (BuildContext context, Widget child, int frame,
                      bool wasSynchronouslyLoaded) {
                    if (wasSynchronouslyLoaded) {
                      return child;
                    }
                    return Stack(alignment: Alignment.center, children: [
                      AnimatedOpacity(
                        child: ProgressSpinner(),
                        opacity: frame == null ? 1 : 0,
                        duration: const Duration(milliseconds: 250),
                        curve: Curves.easeOut,
                      ),
                      AnimatedOpacity(
                        child: child,
                        opacity: frame == null ? 0 : 1,
                        duration: const Duration(milliseconds: 500),
                        curve: Curves.easeOut,
                      ),
                    ]);
                  },
                  fit: BoxFit.contain,
                  height: 82,
                  width: 56,
                ),
                Spacer(),
                SizedBox(
                  height: 82,
                  width: 40,
                  child: Column(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (1 > 0) //TODO check coverage after BE will provide it
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/bag_large.png',
                              color: textTheme.bodyText1.color,
                              colorBlendMode: BlendMode.srcATop,
                              height: 48,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 2,
                              ),
                              child: Text(
                                '\u00D7\u200A${1}', //TODO check coverage after BE will provide it
                                style: textTheme.caption.copyWith(
                                  color: textTheme.bodyText1.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                      Spacer(),
                      if (2 > 0) //TODO check coverage after BE will provide it
                        Stack(
                          alignment: Alignment.center,
                          children: [
                            Image.asset(
                              'assets/icons/bag_small.png',
                              color: textTheme.bodyText1.color,
                              colorBlendMode: BlendMode.srcATop,
                              height: 32,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(
                                bottom: 1,
                              ),
                              child: Text(
                                '\u00D7\u200A${2}',
                                style: textTheme.caption.copyWith(
                                  color: textTheme.bodyText1.color,
                                ),
                              ),
                            ),
                          ],
                        ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              Badge(
                text: 'EARLY SUMMER',
                color: Styleguide.color_green_2,
                margin: EdgeInsets.fromLTRB(0, 12, 0, 8),
                size: BadgeSize.Small,
              ),
            ],
          ),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(bottom: 4),
              child: Text(
                shipment.products.first.shortDescription,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
                style: textTheme.bodyText2.copyWith(
                  height: 1.5,
                ),
              ),
            ),
          ),
          Text(
            '\$59.99',
            style: textTheme.subtitle2.copyWith(
              color: Styleguide.color_green_4,
              fontWeight: FontWeight.w600,
            ),
          )
        ],
      ),
    );
  }

  Widget _buildBottomSection() {
    return Container(
      decoration: BoxDecoration(
        color: Styleguide.color_gray_0,
        boxShadow: [
          BoxShadow(
            color: Color(0x33000000),
            offset: Offset(0, 1),
            blurRadius: 10,
            spreadRadius: 0,
          ),
        ],
      ),
      height: 175,
      width: double.infinity,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: 8,
            ),
            Container(
              height: 56,
              child: FractionallySizedBox(
                widthFactor: 1,
                child: RaisedButton(
                  child: Text(
                    'CONTINUE WITH CURRENT SETTINGS',
                  ),
                  onPressed: () {
                    busPublish<SubscriptionModel, SubscriptionData>(
                      publisher: (data) => data.copyWith(
                        startedAt: DateTime.now(),
                        renewalAt: DateTime.now().add(Duration(days: 335)),
                        expiredAt: null,
                      ),
                    );
                    registry<Navigation>().pop();
                  },
                ),
              ),
            ),
            SizedBox(
              height: 18,
            ),
            Container(
              height: 32,
              child: FlatButton(
                  padding: EdgeInsets.all(8),
                  onPressed: () {
                    registry<AdobeRepository>()
                        .trackAppState(CancelSubscriptionScreenAdobeState());

                    registry<Navigation>().push('/profile/subscription/cancel');
                  },
                  child: Text(
                    'CANCEL SUBSCRIPTION',
                  )),
            )
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BasicScaffoldWithSliverAppBar(
      titleString: 'Review Lawn Profile',
      child: Column(
        children: [
          _buildLawnProfile(context),
          _buildCurrentPlan(context),
        ],
      ),
      bottom: _buildBottomSection(),
    );
  }
}

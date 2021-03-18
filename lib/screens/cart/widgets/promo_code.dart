import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/services/analytic/screen_state_action/subscription_flow/state.dart';
import 'package:my_lawn/widgets/bottom_dialog_widget.dart';
import 'package:my_lawn/widgets/text_input_field_widget.dart';

class PromoCodeWidget extends StatelessWidget {
  const PromoCodeWidget({
    Key key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(top: 26.0, bottom: 34),
      child: GestureDetector(
        onTap: () => showBottomSheetDialog(
          context: context,
          hasDivider: true,
          title: Padding(
            padding: const EdgeInsets.only(top: 15.0),
            child: Text(
              'Apply Promo Code',
              style: Theme.of(context).textTheme.subtitle1.copyWith(height: 1.5),
            ),
          ),
          trailing: Padding(
            padding: const EdgeInsets.only(top: 7.0),
            child: GestureDetector(
              onTap: () => Navigator.of(context).pop(),
              child: SizedBox(
                height: 32,
                width: 48,
                child: Center(
                  child: Text(
                    'CANCEL',
                    style: Theme.of(context)
                        .textTheme
                        .bodyText1
                        .copyWith(color: Styleguide.color_green_7),
                  ),
                ),
              ),
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.fromLTRB(24,10,24,32),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                TextInputField(
                  autofocus: true,
                ),
                SizedBox(height:81),
                Container(
                  height: 52,
                  child: FractionallySizedBox(
                    widthFactor: 1,
                    child: RaisedButton(
                      child: Text(
                        'APPLY',
                      ),
                      onPressed: () {
                        //TODO: add promo code from text input
                        registry<AdobeRepository>().trackAppState(
                          AddPromoCodeScreenAdobeState(promoCode: ''),
                        );
                      },
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        child: Row(
          children: [
            Image.asset(
              'assets/icons/add.png',
              height: 16,
              width: 16,
            ),
            SizedBox(width: 11),
            Text('Add Promo Code',
                style: Theme.of(context).textTheme.subtitle2.copyWith(
                    color: Styleguide.color_green_4,
                    fontWeight: FontWeight.w600,
                    height: 1.43))
          ],
        ),
      ),
    );
  }
}

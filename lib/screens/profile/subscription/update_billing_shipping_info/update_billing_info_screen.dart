import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:my_lawn/blocs/subscription/subscription_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/screens/profile/subscription/update_billing_shipping_info/divider_with_text.dart';
import 'package:my_lawn/screens/profile/subscription/update_billing_shipping_info/update_billing_info_form.dart';
import 'package:my_lawn/screens/profile/subscription/update_billing_shipping_info/payment_buttons.dart';
import 'package:my_lawn/screens/profile/subscription/update_billing_shipping_info/payment_radio_list_tile.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:my_lawn/data/subscription_data.dart';

class UpdateBillingInfoScreen extends StatefulWidget {
  @override
  UpdateBillingInfoScreenState createState() => UpdateBillingInfoScreenState();
}

class UpdateBillingInfoScreenState extends State<UpdateBillingInfoScreen> {
  int _groupValue = 0;
  bool _isUpdatingInfo = false;
  SubscriptionData _subscriptionData;

  @override
  void initState() {
    super.initState();
    _subscriptionData = registry<SubscriptionBloc>().state.data.last;
  }

  void _changeRadioButton(int value) {
    setState(() {
      _groupValue = value;
      _isUpdatingInfo = false;
    });
  }

  void _editBillingInfo() {
    setState(() {
      _groupValue = -1;
      _isUpdatingInfo = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    final _textTheme = Theme.of(context).textTheme;

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BasicScaffoldWithSliverAppBar(
        titleString: 'Update Billing Info',
        child: Column(
          children: [
            PaymentRadioListTile(
              key: Key('payment_radio_list_tile'),
              value: 0,
              groupValue: _groupValue,
              textTheme: _textTheme,
              changeRadioButton: _changeRadioButton,
              icon: _subscriptionData.ccType.iconPath,
              lastDigits: '···· ${_subscriptionData.ccLastFour}',
            ),
            DividerWithText(
              text: Text(
                'OR',
                style: _textTheme.caption.copyWith(
                  height: 1.36,
                ),
              ),
            ),
            _isUpdatingInfo
                ? PaymentButtonsRow(
                    key: Key('payment_button_row'), onTap: _editBillingInfo)
                : PaymentButtonsColumn(
                    key: Key('payment_button_column'),
                    textTheme: _textTheme,
                    onTap: _editBillingInfo,
                  ),
            if (_isUpdatingInfo)
              UpdateBillingInfoForm(
                billingAddress: _subscriptionData.billingAddress,
                shippingAddress: _subscriptionData.shippingAddress,
              ),
          ],
        ),
      ),
    );
  }
}

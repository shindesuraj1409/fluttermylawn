import 'package:flutter/material.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/data/recommendation_data.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/screens/subscription/widgets/subscription_option_card_widgets.dart';
import 'package:my_lawn/blocs/auth/login/login_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:navigation/navigation.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ChooseSubscriptionSection extends StatefulWidget {
  final Plan plan;
  final onSubscriptionOptionSelected onSelected;
  ChooseSubscriptionSection({this.plan, this.onSelected});

  @override
  _ChooseSubscriptionSectionState createState() =>
      _ChooseSubscriptionSectionState();
}

class _ChooseSubscriptionSectionState extends State<ChooseSubscriptionSection> {
  SubscriptionType _selectedSubscriptionType = SubscriptionType.annual;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BlocListener<LoginBloc, LoginState>(
      cubit: registry<LoginBloc>(),
      listener: (context, state) {
        if (state is PendingRegistrationState) {
          registry<Navigation>().push(
            '/auth/pendingregistration',
            arguments: {'email': state.email, 'regToken': state.regToken},
          );
        }
      },
      child: Container(
        color: Styleguide.nearBackground(theme),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Column(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 24),
                child: Text(
                  'Choose a subscription that works for you',
                  style: theme.textTheme.headline3,
                ),
              ),
              AnnualSubscriptionCard(
                annualPlanPrice: widget.plan.prices.annualPrice,
                annualPlanDiscountedPrice:
                    widget.plan.prices.annualDiscountedPrice,
                onSelected: (option) {
                  if (option != _selectedSubscriptionType) {
                    setState(() {
                      _selectedSubscriptionType = option;
                      widget.onSelected(option);
                    });
                  }
                },
                selectedSubscriptionOption: _selectedSubscriptionType,
              ),
              SeasonalSubscriptionCard(
                products: widget.plan.products,
                onSelected: (option) {
                  if (option != _selectedSubscriptionType) {
                    setState(() {
                      _selectedSubscriptionType = option;
                      widget.onSelected(option);
                    });
                  }
                },
                selectedSubscriptionOption: _selectedSubscriptionType,
              ),
              SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }
}

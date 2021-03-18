import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/blocs/subscription/cancel_subscription/cancel_subscription_bloc.dart';
import 'package:my_lawn/blocs/subscription/subscription_bloc.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/screens/profile/update_lawn_profile/progress_images.dart';
import 'package:my_lawn/widgets/circle_image_progress_spinner_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:my_lawn/widgets/snackbar_widget.dart';
import 'package:navigation/navigation.dart';

class CancellationCompletedScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _StateCancellationCompleted();
}

class _StateCancellationCompleted extends State<CancellationCompletedScreen> {
  CancelSubscriptionBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = registry<CancelSubscriptionBloc>();
  }

  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    final orderId = registry<SubscriptionBloc>().state.data.last.orderId;
    _bloc.add(CancelSubscriptionEvent(orderId));
  }

  String _getTitle(CancelSubscriptionState state) {
    if (state is CancelSubscriptionStateSuccess) {
      return 'YOU ARE ALL SET';
    }
    return 'HANG TIGHT';
  }

  String _getDescription(CancelSubscriptionState state) {
    if (state is CancelSubscriptionStateSuccess) {
      return 'Your subscription is canceled.';
    }
    return 'Processing cancelation';
  }

  double _getTopPadding(CancelSubscriptionState state) {
    if (state is CancelSubscriptionStateSuccess) {
      return 35;
    }
    return 24;
  }

  double _getBottomPadding(CancelSubscriptionState state) {
    if (state is CancelSubscriptionStateSuccess) {
      return 9;
    }
    return 16;
  }

  Widget _progressCancellation(CancelSubscriptionState state, ThemeData theme) {
    delayedFuture(state);
    return Padding(
      padding: const EdgeInsets.only(top: 168.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          !(state is CancelSubscriptionStateSuccess)
              ? CircleImageProgressSpinner(
                  image: 'assets/icons/shredding_machine.png')
              : CompletedImage(theme: theme),
          Padding(
            padding: EdgeInsets.only(
                top: _getTopPadding(state), bottom: _getBottomPadding(state)),
            child: Text(
              _getTitle(state),
              style: theme.textTheme.bodyText2.copyWith(
                color: theme.colorScheme.onPrimary,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 32),
            child: Text(
              _getDescription(state),
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

  Future<void> delayedFuture(CancelSubscriptionState state) {
    if (state is CancelSubscriptionStateSuccess) {
      final customerId = registry<AuthenticationBloc>().state.user.customerId;
      registry<SubscriptionBloc>().add(FindSubscription(customerId));
      return Future.delayed(Duration(seconds: 3), () {
        registry<Navigation>().popTo('/profile/subscription');
      });
    }

    return Future.value();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BasicScaffold(
      backgroundColor: theme.colorScheme.primary,
      child: BlocConsumer<CancelSubscriptionBloc, CancelSubscriptionState>(
        cubit: _bloc,
        listener: (context, state) async {
          if (state is CancelSubscriptionStateError) {
            await showSnackbar(
                context: context,
                text: 'Something went wrong, please try again later.',
                duration: Duration(
                  seconds: 3,
                ));
            return Future.delayed(Duration(seconds: 3), () {
              registry<Navigation>().popTo('/profile/subscription');
            });
          }
        },
        builder: (context, state) {
          return Center(child: _progressCancellation(state, theme));
        },
      ),
    );
  }
}

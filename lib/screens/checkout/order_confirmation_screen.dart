import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:my_lawn/blocs/checkout/confirmation/next_shipment_bloc.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/subscription_data.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:flutter/material.dart';
import 'package:my_lawn/widgets/error_and_loading_widgets.dart';

import 'package:my_lawn/widgets/product_image.dart';

import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';

import 'package:navigation/navigation.dart';

class OrderConfirmationArguments extends Equatable {
  final String orderId;
  final String customerId;

  OrderConfirmationArguments({
    this.orderId,
    this.customerId,
  });

  @override
  List<Object> get props => [orderId, customerId];
}

class OrderConfirmationScreen extends StatefulWidget {
  @override
  _OrderConfirmationScreenState createState() =>
      _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen>
    with RouteMixin<OrderConfirmationScreen, OrderConfirmationArguments> {
  String _orderId;
  String _customerId;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if (_orderId == null && _customerId == null) {
      _orderId = routeArguments.orderId;
      _customerId = routeArguments.customerId;
    }
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return BasicScaffoldWithAppBar(
      appBarElevation: 0,
      leading: IconButton(
        icon: Icon(
          Icons.close,
          color: theme.colorScheme.onBackground,
        ),
        onPressed: () => registry<Navigation>().setRoot('/home'),
      ),
      child: Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          _OrderIdSection(_orderId),
          Expanded(
            child: Container(
              color: Styleguide.nearBackground(theme),
              padding: const EdgeInsets.fromLTRB(16, 32, 16, 0),
              child: _NextShipmentSection(_customerId),
            ),
          ),
        ],
      ),
      bottom: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.background,
          boxShadow: const [
            BoxShadow(
              color: Color.fromARGB(0x33, 0x00, 0x00, 0x00),
              blurRadius: 5.0,
              spreadRadius: -1.0,
              offset: Offset(
                0.0,
                3.0,
              ),
            ),
            BoxShadow(
              color: Color.fromARGB(0x1E, 0x00, 0x00, 0x00),
              blurRadius: 18.0,
              spreadRadius: 0.0,
              offset: Offset(
                0.0,
                1.0,
              ),
            ),
            BoxShadow(
              color: Color.fromARGB(0x23, 0x00, 0x00, 0x00),
              blurRadius: 10.0,
              spreadRadius: 0.0,
              offset: Offset(
                0.0,
                6.0,
              ),
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: FractionallySizedBox(
            widthFactor: 1,
            child: RaisedButton(
              child: Text('RETURN HOME'),
              onPressed: () {
                registry<Navigation>().setRoot('/home');
              },
            ),
          ),
        ),
      ),
    );
  }
}

class _OrderIdSection extends StatelessWidget {
  final String orderId;
  const _OrderIdSection(this.orderId);

  final confirmationText =
      'Your order confirmation, complete with tracking details, '
      'will soon be arriving in your inbox.';

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      color: theme.colorScheme.background,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Row(
            mainAxisSize: MainAxisSize.min,
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.asset(
                'assets/icons/order_completed.png',
                width: 32,
              ),
              SizedBox(width: 8),
              Text(
                'Thank You',
                style: theme.textTheme.headline1,
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.only(top: 16),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  'Order Number',
                  style: theme.textTheme.subtitle2
                      .copyWith(fontWeight: FontWeight.w600),
                ),
                SizedBox(width: 8),
                Text(
                  '#${orderId}',
                  style: theme.textTheme.subtitle2,
                  key: Key('order_number'),
                ),
              ],
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 32),
            child: Text(
              confirmationText,
              textAlign: TextAlign.center,
              style: theme.textTheme.subtitle2,
            ),
          ),
        ],
      ),
    );
  }
}

class _NextShipmentSection extends StatefulWidget {
  final String customerId;
  const _NextShipmentSection(this.customerId);

  @override
  __NextShipmentSectionState createState() => __NextShipmentSectionState();
}

class __NextShipmentSectionState extends State<_NextShipmentSection> {
  NextShipmentBloc _bloc;

  @override
  void initState() {
    super.initState();
    _bloc = registry<NextShipmentBloc>();
    _bloc.add(NextShipmentEvent(widget.customerId));
  }

  void _retryRequest() {
    _bloc.add(NextShipmentEvent(widget.customerId));
  }

  String _formatDate(DateTime dateTime) =>
      DateFormat('EEE MMM. d').format(dateTime);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return BlocBuilder<NextShipmentBloc, NextShipmentState>(
      cubit: _bloc,
      builder: (context, state) {
        if (state is NextShipmentLoading || state is NextShipmentInitial) {
          return Center(
            child: ProgressSpinner(),
          );
        } else if (state is NextShipmentError) {
          return ErrorMessage(
            errorMessage: '${state.errorMessage}',
            retryRequest: _retryRequest,
          );
        } else if (state is NextShipmentSuccess) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('NEXT SHIPMENT'),
              SizedBox(height: 4),
              Text(
                _formatDate(state.firstShipmentDate),
                style: theme.textTheme.headline3,
                key: Key('next_shipment_date'),
              ),
              SizedBox(height: 8),
              Text(
                'We’ll send you SMS and push notifications on your shipments.',
                style: theme.textTheme.bodyText2,
              ),
              FlatButton(
                padding: EdgeInsets.zero,
                onPressed: () =>
                    registry<Navigation>().push('/profile/settings'),
                child: Text(
                  'Change settings',
                ),
              ),
              _ShipmentGrid(
                products: state.products,
                firstShipmentDate: state.firstShipmentDate,
              ),
            ],
          );
        } else {
          throw UnimplementedError('Incorrect state reached : $state');
        }
      },
    );
  }
}

class _ShipmentGrid extends StatelessWidget {
  final List<ShipmentProduct> products;
  final DateTime firstShipmentDate;
  const _ShipmentGrid({
    @required this.products,
    @required this.firstShipmentDate,
  });

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GridView.builder(
        itemCount: products.length,
        padding: const EdgeInsets.symmetric(vertical: 8),
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          mainAxisSpacing: 8,
          crossAxisSpacing: 8,
        ),
        itemBuilder: (context, index) {
          return _ShipmentCard(products[index]);
        },
      ),
    );
  }
}

class _ShipmentCard extends StatelessWidget {
  final ShipmentProduct product;
  const _ShipmentCard(this.product);

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                  ProductImage(
                    productImageUrl: product.thumbnailImage ?? 'assets/images/product_placeholder.png',
                    width: 56,
                    height: 84,
                    fit: BoxFit.cover,
                  ),
                SizedBox(width: 12),
                _ProductBag(
                  coverage: product.coverage ?? 0,
                  qty: product.qty ?? 0,
                ),
              ],
            ),
            Flexible(
              flex: 1,
              child: Text(
                product.productName,
                overflow: TextOverflow.ellipsis,
                maxLines: 2,
                key: Key(product.productName
                    .toLowerCase()
                    .replaceAll(RegExp(r'[^\w]'), '_')),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ProductBag extends StatelessWidget {
  final int coverage;
  final int qty;
  const _ProductBag({
    @required this.coverage,
    @required this.qty,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Stack(
        alignment: Alignment.center,
        children: [
          Image.asset(
            coverage <= 5000
                ? 'assets/icons/bag_small.png'
                : 'assets/icons/bag_large.png',
            color: theme.colorScheme.onBackground,
            height: coverage <= 5000 ? 32 : 40,
            key: Key('bag_image'),
          ),
          Text(
            'x${qty}',
            style: theme.textTheme.subtitle2.copyWith(
              color: theme.colorScheme.onBackground,
              fontWeight: FontWeight.w600,
            ),
            key: Key('bag_text'),
          ),
        ],
      ),
    );
  }
}

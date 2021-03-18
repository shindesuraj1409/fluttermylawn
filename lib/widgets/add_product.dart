import 'dart:async';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/activity/activity_bloc.dart';
import 'package:my_lawn/blocs/activity/activity_event.dart';
import 'package:my_lawn/blocs/activity/activity_state.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/activity_data.dart';
import 'package:my_lawn/data/activity_type.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/screens/home/actions/widgets/date_form_field.dart';
import 'package:my_lawn/screens/home/actions/widgets/save_activity_button.dart';
import 'package:my_lawn/services/analytic/actions/localytics/product_events.dart';
import 'package:my_lawn/services/analytic/localytics_service.dart';
import 'package:my_lawn/services/analytic/screen_state_action/calendar_screen/action.dart';
import 'package:my_lawn/services/analytic/screen_state_action/calendar_screen/state.dart';
import 'package:my_lawn/widgets/product_image.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:my_lawn/widgets/snackbar_widget.dart';
import 'package:navigation/navigation.dart';

import 'login_widget.dart';

class AddProduct extends StatefulWidget {
  @override
  _AddProductScreenState createState() => _AddProductScreenState();
}

class _AddProductScreenState extends State<AddProduct>
    with RouteMixin<AddProduct, Product> {
  ThemeData _theme;
  TextEditingController textEditingController;
  ActivityBloc _bloc;
  Product _product;
  StreamSubscription blocSubscription;

  DateTime _selectedDate = DateTime.now();
  @override
  void initState() {
    super.initState();
    textEditingController = TextEditingController();
    _bloc = registry<ActivityBloc>();

    blocSubscription = _bloc.listen((state) {
      if (state is SuccessActivityState) {
        registry<Navigation>().popTo('/home').then(
              (_) => showSnackbar(
                context: context,
                text: 'Added to Calendar',
                duration: Duration(seconds: 2),
              ),
            );
      }
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _product = routeArguments;
    _theme = Theme.of(context);

    registry<AdobeRepository>().trackAppState(
      AddProductScreenAdobeState(
        productId: _product.parentSku,
      ),
    );
  }

  void _tagSaveEvent() {
    registry<LocalyticsService>().tagEvent(AddProductEvent(
      _product.categoryList.join(', '),
      _product.name,
    ));

    registry<AdobeRepository>().trackAppActions(
      ProductAddedScreenAdobeAction(
        productId: _product.parentSku,
      ),
    );
  }

  @override
  void dispose() {
    textEditingController.dispose();
    blocSubscription.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    Widget _headWidget() => Container(
          margin: EdgeInsets.fromLTRB(16, 0, 16, 0),
          child: Row(
            children: <Widget>[
              Text('Add Product',
                  key: Key('add_product'),
                  style: _theme.textTheme.headline1.copyWith(
                    fontSize: 28,
                  )),
              Spacer(),
              Image.asset(
                'assets/icons/add_product.png',
                key: Key('add_product_image'),
                height: 50,
                width: 50,
              )
            ],
          ),
        );

    Widget _contentWidget() => Container(
        margin: EdgeInsets.only(top: 20, left: 20, right: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            ProductImage(
              height: 100,
              width: 100,
              productImageUrl: _product.imageUrl,
            ),
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 16),
                child: Text(
                  _product.name,
                  style: _theme.textTheme.subtitle1
                      .copyWith(fontWeight: FontWeight.w600),
                  textAlign: TextAlign.start,
                  key: Key('product_name'),
                ),
              ),
            )
          ],
        ));

    Widget _formWidget() => Container(
          margin: EdgeInsets.fromLTRB(16, 16, 16, 0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: <Widget>[
              Container(
                margin: EdgeInsets.fromLTRB(0, 3, 0, 3),
                decoration: BoxDecoration(
                  color: Styleguide.color_gray_1,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: DateFormField(
                  selectedItem: _selectedDate,
                  onValueSelected: (value) {
                    setState(() {
                      _selectedDate = value;
                    });
                  },
                ),
              ),
              Container(
                margin: EdgeInsets.fromLTRB(0, 3, 0, 3),
                decoration: BoxDecoration(
                  color: Styleguide.color_gray_1,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Container(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(minHeight: 136),
                    child: TextField(
                        controller: textEditingController,
                        onChanged: (value) => setState(() {}),
                        maxLength: 280,
                        maxLengthEnforced: true,
                        maxLines: null,
                        keyboardType: TextInputType.text,
                        key: Key('text_box'),
                        decoration: InputDecoration(
                          border: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          disabledBorder: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          hintText: 'Any notes?',
                          contentPadding: EdgeInsets.fromLTRB(16, 20, 30, 10),
                          hintStyle: _theme.textTheme.subtitle1,
                          helperStyle: TextStyle(color: Colors.transparent),
                        )),
                  ),
                ),
              ),
              Padding(
                  padding: EdgeInsets.only(top: 4.0, right: 16),
                  child: Text(
                    '${textEditingController.text.length}/280 Characters',
                    style: _theme.textTheme.caption.copyWith(fontSize: 10),
                    key: Key('characters_count'),
                  ))
            ],
          ),
        );

    /** 
     * 
     * 
     *                  Uncomment this when the Frequently
     *                  Bought Together feature is implemented 
     * 
     * 
     * */
    // Widget _bottomFeeds() => Container(
    //       margin: EdgeInsets.all(15),
    //       height: 350,
    //       child: Column(
    //         crossAxisAlignment: CrossAxisAlignment.start,
    //         mainAxisAlignment: MainAxisAlignment.start,
    //         children: <Widget>[
    //           Padding(
    //             padding: EdgeInsets.all(10),
    //             child: Text(
    //               'Frequently Bought Together',
    //               style: _theme.textTheme.headline4,
    //             ),
    //           ),
    //           Expanded(
    //             child: ListView.builder(
    //                 scrollDirection: Axis.horizontal,
    //                 itemCount: 10,
    //                 shrinkWrap: true,
    //                 itemBuilder: (BuildContext context, int index) {
    //                   return Container(
    //                     margin: EdgeInsets.all(5),
    //                     decoration: _radioDecoration(Colors.white),
    //                     padding: const EdgeInsets.all(16),
    //                     width: 250,
    //                     height: 254,
    //                     child: Stack(
    //                       children: <Widget>[
    //                         Column(
    //                           mainAxisAlignment: MainAxisAlignment.start,
    //                           crossAxisAlignment: CrossAxisAlignment.center,
    //                           mainAxisSize: MainAxisSize.min,
    //                           children: <Widget>[
    //                             Image.asset(
    //                               'assets/images/kill_switch.png',
    //                               width: 100,
    //                               height: 100,
    //                             ),
    //                             Padding(
    //                               padding: const EdgeInsets.only(top: 16.0),
    //                               child: Text(
    //                                 'Scotts® Turf Builder® Thick\'R LawnTM Tall Fescue Mix',
    //                                 style: _theme.textTheme.subtitle1,
    //                                 textAlign: TextAlign.start,
    //                               ),
    //                             ),
    //                           ],
    //                         ),
    //                         Align(
    //                           alignment: Alignment.bottomCenter,
    //                           child: Container(
    //                             width: double.infinity,
    //                             padding: EdgeInsets.all(10),
    //                             decoration: BoxDecoration(
    //                                 border: Border.all(
    //                                     color: _theme.primaryColor, width: 1.0),
    //                                 borderRadius:
    //                                     BorderRadius.all(Radius.circular(6))),
    //                             child: Text(
    //                               'VIEW DETAILS',
    //                               textAlign: TextAlign.center,
    //                               style: _theme.textTheme.button.copyWith(
    //                                 color: _theme.primaryColor,
    //                               ),
    //                             ),
    //                           ),
    //                         )
    //                       ],
    //                     ),
    //                   );
    //                 }),
    //           ),
    //         ],
    //       ),
    //     );

    return GestureDetector(
      onTap: () => FocusScope.of(context).unfocus(),
      child: BlocListener<AuthenticationBloc, AuthenticationState>(
        cubit: registry<AuthenticationBloc>(),
        listenWhen: (prev, current) {
          return prev.isGuest && current.isLogggedIn;
        },
        listener: (context, current) {
          saveActivity();
        },
        child: BasicScaffoldWithSliverAppBar(
          isNotUsingWillPop: true,
          slivers: [
            SliverToBoxAdapter(child: _headWidget()),
            SliverToBoxAdapter(child: _contentWidget()),
            SliverToBoxAdapter(child: _formWidget()),
          ],
          bottom: SaveActivityButton(
            key: Key('save_button'),
            onTap: () {
              _tagSaveEvent();

              final isGuest = registry<AuthenticationBloc>().state.isGuest;
              if (isGuest) {
                buildLoginBottomCard(context);
              } else {
                saveActivity();
              }
            },
          ),
        ),
      ),
    );
  }

  void saveActivity() {
    _bloc.add(
      SaveActivityEvent(
        ActivityData(
          productId: _product.sku,
          activityType: ActivityType.userAddedProduct,
          applicationWindow: ProductApplicationWindow(startDate: _selectedDate),
          activityDate: _selectedDate,
          description: textEditingController.text,
          childProducts: [_product],
        ),
      ),
    );
  }

  void returnToHome() {
    registry<Navigation>().popToRoot();
  }
}

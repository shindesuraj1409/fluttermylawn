import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/plp_bloc/search/plp_search_bloc.dart';
import 'package:my_lawn/blocs/plp_bloc/search/plp_search_event.dart';
import 'package:my_lawn/blocs/plp_bloc/search/plp_search_state.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/mixins/route_arguments_mixin.dart';
import 'package:my_lawn/screens/plp/widgets/plp_tile_widget.dart';
import 'package:my_lawn/screens/plp/widgets/search_icon_button.dart';
import 'package:my_lawn/data/product/product_data.dart';
import 'package:my_lawn/widgets/error_and_loading_widgets.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:navigation/navigation.dart';

class PlpSearchScreen extends StatefulWidget {
  PlpSearchScreen();

  @override
  _PlpSearchScreenState createState() => _PlpSearchScreenState();
}

class _PlpSearchScreenState extends State<PlpSearchScreen>
    with RouteMixin<PlpSearchScreen, List<Product>> {
  List<Product> productList;
  PlpSearchBloc bloc;
  TextEditingController textController;

  @override
  void initState() {
    textController = TextEditingController();
    bloc = PlpSearchBloc();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    productList = routeArguments;
    bloc.add(PlpSearchInitialEvent(productList: productList));
  }

  @override
  Widget build(BuildContext context) {
    return BasicScaffold(
      child: Container(
        color: Styleguide.color_gray_1,
        child: SafeArea(
          bottom: false,
          child: Container(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              children: [
                _buildListTitleBar(context),
                Expanded(
                  child: _buildListView(context),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  ListTile _buildListTitleBar(BuildContext context) {
    return ListTile(
      title: _buildTitle(),
      trailing: _buildTrailing(context),
    );
  }

  Container _buildTitle() {
    return Container(
      color: Styleguide.color_gray_0,
      child: TextField(
        controller: textController,
        key: Key('search_input'),
        autofocus: true,
        onChanged: (value) {
          bloc.add(
            PlpSearchUpdateEvent(value),
          );
        },
        decoration: InputDecoration(
          contentPadding: EdgeInsets.only(
            left: 13,
            top: 14,
            bottom: 14,
          ),
          filled: true,
          fillColor: Styleguide.color_gray_0,
          hintText: 'Search Products',
          hintStyle: TextStyle(
            color: Styleguide.color_gray_9,
          ),
          icon: null,
          prefixIcon: SearchIconButton(),
          border: InputBorder.none,
          enabledBorder: InputBorder.none,
          focusedBorder: InputBorder.none,
        ),
      ),
    );
  }

  GestureDetector _buildTrailing(BuildContext context) {
    return GestureDetector(
      onTap: () {
        bloc.close();
        registry<Navigation>().pop();
      },
      child: Text(
        'CANCEL',
        style: TextStyle(
          color: Styleguide.color_green_4,
          fontWeight: FontWeight.bold,
          fontSize: 12,
        ),
      ),
    );
  }

  Widget _buildListView(BuildContext context) {
    return BlocBuilder<PlpSearchBloc, PlpSearchState>(
      cubit: bloc,
      builder: (context, state) {
        if (state is PlpSearchUpdatedState) {
          if (state.productList == null || state.productList.isEmpty) {
            return Container(
              child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Image.asset(
                      'assets/icons/not_found.png',
                      key: Key('not_found_icon'),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 20),
                      child: Text(
                        'No Results found',
                        style: Theme.of(context).textTheme.headline1,
                      ),
                    ),
                    Text(
                      'Please try different keywords.',
                      style: Theme.of(context).textTheme.bodyText2,
                    ),
                    SizedBox(
                      height: 150,
                    )
                  ],
                ),
              ),
            );
          }
          return ListView.builder(
              shrinkWrap: true,
              physics: BouncingScrollPhysics(),
              itemCount: state.productList.length,
              itemBuilder: (ctx, index) {
                return PlpTileWidget(
                  index: index,
                  showLeading: true,
                  showTrailing: false,
                  showProduct: true,
                  isTitleCentered: false,
                  isLeadingNetworkImage: true,
                  isTrailingNetworkImage: false,
                  isSubtitle: true,
                  isProductList: true,
                  title: state.productList[index].name,
                  subtitle: '', // TODO Subscription data implementation
                  leadingIcon: state.productList[index].imageUrl,
                  trailingIcon: null,
                  color: Styleguide.color_gray_0,
                  elevation: 0,
                  listTileVerticalPadding: 16,
                  onTapMethod: () {
                    registry<Navigation>().push('/product/detail',
                        arguments: state.productList[index]);
                  },
                  cardVerticalPadding: 0,
                  cardHorizontalPadding: 0,
                  cardBorderRadius: 0,
                  trailingPadding: 0,
                  titleLeftPadding: 12,
                  titleTopPadding: 0,
                  titleBottomPadding: 8,
                  subTitleLeftPadding: 16,
                  subTitleTopPadding: 0,
                  subTitleBottomPadding: 0,
                  leadingContainerHorizontalPadding: 0,
                  leadingContainerVerticalPadding: 0,
                  trailingContainerHorizontalPadding: 0,
                  trailingContainerVerticalPadding: 0,
                );
              });
        }
        if (state is PlpSearchErrorState) {
          return ErrorMessage(
              errorMessage: '${state.errorMessage}',
              retryRequest: () =>
                  bloc.add(PlpSearchUpdateEvent(textController.text)));
        }
        if (state is PlpSearchLoadingState) {
          return Container(
              child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                ProgressSpinner(),
                SizedBox(
                  height: 150,
                )
              ],
            ),
          ));
        }
        return Container();
      },
    );
  }
}

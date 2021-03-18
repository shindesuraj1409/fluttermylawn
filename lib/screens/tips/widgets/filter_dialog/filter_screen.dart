import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intersperse/intersperse.dart';
import 'package:my_lawn/blocs/tips_bloc/tips_bloc.dart';
import 'package:my_lawn/blocs/tips_bloc/tips_event.dart';
import 'package:my_lawn/blocs/tips_bloc/tips_filter_bloc/tips_filter_bloc.dart';
import 'package:my_lawn/blocs/tips_bloc/tips_filter_bloc/tips_filter_event.dart';
import 'package:my_lawn/blocs/tips_bloc/tips_filter_bloc/tips_filter_state.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/screens/tips/widgets/filter_dialog/expanded_filter_block.dart';
import 'package:my_lawn/services/analytic/screen_state_action/tips_screen/state.dart';
import 'package:navigation/navigation.dart';

class FilterScreen extends StatelessWidget {
  void sendAdobeState(List<String> filter) {
    var filters = '';

    filter?.forEach((element) {
      filters += '$element,';
    });

    registry<AdobeRepository>()
        .trackAppState(TipsScreenAdobeState(filters: filters));
  }

  @override
  Widget build(BuildContext context) {
    var filterList = [];
    var count = 0;
    var filter;
    final textTheme = Theme.of(context).textTheme;
    return BlocBuilder<TipsFilterBloc, TipsFilterState>(
      cubit: registry<TipsFilterBloc>(),
      builder: (context, state) {
        if (state is TipsFilterOpened) {
          filterList = state.filter.filters;
          count = state.filter.filteredArticles.length;
          filter = state.filter;
        }
        if (state is TipsBeingFiltered) {
          filterList = state.filter.filters;
          count = state.filter.filteredArticles.length;
          filter = state.filter;
        }
        if (state is TipsFiltered) {
          filterList = state.filter.filters;
          count = state.filter.filteredArticles.length;
          filter = state.filter;
        }

        return Container(
          height: MediaQuery.of(context).size.height - 50,
          child: Column(
            children: [
              Center(
                child: Container(
                  margin: const EdgeInsets.only(top: 13),
                  height: 4,
                  width: 40,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(2),
                      color: Styleguide.color_gray_2),
                ),
              ),
              Container(
                padding: const EdgeInsets.only(
                    top: 17, left: 24.0, right: 24.0, bottom: 20),
                decoration: BoxDecoration(
                  border: Border(
                    bottom:
                        BorderSide(color: Styleguide.color_gray_2, width: 1.0),
                  ),
                ),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      'Filters',
                      style: textTheme.subtitle1,
                    ),
                    InkWell(
                      onTap: () {
                        registry<TipsFilterBloc>()
                            .add(TipsFilterCanceled(filter: filter));
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'CANCEL',
                        style: textTheme.bodyText2.copyWith(
                          color: Styleguide.color_green_4,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Container(
                  child: ListView(
                    children: [
                      ...intersperse(
                        Container(
                          margin: const EdgeInsets.only(top: 10.0),
                          padding: const EdgeInsets.symmetric(horizontal: 24.0),
                          child: Divider(
                            color: Styleguide.color_gray_2,
                            thickness: 1.0,
                          ),
                        ),
                        filterList
                            .map((e) => ExpandedFilterBlock(
                                  filter: e,
                                ))
                            .toList(),
                      )
                    ],
                  ),
                ),
              ),
              Container(
                margin: const EdgeInsets.only(top: 10.0),
                width: double.infinity,
                padding: const EdgeInsets.symmetric(vertical: 24.0),
                decoration: BoxDecoration(color: Colors.white, boxShadow: [
                  BoxShadow(
                    color: Color(0x33000000),
                    offset: Offset(0, 3),
                    blurRadius: 5.0,
                    spreadRadius: -1,
                  ),
                  BoxShadow(
                    color: Color(0x1e000000),
                    offset: Offset(0, 1),
                    blurRadius: 18.0,
                    spreadRadius: 0.0,
                  ),
                  BoxShadow(
                    color: Color(0x1e000000),
                    offset: Offset(0, 1),
                    blurRadius: 18.0,
                    spreadRadius: 0.0,
                  ),
                ]),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Container(
                      width: double.infinity,
                      margin: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: RaisedButton(
                          onPressed: count == 0
                              ? null
                              : () {
                                  List<String> appliedFilters;
                                  state is TipsFilterOpened
                                      ? appliedFilters =
                                          state.filter.partialFilters
                                      : state is TipsBeingFiltered
                                          ? appliedFilters =
                                              state.filter.partialFilters
                                          : appliedFilters = [];
                                  registry<TipsFilterBloc>()
                                      .add(ShowTipsFiltered(filter: filter));
                                  registry<TipsBloc>()
                                      .add(TipsFilter(appliedFilters));
                                  registry<Navigation>().pop();

                                  sendAdobeState(appliedFilters);
                                },
                          child: Container(
                            child: Text(
                              'SHOW $count ARTICLES',
                            ),
                          )),
                    ),
                    SizedBox(
                      height: 5.0,
                    ),
                    Container(
                      height: 45.0,
                      child: FlatButton(
                        onPressed: () {
                          registry<TipsFilterBloc>()
                              .add(TipsFilterCleared(filter: filter));
                          registry<TipsBloc>().add(TipsClearedFilter());
                          registry<Navigation>().pop();
                        },
                        child: Text(
                          'Clear Filters',
                        ),
                      ),
                    ),
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }
}

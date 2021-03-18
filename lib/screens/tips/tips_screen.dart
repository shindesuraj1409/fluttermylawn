import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/tips_bloc/article_bloc/article_bloc_bloc.dart';

import 'package:my_lawn/blocs/tips_bloc/tips_bloc.dart';
import 'package:my_lawn/blocs/tips_bloc/tips_event.dart';
import 'package:my_lawn/blocs/tips_bloc/tips_filter_bloc/tips_filter_bloc.dart';
import 'package:my_lawn/blocs/tips_bloc/tips_filter_bloc/tips_filter_event.dart';
import 'package:my_lawn/blocs/tips_bloc/tips_filter_bloc/tips_filter_state.dart';
import 'package:my_lawn/blocs/tips_bloc/tips_state.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/data/tips/filter_data.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/widgets/error_and_loading_widgets.dart';
import 'package:my_lawn/screens/tips/widgets/filter_dialog/filter_screen.dart';
import 'package:my_lawn/screens/tips/widgets/tips_article_carousel.dart';
import 'package:my_lawn/screens/tips/widgets/tips_article_widget.dart';
import 'package:my_lawn/services/analytic/screen_state_action/tips_screen/state.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:navigation/navigation.dart';

class TipsScreen extends StatefulWidget {
  final String deepLinkPath;

  const TipsScreen({
    Key key,
    this.deepLinkPath,
  }) : super(key: key);

  @override
  _TipsScreenState createState() => _TipsScreenState();
}

class _TipsScreenState extends State<TipsScreen>
    with TickerProviderStateMixin, AutomaticKeepAliveClientMixin<TipsScreen> {
  final List<String> _tabs = <String>['LATEST', 'ARTICLES', 'VIDEOS'];
  bool loading = false;
  final TipsBloc _bloc = registry<TipsBloc>();
  TabController _tabController;
  final _scrollController = ScrollController();
  int _tipsCategoryIndex;
  final ArticleBloc _articleBloc = registry<ArticleBloc>();
  String _deepLinkPath;

  @override
  void initState() {
    super.initState();
    _deepLinkPath = widget.deepLinkPath;
    _scrollController.addListener(() {
      if (_scrollController.position.atEdge) {
        if (_scrollController.position.pixels > 0) {
          _onScroll();
          setState(() {
            loading = true;
          });
        }
      }
    });
    _tipsCategoryIndex = 0;
    _bloc.add(InitialTipsFetch());
    _bloc.listen((state) {
      if (state is TipsLoadSuccess) {
        loading = false;
      }
      if (state is FiltersFetched) {
        final articles = state.articles;
        registry<TipsFilterBloc>().add((TipsFilterInitialLoad(
          filter: Filter(articles: articles, filters: state.filters),
        )));
      }
    });
    if (_deepLinkPath != null && _deepLinkPath.isNotEmpty) {
      _articleBloc.add(ArticleFetch(_deepLinkPath));
    }
    _tabController = TabController(
      initialIndex: 0,
      length: _tabs.length,
      vsync: this,
    );
    registry<AdobeRepository>()
        .trackAppState(TipsScreenAdobeState(filters: ''));
  }

  @override
  void dispose() {
    _tabController?.dispose();
    _scrollController?.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (registry<TipsFilterBloc>().state != TipsFiltered()) {
      switch (_tipsCategoryIndex) {
        case 0:
          _bloc.add(LatestTipsFetch());
          break;
        case 1:
          _bloc.add(ArticleTipsFetch());
          break;
        case 2:
          _bloc.add(VideoTipsFetch());
          break;
        default:
      }
    }
  }

  void _selectNewTab(int index) {
    setState(() {
      _bloc.add(TabChanged(tab: index));
      _tipsCategoryIndex = index;
    });
  }

  void showFilterModal(state) {
    registry<TipsFilterBloc>().add(
      TipsFilterInitialLoad(
        filter: Filter(
          filters: state.filters,
          appliedFilters: state.appliedFilters,
        ),
      ),
    );
    showModalBottomSheet(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(25.0),
            topRight: const Radius.circular(25.0),
          ),
        ),
        context: context,
        isScrollControlled: true,
        isDismissible: true,
        builder: (BuildContext context) {
          return FilterScreen();
        });
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final _theme = Theme.of(context);

    return BlocConsumer<ArticleBloc, ArticleBlocState>(
      cubit: _articleBloc,
      listener: (context, articleState) {
        if (articleState is ArticleBlocSuccess) {
          registry<Navigation>()
              .push('/tips/detail', arguments: articleState.article);
          _articleBloc.add(ArticleOpened());
        }
      },
      builder: (context, articleState) {
        return BlocBuilder<TipsBloc, TipsState>(
          cubit: _bloc,
          builder: (context, state) {
            if (state is TipsInitial) {
              return Container(
                child: Center(
                  child: ProgressSpinner(),
                ),
              );
            }
            if (state is TipsLoadInProgress) {
              return Container(
                child: Center(
                  child: ProgressSpinner(),
                ),
              );
            }
            if (state is TipsLoadFailure) {
              return Center(
                child: ErrorMessage(
                  errorMessage: '${state.errorMessage}',
                  retryRequest: () => _bloc.add(InitialTipsFetch()),
                ),
              );
            }
            if (state is TipsLoadSuccess) {
              return BasicScaffold(
                allowBackNavigation: false,
                child: CustomScrollView(
                  physics: ScrollPhysics(),
                  controller: _scrollController,
                  slivers: [
                    SliverList(
                      delegate: SliverChildListDelegate.fixed(
                        [
                          Container(
                            margin: const EdgeInsets.only(
                                top: 64.0, left: 16.0, right: 16.0),
                            child: Text(
                              'Lawn Tips',
                              style: _theme.textTheme.headline1,
                            ),
                          ),
                          Container(
                            margin: const EdgeInsets.symmetric(
                                horizontal: 16.0, vertical: 14.0),
                            child: Text(
                              'Ideas, inspirations, and other tips for your lawn',
                              style: _theme.textTheme.headline6.copyWith(
                                fontWeight: FontWeight.w300,
                              ),
                            ),
                          ),
                          TipsCarouselWidget(
                            tipsCarouselData: state.heroTips,
                          ),
                          SizedBox(
                            height: 28.0,
                          ),
                        ],
                      ),
                    ),
                    SliverToBoxAdapter(
                      child: DefaultTabController(
                        length: _tabs.length,
                        child: Column(
                          children: [
                            Container(
                              height: 36.0,
                              margin:
                                  const EdgeInsets.symmetric(horizontal: 16.0),
                              child: Row(
                                children: <Widget>[
                                  Expanded(
                                    child: TabBar(
                                      controller: _tabController,
                                      onTap: (index) => _selectNewTab(index),
                                      isScrollable: true,
                                      indicator: UnderlineTabIndicator(
                                        borderSide: BorderSide(
                                            color: Styleguide.color_green_5,
                                            width: 2.0),
                                      ),
                                      labelColor: Styleguide.color_green_5,
                                      indicatorColor: Styleguide.color_green_5,
                                      unselectedLabelColor:
                                          _theme.colorScheme.onBackground,
                                      labelStyle: _theme.textTheme.bodyText1
                                          .copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Styleguide.color_green_5),
                                      tabs: _tabs
                                          .map((String e) => Tab(
                                                text: e,
                                              ))
                                          .toList(),
                                    ),
                                  ),
                                  InkWell(
                                    onTap: () => showFilterModal(state),
                                    child: Container(
                                      padding: const EdgeInsets.symmetric(
                                          horizontal: 19.0, vertical: 8.0),
                                      decoration: BoxDecoration(
                                          border: Border.all(
                                            color: Styleguide.color_green_7,
                                            width: 1.0,
                                          ),
                                          borderRadius: const BorderRadius.all(
                                              Radius.circular(4.0))),
                                      child: BlocBuilder<TipsFilterBloc,
                                          TipsFilterState>(
                                        cubit: registry<TipsFilterBloc>(),
                                        builder: (context, state) {
                                          var count = 0;
                                          if (state is TipsFiltered) {
                                            count = state
                                                .filter.appliedFilters.length;
                                          }
                                          return Text(
                                            'Filters ${count != 0 ? count : ''}',
                                            style: _theme.textTheme.bodyText1
                                                .copyWith(
                                              fontWeight: FontWeight.w600,
                                              color: Styleguide.color_green_5,
                                            ),
                                          );
                                        },
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            GestureDetector(
                              onHorizontalDragEnd: (details) {
                                var newIndex = _tipsCategoryIndex;
                                if (details.primaryVelocity < 0) {
                                  if (_tipsCategoryIndex < _tabs.length - 1) {
                                    newIndex = _tipsCategoryIndex += 1;
                                    _tabController.animateTo(newIndex,
                                        duration: Duration(milliseconds: 500),
                                        curve: Curves.easeIn);
                                    _selectNewTab(newIndex);
                                  }
                                } else {
                                  if (_tipsCategoryIndex > 0) {
                                    newIndex = _tipsCategoryIndex -= 1;
                                    _tabController.animateTo(newIndex,
                                        duration: Duration(milliseconds: 200),
                                        curve: Curves.easeIn);
                                    _selectNewTab(newIndex);
                                  }
                                }
                              },
                              child: Padding(
                                  padding: const EdgeInsets.only(top: 32.0),
                                  child: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    key: Key('$_tipsCategoryIndex'),
                                    children: [
                                      if (_tipsCategoryIndex == 0)
                                        ...state.latest
                                            .map((e) => TipsListElement(
                                                tipsListModel: e))
                                            .toList(),
                                      if (_tipsCategoryIndex == 1)
                                        ...state.articles
                                            .map((e) => TipsListElement(
                                                tipsListModel: e))
                                            .toList(),
                                      if (_tipsCategoryIndex == 2)
                                        ...state.videos
                                            .map((e) => TipsListElement(
                                                tipsListModel: e))
                                            .toList(),
                                      if ((_tipsCategoryIndex == 0 &&
                                              state.latest.isNotEmpty) ||
                                          (_tipsCategoryIndex == 1 &&
                                              state.articles.isNotEmpty) ||
                                          (_tipsCategoryIndex == 2 &&
                                              state.videos.isNotEmpty))
                                        loading && !state.hasReachedMax
                                            ? Container(
                                                key: Key('loading'),
                                                height: 80,
                                                child: Center(
                                                    child: ProgressSpinner()),
                                              )
                                            : !state.hasReachedMax
                                                ? Container(
                                                    height: 80,
                                                  )
                                                : Container(),
                                      if ((_tipsCategoryIndex == 0 &&
                                              state.latest.isEmpty) ||
                                          (_tipsCategoryIndex == 1 &&
                                              state.articles.isEmpty) ||
                                          (_tipsCategoryIndex == 2 &&
                                              state.videos.isEmpty))
                                        Container(
                                          height: 300,
                                          decoration: BoxDecoration(),
                                          child: Center(
                                            child: Text(
                                                'NO ${_tabs[_tipsCategoryIndex]}'),
                                          ),
                                        ),
                                    ],
                                  )),
                            )
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              );
            }
            return Container();
          },
        );
      },
    );
  }

  @override
  bool get wantKeepAlive => true;
}

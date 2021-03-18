import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:my_lawn/blocs/calendar/calendar_bloc.dart';
import 'package:my_lawn/blocs/calendar/calendar_event.dart';
import 'package:my_lawn/blocs/calendar/calendar_state.dart';
import 'package:my_lawn/blocs/subscription/order_details/order_details_bloc.dart';
import 'package:my_lawn/blocs/subscription/subscription_bloc.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/screens/calendar/entity/events.dart';
import 'package:my_lawn/screens/calendar/widgets/bottom_sheet/calendar_bottom_sheet_widget.dart';
import 'package:my_lawn/screens/calendar/widgets/calendar_event_item.dart';
import 'package:my_lawn/screens/calendar/widgets/date_widget.dart';
import 'package:my_lawn/screens/calendar/widgets/search_widget.dart';
import 'package:my_lawn/screens/calendar/widgets/tabs_widget.dart';
import 'package:my_lawn/widgets/error_and_loading_widgets.dart';
import 'package:my_lawn/services/analytic/screen_state_action/calendar_screen/state.dart';
import 'package:my_lawn/utils/date_utils.dart';
import 'package:my_lawn/widgets/bottom_dialog_widget.dart';
import 'package:my_lawn/widgets/circular_fab.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:my_lawn/widgets/scaffold_widgets.dart';
import 'package:scroll_to_index/scroll_to_index.dart';

class CalendarScreen extends StatefulWidget {
  @override
  State<StatefulWidget> createState() => _CalendarState();
}

class _CalendarState extends State<CalendarScreen> {
  final _scrollController = AutoScrollController();
  CalendarBloc _bloc;
  DateTime selectedDate;

  void _onDateTap(CalendarState state) {
    showBottomSheetDialog(
        context: context,
        color: Styleguide.color_gray_1,
        child: CalendarBottomSheetWidget(
          events: state.calendarMarkers,
          date: selectedDate,
          onNewDateSelected: (newDate) {
            _bloc.add(SelectedDateEvent(newDate));
            setState(() {
              selectedDate = newDate;
            });
          },
        ));
  }

  void _onTodayTap() {
    _bloc.add(TodayEvent());
    setState(() {
      selectedDate = DateTime.now();
    });
  }

  void _onSearchValueChanged(String value) {
    _bloc.add(SearchValueChangedEvent(value));
  }

  void _onSelectedTabsUpdated(List<Event> tabs) {
    _bloc.add(TabsChangedEvent(tabs));
  }

  @override
  void initState() {
    super.initState();

    selectedDate = DateTime.now();
    registry<SubscriptionBloc>().listen((state) {
      if (state.status == SubscriptionStatus.active) {
        registry<OrderDetailsBloc>()
            .add(GetOrderDetails(state.data.last.shipments));
      }
    });

    _bloc = registry<CalendarBloc>();
    if (_bloc.state.displayedEvents == null || _bloc.state.exception != null) {
      _bloc.add(InitialCalendarEvent());
    }

    _bloc.listen((state) {
      final todayElement = state.displayedEvents.indexOf(state.focusedEvent);
      _scrollController.scrollToIndex(
        todayElement,
        duration: Duration(milliseconds: 500),
        preferPosition: AutoScrollPosition.begin,
      );
    });
    adobeAnalyticStateCall();
  }

  void adobeAnalyticStateCall() {
    registry<AdobeRepository>().trackAppState(
      CalendarScreenAdobeState(),
    );
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BasicScaffold(
      child: Stack(
        children: [
          NestedScrollView(
            headerSliverBuilder:
                (BuildContext context, bool innerBoxIsScrolled) => [
              SliverAppBar(
                floating: false,
                pinned: true,
                snap: false,
                title: _buildAppBar(),
                elevation: 0,
                backgroundColor: Styleguide.color_gray_0,
                bottom: _buildTabsWidget(),
              ),
            ],
            body: BlocBuilder<CalendarBloc, CalendarState>(
              cubit: _bloc,
              buildWhen: (previous, current) => previous != current,
              builder: (context, state) {
                return _buildContent(state);
              },
            ),
          ),
          CircularFab()
        ],
      ),
    );
  }

  Widget _buildContent(CalendarState state) {
    if (state.loading) {
      return Center(child: ProgressSpinner());
    } else if (state.exception != null) {
      return ErrorMessage(
        errorMessage: 'Something went wrong. Please try again.',
        retryRequest: () => _bloc.add(InitialCalendarEvent()),
      );
    } else if (state.displayedEvents.isNotEmpty) {
      return Container(
        child: SingleChildScrollView(
            controller: _scrollController, child: _buildItemsList(state)),
      );
    } else {
      return _buildEmptyListMessage();
    }
  }

  Widget _buildAppBar() {
    return BlocBuilder<CalendarBloc, CalendarState>(
        cubit: _bloc,
        builder: (context, state) {
          return DateWidget(
            date: selectedDate,
            onDateTap: () => state.exception != null || state.loading
                ? null
                : _onDateTap(state),
            onTodayTap: () => _onTodayTap(),
          );
        });
  }

  Widget _buildTabsWidget() {
    return PreferredSize(
      preferredSize: Size(0, 46),
      child: BlocBuilder<CalendarBloc, CalendarState>(
        cubit: _bloc,
        builder: (context, state) => Padding(
          padding: const EdgeInsets.only(
            left: 16,
            right: 16,
            bottom: 16,
          ),
          child: Row(
            children: [
              Expanded(
                child: TabsWidget(
                  selectedTabs: state.selectedTabs,
                  selectedTabsUpdated: _onSelectedTabsUpdated,
                ),
              ),
              SearchWidget(
                onSearchValueChanged: _onSearchValueChanged,
                searchValue: state.searchText,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildItemsList(CalendarState state) {
    return Column(
      children: [
        ListView.builder(
          padding: EdgeInsets.zero,
          shrinkWrap: true,
          itemCount: state.displayedEvents.length,
          itemBuilder: (ctx, i) => AutoScrollTag(
            key: ValueKey(i),
            controller: _scrollController,
            index: i,
            child: CalendarEventItem(
              key: Key('calendar_event_item_$i'),
              event: state.displayedEvents[i],
              showDate: i == 0 ||
                  !isTheSameDay(state.displayedEvents[i - 1].eventDate,
                      state.displayedEvents[i].eventDate),
              onDeleteTap: () =>
                  _bloc.add(DeleteEvent(state.displayedEvents[i])),
              onMarkDoneTap: () =>
                  _bloc.add(MarkDoneEvent(state.displayedEvents[i])),
            ),
          ),
        ),
        Container(
          height: 80,
        )
      ],
    );
  }

  Widget _buildEmptyListMessage() {
    return Container(
      child: Center(
        child: Column(
          mainAxisSize: MainAxisSize.max,
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Image.asset(
              'assets/icons/empty.png',
              width: 64,
              fit: BoxFit.fill,
            ),
            const Text(
              'No activity found!',
              style: TextStyle(fontSize: 28, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

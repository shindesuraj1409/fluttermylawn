import 'package:my_lawn/data/tips/filter_data.dart';

abstract class TipsFilterEvent {}

/// The initial load class to be called when the filter screen is opened event
class TipsFilterInitialLoad extends TipsFilterEvent {
  final Filter filter;
  TipsFilterInitialLoad({this.filter});
}

///Class that handles an unchecked filter being pressed event
class ApplyTipsFilter extends TipsFilterEvent {
  final Filter filter;

  final List<String> filterIdList;

  ApplyTipsFilter({this.filterIdList, this.filter});
}

///Class that handles a checked filter being pressed event
class RemoveTipsFilter extends TipsFilterEvent {
  final List<String> filterIdList;
  final Filter filter;

  RemoveTipsFilter({this.filterIdList, this.filter});
}

///Class that handles the show filters button pressed event
class ShowTipsFiltered extends TipsFilterEvent {
  final Filter filter;

  ShowTipsFiltered({this.filter});
}

///Class to handle the filters being cleared event
class TipsFilterCleared extends TipsFilterEvent {
  final Filter filter;

  TipsFilterCleared({this.filter});
}

///Class to handle the cancel filtering event
class TipsFilterCanceled extends TipsFilterEvent {
  final Filter filter;

  TipsFilterCanceled({this.filter});
}

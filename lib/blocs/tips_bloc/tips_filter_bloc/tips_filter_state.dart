import 'package:my_lawn/data/tips/filter_data.dart';

//reason why this can't be equatable:
//https://github.com/felangel/bloc/issues/140
//https://bloclibrary.dev/#/faqs

abstract class TipsFilterState {
  const TipsFilterState();
}

class TipsFilterInitial extends TipsFilterState {}

class TipsFilterOpened extends TipsFilterState {
  final Filter filter;

  const TipsFilterOpened({this.filter});
}

class TipsBeingFiltered extends TipsFilterState {
  final Filter filter;

  const TipsBeingFiltered({this.filter});
}

class TipsFiltered extends TipsFilterState {
  final Filter filter;

  const TipsFiltered({this.filter});
}

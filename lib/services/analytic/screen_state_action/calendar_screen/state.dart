import 'package:my_lawn/screens/calendar/entity/events.dart';
import 'package:my_lawn/services/analytic/adobe_analytic_state.dart';

class CalendarScreenAdobeState extends AdobeAnalyticState {
  List<Event> tabEventList;

  CalendarScreenAdobeState({
    this.tabEventList,
  }) : super(type: 'CalendarScreenAdobeState', state: 'activities');


  @override
  Map<String, String> getData() {
    return {
      's.filters': _buildName(tabEventList),
      's.type': 'calendar'
    };
  }

  String _buildName(List<Event> tabEventList) {
    var list = '';

    if(tabEventList == null) {
      return '';
    }

    for(var i = 0; i < tabEventList.length; i++) {
     var str = tabEventList[i].toString().split('.').last;

     if(i != tabEventList.length-1) {
       str += '|';
     }
      list += str;
    }

    return list;
  }
}

class CalendarTaskViewScreenAdobeState extends AdobeAnalyticState {
  Event event;

  CalendarTaskViewScreenAdobeState({
    this.event,
  }) : super(type: 'CalendarTaskViewScreenAdobeState', state: 'detail|${_buildEventName(event)}');

  @override
  Map<String, String> getData() {
    return {
      's.filters': _buildEventName(event),
      's.type': 'calendar'
    };
  }

  static String _buildEventName(Event event) => event.toString().split('.').last;
}

class AddTaskScreenAdobeState extends AdobeAnalyticState {
  Event event;

  AddTaskScreenAdobeState({
    this.event,
  }) : super(type: 'AddTaskScreenAdobeState', state: 'add task');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'calendar'
    };
  }
}

class AddTaskTypeScreenAdobeState extends AdobeAnalyticState {
  String taskType;

  AddTaskTypeScreenAdobeState({
    this.taskType,
  }) : super(type: 'AddTaskTypeScreenAdobeState', state: 'add task|$taskType');

  @override
  Map<String, String> getData() {
    return {
      's.taskType': taskType,
      's.type': 'calendar'
    };
  }
}

class AddProductScreenAdobeState extends AdobeAnalyticState {
  String productId;

  AddProductScreenAdobeState({
    this.productId,
  }) : super(type: 'AddProductScreenAdobeState', state: 'add product');

  @override
  Map<String, String> getData() {
    return {
      '&&products': ';$productId',
      's.type': 'calendar'
    };
  }
}


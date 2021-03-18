import 'dart:developer';

Map<String, List<Map<String,dynamic>>> _calls = {};

const String qty = 'qty';
const String valueStr = 'value';

void verifyFunction(String name, {String value}) {
  if(_calls.containsKey(name)) {
    var _isValue = false;

    if(value == null) {
      return;
    }

    _calls[name].forEach((element) {
      if(element[valueStr] == value) {
        _isValue = true;

        return;
      }
    });

    if(!_isValue) {
      throw StateError('Function $name was not verified!No function call with value: $value was found!');
    }

  } else {
    throw StateError('Function $name was not verified!');
  }
}

void getAllAnalyticCalls() {
  if(_calls.isEmpty) {
    return;
  }

  log('number of functions => ${_calls.length}');
  _calls.forEach((key, value) {
    log('$key :$value');
  });
}

void addNewEntry(
    String name,
    {String value}) {

 var map;

 map = {
   'name': name,
 };

  if(value != null) {
    map['value'] = value;
  }

  _calls.containsKey(name)
      ? _calls[name].add(map)
      : _calls.addAll({name: [map],});
}

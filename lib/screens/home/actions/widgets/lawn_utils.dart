import 'package:intl/intl.dart';

final lawnDateFormat = DateFormat('EE MMM dd');

final frequencyList = <String>[
  'Never',
  'Every day',
  'Every 3 days',
  'Every week',
  'Every other week',
  'Every month'
];

final frequencyListMap = {
  'Never': 'null',
  'Every day': 'every_day',
  'Every 3 days': 'every_3_days',
  'Every week': 'every_week',
  'Every Other week': 'every_other_week',
  'Every month': 'every_month'
};

final waterGoalList = <String>[
  '3 1/2\'\'',
  '3\'\'',
  '2 1/2\'\'',
  '2\'\'',
  '1 1/2\'\'',
  '1\'\'',
];

final waterGoalToDoubleMap = <String, double>{
  '3 1/2\'\'': 3.5,
  '3\'\'': 3.0,
  '2 1/2\'\'': 2.5,
  '2\'\'': 2.0,
  '1 1/2\'\'': 1.5,
  '1\'\'': 1.0,
};

final waterGoalToStringlMap = <double, String>{
  3.5: '3 1/2\'\'',
  3.0: '3\'\'',
  2.5: '2 1/2\'\'',
  2.0: '2\'\'',
  1.5: '1 1/2\'\'',
  1.0: '1\'\'',
};

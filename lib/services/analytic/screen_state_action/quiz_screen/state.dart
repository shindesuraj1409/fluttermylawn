import 'package:my_lawn/services/analytic/adobe_analytic_state.dart';

class LawnLookState extends AdobeAnalyticState {

  LawnLookState() : super(type: 'LawnLookState', state: 'condition');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'quiz',
    };
  }
}

class SpreaderScreenState extends AdobeAnalyticState {
  final String grassThickness;
  final String grassColor;
  final String grassWeeds;

  SpreaderScreenState({
    this.grassThickness,
    this.grassColor,
    this.grassWeeds
  }) : super(type: 'SpreaderScreenState', state: 'tools');


  @override
  Map<String, String> getData() {
    return {
      's.grassThickness' : grassThickness,
      's.grassColor' : grassColor,
      's.grassWeeds' : grassWeeds,
      's.type': 'quiz',
    };
  }

}

class LawnSizeState extends AdobeAnalyticState {
  final String spreaderSelect;


  LawnSizeState({
    this.spreaderSelect
  }) : super(type: 'LawnSizeState', state: 'lawndetails|calculate');

  @override
  Map<String, String> getData() {
    return {
      's.spreaderSelect' : spreaderSelect,
      's.type': 'quiz',
    };
  }

}

class LawnSizeManualState extends AdobeAnalyticState {
  final String spreaderTooltip;

  LawnSizeManualState({
    this.spreaderTooltip
  }) : super(type: 'LawnSizeManualState', state: 'lawndetails|manual');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'quiz',
    };
  }
}

class GrassTypeScreenState extends AdobeAnalyticState {
  final String lawnSizeCalculated;
  final String zip;
  final String typeOfInput;

  GrassTypeScreenState({
    this.lawnSizeCalculated,
    this.zip,
    this.typeOfInput
  }) : super(type: 'GrassTypeScreenState', state: 'lawndetails|calculate');

  @override
  Map<String, String> getData() {
    return {
      's.lawnSize' : '$typeOfInput: $lawnSizeCalculated',
      's.zip' : zip,
      's.type': 'quiz',
    };
  }
}

class ProfileGeneratingState extends AdobeAnalyticState {
  ProfileGeneratingState() : super(type: 'AdobeAnalyticState', state: 'creating plan');

  @override
  Map<String, String> getData() {
    return {
      's.type': 'quiz',
    };
  }
}

class QuizResultEventScreenState extends AdobeAnalyticState {
  final String grassThickness;
  final String grassColor;
  final String grassWeeds;
  final String spreaderSelect;
  final String lawnSize;
  final String zip;
  final String recommendationId;
  final String products;

  QuizResultEventScreenState({
    this.grassThickness,
    this.grassColor,
    this.grassWeeds,
    this.spreaderSelect,
    this.lawnSize,
    this.zip,
    this.recommendationId,
    this.products,
  }) : super(type: 'QuizResultEventScreenState', state: 'results');


  @override
  Map<String, String> getData() {
    return {
      's.grassThickness': grassThickness,
      's.grassColor': grassColor,
      's.grassWeeds': grassWeeds,
      's.spreaderSelect': spreaderSelect,
      's.lawnSize': lawnSize,
      's.zip': zip,
      's.recommendationId': recommendationId,
      //TODO: find how should list be sended
      '&&products': products,
      's.type': 'quiz'
    };
  }
}

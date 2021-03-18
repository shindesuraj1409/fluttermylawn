import 'package:data/data.dart';

class Quiz extends Data {
  final List<QuizPage> pages;
  Quiz({this.pages});

  @override
  List<Object> get props => [pages];
}

class QuizPage extends Data {
  final String title;
  final String subtitle;
  final String tooltipTitle;
  final String tooltipLabel;
  final QuizPageType pageType;
  final List<Question> questions;

  QuizPage({
    this.title,
    this.subtitle,
    this.tooltipTitle,
    this.tooltipLabel,
    this.pageType,
    this.questions,
  });

  @override
  List<Object> get props => [pageType];
}

class Question extends Data {
  final List<Option> options;
  final QuestionType questionType;

  Question({
    this.options,
    this.questionType,
  });

  @override
  List<Object> get props => [questionType];
}

class Option extends Data {
  final String label;
  final String value;
  final String tooltipLabel;
  final String tooltipTitle;
  final String imageUrl;
  final String moreInfoUrl;
  final String key;

  Option({
    this.label,
    this.value,
    this.tooltipLabel,
    this.tooltipTitle,
    this.imageUrl,
    this.moreInfoUrl,
    this.key,
  });

  @override
  List<Object> get props => [label, value];
}

enum QuizPageType {
  lawnCondition,
  spreader,
  lawnAreaAndZipCode,
  grassType,
}

enum QuestionType {
  lawnColor,
  lawnThickness,
  lawnWeeds,
  lawnSpreader,
  lawnArea,
  zipCode,
  lawnZone,
  grassType,
  inputType,
}

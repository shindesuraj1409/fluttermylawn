import 'package:my_lawn/data/lawn_data.dart';
import 'package:my_lawn/data/quiz/quiz_data.dart';
import 'package:my_lawn/extensions/lawn_data_extension.dart';

final quizData = Quiz(pages: [lawnConditionData, spreaderTypeData]);

// Lawn Condition Screen Data
final lawnConditionData = QuizPage(
  pageType: QuizPageType.lawnCondition,
  title: 'What does your Lawn look like?',
  questions: [
    Question(
      questionType: QuestionType.lawnColor,
      options: _colorOptions,
    ),
    Question(
      questionType: QuestionType.lawnThickness,
      options: _thicknessOptions,
    ),
    Question(
      questionType: QuestionType.lawnWeeds,
      options: _weedOptions,
    ),
  ],
);

// Lawn Condition Options
List<Option> get _thicknessOptions => [
      Option(
        imageUrl:
            'https://smg-product-images.storage.googleapis.com/1-thickness-no_grass.png',
        value: '0',
        label: 'No Grass',
      ),
      Option(
        imageUrl:
            'https://smg-product-images.storage.googleapis.com/2-thickness-some_grass.png',
        value: '1',
        label: 'Some Grass',
      ),
      Option(
        imageUrl:
            'https://smg-product-images.storage.googleapis.com/3-thickness-patchy_grass.png',
        value: '2',
        label: 'Patchy Grass',
      ),
      Option(
          imageUrl:
              'https://smg-product-images.storage.googleapis.com/4-thickness-thin_grass.png',
          value: '3',
          label: 'Thin Grass'),
      Option(
        imageUrl:
            'https://smg-product-images.storage.googleapis.com/5-thickness-thick_lush_grass.png',
        value: '4',
        label: 'Thick & Lush',
      )
    ];

List<Option> get _colorOptions => [
      Option(
        imageUrl:
            'https://smg-product-images.storage.googleapis.com/1-color-brown.png',
        value: '0',
        label: 'Brown',
      ),
      Option(
        imageUrl:
            'https://smg-product-images.storage.googleapis.com/2-color-light_brown.png',
        value: '1',
        label: 'Light Brown',
      ),
      Option(
        imageUrl:
            'https://smg-product-images.storage.googleapis.com/3-color-green_and_brown.png',
        value: '2',
        label: 'Green & Brown',
      ),
      Option(
          imageUrl:
              'https://smg-product-images.storage.googleapis.com/4-color-mostly_green.png',
          value: '3',
          label: 'Mostly Green'),
      Option(
        imageUrl:
            'https://smg-product-images.storage.googleapis.com/5-color-very_green.png',
        value: '4',
        label: 'Very Green',
      )
    ];

List<Option> get _weedOptions => [
      Option(
        imageUrl:
            'https://smg-product-images.storage.googleapis.com/1-weeds-many_weeds.png',
        value: '0',
        label: 'Many Weeds',
      ),
      Option(
        imageUrl:
            'https://smg-product-images.storage.googleapis.com/3-weeds-several_weeds.png',
        value: '1',
        label: 'Several Weeds',
      ),
      Option(
        imageUrl:
            'https://smg-product-images.storage.googleapis.com/2-weeds-some_weeds.png',
        value: '2',
        label: 'Some Weeds',
      ),
      Option(
          imageUrl:
              'https://smg-product-images.storage.googleapis.com/4-weeds-few_weeds.png',
          value: '3',
          label: 'Few Weeds'),
      Option(
        imageUrl:
            'https://smg-product-images.storage.googleapis.com/5-weeds-no_weeds.png',
        value: '4',
        label: 'No Weeds',
      )
    ];

// Spreader Type Screen Data
final spreaderTypeData = QuizPage(
  pageType: QuizPageType.spreader,
  title: 'Do you have a spreader?',
  subtitle:
      'A spreader helps evenly apply products to your lawn. Select the type of spreader you use most often.',
  tooltipTitle: 'Why do I need a spreader?',
  tooltipLabel:
      "A spreader helps you apply the right amount of lawn food, weed control, or grass seed uniformly to your entire lawn. Using one helps ensure you don't apply too much product (which could damage your lawn) or too little.",
  questions: [
    Question(
      questionType: QuestionType.lawnSpreader,
      options: [
        Option(
          label: 'Yes, I have a wheeled spreader',
          value: Spreader.wheeled.string,
          imageUrl:
              'https://smg-product-images.storage.googleapis.com/WheeledSpreader.png',
          key: 'spreader_type_screen_wheeled_spreader'
        ),
        Option(
          label: 'Yes, I have a handheld spreader',
          value: Spreader.handheld.string,
          imageUrl:
              'https://smg-product-images.storage.googleapis.com/HandHeldSpreader.png',
          key: 'spreader_type_screen_handheld_spreader'
        ),
        Option(
          label: 'No, I don’t have a spreader',
          value: Spreader.none.string,
          imageUrl: 'https://smg-product-images.storage.googleapis.com/No.png',
          key: 'spreader_type_screen_no_spreader'
        ),
      ],
    )
  ],
);

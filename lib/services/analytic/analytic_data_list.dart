

List<Map<String,dynamic>> analyticActionList = [
  {
    'name' : 'GetStartedAction',
    'action': 'Get Started',
    'context_data' : 'n/a',
    'context_value' : '',
    'behavior' : 'User Selects "Get Started"',
    'description' : '',
  },

  {
    'name' : 'LoginAction',
    'action': 'Login',
    'context_data' : 'n/a',
    'context_value' : '',
    'behavior' : 'User Selects "Log In"',
    'description' : '',
  },

  {
    'name' : 'ConditionContinueAction',
    'action': 'Continue',
    'context_data' : [
      'a.grassthickness',
      'a.grasscolor',
      'a.grassweeds',
    ],
    'context_value' : '',
    'behavior' : 'User Selects "Log In"',
    'description' : '',
  }
];

List<Map<String,dynamic>> quizActionList = [
  {
    'name' : 'ConditionContinueAction',
    'action' : 'Continue',
    'context_data' : [
      'a.grassthickness',
      'a.grasscolor',
      'a.grassweeds',
    ],
    'behavior' : 'Values captured when user taps continue ',
    'description' : '',
  },
  {
    'name' : 'SpreaderSelectAction',
    'action' : 'Spreader Select',
    'context_data': ['a.spreaderselect'],
    'behavior' : 'Selected answer (max 1)',
    'description': 'Value captured once user taps on a spreader option',
  },
  {
    'name' : 'SpreaderTooltipAction',
    'action' : 'Spreader Tooltip',
    'context_data': [
      'a.spreadertooltip'
    ],
    'behavior' : 'Selected answer (max 1)',
    'description': 'Value captured once user taps on a spreader option',
  },
  {
    'name' : 'SaveAction',
    'action' : 'Safe',
    'context_data': [
      'a.lawnsizecalculated',
      'a.zip',
      'a.zoneName',
    ],
    'behavior' : 'Values captured when user taps "Save"',
    'description': '',
  },
  {
    'name' : 'ContinueAction',
    'action' : 'Continue',
    'context_data': [
      'a.lawnsizeinput',
      'a.zip',
      'a.zoneName'
    ],
    'behavior' : '',
    'description': '',
  },
  {
    'name' : 'GrassTypeSelectedAction',
    'action' : 'Grass Type Selected',
    'context_data': [
      'a.lawnsizeinput'
    ],
    'behavior' : '',
    'description': '',
  },
  {
    'name' : 'LawnCarePlanLoadingAction',
    'action' : 'Lawn care plan loading',
    'context_data': [
      'a.zip',
      'a.zoneName'
    ],
    'behavior' : '',
    'description': '',
  },
];

const List<Map<String,dynamic>> signUpActionList = [
  {
    'name' : 'LawnCarePlanLoadingAction',
    'action' : 'Lawn care plan loading',
    'context_data': [
      'a.zip',
          'a.zoneName'
    ],
    'behavior' : '',
    'description': '',
  },
  {
    'name': '',
    'action' : 'Create Account',
    'context_data': [
      'a.subscribe',
      'a.usertype',
      'a.lawnappid',
      'a.signupmethod',
    ]
  },
  {
    'name': '',
    'action' : 'Continue as Guest',
    'context_data': [
      'a.usertype',
      'a.lawnappid',
    ]
  },
  {
    'name': '',
    'action' : 'Login',
    'context_data': [
      'a.usertype',
      'a.lawnappid',
    ]
  },
  {
    'name': '',
    'action' : 'Guest user -> sign-up',
    'context_data': [
      'a.subscribe',
      'a.usertype',
    ]
  },
  {
    'name': '',
    'action' : 'Guest user -> login',
    'context_data': [
      'a.usertype',

    ]
  },
];

const List<Map<String,dynamic>> softAskActionList = [];

const List<Map<String,dynamic>> homeScreenActionList = [];

const List<Map<String,dynamic>> subscriptionCheckoutActionList = [];

const List<Map<String,dynamic>> profileOverviewActionList = [];
//not done
const List<Map<String,dynamic>> mySubscriptionScreenActionList = [];
const List<Map<String,dynamic>> myScottsAccountActionList = [];
const List<Map<String,dynamic>> calendarActionList = [];
const List<Map<String,dynamic>> customizeActionList = [];
const List<Map<String,dynamic>> pdpActionList = [];
const List<Map<String,dynamic>> findLocalStoreListActionList = [];
const List<Map<String,dynamic>> findLocalStoreMapActionList = [];
const List<Map<String,dynamic>> tipsActionList = [];
const List<Map<String,dynamic>> askActionList = [];
const List<Map<String,dynamic>> appSettingsActionList = [];
const List<Map<String,dynamic>> deepLinkActionList = [];

const allowedEmailCharactersRegex = r'[a-zA-Z0-9_.+-@]';
const symbolsAndEmojiRegex =
    '([\u0021-\u002c\u002e-\u0040\u005b-\u0060\u007b-\u0089\u008b\u0091-\u0095\u0097-\u0099\u009b\u00a0-\u00bf\u00d7\u00f7\u2000-\u2012\u2014-\u2bff\ufff0-\uffff]|\ud83c[\ud000-\udfff]|\ud83d[\ud000-\udfff]|\ud83e[\ud000-\udfff]|\ufe0f)';
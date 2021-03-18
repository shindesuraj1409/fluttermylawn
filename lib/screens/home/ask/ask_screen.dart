import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intersperse/intersperse.dart';
import 'package:my_lawn/blocs/auth/authentication_bloc.dart';
import 'package:my_lawn/blocs/help_bloc/help_bloc.dart';
import 'package:my_lawn/blocs/help_bloc/help_event.dart';
import 'package:my_lawn/blocs/help_bloc/help_state.dart';
import 'package:my_lawn/config/colors_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/repositories/analytic/adobe_repository.dart';
import 'package:my_lawn/services/analytic/actions/localytics/ask_events.dart';
import 'package:my_lawn/services/analytic/localytics_service.dart';
import 'package:my_lawn/services/analytic/screen_state_action/ask_screen/action.dart';
import 'package:my_lawn/services/analytic/screen_state_action/ask_screen/state.dart';
import 'package:my_lawn/widgets/dialog_widgets.dart';
import 'package:my_lawn/widgets/error_and_loading_widgets.dart';
import 'package:my_lawn/widgets/progress_spinner_widget.dart';
import 'package:navigation/navigation.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:my_lawn/extensions/lawn_data_extension.dart';
import 'package:my_lawn/extensions/string_extensions.dart';

class AskScreen extends StatefulWidget {
  final String deepLinkPath;

  const AskScreen({Key key, this.deepLinkPath}) : super(key: key);

  @override
  _AskScreenState createState() => _AskScreenState();
}

class _AskScreenState extends State<AskScreen>
    with AutomaticKeepAliveClientMixin<AskScreen> {
  final HelpBloc _helpBloc = registry<HelpBloc>();
  @override
  void initState() {
    super.initState();
    _helpBloc.add(FetchHelpEvent(helpPage: widget.deepLinkPath));
    registry<AdobeRepository>().trackAppState(AskScreenAdobeState());
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final theme = Theme.of(context);
    final bannerHeight = MediaQuery.of(context).size.height * 0.35;
    final ctaCardsOffset = bannerHeight * 0.80;

    return Scaffold(
      backgroundColor: Styleguide.nearBackground(theme),
      body: SingleChildScrollView(
        child: Stack(
          children: <Widget>[
            Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: <Widget>[
                Container(
                  height: bannerHeight,
                  decoration: BoxDecoration(
                    image: DecorationImage(
                      image:
                          AssetImage('assets/images/ask_screen_background.png'),
                      fit: BoxFit.cover,
                    ),
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    mainAxisSize: MainAxisSize.min,
                    children: <Widget>[
                      Text(
                        'Help when you need it',
                        textAlign: TextAlign.center,
                        style: theme.textTheme.headline2.copyWith(
                          color: theme.colorScheme.onPrimary,
                        ),
                      ),
                      SizedBox(height: 16),
                      Image.asset(
                        'assets/images/scotts_logo.png',
                        height: 32,
                        width: 64,
                      )
                    ],
                  ),
                ),
                SizedBox(height: 120),
                Padding(
                  padding: const EdgeInsets.fromLTRB(16, 16, 16, 20),
                  child: Text(
                    'Learn More about the App',
                    style: theme.textTheme.headline5,
                  ),
                ),
                BlocConsumer<HelpBloc, HelpState>(
                  cubit: _helpBloc,
                  listener: (context, state) {
                    if (state is HelpSuccessState) {
                      final path = state.helpPage ?? '';
                      final helpPage = state.helpList.firstWhere(
                          (element) => element.title == path,
                          orElse: () => null);
                      if (helpPage == null) return;
                      registry<Navigation>()
                          .push('/ask/detail', arguments: helpPage);
                    }
                  },
                  builder: (context, state) => (state is HelpLoadingState
                      ? Center(
                          child: Container(
                              height: 32, width: 32, child: ProgressSpinner()),
                        )
                      : state is HelpSuccessState
                          ? Column(
                              children: intersperse(
                                  Divider(),
                                  state.helpList
                                      .where((element) =>
                                          element.isAboutTheAppArticle == false)
                                      .map<Widget>((e) => _Link(
                                            title: e.title,
                                            image: e.image,
                                            onTap: () {
                                              registry<AdobeRepository>()
                                                  .trackAppState(
                                                      AskSubScreenAdobeState(
                                                          subScreen: e.title
                                                              .toLowerCase()));

                                              registry<Navigation>().push(
                                                  '/ask/detail',
                                                  arguments: e);
                                            },
                                          ))).toList())
                          : state is HelpErrorState
                              ? ErrorMessage(
                                  errorMessage: '${state.errorMessage}',
                                  retryRequest: () => _helpBloc.add(
                                    FetchHelpEvent(
                                        helpPage: widget.deepLinkPath),
                                  ),
                                )
                              : Container()),
                ),
              ],
            ),
            Positioned(
              top: ctaCardsOffset,
              left: 0,
              right: 0,
              child: _CTACards(),
            ),
          ],
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}

class _CTACards extends StatelessWidget {
  final customerSupportEmail = 'consumer.services@scotts.com';
  final customerSupportContact = '+1 (866) 882-0846';

  void _callUs(BuildContext context) async {
    await registry<LocalyticsService>().tagEvent(
      CalledScottsEvent(call: customerSupportContact),
    );

    final params = Uri(
      scheme: 'tel',
      path: customerSupportContact,
    );
    final uri = params.toString();
    if (await canLaunch(uri)) {
      await launch(uri);
    }
  }

  void _emailUs(BuildContext context) async {
    await registry<LocalyticsService>().tagEvent(
      SentEmailEvent(customerSupportEmail),
    );

    final lawnData = registry<AuthenticationBloc>().state?.lawnData;

    final zipCode = lawnData?.lawnAddress?.zip;
    final grassType = lawnData?.grassTypeName;
    final lawnSize = lawnData?.lawnSqFt;
    final lawnConditions = '''
    Color: ${lawnData?.color?.string}
    Thickness : ${lawnData?.thickness?.string} 
    Weeds: ${lawnData?.weeds?.string}''';

    adobeActionFunction('email');

    final subject = 'Email from My Lawn App'.sanitizeTextForEmail;
    final body = '''
Thank you for contacting Scotts. In order to best help you, please include the below lawn details in the body of your email as well as 'Email from My Lawn App' in the subject line.


Zip Code : ${zipCode}
Grass type : ${grassType}
Lawn conditions : 
${lawnConditions}
Lawn size : ${lawnSize} sq.ft
'''
        .sanitizeTextForEmail;

    final uri = Uri.encodeFull(
        'mailto:$customerSupportEmail?subject=$subject&body=$body');

    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      final snackbar = SnackBar(content: Text('Unable to send an email'));
      Scaffold.of(context).showSnackBar(snackbar);
    }
  }

  void _textUs(BuildContext context) async {
    await registry<LocalyticsService>().tagEvent(
      TextedEvent(customerSupportContact),
    );

    adobeActionFunction('text');

    final params = Uri(
      scheme: 'sms',
      path: customerSupportContact,
    );
    final uri = params.toString();
    if (await canLaunch(uri)) {
      await launch(uri);
    } else {
      final snackbar = SnackBar(content: Text('Unable to send sms'));
      Scaffold.of(context).showSnackBar(snackbar);
    }
  }

  void adobeActionFunction(String value) {
    registry<AdobeRepository>().trackAppActions(SendAskAction(value));
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      children: <Widget>[
        _CTACard(
          key: Key('email_us'),
          ctaAction: 'Email Us',
          ctaAsset: 'assets/icons/email.png',
          ctaETA: 'Typically replies in 3 business days',
          onTap: () => _emailUs(context),
        ),
        _CTACard(
          key: Key('call_us'),
          ctaAction: 'Call Us',
          ctaAsset: 'assets/icons/call.png',
          ctaETA: 'Wait times may be long due to COVID',
          onTap: () {
            adobeActionFunction('call');

            showDialog(
              context: context,
              builder: (context) => PlatformAwareAlertDialog(
                title: Text('Call Scotts'),
                content: Text(customerSupportContact),
                actions: [
                  FlatButton(
                      child: Text('Cancel'),
                      onPressed: () => Navigator.pop(context)),
                  FlatButton(
                    child: Text('Call'),
                    onPressed: () {
                      Navigator.pop(context);
                      _callUs(context);
                    },
                  ),
                ],
              ),
            );
          },
        ),
        _CTACard(
          key: Key('text_us'),
          ctaAction: 'Text Us',
          ctaAsset: 'assets/icons/sms.png',
          ctaETA: 'Get a quick response from us',
          onTap: () => _textUs(context),
        ),
      ],
    );
  }
}

class _CTACard extends StatelessWidget {
  final String ctaAction;
  final String ctaAsset;
  final String ctaETA;
  final VoidCallback onTap;

  _CTACard({Key key, this.ctaAction, this.ctaAsset, this.ctaETA, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Container(
      width: 104,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: <Widget>[
          InkWell(
            onTap: onTap,
            child: Card(
              child: Padding(
                padding: const EdgeInsets.all(16),
                child: Column(
                  children: <Widget>[
                    Image.asset(
                      ctaAsset,
                      height: 64,
                      width: 64,
                    ),
                    Text(
                      ctaAction,
                      style: theme.textTheme.bodyText2,
                    ),
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: 8),
          Text(ctaETA,
              textAlign: TextAlign.center,
              style: theme.textTheme.caption.copyWith(
                fontWeight: FontWeight.normal,
                height: 1.36,
              )),
        ],
      ),
    );
  }
}

class _Link extends StatelessWidget {
  final String title;
  final String image;
  final VoidCallback onTap;

  _Link({this.title, this.image, this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Material(
      color: theme.colorScheme.onPrimary,
      child: InkWell(
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Image.network(
                image,
                width: 24,
                height: 24,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Text(
                    title,
                    style: theme.textTheme.subtitle2.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
              ),
              Icon(
                Icons.keyboard_arrow_right,
                size: 16,
                color: theme.textTheme.bodyText2.color,
              ),
            ],
          ),
        ),
        onTap: onTap,
      ),
    );
  }
}

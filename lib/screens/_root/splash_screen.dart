import 'package:flutter/material.dart';

class SplashScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return MaterialApp(
      home: Scaffold(
        body: Stack(
          children: [
            FractionallySizedBox(
              widthFactor: 1,
              heightFactor: 1,
              child: Container(
                key: Key('splash_screen_background_image'),
                decoration: BoxDecoration(
                    image: DecorationImage(
                  image:
                      AssetImage('assets/images/splash_screen_background.png'),
                  fit: BoxFit.cover,
                )),
              ),
            ),
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SizedBox(
                    width: 256,
                    height: 56,
                    child: Image.asset(
                      'assets/images/my_lawn.png',
                      fit: BoxFit.contain,
                      key: Key('my_lawn_image'),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.fromLTRB(0, 8, 0, 12),
                    child: Text(
                      'by',
                      style: theme.textTheme.bodyText2.copyWith(
                        color: theme.colorScheme.onPrimary,
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ),
                  Image.asset(
                    'assets/images/scotts_logo.png',
                    key: Key('scotts_logo'),
                    fit: BoxFit.contain,
                    width: 150,
                    height: 70,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

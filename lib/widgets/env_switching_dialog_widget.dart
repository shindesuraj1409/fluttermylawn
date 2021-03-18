import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_phoenix/flutter_phoenix.dart';
import 'package:my_lawn/config/environment_config.dart';
import 'package:my_lawn/config/registry_config.dart';
import 'package:my_lawn/widgets/button_widget.dart';
import 'package:my_lawn/widgets/snackbar_widget.dart';
import 'bottom_dialog_widget.dart';

void showEnvironmentSwitchingDialog(
  BuildContext context,
  Environment environmentSelected, {
  bool allowCopyingTransId = false,
}) {
  final theme = Theme.of(context);

  showBottomSheetDialog(
    context: context,
    allowBackNavigation: true,
    title: Text(
      'Choose environment',
      style: theme.textTheme.headline3,
    ),
    trailing: Flexible(
      flex: 1,
      child: Wrap(
        alignment: WrapAlignment.end,
        crossAxisAlignment: WrapCrossAlignment.center,
        children: [
          if (allowCopyingTransId)
            TappableText(
              backgroundColor: theme.colorScheme.primary,
              onTap: () async {
                final transId =
                    registry.call<String>(name: RegistryConfig.TRANS_ID);
                await Clipboard.setData(ClipboardData(text: transId));
                showSnackbar(
                  context: context,
                  text: 'TransId Copied',
                  duration: Duration(seconds: 2),
                );
              },
              child: Text(
                'Copy TransId',
                style: theme.textTheme.bodyText1.copyWith(
                  color: theme.colorScheme.background,
                ),
              ),
            ),
          IconButton(
            icon: Icon(Icons.close),
            onPressed: () => Navigator.pop(context),
          ),
        ],
      ),
    ),
    child: ListView.separated(
      shrinkWrap: true,
      itemCount: Environment.values.length,
      separatorBuilder: (_, __) => Divider(),
      itemBuilder: (BuildContext context, int index) {
        final environment = Environment.values[index];
        final isSelected = environment == environmentSelected;
        return ListTile(
          title: Text(
            environment.host,
            style: theme.textTheme.headline5.copyWith(
              color: isSelected
                  ? theme.colorScheme.secondaryVariant
                  : theme.colorScheme.onBackground,
            ),
          ),
          leading: Container(
            width: 72,
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: environment.color,
              borderRadius: BorderRadius.all(
                Radius.circular(4),
              ),
            ),
            child: Text(
              environment.string.toUpperCase(),
              textAlign: TextAlign.center,
              style: theme.textTheme.bodyText2.copyWith(
                color: theme.colorScheme.onPrimary,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          onTap: () async {
            await registry<EnvironmentConfig>().switchEnvironment(environment);
            registry.reset();
            Phoenix.rebirth(context);
          },
        );
      },
    ),
  );
}

import 'package:capture/app/capture_bootstrap.dart';
import 'package:capture/app/phone_localizations.dart';
import 'package:capture/core/data/system/system_datasource.dart';
import 'package:capture/core/router/app_router.dart';
import 'package:capture/core/theme/app_theme.dart';
import 'package:capture/l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class CaptureApp extends ConsumerWidget {
  const CaptureApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) => MaterialApp.router(
    onGenerateTitle: (context) => AppLocalizations.of(context).appTitle,
    debugShowCheckedModeBanner: false,
    theme: buildAppTheme(),
    localizationsDelegates: ref.watch(systemDatasourceProvider.select((s) => s.isPhone))
        ? PhoneLocalizationsDelegate.delegates
        : AppLocalizations.localizationsDelegates,
    supportedLocales: AppLocalizations.supportedLocales,
    routerConfig: ref.watch(appRouterProvider),
    builder: (context, child) => CaptureBootstrap(child: child ?? const SizedBox.shrink()),
  );
}

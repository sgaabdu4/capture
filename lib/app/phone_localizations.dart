import 'package:capture/l10n/app_localizations.g.dart';
import 'package:capture/l10n/app_localizations_en.g.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';

/// The iPhone's wording for the strings that name the Mac or macOS; the texts are `phone…` keys in `app_en.arb`.
class PhoneLocalizations extends AppLocalizationsEn {
  PhoneLocalizations();

  @override
  String get overlayTranscribing => phoneOverlayTranscribing;

  @override
  String get noticeSavedNotificationsOff => phoneNoticeSavedNotificationsOff;

  @override
  String get noticeSetupIncomplete => phoneNoticeSetupIncomplete;

  @override
  String get noticeMicDenied => phoneNoticeMicDenied;

  @override
  String get failureAudioMissing => phoneFailureAudioMissing;

  @override
  String get setupSubtitle => phoneSetupSubtitle;

  @override
  String get modelReady => phoneModelReady;

  @override
  String modelNeeded(int megabytes) => phoneModelNeeded(megabytes);

  @override
  String get modelAttribution => phoneModelAttribution;

  @override
  String get micUndetermined => phoneMicUndetermined;

  @override
  String get privacyBody => phonePrivacyBody;

  @override
  String get resetBody => phoneResetBody;

  @override
  String get recordingsSubtitle => phoneRecordingsSubtitle;

  @override
  String get deleteFromMac => phoneDeleteFromMac;

  @override
  String get deleteSavedBody => phoneDeleteSavedBody;

  @override
  String get deleteUnsavedBody => phoneDeleteUnsavedBody;
}

/// Loads [PhoneLocalizations] in place of the generated English strings.
class PhoneLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const PhoneLocalizationsDelegate();

  /// The app's delegates with the phone strings first.
  static const delegates = <LocalizationsDelegate<Object?>>[
    PhoneLocalizationsDelegate(),
    ...AppLocalizations.localizationsDelegates,
  ];

  @override
  bool isSupported(Locale locale) => AppLocalizations.delegate.isSupported(locale);

  @override
  Future<AppLocalizations> load(Locale locale) => SynchronousFuture(PhoneLocalizations());

  @override
  bool shouldReload(PhoneLocalizationsDelegate old) => false;
}

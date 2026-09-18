import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale) : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate = _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[Locale('en')];

  /// Wordmark and window title
  ///
  /// In en, this message translates to:
  /// **'Capture'**
  String get appTitle;

  /// Hero tagline under the wordmark on Home
  ///
  /// In en, this message translates to:
  /// **'Say anything. We’ll sort it.'**
  String get tagline;

  /// Handwritten note at the bottom of the sidebar
  ///
  /// In en, this message translates to:
  /// **'A calmer mind\ngets more done.'**
  String get sidebarMotto;

  /// No description provided for @navGroups.
  ///
  /// In en, this message translates to:
  /// **'Groups'**
  String get navGroups;

  /// No description provided for @navRecordings.
  ///
  /// In en, this message translates to:
  /// **'Recordings'**
  String get navRecordings;

  /// No description provided for @navTodo.
  ///
  /// In en, this message translates to:
  /// **'To-Do'**
  String get navTodo;

  /// No description provided for @navUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Upcoming'**
  String get navUpcoming;

  /// Settings button tooltip and page title
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get navSettings;

  /// No description provided for @notionConnected.
  ///
  /// In en, this message translates to:
  /// **'Notion connected'**
  String get notionConnected;

  /// No description provided for @notionNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Notion not connected'**
  String get notionNotConnected;

  /// Separator between parts of a one-line detail
  ///
  /// In en, this message translates to:
  /// **' · '**
  String get detailSeparator;

  /// No description provided for @recordTap.
  ///
  /// In en, this message translates to:
  /// **'Tap to record'**
  String get recordTap;

  /// No description provided for @recordStopTap.
  ///
  /// In en, this message translates to:
  /// **'Tap to stop'**
  String get recordStopTap;

  /// No description provided for @recordTranscribing.
  ///
  /// In en, this message translates to:
  /// **'Transcribing…'**
  String get recordTranscribing;

  /// No description provided for @recordSorting.
  ///
  /// In en, this message translates to:
  /// **'Sorting…'**
  String get recordSorting;

  /// No description provided for @recordWaitingReview.
  ///
  /// In en, this message translates to:
  /// **'Waiting for your review'**
  String get recordWaitingReview;

  /// No description provided for @recordSaving.
  ///
  /// In en, this message translates to:
  /// **'Saving to Notion…'**
  String get recordSaving;

  /// Hint under the mic button
  ///
  /// In en, this message translates to:
  /// **'or press {shortcut}'**
  String recordShortcutHint(String shortcut);

  /// Mic button semantics
  ///
  /// In en, this message translates to:
  /// **'Record'**
  String get recordButton;

  /// Mic button semantics while recording
  ///
  /// In en, this message translates to:
  /// **'Stop recording'**
  String get stopButton;

  /// No description provided for @overlayTranscribing.
  ///
  /// In en, this message translates to:
  /// **'Transcribing on this Mac…'**
  String get overlayTranscribing;

  /// No description provided for @overlaySorting.
  ///
  /// In en, this message translates to:
  /// **'Sorting your thoughts…'**
  String get overlaySorting;

  /// No description provided for @overlaySaving.
  ///
  /// In en, this message translates to:
  /// **'Saving to Notion…'**
  String get overlaySaving;

  /// Review card count line when nothing was found
  ///
  /// In en, this message translates to:
  /// **'I didn’t catch anything to save.'**
  String get reviewNothing;

  /// No description provided for @countNotes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 note} other{{count} notes}}'**
  String countNotes(int count);

  /// No description provided for @countTasks.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 task} other{{count} tasks}}'**
  String countTasks(int count);

  /// No description provided for @countReminders.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 reminder} other{{count} reminders}}'**
  String countReminders(int count);

  /// Why the review card cannot approve yet
  ///
  /// In en, this message translates to:
  /// **'Needs a look: {problem}'**
  String reviewNeedsLook(String problem);

  /// No description provided for @kindNote.
  ///
  /// In en, this message translates to:
  /// **'Note'**
  String get kindNote;

  /// No description provided for @kindTask.
  ///
  /// In en, this message translates to:
  /// **'Task'**
  String get kindTask;

  /// No description provided for @menuNothingScheduled.
  ///
  /// In en, this message translates to:
  /// **'Nothing scheduled'**
  String get menuNothingScheduled;

  /// No description provided for @menuNoCaptures.
  ///
  /// In en, this message translates to:
  /// **'No captures yet'**
  String get menuNoCaptures;

  /// Menu bar next-up line
  ///
  /// In en, this message translates to:
  /// **'{title} · {when}'**
  String menuNextUp(String title, String when);

  /// No description provided for @statusSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved to Notion'**
  String get statusSaved;

  /// No description provided for @statusWaitingReview.
  ///
  /// In en, this message translates to:
  /// **'Waiting for your review'**
  String get statusWaitingReview;

  /// No description provided for @statusSaveIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Save incomplete'**
  String get statusSaveIncomplete;

  /// No description provided for @statusNotSaved.
  ///
  /// In en, this message translates to:
  /// **'Not saved'**
  String get statusNotSaved;

  /// No description provided for @statusNotTranscribed.
  ///
  /// In en, this message translates to:
  /// **'Not transcribed yet'**
  String get statusNotTranscribed;

  /// No description provided for @statusTranscriptionFailed.
  ///
  /// In en, this message translates to:
  /// **'Transcription failed'**
  String get statusTranscriptionFailed;

  /// No description provided for @statusNotSorted.
  ///
  /// In en, this message translates to:
  /// **'Not sorted yet'**
  String get statusNotSorted;

  /// No description provided for @statusProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get statusProcessing;

  /// No description provided for @statusNeedsAttention.
  ///
  /// In en, this message translates to:
  /// **'Needs attention'**
  String get statusNeedsAttention;

  /// Recent capture row title for a saved capture
  ///
  /// In en, this message translates to:
  /// **'{summary} saved'**
  String recentSaved(String summary);

  /// No description provided for @noticeSetupIncomplete.
  ///
  /// In en, this message translates to:
  /// **'Finish setup before your first capture.'**
  String get noticeSetupIncomplete;

  /// No description provided for @noticeMicDenied.
  ///
  /// In en, this message translates to:
  /// **'Capture needs microphone access. Allow it in System Settings → Privacy & Security → Microphone.'**
  String get noticeMicDenied;

  /// No description provided for @noticeRecordingNotStarted.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t start recording.'**
  String get noticeRecordingNotStarted;

  /// No description provided for @noticeTooShort.
  ///
  /// In en, this message translates to:
  /// **'That was too short to keep.'**
  String get noticeTooShort;

  /// No description provided for @noticeLimitReached.
  ///
  /// In en, this message translates to:
  /// **'Stopped at the 5-minute limit.'**
  String get noticeLimitReached;

  /// No description provided for @noticeRecordingInterrupted.
  ///
  /// In en, this message translates to:
  /// **'Recording stopped unexpectedly. What was recorded is kept.'**
  String get noticeRecordingInterrupted;

  /// No description provided for @noticeDismissed.
  ///
  /// In en, this message translates to:
  /// **'Not saved. It stays in Recordings until you delete it.'**
  String get noticeDismissed;

  /// No description provided for @noticeReviewLater.
  ///
  /// In en, this message translates to:
  /// **'Waiting for your review in Recordings.'**
  String get noticeReviewLater;

  /// No description provided for @noticeSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved to Notion.'**
  String get noticeSaved;

  /// No description provided for @noticeSavedNotificationsOff.
  ///
  /// In en, this message translates to:
  /// **'Saved, but macOS notifications are off for Capture.'**
  String get noticeSavedNotificationsOff;

  /// No description provided for @noticeNotionNotConnected.
  ///
  /// In en, this message translates to:
  /// **'Connect Notion in Settings to save.'**
  String get noticeNotionNotConnected;

  /// No description provided for @failureTranscription.
  ///
  /// In en, this message translates to:
  /// **'Transcription failed. Your recording is kept; try again.'**
  String get failureTranscription;

  /// No description provided for @failureJevKey.
  ///
  /// In en, this message translates to:
  /// **'TypeSafe rejected the API key. Your capture is kept as one note to edit.'**
  String get failureJevKey;

  /// No description provided for @failureJevUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t reach TypeSafe. Your capture is kept as one note to edit.'**
  String get failureJevUnavailable;

  /// No description provided for @failureJevResponse.
  ///
  /// In en, this message translates to:
  /// **'TypeSafe returned an unexpected response. Your capture is kept as one note to edit.'**
  String get failureJevResponse;

  /// No description provided for @failureAudioTooLarge.
  ///
  /// In en, this message translates to:
  /// **'The recording is larger than this Notion workspace’s upload limit.'**
  String get failureAudioTooLarge;

  /// No description provided for @failureAudioMissing.
  ///
  /// In en, this message translates to:
  /// **'The compressed recording is missing on this Mac.'**
  String get failureAudioMissing;

  /// No description provided for @failureNotionAuth.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t save: Notion rejected the token.'**
  String get failureNotionAuth;

  /// No description provided for @failureNotionAccess.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t save: Capture can’t see the Notion page any more.'**
  String get failureNotionAccess;

  /// No description provided for @failureNotionBlockLimit.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t save: this Notion workspace has reached its block limit.'**
  String get failureNotionBlockLimit;

  /// No description provided for @failureNotionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t save: Notion is unavailable. Try again shortly.'**
  String get failureNotionUnavailable;

  /// No description provided for @failureNotionRejected.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t save: Notion refused the request.'**
  String get failureNotionRejected;

  /// No description provided for @jevInvalidKey.
  ///
  /// In en, this message translates to:
  /// **'TypeSafe rejected the API key.'**
  String get jevInvalidKey;

  /// No description provided for @jevRateLimited.
  ///
  /// In en, this message translates to:
  /// **'TypeSafe is rate limiting requests. Try again shortly.'**
  String get jevRateLimited;

  /// No description provided for @jevUnavailable.
  ///
  /// In en, this message translates to:
  /// **'TypeSafe is unavailable right now.'**
  String get jevUnavailable;

  /// No description provided for @jevNetwork.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t reach TypeSafe. Check your connection.'**
  String get jevNetwork;

  /// No description provided for @jevInvalidResponse.
  ///
  /// In en, this message translates to:
  /// **'TypeSafe returned an unexpected response.'**
  String get jevInvalidResponse;

  /// No description provided for @notionInvalidToken.
  ///
  /// In en, this message translates to:
  /// **'Notion rejected the token.'**
  String get notionInvalidToken;

  /// No description provided for @notionNotShared.
  ///
  /// In en, this message translates to:
  /// **'Capture can’t see that page. In Notion open it, then ••• → Connections → Add connection → Capture.'**
  String get notionNotShared;

  /// No description provided for @notionMissingCapability.
  ///
  /// In en, this message translates to:
  /// **'The Notion connection needs read, update and insert content capabilities.'**
  String get notionMissingCapability;

  /// No description provided for @notionBlockLimit.
  ///
  /// In en, this message translates to:
  /// **'This Notion workspace has reached its free-plan block limit.'**
  String get notionBlockLimit;

  /// No description provided for @notionRateLimited.
  ///
  /// In en, this message translates to:
  /// **'Notion is busy. Try again in a minute.'**
  String get notionRateLimited;

  /// No description provided for @notionUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Notion is unavailable right now.'**
  String get notionUnavailable;

  /// No description provided for @notionNetwork.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t reach Notion. Check your connection.'**
  String get notionNetwork;

  /// No description provided for @notionInvalidRequest.
  ///
  /// In en, this message translates to:
  /// **'Notion refused the request.'**
  String get notionInvalidRequest;

  /// No description provided for @notionTokenMissing.
  ///
  /// In en, this message translates to:
  /// **'Paste your Notion connection token.'**
  String get notionTokenMissing;

  /// No description provided for @notionPageMissing.
  ///
  /// In en, this message translates to:
  /// **'Paste the link to the Notion page to use.'**
  String get notionPageMissing;

  /// No description provided for @typesafeKeyMissing.
  ///
  /// In en, this message translates to:
  /// **'Paste your TypeSafe API key.'**
  String get typesafeKeyMissing;

  /// No description provided for @flagCheckSplit.
  ///
  /// In en, this message translates to:
  /// **'Check this split'**
  String get flagCheckSplit;

  /// No description provided for @flagCheckGroup.
  ///
  /// In en, this message translates to:
  /// **'Check the group'**
  String get flagCheckGroup;

  /// No description provided for @flagCheckTask.
  ///
  /// In en, this message translates to:
  /// **'Check whether this is a task'**
  String get flagCheckTask;

  /// No description provided for @flagCheckReminder.
  ///
  /// In en, this message translates to:
  /// **'Check the reminder'**
  String get flagCheckReminder;

  /// No description provided for @flagChooseTime.
  ///
  /// In en, this message translates to:
  /// **'Choose a time'**
  String get flagChooseTime;

  /// No description provided for @flagChooseAmPm.
  ///
  /// In en, this message translates to:
  /// **'Choose AM or PM'**
  String get flagChooseAmPm;

  /// No description provided for @flagChooseDate.
  ///
  /// In en, this message translates to:
  /// **'Choose a date'**
  String get flagChooseDate;

  /// No description provided for @flagCheckDate.
  ///
  /// In en, this message translates to:
  /// **'Check which date applies'**
  String get flagCheckDate;

  /// No description provided for @flagTimePassed.
  ///
  /// In en, this message translates to:
  /// **'This time has already passed'**
  String get flagTimePassed;

  /// No description provided for @flagClockChange.
  ///
  /// In en, this message translates to:
  /// **'Check the time (clock change)'**
  String get flagClockChange;

  /// No description provided for @flagCorrectionElsewhere.
  ///
  /// In en, this message translates to:
  /// **'Check which item this correction belongs to'**
  String get flagCorrectionElsewhere;

  /// No description provided for @flagRecallUnsupported.
  ///
  /// In en, this message translates to:
  /// **'Recall isn’t available in this version'**
  String get flagRecallUnsupported;

  /// No description provided for @flagNewPiece.
  ///
  /// In en, this message translates to:
  /// **'Review this new piece'**
  String get flagNewPiece;

  /// No description provided for @flagClassificationFailed.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t classify automatically'**
  String get flagClassificationFailed;

  /// No description provided for @problemChooseGroup.
  ///
  /// In en, this message translates to:
  /// **'Choose a group'**
  String get problemChooseGroup;

  /// No description provided for @problemAddTitle.
  ///
  /// In en, this message translates to:
  /// **'Add a title'**
  String get problemAddTitle;

  /// No description provided for @problemChooseAmPm.
  ///
  /// In en, this message translates to:
  /// **'Choose AM or PM'**
  String get problemChooseAmPm;

  /// No description provided for @problemCheckClockChange.
  ///
  /// In en, this message translates to:
  /// **'Check a reminder time near a clock change'**
  String get problemCheckClockChange;

  /// No description provided for @dayToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get dayToday;

  /// No description provided for @dayTomorrow.
  ///
  /// In en, this message translates to:
  /// **'Tomorrow'**
  String get dayTomorrow;

  /// No description provided for @dayYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get dayYesterday;

  /// A day label followed by a time
  ///
  /// In en, this message translates to:
  /// **'{day} {time}'**
  String dayWithTime(String day, String time);

  /// No description provided for @agoJustNow.
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get agoJustNow;

  /// No description provided for @agoMinutes.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 minute ago} other{{count} minutes ago}}'**
  String agoMinutes(int count);

  /// No description provided for @agoHours.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 hour ago} other{{count} hours ago}}'**
  String agoHours(int count);

  /// No description provided for @agoYesterday.
  ///
  /// In en, this message translates to:
  /// **'Yesterday'**
  String get agoYesterday;

  /// No description provided for @agoDays.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 day ago} other{{count} days ago}}'**
  String agoDays(int count);

  /// No description provided for @cardToday.
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get cardToday;

  /// No description provided for @cardRecent.
  ///
  /// In en, this message translates to:
  /// **'Recent capture'**
  String get cardRecent;

  /// No description provided for @cardGroups.
  ///
  /// In en, this message translates to:
  /// **'Quick groups'**
  String get cardGroups;

  /// No description provided for @viewAll.
  ///
  /// In en, this message translates to:
  /// **'View all'**
  String get viewAll;

  /// No description provided for @emptyToday.
  ///
  /// In en, this message translates to:
  /// **'Nothing due today.'**
  String get emptyToday;

  /// No description provided for @emptyCaptures.
  ///
  /// In en, this message translates to:
  /// **'No captures yet.'**
  String get emptyCaptures;

  /// No description provided for @emptyGroups.
  ///
  /// In en, this message translates to:
  /// **'No groups yet.'**
  String get emptyGroups;

  /// No description provided for @setupTitle.
  ///
  /// In en, this message translates to:
  /// **'Before your first capture'**
  String get setupTitle;

  /// No description provided for @setupSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Three things, once. Keys stay in your Mac’s Keychain.'**
  String get setupSubtitle;

  /// No description provided for @modelTitle.
  ///
  /// In en, this message translates to:
  /// **'Speech model'**
  String get modelTitle;

  /// No description provided for @modelReady.
  ///
  /// In en, this message translates to:
  /// **'Parakeet is on this Mac. Recordings are transcribed locally.'**
  String get modelReady;

  /// No description provided for @modelNeeded.
  ///
  /// In en, this message translates to:
  /// **'Download Parakeet ({megabytes} MB) to transcribe on this Mac.'**
  String modelNeeded(int megabytes);

  /// No description provided for @modelDownload.
  ///
  /// In en, this message translates to:
  /// **'Download'**
  String get modelDownload;

  /// No description provided for @modelRetry.
  ///
  /// In en, this message translates to:
  /// **'Retry download'**
  String get modelRetry;

  /// No description provided for @modelStarting.
  ///
  /// In en, this message translates to:
  /// **'Starting download…'**
  String get modelStarting;

  /// No description provided for @modelProgress.
  ///
  /// In en, this message translates to:
  /// **'Downloading {received} of {total} MB'**
  String modelProgress(int received, int total);

  /// No description provided for @modelVerifying.
  ///
  /// In en, this message translates to:
  /// **'Checking {file}…'**
  String modelVerifying(String file);

  /// No description provided for @modelFailedNetwork.
  ///
  /// In en, this message translates to:
  /// **'Couldn’t download the speech model. Check your connection and retry; it resumes where it stopped.'**
  String get modelFailedNetwork;

  /// No description provided for @modelFailedDisk.
  ///
  /// In en, this message translates to:
  /// **'Not enough disk space for the speech model.'**
  String get modelFailedDisk;

  /// No description provided for @modelFailedChecksum.
  ///
  /// In en, this message translates to:
  /// **'A model file failed its checksum and was deleted. Retry the download.'**
  String get modelFailedChecksum;

  /// No description provided for @modelFailedUnknown.
  ///
  /// In en, this message translates to:
  /// **'The speech model download stopped. Retry the download.'**
  String get modelFailedUnknown;

  /// No description provided for @modelAttribution.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition: Parakeet-TDT-0.6B-v3 by NVIDIA, licensed CC BY 4.0 (huggingface.co/nvidia/parakeet-tdt-0.6b-v3); ONNX int8 conversion by the k2-fsa sherpa-onnx project. Runs entirely on this Mac.'**
  String get modelAttribution;

  /// No description provided for @typesafeTitle.
  ///
  /// In en, this message translates to:
  /// **'TypeSafe API key'**
  String get typesafeTitle;

  /// No description provided for @typesafeSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved in Keychain. Only transcript text is sent to Jev to sort it.'**
  String get typesafeSaved;

  /// No description provided for @typesafeNeeded.
  ///
  /// In en, this message translates to:
  /// **'Jev sorts the transcript into notes and tasks. Get a key at console.typesafe.ai.'**
  String get typesafeNeeded;

  /// No description provided for @typesafeHintNew.
  ///
  /// In en, this message translates to:
  /// **'Paste your key'**
  String get typesafeHintNew;

  /// No description provided for @typesafeHintReplace.
  ///
  /// In en, this message translates to:
  /// **'Paste a new key to replace it'**
  String get typesafeHintReplace;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @replace.
  ///
  /// In en, this message translates to:
  /// **'Replace'**
  String get replace;

  /// No description provided for @notionTitle.
  ///
  /// In en, this message translates to:
  /// **'Notion'**
  String get notionTitle;

  /// No description provided for @notionConnectedTo.
  ///
  /// In en, this message translates to:
  /// **'Connected to {workspace}. Captures, Library and Groups live in the \"Capture\" page inside the page you chose.'**
  String notionConnectedTo(String workspace);

  /// No description provided for @notionYourWorkspace.
  ///
  /// In en, this message translates to:
  /// **'your workspace'**
  String get notionYourWorkspace;

  /// No description provided for @notionNeeded.
  ///
  /// In en, this message translates to:
  /// **'Create a Notion connection with an access token, add it to one page, then paste the token and the page link here.'**
  String get notionNeeded;

  /// No description provided for @notionTokenHintNew.
  ///
  /// In en, this message translates to:
  /// **'Internal connection token (ntn_…)'**
  String get notionTokenHintNew;

  /// No description provided for @notionTokenHintReplace.
  ///
  /// In en, this message translates to:
  /// **'Paste a new token to replace it'**
  String get notionTokenHintReplace;

  /// No description provided for @notionPageHint.
  ///
  /// In en, this message translates to:
  /// **'Link to the Notion page Capture may use'**
  String get notionPageHint;

  /// No description provided for @notionShowMe.
  ///
  /// In en, this message translates to:
  /// **'Show me how'**
  String get notionShowMe;

  /// No description provided for @notionGuideTitle.
  ///
  /// In en, this message translates to:
  /// **'Connect Notion'**
  String get notionGuideTitle;

  /// No description provided for @notionGuideStep1.
  ///
  /// In en, this message translates to:
  /// **'In Notion, open Settings → Developer and choose Open developer tools.'**
  String get notionGuideStep1;

  /// No description provided for @notionGuideStep2.
  ///
  /// In en, this message translates to:
  /// **'Under Connections, choose New connection.'**
  String get notionGuideStep2;

  /// No description provided for @notionGuideStep3.
  ///
  /// In en, this message translates to:
  /// **'Name it Capture, keep Access token selected, then choose Create connection.'**
  String get notionGuideStep3;

  /// No description provided for @notionGuideStep4.
  ///
  /// In en, this message translates to:
  /// **'Check that Read, Update and Insert content are ticked. Copy the access token and paste it into Capture.'**
  String get notionGuideStep4;

  /// No description provided for @notionGuideStep5.
  ///
  /// In en, this message translates to:
  /// **'Open the page Capture may use, then choose ••• → Connections → Add connection → Capture.'**
  String get notionGuideStep5;

  /// No description provided for @notionGuideStep6.
  ///
  /// In en, this message translates to:
  /// **'Choose Add to page. Copy the page link (••• → Copy link) and paste it into Capture.'**
  String get notionGuideStep6;

  /// No description provided for @close.
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// No description provided for @numberedStep.
  ///
  /// In en, this message translates to:
  /// **'{number}. {step}'**
  String numberedStep(int number, String step);

  /// No description provided for @connect.
  ///
  /// In en, this message translates to:
  /// **'Connect'**
  String get connect;

  /// No description provided for @reconnect.
  ///
  /// In en, this message translates to:
  /// **'Reconnect'**
  String get reconnect;

  /// No description provided for @disconnect.
  ///
  /// In en, this message translates to:
  /// **'Disconnect'**
  String get disconnect;

  /// No description provided for @shortcutTitle.
  ///
  /// In en, this message translates to:
  /// **'Shortcut'**
  String get shortcutTitle;

  /// No description provided for @shortcutActive.
  ///
  /// In en, this message translates to:
  /// **'Press {shortcut} in any app to start and stop a capture.'**
  String shortcutActive(String shortcut);

  /// No description provided for @shortcutInactive.
  ///
  /// In en, this message translates to:
  /// **'{shortcut} is taken by another app. Choose another.'**
  String shortcutInactive(String shortcut);

  /// No description provided for @shortcutRecord.
  ///
  /// In en, this message translates to:
  /// **'Record shortcut'**
  String get shortcutRecord;

  /// No description provided for @shortcutSave.
  ///
  /// In en, this message translates to:
  /// **'Save shortcut'**
  String get shortcutSave;

  /// No description provided for @shortcutListening.
  ///
  /// In en, this message translates to:
  /// **'Press the keys, or modifiers like ⌃⌥ on their own…'**
  String get shortcutListening;

  /// No description provided for @shortcutUnsupportedKey.
  ///
  /// In en, this message translates to:
  /// **'Use a letter or a digit.'**
  String get shortcutUnsupportedKey;

  /// No description provided for @shortcutTooFewModifiers.
  ///
  /// In en, this message translates to:
  /// **'Use at least two modifiers, including ⌃ or ⌘.'**
  String get shortcutTooFewModifiers;

  /// No description provided for @shortcutTaken.
  ///
  /// In en, this message translates to:
  /// **'That shortcut is already used by another app.'**
  String get shortcutTaken;

  /// No description provided for @micTitle.
  ///
  /// In en, this message translates to:
  /// **'Microphone'**
  String get micTitle;

  /// No description provided for @micGranted.
  ///
  /// In en, this message translates to:
  /// **'Allowed. The microphone is on only while the pill shows.'**
  String get micGranted;

  /// No description provided for @micDenied.
  ///
  /// In en, this message translates to:
  /// **'Blocked. Allow Capture in System Settings → Privacy & Security → Microphone.'**
  String get micDenied;

  /// No description provided for @micUndetermined.
  ///
  /// In en, this message translates to:
  /// **'macOS will ask the first time you record.'**
  String get micUndetermined;

  /// No description provided for @micAllow.
  ///
  /// In en, this message translates to:
  /// **'Allow microphone'**
  String get micAllow;

  /// No description provided for @privacyTitle.
  ///
  /// In en, this message translates to:
  /// **'Privacy'**
  String get privacyTitle;

  /// No description provided for @privacyBody.
  ///
  /// In en, this message translates to:
  /// **'Audio is recorded and transcribed on this Mac. Only the transcript text and your group descriptions go to TypeSafe (Jev) for sorting. A capture Jev sorts cleanly is saved to Notion straight away; anything that needs a decision waits for your review. Keys live in the macOS Keychain. No analytics, no logs of your words.'**
  String get privacyBody;

  /// No description provided for @recordingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Kept on this Mac. Saved captures are also in Notion.'**
  String get recordingsSubtitle;

  /// No description provided for @noTranscript.
  ///
  /// In en, this message translates to:
  /// **'No transcript yet.'**
  String get noTranscript;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @retrySave.
  ///
  /// In en, this message translates to:
  /// **'Retry save'**
  String get retrySave;

  /// No description provided for @reviewAgain.
  ///
  /// In en, this message translates to:
  /// **'Review again'**
  String get reviewAgain;

  /// No description provided for @deleteFromMac.
  ///
  /// In en, this message translates to:
  /// **'Delete from this Mac'**
  String get deleteFromMac;

  /// No description provided for @deleteTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this recording?'**
  String get deleteTitle;

  /// No description provided for @deleteSavedBody.
  ///
  /// In en, this message translates to:
  /// **'The audio and transcript are removed from this Mac. The copy in Notion stays.'**
  String get deleteSavedBody;

  /// No description provided for @deleteUnsavedBody.
  ///
  /// In en, this message translates to:
  /// **'The audio and transcript are removed from this Mac. This can’t be undone.'**
  String get deleteUnsavedBody;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @emptyOpenTasks.
  ///
  /// In en, this message translates to:
  /// **'No open tasks.'**
  String get emptyOpenTasks;

  /// No description provided for @emptyUpcoming.
  ///
  /// In en, this message translates to:
  /// **'Nothing scheduled.'**
  String get emptyUpcoming;

  /// No description provided for @refresh.
  ///
  /// In en, this message translates to:
  /// **'Refresh'**
  String get refresh;

  /// No description provided for @syncRefreshing.
  ///
  /// In en, this message translates to:
  /// **'Refreshing from Notion…'**
  String get syncRefreshing;

  /// No description provided for @syncNever.
  ///
  /// In en, this message translates to:
  /// **'From your last sync with Notion.'**
  String get syncNever;

  /// No description provided for @syncedAgo.
  ///
  /// In en, this message translates to:
  /// **'Synced with Notion: {ago}.'**
  String syncedAgo(String ago);

  /// No description provided for @reminderLabel.
  ///
  /// In en, this message translates to:
  /// **'Reminder'**
  String get reminderLabel;

  /// No description provided for @groupsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Jev files each thought into one group using these descriptions. Describe what belongs, and what does not.'**
  String get groupsSubtitle;

  /// No description provided for @groupsNeedNotion.
  ///
  /// In en, this message translates to:
  /// **'Connect Notion in Settings to manage groups.'**
  String get groupsNeedNotion;

  /// No description provided for @addGroup.
  ///
  /// In en, this message translates to:
  /// **'Add group'**
  String get addGroup;

  /// No description provided for @archivedHeader.
  ///
  /// In en, this message translates to:
  /// **'Archived'**
  String get archivedHeader;

  /// How many library items use a group
  ///
  /// In en, this message translates to:
  /// **'{count} saved'**
  String groupSavedCount(int count);

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @emptyGroupItems.
  ///
  /// In en, this message translates to:
  /// **'Nothing saved here yet.'**
  String get emptyGroupItems;

  /// No description provided for @newGroup.
  ///
  /// In en, this message translates to:
  /// **'New group'**
  String get newGroup;

  /// No description provided for @editGroup.
  ///
  /// In en, this message translates to:
  /// **'Edit group'**
  String get editGroup;

  /// No description provided for @groupName.
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get groupName;

  /// No description provided for @groupDescription.
  ///
  /// In en, this message translates to:
  /// **'What belongs here'**
  String get groupDescription;

  /// No description provided for @archive.
  ///
  /// In en, this message translates to:
  /// **'Archive'**
  String get archive;

  /// No description provided for @restore.
  ///
  /// In en, this message translates to:
  /// **'Restore'**
  String get restore;

  /// No description provided for @groupNameMissing.
  ///
  /// In en, this message translates to:
  /// **'Add a name.'**
  String get groupNameMissing;

  /// No description provided for @groupNameTooLong.
  ///
  /// In en, this message translates to:
  /// **'Keep the name under {max} characters.'**
  String groupNameTooLong(int max);

  /// No description provided for @groupDescriptionMissing.
  ///
  /// In en, this message translates to:
  /// **'Add a short description.'**
  String get groupDescriptionMissing;

  /// No description provided for @groupDuplicateName.
  ///
  /// In en, this message translates to:
  /// **'Another group already uses this name.'**
  String get groupDuplicateName;

  /// No description provided for @editorTitle.
  ///
  /// In en, this message translates to:
  /// **'Ready to save?'**
  String get editorTitle;

  /// No description provided for @nothingToReview.
  ///
  /// In en, this message translates to:
  /// **'Nothing to review.'**
  String get nothingToReview;

  /// No description provided for @reviewTitle.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get reviewTitle;

  /// No description provided for @titleHint.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get titleHint;

  /// No description provided for @detailsHint.
  ///
  /// In en, this message translates to:
  /// **'Details'**
  String get detailsHint;

  /// No description provided for @groupHint.
  ///
  /// In en, this message translates to:
  /// **'Group'**
  String get groupHint;

  /// No description provided for @addDate.
  ///
  /// In en, this message translates to:
  /// **'Add date'**
  String get addDate;

  /// No description provided for @addTime.
  ///
  /// In en, this message translates to:
  /// **'Add time'**
  String get addTime;

  /// No description provided for @remindMe.
  ///
  /// In en, this message translates to:
  /// **'Remind me'**
  String get remindMe;

  /// No description provided for @addTimeForReminder.
  ///
  /// In en, this message translates to:
  /// **'Add a time to set a reminder'**
  String get addTimeForReminder;

  /// No description provided for @removeDate.
  ///
  /// In en, this message translates to:
  /// **'Remove date'**
  String get removeDate;

  /// No description provided for @sourcesHint.
  ///
  /// In en, this message translates to:
  /// **'What you said · tap a word to split before it'**
  String get sourcesHint;

  /// No description provided for @mergeNext.
  ///
  /// In en, this message translates to:
  /// **'Merge with next'**
  String get mergeNext;

  /// No description provided for @fullTranscript.
  ///
  /// In en, this message translates to:
  /// **'Full transcript'**
  String get fullTranscript;

  /// No description provided for @noWordsHeard.
  ///
  /// In en, this message translates to:
  /// **'No words were heard.'**
  String get noWordsHeard;

  /// No description provided for @editorSaved.
  ///
  /// In en, this message translates to:
  /// **'Saved to Notion.'**
  String get editorSaved;

  /// No description provided for @editorNothingSent.
  ///
  /// In en, this message translates to:
  /// **'Nothing is sent to Notion until you save.'**
  String get editorNothingSent;

  /// No description provided for @dontSave.
  ///
  /// In en, this message translates to:
  /// **'Don’t save'**
  String get dontSave;

  /// No description provided for @saveToNotion.
  ///
  /// In en, this message translates to:
  /// **'Save to Notion'**
  String get saveToNotion;

  /// No description provided for @includeItem.
  ///
  /// In en, this message translates to:
  /// **'Include this item'**
  String get includeItem;
}

class _AppLocalizationsDelegate extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) => <String>['en'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

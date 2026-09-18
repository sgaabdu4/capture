// ignore: unused_import
import 'package:intl/intl.dart' as intl;

import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'Capture';

  @override
  String get tagline => 'Say anything. We’ll sort it.';

  @override
  String get sidebarMotto => 'A calmer mind\ngets more done.';

  @override
  String get navGroups => 'Groups';

  @override
  String get navRecordings => 'Recordings';

  @override
  String get navTodo => 'To-Do';

  @override
  String get navUpcoming => 'Upcoming';

  @override
  String get navSettings => 'Settings';

  @override
  String get checkForUpdates => 'Check for updates';

  @override
  String get updateDownloadNow => 'New version · Download now';

  @override
  String get notionConnected => 'Notion connected';

  @override
  String get notionNotConnected => 'Notion not connected';

  @override
  String get detailSeparator => ' · ';

  @override
  String get recordTap => 'Tap to record';

  @override
  String get recordStopTap => 'Tap to stop';

  @override
  String get recordTranscribing => 'Transcribing…';

  @override
  String get recordSorting => 'Sorting…';

  @override
  String get recordWaitingReview => 'Waiting for your review';

  @override
  String get recordSaving => 'Saving to Notion…';

  @override
  String recordShortcutHint(String shortcut) {
    return 'or press $shortcut';
  }

  @override
  String get recordButton => 'Record';

  @override
  String get stopButton => 'Stop recording';

  @override
  String get overlayTranscribing => 'Transcribing on this Mac…';

  @override
  String get overlaySorting => 'Sorting your thoughts…';

  @override
  String get overlaySaving => 'Saving to Notion…';

  @override
  String get reviewNothing => 'I didn’t catch anything to save.';

  @override
  String countNotes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count notes',
      one: '1 note',
    );
    return '$_temp0';
  }

  @override
  String countTasks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count tasks',
      one: '1 task',
    );
    return '$_temp0';
  }

  @override
  String countReminders(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count reminders',
      one: '1 reminder',
    );
    return '$_temp0';
  }

  @override
  String reviewNeedsLook(String problem) {
    return 'Needs a look: $problem';
  }

  @override
  String get kindNote => 'Note';

  @override
  String get kindTask => 'Task';

  @override
  String get menuNothingScheduled => 'Nothing scheduled';

  @override
  String get menuNoCaptures => 'No captures yet';

  @override
  String menuNextUp(String title, String when) {
    return '$title · $when';
  }

  @override
  String get statusSaved => 'Saved to Notion';

  @override
  String get statusWaitingReview => 'Waiting for your review';

  @override
  String get statusSaveIncomplete => 'Save incomplete';

  @override
  String get statusNotSaved => 'Not saved';

  @override
  String get statusNotTranscribed => 'Not transcribed yet';

  @override
  String get statusTranscriptionFailed => 'Transcription failed';

  @override
  String get statusNotSorted => 'Not sorted yet';

  @override
  String get statusProcessing => 'Processing';

  @override
  String get statusNeedsAttention => 'Needs attention';

  @override
  String recentSaved(String summary) {
    return '$summary saved';
  }

  @override
  String get noticeSetupIncomplete => 'Finish setup before your first capture.';

  @override
  String get noticeMicDenied =>
      'Capture needs microphone access. Allow it in System Settings → Privacy & Security → Microphone.';

  @override
  String get noticeRecordingNotStarted => 'Couldn’t start recording.';

  @override
  String get noticeTooShort => 'That was too short to keep.';

  @override
  String get noticeLimitReached => 'Stopped at the 5-minute limit.';

  @override
  String get noticeRecordingInterrupted =>
      'Recording stopped unexpectedly. What was recorded is kept.';

  @override
  String get noticeDismissed => 'Not saved. It stays in Recordings until you delete it.';

  @override
  String get noticeReviewLater => 'Waiting for your review in Recordings.';

  @override
  String get noticeSaved => 'Saved to Notion.';

  @override
  String get noticeSavedNotificationsOff => 'Saved, but macOS notifications are off for Capture.';

  @override
  String get noticeNotionNotConnected => 'Connect Notion in Settings to save.';

  @override
  String get failureTranscription => 'Transcription failed. Your recording is kept; try again.';

  @override
  String get failureJevKey =>
      'TypeSafe rejected the API key. Your capture is kept as one note to edit.';

  @override
  String get failureJevUnavailable =>
      'Couldn’t reach TypeSafe. Your capture is kept as one note to edit.';

  @override
  String get failureJevResponse =>
      'TypeSafe returned an unexpected response. Your capture is kept as one note to edit.';

  @override
  String get failureAudioTooLarge =>
      'The recording is larger than this Notion workspace’s upload limit.';

  @override
  String get failureAudioMissing => 'The compressed recording is missing on this Mac.';

  @override
  String get failureNotionAuth => 'Couldn’t save: Notion rejected the token.';

  @override
  String get failureNotionAccess => 'Couldn’t save: Capture can’t see the Notion page any more.';

  @override
  String get failureNotionBlockLimit =>
      'Couldn’t save: this Notion workspace has reached its block limit.';

  @override
  String get failureNotionUnavailable => 'Couldn’t save: Notion is unavailable. Try again shortly.';

  @override
  String get failureNotionRejected => 'Couldn’t save: Notion refused the request.';

  @override
  String get jevInvalidKey => 'TypeSafe rejected the API key.';

  @override
  String get jevRateLimited => 'TypeSafe is rate limiting requests. Try again shortly.';

  @override
  String get jevUnavailable => 'TypeSafe is unavailable right now.';

  @override
  String get jevNetwork => 'Couldn’t reach TypeSafe. Check your connection.';

  @override
  String get jevInvalidResponse => 'TypeSafe returned an unexpected response.';

  @override
  String get notionInvalidToken => 'Notion rejected the token.';

  @override
  String get notionNotShared =>
      'Capture can’t see that page. In Notion open it, then ••• → Connections → Add connection → Capture.';

  @override
  String get notionMissingCapability =>
      'The Notion connection needs read, update and insert content capabilities.';

  @override
  String get notionBlockLimit => 'This Notion workspace has reached its free-plan block limit.';

  @override
  String get notionRateLimited => 'Notion is busy. Try again in a minute.';

  @override
  String get notionUnavailable => 'Notion is unavailable right now.';

  @override
  String get notionNetwork => 'Couldn’t reach Notion. Check your connection.';

  @override
  String get notionInvalidRequest => 'Notion refused the request.';

  @override
  String get notionTokenMissing => 'Paste your Notion connection token.';

  @override
  String get notionPageMissing => 'Paste the link to the Notion page to use.';

  @override
  String get typesafeKeyMissing => 'Paste your TypeSafe API key.';

  @override
  String get flagCheckSplit => 'Check this split';

  @override
  String get flagCheckGroup => 'Check the group';

  @override
  String get flagCheckTask => 'Check whether this is a task';

  @override
  String get flagCheckReminder => 'Check the reminder';

  @override
  String get flagChooseTime => 'Choose a time';

  @override
  String get flagChooseAmPm => 'Choose AM or PM';

  @override
  String get flagChooseDate => 'Choose a date';

  @override
  String get flagCheckDate => 'Check which date applies';

  @override
  String get flagTimePassed => 'This time has already passed';

  @override
  String get flagClockChange => 'Check the time (clock change)';

  @override
  String get flagCorrectionElsewhere => 'Check which item this correction belongs to';

  @override
  String get flagRecallUnsupported => 'Recall isn’t available in this version';

  @override
  String get flagNewPiece => 'Review this new piece';

  @override
  String get flagClassificationFailed => 'Couldn’t classify automatically';

  @override
  String get problemChooseGroup => 'Choose a group';

  @override
  String get problemAddTitle => 'Add a title';

  @override
  String get problemChooseAmPm => 'Choose AM or PM';

  @override
  String get problemCheckClockChange => 'Check a reminder time near a clock change';

  @override
  String get dayToday => 'Today';

  @override
  String get dayTomorrow => 'Tomorrow';

  @override
  String get dayYesterday => 'Yesterday';

  @override
  String dayWithTime(String day, String time) {
    return '$day $time';
  }

  @override
  String get agoJustNow => 'Just now';

  @override
  String agoMinutes(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count minutes ago',
      one: '1 minute ago',
    );
    return '$_temp0';
  }

  @override
  String agoHours(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count hours ago',
      one: '1 hour ago',
    );
    return '$_temp0';
  }

  @override
  String get agoYesterday => 'Yesterday';

  @override
  String agoDays(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count days ago',
      one: '1 day ago',
    );
    return '$_temp0';
  }

  @override
  String get cardToday => 'Today';

  @override
  String get cardRecent => 'Recent capture';

  @override
  String get cardGroups => 'Quick groups';

  @override
  String get viewAll => 'View all';

  @override
  String get emptyToday => 'Nothing due today.';

  @override
  String get emptyCaptures => 'No captures yet.';

  @override
  String get emptyGroups => 'No groups yet.';

  @override
  String get setupTitle => 'Before your first capture';

  @override
  String get setupSubtitle => 'Three things, once. Keys stay in your Mac’s Keychain.';

  @override
  String get modelTitle => 'Speech model';

  @override
  String get modelReady => 'Parakeet is on this Mac. Recordings are transcribed locally.';

  @override
  String modelNeeded(int megabytes) {
    return 'Download Parakeet ($megabytes MB) to transcribe on this Mac.';
  }

  @override
  String get modelDownload => 'Download';

  @override
  String get modelRetry => 'Retry download';

  @override
  String get modelStarting => 'Starting download…';

  @override
  String modelProgress(int received, int total) {
    return 'Downloading $received of $total MB';
  }

  @override
  String modelVerifying(String file) {
    return 'Checking $file…';
  }

  @override
  String get modelFailedNetwork =>
      'Couldn’t download the speech model. Check your connection and retry; it resumes where it stopped.';

  @override
  String get modelFailedDisk => 'Not enough disk space for the speech model.';

  @override
  String get modelFailedChecksum =>
      'A model file failed its checksum and was deleted. Retry the download.';

  @override
  String get modelFailedUnknown => 'The speech model download stopped. Retry the download.';

  @override
  String get modelAttribution =>
      'Speech recognition: Parakeet-TDT-0.6B-v3 by NVIDIA, licensed CC BY 4.0 (huggingface.co/nvidia/parakeet-tdt-0.6b-v3); ONNX int8 conversion by the k2-fsa sherpa-onnx project. Runs entirely on this Mac.';

  @override
  String get typesafeTitle => 'TypeSafe API key';

  @override
  String get typesafeSaved => 'Saved in Keychain. Only transcript text is sent to Jev to sort it.';

  @override
  String get typesafeNeeded =>
      'Jev sorts the transcript into notes and tasks. Get a key at console.typesafe.ai.';

  @override
  String get typesafeHintNew => 'Paste your key';

  @override
  String get typesafeHintReplace => 'Paste a new key to replace it';

  @override
  String get save => 'Save';

  @override
  String get replace => 'Replace';

  @override
  String get notionTitle => 'Notion';

  @override
  String notionConnectedTo(String workspace) {
    return 'Connected to $workspace. Captures, Library and Groups live in the \"Capture\" page inside the page you chose.';
  }

  @override
  String get notionYourWorkspace => 'your workspace';

  @override
  String get notionNeeded =>
      'Create a Notion connection with an access token, add it to one page, then paste the token and the page link here.';

  @override
  String get notionTokenHintNew => 'Internal connection token (ntn_…)';

  @override
  String get notionTokenHintReplace => 'Paste a new token to replace it';

  @override
  String get notionPageHint => 'Link to the Notion page Capture may use';

  @override
  String get notionShowMe => 'Show me how';

  @override
  String get notionGuideTitle => 'Connect Notion';

  @override
  String get notionGuideStep1 =>
      'In Notion, open Settings → Developer and choose Open developer tools.';

  @override
  String get notionGuideStep2 => 'Under Connections, choose New connection.';

  @override
  String get notionGuideStep3 =>
      'Name it Capture, keep Access token selected, then choose Create connection.';

  @override
  String get notionGuideStep4 =>
      'Check that Read, Update and Insert content are ticked. Copy the access token and paste it into Capture.';

  @override
  String get notionGuideStep5 =>
      'Open the page Capture may use, then choose ••• → Connections → Add connection → Capture.';

  @override
  String get notionGuideStep6 =>
      'Choose Add to page. Copy the page link (••• → Copy link) and paste it into Capture.';

  @override
  String get close => 'Close';

  @override
  String numberedStep(int number, String step) {
    return '$number. $step';
  }

  @override
  String get connect => 'Connect';

  @override
  String get reconnect => 'Reconnect';

  @override
  String get disconnect => 'Disconnect';

  @override
  String get shortcutTitle => 'Shortcut';

  @override
  String shortcutActive(String shortcut) {
    return 'Press $shortcut in any app to start and stop a capture.';
  }

  @override
  String shortcutInactive(String shortcut) {
    return '$shortcut is taken by another app. Choose another.';
  }

  @override
  String get shortcutRecord => 'Record shortcut';

  @override
  String get shortcutSave => 'Save shortcut';

  @override
  String get shortcutListening => 'Press the keys, or modifiers like ⌃⌥ on their own…';

  @override
  String get shortcutUnsupportedKey => 'Use a letter or a digit.';

  @override
  String get shortcutTooFewModifiers => 'Use at least two modifiers, including ⌃ or ⌘.';

  @override
  String get shortcutTaken => 'That shortcut is already used by another app.';

  @override
  String get micTitle => 'Microphone';

  @override
  String get micGranted => 'Allowed. The microphone is on only while the pill shows.';

  @override
  String get micDenied =>
      'Blocked. Allow Capture in System Settings → Privacy & Security → Microphone.';

  @override
  String get micUndetermined => 'macOS will ask the first time you record.';

  @override
  String get micAllow => 'Allow microphone';

  @override
  String get privacyTitle => 'Privacy';

  @override
  String get privacyBody =>
      'Audio is recorded and transcribed on this Mac. Only the transcript text and your group descriptions go to TypeSafe (Jev) for sorting. Nothing reaches Notion until you approve it. Keys live in the macOS Keychain. No analytics, no logs of your words.';

  @override
  String get recordingsSubtitle => 'Kept on this Mac. Saved captures are also in Notion.';

  @override
  String get noTranscript => 'No transcript yet.';

  @override
  String get retry => 'Retry';

  @override
  String get review => 'Review';

  @override
  String get retrySave => 'Retry save';

  @override
  String get reviewAgain => 'Review again';

  @override
  String get deleteFromMac => 'Delete from this Mac';

  @override
  String get deleteTitle => 'Delete this recording?';

  @override
  String get deleteSavedBody =>
      'The audio and transcript are removed from this Mac. The copy in Notion stays.';

  @override
  String get deleteUnsavedBody =>
      'The audio and transcript are removed from this Mac. This can’t be undone.';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get emptyOpenTasks => 'No open tasks.';

  @override
  String get emptyUpcoming => 'Nothing scheduled.';

  @override
  String get refresh => 'Refresh';

  @override
  String get syncRefreshing => 'Refreshing from Notion…';

  @override
  String get syncNever => 'From your last sync with Notion.';

  @override
  String syncedAgo(String ago) {
    return 'Synced with Notion: $ago.';
  }

  @override
  String get reminderLabel => 'Reminder';

  @override
  String get groupsSubtitle =>
      'Jev files each thought into one group using these descriptions. Describe what belongs, and what does not.';

  @override
  String get groupsNeedNotion => 'Connect Notion in Settings to manage groups.';

  @override
  String get addGroup => 'Add group';

  @override
  String get archivedHeader => 'Archived';

  @override
  String groupSavedCount(int count) {
    return '$count saved';
  }

  @override
  String get edit => 'Edit';

  @override
  String get emptyGroupItems => 'Nothing saved here yet.';

  @override
  String get editNote => 'Edit note';

  @override
  String get editTask => 'Edit task';

  @override
  String get entryBodyLoading => 'Loading details from Notion…';

  @override
  String get entryBodyUnavailable => 'Couldn’t load the details from Notion. Edit them there.';

  @override
  String get entryDeleteConfirm => 'Move to Notion trash';

  @override
  String get searchHint => 'Search saved notes and tasks';

  @override
  String get clearSearch => 'Clear search';

  @override
  String searchNoMatches(String query) {
    return 'Nothing saved matches “$query”.';
  }

  @override
  String get newGroup => 'New group';

  @override
  String get editGroup => 'Edit group';

  @override
  String get groupName => 'Name';

  @override
  String get groupDescription => 'What belongs here';

  @override
  String get archive => 'Archive';

  @override
  String get restore => 'Restore';

  @override
  String get groupNameMissing => 'Add a name.';

  @override
  String groupNameTooLong(int max) {
    return 'Keep the name under $max characters.';
  }

  @override
  String get groupDescriptionMissing => 'Add a short description.';

  @override
  String get groupDuplicateName => 'Another group already uses this name.';

  @override
  String get editorTitle => 'Ready to save?';

  @override
  String get nothingToReview => 'Nothing to review.';

  @override
  String get reviewTitle => 'Review';

  @override
  String get titleHint => 'Title';

  @override
  String get detailsHint => 'Details';

  @override
  String get groupHint => 'Group';

  @override
  String get addDate => 'Add date';

  @override
  String get addTime => 'Add time';

  @override
  String get remindMe => 'Remind me';

  @override
  String get addTimeForReminder => 'Add a time to set a reminder';

  @override
  String get removeDate => 'Remove date';

  @override
  String get sourcesHint => 'What you said · tap a word to split before it';

  @override
  String get mergeNext => 'Merge with next';

  @override
  String get fullTranscript => 'Full transcript';

  @override
  String get noWordsHeard => 'No words were heard.';

  @override
  String get editorSaved => 'Saved to Notion.';

  @override
  String get editorNothingSent => 'Nothing is sent to Notion until you save.';

  @override
  String get dontSave => 'Don’t save';

  @override
  String get saveToNotion => 'Save to Notion';

  @override
  String get includeItem => 'Include this item';
}

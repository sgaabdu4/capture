/// Stable selectors for widget and E2E tests. Widgets use
/// `ValueKey(AppWidgetKeys.x)`.
abstract final class AppWidgetKeys {
  // Shell
  static const navHome = 'shell.nav.home';
  static const navGroups = 'shell.nav.groups';
  static const navRecordings = 'shell.nav.recordings';
  static const navTodo = 'shell.nav.todo';
  static const navUpcoming = 'shell.nav.upcoming';
  static const settingsButton = 'shell.settings.button';
  static const notionChip = 'shell.notion.chip';

  // Home
  static const recordButton = 'home.record.button';

  // iPhone overlay
  static const pillStopButton = 'phone.pill.stop';
  static const reviewLaterButton = 'phone.pill.later';
  static const reviewCloseButton = 'phone.review.close';
  static const reviewNoButton = 'phone.review.no';
  static const reviewYesButton = 'phone.review.yes';
  static const reviewEditButton = 'phone.review.edit';

  // Setup and Settings
  static const modelDownloadButton = 'setup.model.download';
  static const typesafeKeyField = 'setup.typesafe.field';
  static const typesafeSaveButton = 'setup.typesafe.save';
  static const notionTokenField = 'setup.notion.token';
  static const notionPageField = 'setup.notion.page';
  static const notionConnectButton = 'setup.notion.connect';
  static const notionGuideButton = 'setup.notion.guide';
  static const notionDisconnectButton = 'setup.notion.disconnect';
  static const shortcutChangeButton = 'settings.shortcut.change';
  static const shortcutSaveButton = 'settings.shortcut.save';
  static const micAllowButton = 'settings.mic.allow';
  static const autoSaveCheckbox = 'settings.autoSave';
  static const resetButton = 'settings.reset';
  static const resetConfirmButton = 'settings.reset.confirm';

  // Recordings and Editor
  static const deleteConfirmButton = 'recordings.delete.confirm';
  static const editorSaveButton = 'editor.save';
  static const editorDontSaveButton = 'editor.dontSave';

  // Groups
  static const addGroupButton = 'groups.add';
  static const groupNameField = 'groups.dialog.name';
  static const groupDescriptionField = 'groups.dialog.description';
  static const groupDialogSaveButton = 'groups.dialog.save';

  // Library
  static const refreshButton = 'library.refresh';
  static const searchField = 'library.search';
  static const entryTitleField = 'library.entry.title';
  static const entryBodyField = 'library.entry.body';
  static const entrySaveButton = 'library.entry.save';
  static const entryCancelButton = 'library.entry.cancel';
  static const entryDeleteButton = 'library.entry.delete';
  static const entryDeleteConfirmButton = 'library.entry.deleteConfirm';
}

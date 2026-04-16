import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_ru.dart';

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
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

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
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('ru'),
  ];

  /// No description provided for @appTitle.
  ///
  /// In en, this message translates to:
  /// **'NeuroGen'**
  String get appTitle;

  /// No description provided for @navGenerate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get navGenerate;

  /// No description provided for @navHistory.
  ///
  /// In en, this message translates to:
  /// **'History'**
  String get navHistory;

  /// No description provided for @generationQueuedSnack.
  ///
  /// In en, this message translates to:
  /// **'Generation queued. Open History to watch progress in real time.'**
  String get generationQueuedSnack;

  /// No description provided for @settingsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTooltip;

  /// No description provided for @activeGenerationsBanner.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 active generation — you can keep using the app.} other{{count} active generations — you can keep using the app.}}'**
  String activeGenerationsBanner(int count);

  /// No description provided for @addPhoto.
  ///
  /// In en, this message translates to:
  /// **'Add a photo'**
  String get addPhoto;

  /// No description provided for @replacePhoto.
  ///
  /// In en, this message translates to:
  /// **'Replace photo'**
  String get replacePhoto;

  /// No description provided for @uploadedReference.
  ///
  /// In en, this message translates to:
  /// **'Uploaded reference'**
  String get uploadedReference;

  /// No description provided for @clearSelectedImageTooltip.
  ///
  /// In en, this message translates to:
  /// **'Clear selected image'**
  String get clearSelectedImageTooltip;

  /// No description provided for @promptTipsTitle.
  ///
  /// In en, this message translates to:
  /// **'Prompt tips'**
  String get promptTipsTitle;

  /// No description provided for @promptTipsParagraph1.
  ///
  /// In en, this message translates to:
  /// **'Describe subject, lighting, style, and composition. Mention colors or mood when it matters.'**
  String get promptTipsParagraph1;

  /// No description provided for @promptTipsParagraph2.
  ///
  /// In en, this message translates to:
  /// **'Avoid only vague words; add concrete visual details.'**
  String get promptTipsParagraph2;

  /// No description provided for @promptHint.
  ///
  /// In en, this message translates to:
  /// **'Describe the image you want to generate'**
  String get promptHint;

  /// No description provided for @promptTipsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Prompt tips'**
  String get promptTipsTooltip;

  /// No description provided for @generate.
  ///
  /// In en, this message translates to:
  /// **'Generate'**
  String get generate;

  /// No description provided for @unableToLoadGeneratedImage.
  ///
  /// In en, this message translates to:
  /// **'Unable to load generated image.'**
  String get unableToLoadGeneratedImage;

  /// No description provided for @historyEmpty.
  ///
  /// In en, this message translates to:
  /// **'No generations yet. Start one from the Generate tab — jobs update here in real time.'**
  String get historyEmpty;

  /// No description provided for @hideResultsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Hide results'**
  String get hideResultsTooltip;

  /// No description provided for @showResultsTooltip.
  ///
  /// In en, this message translates to:
  /// **'Show results'**
  String get showResultsTooltip;

  /// No description provided for @referenceImageTooltip.
  ///
  /// In en, this message translates to:
  /// **'Reference image used for this prompt'**
  String get referenceImageTooltip;

  /// No description provided for @historyNoReferenceThumbnailTooltip.
  ///
  /// In en, this message translates to:
  /// **'No reference image for this prompt'**
  String get historyNoReferenceThumbnailTooltip;

  /// No description provided for @generationRunsCount.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{1 generation} other{{count} generations}}'**
  String generationRunsCount(int count);

  /// No description provided for @latestStatusAt.
  ///
  /// In en, this message translates to:
  /// **'Latest: {status} · {time}'**
  String latestStatusAt(Object status, Object time);

  /// No description provided for @statusPending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get statusPending;

  /// No description provided for @statusProcessing.
  ///
  /// In en, this message translates to:
  /// **'Processing'**
  String get statusProcessing;

  /// No description provided for @statusDone.
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get statusDone;

  /// No description provided for @statusFailed.
  ///
  /// In en, this message translates to:
  /// **'Failed'**
  String get statusFailed;

  /// No description provided for @editInGenerateTooltip.
  ///
  /// In en, this message translates to:
  /// **'Edit in Generate'**
  String get editInGenerateTooltip;

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @retryWithRemaining.
  ///
  /// In en, this message translates to:
  /// **'Retry ({remaining} left)'**
  String retryWithRemaining(int remaining);

  /// No description provided for @noResultImagesOnJob.
  ///
  /// In en, this message translates to:
  /// **'No result images on this job.'**
  String get noResultImagesOnJob;

  /// No description provided for @shareMockMessage.
  ///
  /// In en, this message translates to:
  /// **'Share (mock): image queued for export.\n{url}'**
  String shareMockMessage(Object url);

  /// No description provided for @saved.
  ///
  /// In en, this message translates to:
  /// **'Saved'**
  String get saved;

  /// No description provided for @saveToGallery.
  ///
  /// In en, this message translates to:
  /// **'Save to gallery'**
  String get saveToGallery;

  /// No description provided for @unmarkSaved.
  ///
  /// In en, this message translates to:
  /// **'Unmark saved'**
  String get unmarkSaved;

  /// No description provided for @shareEllipsis.
  ///
  /// In en, this message translates to:
  /// **'Share…'**
  String get shareEllipsis;

  /// No description provided for @delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// No description provided for @historyDeleteSectionTooltip.
  ///
  /// In en, this message translates to:
  /// **'Delete this prompt section from history'**
  String get historyDeleteSectionTooltip;

  /// No description provided for @historyDeleteSectionTitle.
  ///
  /// In en, this message translates to:
  /// **'Delete this section?'**
  String get historyDeleteSectionTitle;

  /// No description provided for @historyDeleteSectionMessage.
  ///
  /// In en, this message translates to:
  /// **'{count, plural, =1{This removes 1 generation for this prompt from history. This cannot be undone.} other{This removes {count} generations for this prompt from history. This cannot be undone.}}'**
  String historyDeleteSectionMessage(int count);

  /// No description provided for @dialogCancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get dialogCancel;

  /// No description provided for @snackMarkedNotSaved.
  ///
  /// In en, this message translates to:
  /// **'Marked as not saved (image stays in your gallery).'**
  String get snackMarkedNotSaved;

  /// No description provided for @snackImageAddedToGallery.
  ///
  /// In en, this message translates to:
  /// **'Image added to your gallery (Photos).'**
  String get snackImageAddedToGallery;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsLanguageSection.
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get settingsLanguageSection;

  /// No description provided for @settingsLanguageDescription.
  ///
  /// In en, this message translates to:
  /// **'Use the device default or pick English or Russian.'**
  String get settingsLanguageDescription;

  /// No description provided for @settingsLanguageSystem.
  ///
  /// In en, this message translates to:
  /// **'System default'**
  String get settingsLanguageSystem;

  /// No description provided for @settingsLanguageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get settingsLanguageEnglish;

  /// No description provided for @settingsLanguageRussian.
  ///
  /// In en, this message translates to:
  /// **'Russian'**
  String get settingsLanguageRussian;

  /// No description provided for @settingsAiProviderMock.
  ///
  /// In en, this message translates to:
  /// **'AI provider (mock)'**
  String get settingsAiProviderMock;

  /// No description provided for @settingsAiProviderMockDescription.
  ///
  /// In en, this message translates to:
  /// **'Only Kling is implemented. Other names are placeholders for future providers.'**
  String get settingsAiProviderMockDescription;

  /// No description provided for @providerSubtitleActiveKling.
  ///
  /// In en, this message translates to:
  /// **'Active — all generations use Kling.'**
  String get providerSubtitleActiveKling;

  /// No description provided for @providerSubtitleMock.
  ///
  /// In en, this message translates to:
  /// **'Mock — not connected.'**
  String get providerSubtitleMock;

  /// No description provided for @aboutSection.
  ///
  /// In en, this message translates to:
  /// **'About'**
  String get aboutSection;

  /// No description provided for @brandNeurogen.
  ///
  /// In en, this message translates to:
  /// **'NeuroGen'**
  String get brandNeurogen;

  /// No description provided for @brandAiBadge.
  ///
  /// In en, this message translates to:
  /// **'AI'**
  String get brandAiBadge;

  /// No description provided for @brandPro.
  ///
  /// In en, this message translates to:
  /// **' Pro'**
  String get brandPro;

  /// No description provided for @errorRequestTimeout.
  ///
  /// In en, this message translates to:
  /// **'The request took too long. Check your connection and try again.'**
  String get errorRequestTimeout;

  /// No description provided for @errorNoConnection.
  ///
  /// In en, this message translates to:
  /// **'No internet connection. Try again when you are online.'**
  String get errorNoConnection;

  /// No description provided for @errorRequestCancelled.
  ///
  /// In en, this message translates to:
  /// **'The request was cancelled.'**
  String get errorRequestCancelled;

  /// No description provided for @errorServiceUnavailableWithCode.
  ///
  /// In en, this message translates to:
  /// **'The service is temporarily unavailable (code {code}). Please try again.'**
  String errorServiceUnavailableWithCode(int code);

  /// No description provided for @errorServiceUnavailable.
  ///
  /// In en, this message translates to:
  /// **'The service is temporarily unavailable. Please try again.'**
  String get errorServiceUnavailable;

  /// No description provided for @errorSomethingWentWrong.
  ///
  /// In en, this message translates to:
  /// **'Something went wrong. Please try again.'**
  String get errorSomethingWentWrong;

  /// No description provided for @errorGenerationNotFound.
  ///
  /// In en, this message translates to:
  /// **'Generation not found.'**
  String get errorGenerationNotFound;

  /// No description provided for @errorImageNotFound.
  ///
  /// In en, this message translates to:
  /// **'Image not found.'**
  String get errorImageNotFound;

  /// No description provided for @errorProviderNotAvailable.
  ///
  /// In en, this message translates to:
  /// **'{name} is not available for image generation.'**
  String errorProviderNotAvailable(Object name);

  /// No description provided for @errorNoTaskIdFromProvider.
  ///
  /// In en, this message translates to:
  /// **'No task id returned from provider.'**
  String get errorNoTaskIdFromProvider;

  /// No description provided for @errorNoImagesReturned.
  ///
  /// In en, this message translates to:
  /// **'No images returned.'**
  String get errorNoImagesReturned;

  /// No description provided for @errorGenerationFailed.
  ///
  /// In en, this message translates to:
  /// **'Generation failed.'**
  String get errorGenerationFailed;

  /// No description provided for @errorEmptyResponseFromApi.
  ///
  /// In en, this message translates to:
  /// **'Empty response from API.'**
  String get errorEmptyResponseFromApi;

  /// No description provided for @errorUnexpectedApiMissingData.
  ///
  /// In en, this message translates to:
  /// **'Unexpected API response: missing data object.'**
  String get errorUnexpectedApiMissingData;

  /// No description provided for @errorUnexpectedNoImageOrTask.
  ///
  /// In en, this message translates to:
  /// **'Unexpected API response: no image URL or task.'**
  String get errorUnexpectedNoImageOrTask;

  /// No description provided for @errorImageGenerationFailed.
  ///
  /// In en, this message translates to:
  /// **'Image generation failed.'**
  String get errorImageGenerationFailed;

  /// No description provided for @errorCompletedWithoutUrls.
  ///
  /// In en, this message translates to:
  /// **'Completed without image URLs.'**
  String get errorCompletedWithoutUrls;

  /// No description provided for @errorKlingApiReturned.
  ///
  /// In en, this message translates to:
  /// **'Kling API returned an error.'**
  String get errorKlingApiReturned;

  /// No description provided for @errorSelectedImageFileNotFound.
  ///
  /// In en, this message translates to:
  /// **'Selected image file was not found.'**
  String get errorSelectedImageFileNotFound;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'ru'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'ru':
      return AppLocalizationsRu();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}

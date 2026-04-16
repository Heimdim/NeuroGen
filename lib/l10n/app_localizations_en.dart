// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'NeuroGen';

  @override
  String get navGenerate => 'Generate';

  @override
  String get navHistory => 'History';

  @override
  String get generationQueuedSnack =>
      'Generation queued. Open History to watch progress in real time.';

  @override
  String get settingsTooltip => 'Settings';

  @override
  String activeGenerationsBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count active generations — you can keep using the app.',
      one: '1 active generation — you can keep using the app.',
    );
    return '$_temp0';
  }

  @override
  String get addPhoto => 'Add a photo';

  @override
  String get replacePhoto => 'Replace photo';

  @override
  String get uploadedReference => 'Uploaded reference';

  @override
  String get clearSelectedImageTooltip => 'Clear selected image';

  @override
  String get promptTipsTitle => 'Prompt tips';

  @override
  String get promptTipsParagraph1 =>
      'Describe subject, lighting, style, and composition. Mention colors or mood when it matters.';

  @override
  String get promptTipsParagraph2 =>
      'Avoid only vague words; add concrete visual details.';

  @override
  String get promptHint => 'Describe the image you want to generate';

  @override
  String get promptTipsTooltip => 'Prompt tips';

  @override
  String get generate => 'Generate';

  @override
  String get unableToLoadGeneratedImage => 'Unable to load generated image.';

  @override
  String get historyEmpty =>
      'No generations yet. Start one from the Generate tab — jobs update here in real time.';

  @override
  String get hideResultsTooltip => 'Hide results';

  @override
  String get showResultsTooltip => 'Show results';

  @override
  String get referenceImageTooltip => 'Reference image used for this prompt';

  @override
  String get historyNoReferenceThumbnailTooltip =>
      'No reference image for this prompt';

  @override
  String generationRunsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count generations',
      one: '1 generation',
    );
    return '$_temp0';
  }

  @override
  String latestStatusAt(Object status, Object time) {
    return 'Latest: $status · $time';
  }

  @override
  String get statusPending => 'Pending';

  @override
  String get statusProcessing => 'Processing';

  @override
  String get statusDone => 'Done';

  @override
  String get statusFailed => 'Failed';

  @override
  String get editInGenerateTooltip => 'Edit in Generate';

  @override
  String get retry => 'Retry';

  @override
  String retryWithRemaining(int remaining) {
    return 'Retry ($remaining left)';
  }

  @override
  String get noResultImagesOnJob => 'No result images on this job.';

  @override
  String shareMockMessage(Object url) {
    return 'Share (mock): image queued for export.\n$url';
  }

  @override
  String get saved => 'Saved';

  @override
  String get saveToGallery => 'Save to gallery';

  @override
  String get unmarkSaved => 'Unmark saved';

  @override
  String get shareEllipsis => 'Share…';

  @override
  String get delete => 'Delete';

  @override
  String get historyDeleteSectionTooltip =>
      'Delete this prompt section from history';

  @override
  String get historyDeleteSectionTitle => 'Delete this section?';

  @override
  String historyDeleteSectionMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'This removes $count generations for this prompt from history. This cannot be undone.',
      one:
          'This removes 1 generation for this prompt from history. This cannot be undone.',
    );
    return '$_temp0';
  }

  @override
  String get dialogCancel => 'Cancel';

  @override
  String get snackMarkedNotSaved =>
      'Marked as not saved (image stays in your gallery).';

  @override
  String get snackImageAddedToGallery =>
      'Image added to your gallery (Photos).';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsLanguageSection => 'Language';

  @override
  String get settingsLanguageDescription =>
      'Use the device default or pick English or Russian.';

  @override
  String get settingsLanguageSystem => 'System default';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageRussian => 'Russian';

  @override
  String get settingsAiProviderMock => 'AI provider (mock)';

  @override
  String get settingsAiProviderMockDescription =>
      'Only Kling is implemented. Other names are placeholders for future providers.';

  @override
  String get providerSubtitleActiveKling =>
      'Active — all generations use Kling.';

  @override
  String get providerSubtitleMock => 'Mock — not connected.';

  @override
  String get aboutSection => 'About';

  @override
  String get brandNeurogen => 'NeuroGen';

  @override
  String get brandAiBadge => 'AI';

  @override
  String get brandPro => ' Pro';

  @override
  String get errorRequestTimeout =>
      'The request took too long. Check your connection and try again.';

  @override
  String get errorNoConnection =>
      'No internet connection. Try again when you are online.';

  @override
  String get errorRequestCancelled => 'The request was cancelled.';

  @override
  String errorServiceUnavailableWithCode(int code) {
    return 'The service is temporarily unavailable (code $code). Please try again.';
  }

  @override
  String get errorServiceUnavailable =>
      'The service is temporarily unavailable. Please try again.';

  @override
  String get errorSomethingWentWrong =>
      'Something went wrong. Please try again.';

  @override
  String get errorGenerationNotFound => 'Generation not found.';

  @override
  String get errorImageNotFound => 'Image not found.';

  @override
  String errorProviderNotAvailable(Object name) {
    return '$name is not available for image generation.';
  }

  @override
  String get errorNoTaskIdFromProvider => 'No task id returned from provider.';

  @override
  String get errorNoImagesReturned => 'No images returned.';

  @override
  String get errorGenerationFailed => 'Generation failed.';

  @override
  String get errorEmptyResponseFromApi => 'Empty response from API.';

  @override
  String get errorUnexpectedApiMissingData =>
      'Unexpected API response: missing data object.';

  @override
  String get errorUnexpectedNoImageOrTask =>
      'Unexpected API response: no image URL or task.';

  @override
  String get errorImageGenerationFailed => 'Image generation failed.';

  @override
  String get errorCompletedWithoutUrls => 'Completed without image URLs.';

  @override
  String get errorKlingApiReturned => 'Kling API returned an error.';

  @override
  String get errorSelectedImageFileNotFound =>
      'Selected image file was not found.';
}

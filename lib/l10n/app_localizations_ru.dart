// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Russian (`ru`).
class AppLocalizationsRu extends AppLocalizations {
  AppLocalizationsRu([String locale = 'ru']) : super(locale);

  @override
  String get appTitle => 'NeuroGen';

  @override
  String get navGenerate => 'Генерация';

  @override
  String get navHistory => 'История';

  @override
  String get generationQueuedSnack =>
      'Генерация поставлена в очередь. Откройте «История», чтобы следить за прогрессом.';

  @override
  String get settingsTooltip => 'Настройки';

  @override
  String activeGenerationsBanner(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          '$count активных генераций — можно продолжать пользоваться приложением.',
      many:
          '$count активных генераций — можно продолжать пользоваться приложением.',
      few:
          '$count активные генерации — можно продолжать пользоваться приложением.',
      one: '1 активная генерация — можно продолжать пользоваться приложением.',
    );
    return '$_temp0';
  }

  @override
  String get addPhoto => 'Добавить фото';

  @override
  String get replacePhoto => 'Заменить фото';

  @override
  String get uploadedReference => 'Загруженная референс-картинка';

  @override
  String get clearSelectedImageTooltip => 'Убрать выбранное изображение';

  @override
  String get promptTipsTitle => 'Советы по промпту';

  @override
  String get promptTipsParagraph1 =>
      'Опишите объект, свет, стиль и композицию. Укажите цвета или настроение, если это важно.';

  @override
  String get promptTipsParagraph2 =>
      'Избегайте только общих слов — добавьте конкретные визуальные детали.';

  @override
  String get promptHint => 'Опишите изображение, которое хотите получить';

  @override
  String get promptTipsTooltip => 'Советы по промпту';

  @override
  String get generate => 'Сгенерировать';

  @override
  String get unableToLoadGeneratedImage =>
      'Не удалось загрузить сгенерированное изображение.';

  @override
  String get historyEmpty =>
      'Пока нет генераций. Запустите на вкладке «Генерация» — задания обновляются здесь в реальном времени.';

  @override
  String get hideResultsTooltip => 'Скрыть результаты';

  @override
  String get showResultsTooltip => 'Показать результаты';

  @override
  String get referenceImageTooltip => 'Референс для этого промпта';

  @override
  String get historyNoReferenceThumbnailTooltip =>
      'Нет референс-изображения для этого промпта';

  @override
  String generationRunsCount(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '$count генераций',
      many: '$count генераций',
      few: '$count генерации',
      one: '1 генерация',
    );
    return '$_temp0';
  }

  @override
  String latestStatusAt(Object status, Object time) {
    return 'Последняя: $status · $time';
  }

  @override
  String get statusPending => 'В очереди';

  @override
  String get statusProcessing => 'Обработка';

  @override
  String get statusDone => 'Готово';

  @override
  String get statusFailed => 'Ошибка';

  @override
  String get editInGenerateTooltip => 'Редактировать в «Генерации»';

  @override
  String get retry => 'Повторить';

  @override
  String retryWithRemaining(int remaining) {
    return 'Повторить (осталось $remaining)';
  }

  @override
  String get noResultImagesOnJob =>
      'У этого задания нет результирующих изображений.';

  @override
  String shareMockMessage(Object url) {
    return 'Поделиться (заглушка): изображение поставлено в очередь экспорта.\n$url';
  }

  @override
  String get saved => 'Сохранено';

  @override
  String get saveToGallery => 'Сохранить в галерею';

  @override
  String get unmarkSaved => 'Снять отметку сохранения';

  @override
  String get shareEllipsis => 'Поделиться…';

  @override
  String get delete => 'Удалить';

  @override
  String get historyDeleteSectionTooltip =>
      'Удалить этот блок промпта из истории';

  @override
  String get historyDeleteSectionTitle => 'Удалить этот блок?';

  @override
  String historyDeleteSectionMessage(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other:
          'Будет удалено $count генераций с этим промптом из истории. Это нельзя отменить.',
      many:
          'Будет удалено $count генераций с этим промптом из истории. Это нельзя отменить.',
      few:
          'Будут удалены $count генерации с этим промптом из истории. Это нельзя отменить.',
      one:
          'Будет удалена 1 генерация с этим промптом из истории. Это нельзя отменить.',
    );
    return '$_temp0';
  }

  @override
  String get dialogCancel => 'Отмена';

  @override
  String get snackMarkedNotSaved =>
      'Отметка сохранения снята (файл остаётся в вашей галерее).';

  @override
  String get snackImageAddedToGallery =>
      'Изображение добавлено в галерею (Фото).';

  @override
  String get settingsTitle => 'Настройки';

  @override
  String get settingsLanguageSection => 'Язык';

  @override
  String get settingsLanguageDescription =>
      'Язык устройства или явный выбор English / Русский.';

  @override
  String get settingsLanguageSystem => 'Как в системе';

  @override
  String get settingsLanguageEnglish => 'English';

  @override
  String get settingsLanguageRussian => 'Русский';

  @override
  String get settingsAiProviderMock => 'Провайдер ИИ (заглушка)';

  @override
  String get settingsAiProviderMockDescription =>
      'Реализован только Kling. Остальные имена — заглушки для будущих провайдеров.';

  @override
  String get providerSubtitleActiveKling =>
      'Активен — все генерации идут через Kling.';

  @override
  String get providerSubtitleMock => 'Заглушка — не подключено.';

  @override
  String get aboutSection => 'О приложении';

  @override
  String get brandNeurogen => 'NeuroGen';

  @override
  String get brandAiBadge => 'AI';

  @override
  String get brandPro => ' Pro';

  @override
  String get errorRequestTimeout =>
      'Запрос занял слишком много времени. Проверьте соединение и попробуйте снова.';

  @override
  String get errorNoConnection =>
      'Нет подключения к интернету. Повторите, когда сеть появится.';

  @override
  String get errorRequestCancelled => 'Запрос отменён.';

  @override
  String errorServiceUnavailableWithCode(int code) {
    return 'Сервис временно недоступен (код $code). Попробуйте позже.';
  }

  @override
  String get errorServiceUnavailable =>
      'Сервис временно недоступен. Попробуйте позже.';

  @override
  String get errorSomethingWentWrong =>
      'Что-то пошло не так. Попробуйте снова.';

  @override
  String get errorGenerationNotFound => 'Генерация не найдена.';

  @override
  String get errorImageNotFound => 'Изображение не найдено.';

  @override
  String errorProviderNotAvailable(Object name) {
    return '$name недоступен для генерации изображений.';
  }

  @override
  String get errorNoTaskIdFromProvider =>
      'Провайдер не вернул идентификатор задачи.';

  @override
  String get errorNoImagesReturned => 'Изображения не получены.';

  @override
  String get errorGenerationFailed => 'Генерация не удалась.';

  @override
  String get errorEmptyResponseFromApi => 'Пустой ответ API.';

  @override
  String get errorUnexpectedApiMissingData =>
      'Неожиданный ответ API: нет объекта data.';

  @override
  String get errorUnexpectedNoImageOrTask =>
      'Неожиданный ответ API: нет URL изображения и нет задачи.';

  @override
  String get errorImageGenerationFailed => 'Генерация изображения не удалась.';

  @override
  String get errorCompletedWithoutUrls => 'Завершено без URL изображений.';

  @override
  String get errorKlingApiReturned => 'Kling API вернул ошибку.';

  @override
  String get errorSelectedImageFileNotFound =>
      'Выбранный файл изображения не найден.';
}

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';

class AppLocaleController extends ChangeNotifier {
  AppLocaleController(this._box) {
    _readFromBox();
  }

  final Box<String> _box;

  static const String _storageKey = 'app_locale_v1';

  Locale? _override;
  Locale? get localeOverride => _override;

  String get currentTag {
    if (_override == null) {
      return 'system';
    }
    return _override!.languageCode == 'ru' ? 'ru' : 'en';
  }

  void _readFromBox() {
    final String raw = _box.get(_storageKey)?.trim().toLowerCase() ?? '';
    if (raw.isEmpty || raw == 'system') {
      _override = null;
      return;
    }
    if (raw == 'ru') {
      _override = const Locale('ru');
      return;
    }
    _override = const Locale('en');
  }

  Future<void> applyTag(String tag) async {
    if (tag == 'ru') {
      _override = const Locale('ru');
      await _box.put(_storageKey, 'ru');
    } else if (tag == 'en') {
      _override = const Locale('en');
      await _box.put(_storageKey, 'en');
    } else {
      _override = null;
      await _box.put(_storageKey, 'system');
    }
    notifyListeners();
  }
}

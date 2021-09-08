import 'package:daeem/l10n/l10n.dart';
import 'package:daeem/preferences/prefs.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class LocaleProvider extends ChangeNotifier {
  Locale? _locale;

  Locale? get locale => _locale;

  void setLocale(Locale locale) {
    if (!L10n.all.contains(locale)) return;

    Prefs.instance.setLanguageCode(locale.languageCode);
    _locale = locale;
    notifyListeners();
  }

  void clearLocale() {
    _locale = null;
    notifyListeners();
  }

  void updateLocale(BuildContext context) async {
    final provider = Provider.of<LocaleProvider>(context, listen: false);
    String? languageCode = await Prefs.instance.getLanguageCode();
    Locale locale = Locale(languageCode ?? "en");
    provider.setLocale(locale);
  }
}

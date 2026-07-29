import 'package:anotty/ads/ad_helper.dart';
import 'package:anotty/ads/ad_manager.dart';
import 'package:anotty/core/database/hive_service.dart';
import 'package:anotty/core/theme/app_theme.dart';
import 'package:anotty/features/home/pages/home_page.dart';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/date_symbol_data_local.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await initializeDateFormatting('pt_BR');

  await HiveService.init();

  // Inicializa anúncios apenas no Android e iOS
  if (!kIsWeb) {
    await AdHelper.initialize();
    await AdManager.initialize();
  }

  runApp(const AnottyApp());
}

class AnottyApp extends StatelessWidget {
  const AnottyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Anotty',
      debugShowCheckedModeBanner: false,

      theme: AppTheme.light,
      darkTheme: AppTheme.dark,
      themeMode: ThemeMode.system,

      locale: const Locale('pt', 'BR'),

      supportedLocales: const [
        Locale('pt', 'BR'),
      ],

      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],

      home: const HomePage(),
    );
  }
}
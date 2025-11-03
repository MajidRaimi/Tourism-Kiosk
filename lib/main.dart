import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'theme/app_theme.dart';
import 'router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  // Initialize with all supported languages
  await Locales.init(['en', 'ar', 'fr', 'es', 'zh', 'hi', 'ur']);

  runApp(
    const ProviderScope(
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      // Design size for tablet (iPad Pro like 11-inch: 834x1194)
      // This creates better scaling for touch kiosks
      designSize: const Size(834, 1194),
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return LocaleBuilder(
          builder: (locale) => MaterialApp.router(
            title: 'Saudi Tourism Kiosk',
            debugShowCheckedModeBanner: false,

            // Localization
            localizationsDelegates: Locales.delegates,
            supportedLocales: Locales.supportedLocales,
            locale: locale,

            // Theme
            theme: AppTheme.getLightTheme(),

            // Router
            routerConfig: AppRouter.router,
          ),
        );
      },
    );
  }
}

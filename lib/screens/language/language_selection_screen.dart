import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../router/app_router.dart';

class LanguageSelectionScreen extends StatelessWidget {
  const LanguageSelectionScreen({super.key});

  final List<Map<String, String>> _languages = const [
    {'code': 'en', 'name': 'English', 'nativeName': 'English', 'flag': '🇬🇧'},
    {'code': 'ar', 'name': 'Arabic', 'nativeName': 'العربية', 'flag': '🇸🇦'},
    {'code': 'fr', 'name': 'French', 'nativeName': 'Français', 'flag': '🇫🇷'},
    {'code': 'es', 'name': 'Spanish', 'nativeName': 'Español', 'flag': '🇪🇸'},
    {'code': 'zh', 'name': 'Chinese', 'nativeName': '中文', 'flag': '🇨🇳'},
    {'code': 'hi', 'name': 'Hindi', 'nativeName': 'हिन्दी', 'flag': '🇮🇳'},
    {'code': 'ur', 'name': 'Urdu', 'nativeName': 'اردو', 'flag': '🇵🇰'},
  ];

  void _selectLanguage(BuildContext context, String languageCode) {
    Locales.change(context, languageCode);
    Future.delayed(const Duration(milliseconds: 300), () {
      if (context.mounted) {
        context.go(AppRouter.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/balad.jpg',
              fit: BoxFit.cover,
            ),
          ),
          // Primary color overlay
          Positioned.fill(
            child: Container(
              decoration: BoxDecoration(
                color: AppTheme.primaryGreen.withOpacity(0.85),
              ),
            ),
          ),
          Container(
            child: Stack(
              children: [
                // Background decorative circles
                Positioned(
                  top: -100.h,
                  right: -100.w,
                  child: Container(
                    width: 300.w,
                    height: 300.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.beigeAccent.withOpacity(0.1),
                    ),
                  ),
                ),
                Positioned(
                  bottom: -150.h,
                  left: -150.w,
                  child: Container(
                    width: 400.w,
                    height: 400.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.lightGreen.withOpacity(0.08),
                    ),
                  ),
                ),

                SafeArea(
                  child: Padding(
                    padding: EdgeInsets.all(48.w),
                    child: Column(
                      children: [
                        // Back Button
                        Row(
                          children: [
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20.r),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () => Navigator.of(context).pop(),
                                    borderRadius: BorderRadius.circular(20.r),
                                    splashColor: AppTheme.lightGreen.withOpacity(0.3),
                                    child: Container(
                                      decoration: BoxDecoration(
                                        gradient: LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: [
                                            Colors.white.withOpacity(0.2),
                                            Colors.white.withOpacity(0.1),
                                          ],
                                        ),
                                        borderRadius: BorderRadius.circular(20.r),
                                        boxShadow: [
                                          BoxShadow(
                                            color: Colors.black.withOpacity(0.2),
                                            blurRadius: 20,
                                            offset: const Offset(0, 10),
                                            spreadRadius: -5,
                                          ),
                                        ],
                                      ),
                                      padding: EdgeInsets.all(16.w),
                                      child: Icon(
                                        Icons.chevron_left,
                                        color: AppTheme.whiteText,
                                        size: 32.sp,
                                      ),
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ],
                        ),

                        SizedBox(height: 40.h),

                        // Title
                        Text(
                          'Select Your Language',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 48.sp,
                            color: AppTheme.whiteText,
                            fontWeight: FontWeight.w900,
                            letterSpacing: 1.2,
                            shadows: [
                              Shadow(
                                color: Colors.black.withOpacity(0.4),
                                offset: const Offset(0, 3),
                                blurRadius: 12,
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: 16.h),
                        Text(
                          'Choose your preferred language to continue',
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: 20.sp,
                            color: AppTheme.beigeAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: 60.h),

                        // Language List
                        Expanded(
                          child: ListView.separated(
                            itemCount: _languages.length,
                            separatorBuilder: (context, index) => SizedBox(height: 16.h),
                            itemBuilder: (context, index) {
                              final language = _languages[index];
                              return _LanguageCard(
                                languageName: language['name']!,
                                nativeName: language['nativeName']!,
                                flag: language['flag']!,
                                onTap: () => _selectLanguage(
                                  context,
                                  language['code']!,
                                ),
                              );
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _LanguageCard extends StatelessWidget {
  final String languageName;
  final String nativeName;
  final String flag;
  final VoidCallback onTap;

  const _LanguageCard({
    required this.languageName,
    required this.nativeName,
    required this.flag,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(24.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24.r),
            splashColor: AppTheme.lightGreen.withOpacity(0.3),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                    spreadRadius: -5,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Flag in background
                  Positioned(
                    right: -20,
                    top: -10,
                    bottom: -10,
                    child: Opacity(
                      opacity: 0.2,
                      child: Text(
                        flag,
                        style: TextStyle(fontSize: 120.sp),
                      ),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 32.w,
                      vertical: 20.h,
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              languageName,
                              style: TextStyle(
                                fontSize: 16.sp,
                                color: AppTheme.beigeAccent,
                                fontWeight: FontWeight.w600,
                                letterSpacing: 0.5,
                              ),
                            ),
                            SizedBox(height: 4.h),
                            Text(
                              nativeName,
                              style: TextStyle(
                                fontSize: 28.sp,
                                color: AppTheme.whiteText,
                                fontWeight: FontWeight.w900,
                                height: 1.0,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.3),
                                    offset: const Offset(0, 2),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

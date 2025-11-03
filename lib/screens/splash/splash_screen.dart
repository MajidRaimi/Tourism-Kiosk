import 'dart:async';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../router/app_router.dart';
import '../../widgets/glass_container.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late AnimationController _subtitleAnimationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;
  late Animation<double> _scaleAnimation;
  Timer? _welcomeTimer;
  int _currentWelcomeIndex = 0;
  String? _selectedLanguage;

  final List<Map<String, String>> _welcomeMessages = [
    {'text': 'Welcome to Saudi Arabia', 'lang': 'English'},
    {'text': 'مرحباً بكم في المملكة العربية السعودية', 'lang': 'العربية'},
    {'text': 'Bienvenue en Arabie Saoudite', 'lang': 'Français'},
    {'text': 'Bienvenido a Arabia Saudita', 'lang': 'Español'},
    {'text': '欢迎来到沙特阿拉伯', 'lang': '中文'},
    {'text': 'सऊदी अरब में आपका स्वागत है', 'lang': 'हिन्दी'},
    {'text': 'سعودی عرب میں خوش آمدید', 'lang': 'اردو'},
  ];

  final List<Map<String, String>> _languages = [
    {'code': 'en', 'name': 'English', 'flag': '🇬🇧'},
    {'code': 'ar', 'name': 'العربية', 'flag': '🇸🇦'},
    {'code': 'fr', 'name': 'Français', 'flag': '🇫🇷'},
    {'code': 'es', 'name': 'Español', 'flag': '🇪🇸'},
    {'code': 'zh', 'name': '中文', 'flag': '🇨🇳'},
    {'code': 'hi', 'name': 'हिन्दी', 'flag': '🇮🇳'},
    {'code': 'ur', 'name': 'اردو', 'flag': '🇵🇰'},
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: const Duration(milliseconds: 800),
      vsync: this,
    );

    _subtitleAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    )..repeat(reverse: true);

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _slideAnimation = Tween<double>(begin: -20.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _subtitleAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _scaleAnimation = Tween<double>(begin: 1.0, end: 1.05).animate(
      CurvedAnimation(
        parent: _subtitleAnimationController,
        curve: Curves.easeInOut,
      ),
    );

    _animationController.forward();
    _startWelcomeRotation();
  }

  void _startWelcomeRotation() {
    _welcomeTimer = Timer.periodic(const Duration(seconds: 3), (timer) {
      if (mounted) {
        setState(() {
          _animationController.reset();
          _currentWelcomeIndex =
              (_currentWelcomeIndex + 1) % _welcomeMessages.length;
          _animationController.forward();
        });
      }
    });
  }

  @override
  void dispose() {
    _welcomeTimer?.cancel();
    _animationController.dispose();
    _subtitleAnimationController.dispose();
    super.dispose();
  }

  void _changeLanguage(String languageCode) {
    Locales.change(context, languageCode);
    Future.delayed(const Duration(milliseconds: 500), () {
      if (mounted) {
        context.go(AppRouter.home);
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: AppTheme.primaryGradient,
        ),
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
              child: Center(
                child: SingleChildScrollView(
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 48.w),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        SizedBox(height: 80.h),

                        // Logo with Glassmorphic effect
                        GlassContainer(
                          borderRadius: 50.r,
                          blur: 15,
                          padding: EdgeInsets.all(50.w),
                          child: Icon(
                            Icons.mosque,
                            size: 120.sp,
                            color: AppTheme.whiteText,
                          ),
                        ),

                        SizedBox(height: 60.h),

                        // Animated Welcome Text
                        SizedBox(
                          height: 120.h,
                          child: FadeTransition(
                            opacity: _fadeAnimation,
                            child: Column(
                              children: [
                                Text(
                                  _welcomeMessages[_currentWelcomeIndex]['text']!,
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 32.sp,
                                    color: AppTheme.whiteText,
                                    fontWeight: FontWeight.bold,
                                    height: 1.3,
                                    shadows: [
                                      Shadow(
                                        color: Colors.black.withOpacity(0.3),
                                        offset: const Offset(0, 2),
                                        blurRadius: 8,
                                      ),
                                    ],
                                  ),
                                ),
                                SizedBox(height: 12.h),
                                Text(
                                  _welcomeMessages[_currentWelcomeIndex]['lang']!,
                                  style: TextStyle(
                                    fontSize: 16.sp,
                                    color: AppTheme.beigeAccent,
                                    fontWeight: FontWeight.w600,
                                    letterSpacing: 2,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),

                        SizedBox(height: 40.h),

                        // Animated Subtitle
                        AnimatedBuilder(
                          animation: _subtitleAnimationController,
                          builder: (context, child) {
                            return Transform.translate(
                              offset: Offset(0, _slideAnimation.value),
                              child: Transform.scale(
                                scale: _scaleAnimation.value,
                                child: Text(
                                  'Explore the Kingdom',
                                  textAlign: TextAlign.center,
                                  style: TextStyle(
                                    fontSize: 20.sp,
                                    color: AppTheme.whiteText.withOpacity(0.9),
                                    fontWeight: FontWeight.w500,
                                  ),
                                ),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 80.h),

                        // Language Selector Label
                        Text(
                          'Choose Your Language',
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: AppTheme.whiteText.withOpacity(0.9),
                            fontWeight: FontWeight.w600,
                          ),
                        ),

                        SizedBox(height: 24.h),

                        // Glassmorphic Language Dropdown
                        ClipRRect(
                          borderRadius: BorderRadius.circular(24.r),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 15, sigmaY: 15),
                            child: Container(
                              width: double.infinity,
                              constraints: BoxConstraints(maxWidth: 500.w),
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.2),
                                borderRadius: BorderRadius.circular(24.r),
                                border: Border.all(
                                  color: Colors.white.withOpacity(0.3),
                                  width: 2,
                                ),
                              ),
                              child: Theme(
                                data: Theme.of(context).copyWith(
                                  canvasColor: Colors.transparent,
                                ),
                                child: DropdownButtonHideUnderline(
                                  child: DropdownButton<String>(
                                    value: _selectedLanguage,
                                    hint: Padding(
                                      padding: EdgeInsets.symmetric(
                                        horizontal: 24.w,
                                        vertical: 20.h,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.language,
                                            color: AppTheme.whiteText,
                                            size: 28.sp,
                                          ),
                                          SizedBox(width: 16.w),
                                          Text(
                                            'Select Language / اختر اللغة',
                                            style: TextStyle(
                                              fontSize: 18.sp,
                                              color: AppTheme.whiteText,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    isExpanded: true,
                                    icon: Padding(
                                      padding: EdgeInsets.only(right: 20.w),
                                      child: Icon(
                                        Icons.keyboard_arrow_down,
                                        color: AppTheme.whiteText,
                                        size: 32.sp,
                                      ),
                                    ),
                                    dropdownColor:
                                        AppTheme.primaryGreen.withOpacity(0.95),
                                    borderRadius: BorderRadius.circular(20.r),
                                    items: _languages.map((lang) {
                                      return DropdownMenuItem<String>(
                                        value: lang['code'],
                                        child: ClipRRect(
                                          borderRadius: BorderRadius.circular(16.r),
                                          child: BackdropFilter(
                                            filter: ImageFilter.blur(
                                                sigmaX: 10, sigmaY: 10),
                                            child: Container(
                                              padding: EdgeInsets.symmetric(
                                                horizontal: 20.w,
                                                vertical: 16.h,
                                              ),
                                              decoration: BoxDecoration(
                                                color: Colors.white.withOpacity(0.1),
                                                borderRadius:
                                                    BorderRadius.circular(16.r),
                                              ),
                                              child: Row(
                                                children: [
                                                  Text(
                                                    lang['flag']!,
                                                    style: TextStyle(fontSize: 28.sp),
                                                  ),
                                                  SizedBox(width: 16.w),
                                                  Text(
                                                    lang['name']!,
                                                    style: TextStyle(
                                                      fontSize: 18.sp,
                                                      color: AppTheme.whiteText,
                                                      fontWeight: FontWeight.w600,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      );
                                    }).toList(),
                                    onChanged: (String? value) {
                                      if (value != null) {
                                        setState(() {
                                          _selectedLanguage = value;
                                        });
                                        _changeLanguage(value);
                                      }
                                    },
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),

                        SizedBox(height: 100.h),
                      ],
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

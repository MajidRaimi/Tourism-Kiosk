import 'dart:async';
import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';

import '../../providers/location_provider.dart';
import '../../router/app_router.dart';
import '../../services/prayer_time_service.dart';
import '../../theme/app_theme.dart';

class SplashScreen extends ConsumerStatefulWidget {
  const SplashScreen({super.key});

  @override
  ConsumerState<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends ConsumerState<SplashScreen>
    with TickerProviderStateMixin {
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  Timer? _welcomeTimer;
  Timer? _clockTimer;
  int _currentWelcomeIndex = 0;
  String? _selectedLanguage;
  String _currentTime = '';

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

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeInOut),
    );

    _animationController.forward();
    _startWelcomeRotation();
    _updateTime();
    _clockTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _updateTime();
    });
  }

  void _updateTime() {
    if (mounted) {
      setState(() {
        final now = DateTime.now();
        _currentTime =
            '${now.hour.toString().padLeft(2, '0')}:${now.minute.toString().padLeft(2, '0')}';
      });
    }
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
    _clockTimer?.cancel();
    _animationController.dispose();
    super.dispose();
  }

  void _goToLanguageSelection() {
    context.push(AppRouter.languageSelection);
  }

  @override
  Widget build(BuildContext context) {
    final weatherAsync = ref.watch(weatherProvider);
    final cityAsync = ref.watch(cityNameProvider);
    final prayerAsync = ref.watch(nextPrayerProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset('assets/images/riyadh.jpg', fit: BoxFit.cover),
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
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Padding(
                          padding: EdgeInsets.symmetric(horizontal: 48.w),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(height: 40.h),

                              // Bento Grid Info Cards
                              SizedBox(
                                height: 200.h,
                                child: Row(
                                  children: [
                                    // Left side - Large Time & City Card with Map
                                    Expanded(
                                      flex: 2,
                                      child: ClipRRect(
                                        borderRadius: BorderRadius.circular(
                                          24.r,
                                        ),
                                        child: BackdropFilter(
                                          filter: ImageFilter.blur(
                                            sigmaX: 20,
                                            sigmaY: 20,
                                          ),
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
                                              borderRadius:
                                                  BorderRadius.circular(24.r),
                                            ),
                                            child: Stack(
                                              children: [
                                                // Map SVG Background
                                                Positioned(
                                                  right: -20,
                                                  bottom: -20,
                                                  child: Opacity(
                                                    opacity: 0.15,
                                                    child: Icon(
                                                      Icons.map_outlined,
                                                      size: 140.sp,
                                                      color:
                                                          AppTheme.beigeAccent,
                                                    ),
                                                  ),
                                                ),
                                                // Content
                                                Padding(
                                                  padding: EdgeInsets.all(24.w),
                                                  child: Column(
                                                    crossAxisAlignment:
                                                        CrossAxisAlignment
                                                            .start,
                                                    mainAxisAlignment:
                                                        MainAxisAlignment
                                                            .spaceBetween,
                                                    children: [
                                                      Row(
                                                        children: [
                                                          Icon(
                                                            Icons.location_on,
                                                            color: AppTheme
                                                                .beigeAccent,
                                                            size: 28.sp,
                                                          ),
                                                          SizedBox(width: 12.w),
                                                          Expanded(
                                                            child: cityAsync.when(
                                                              loading: () => Text(
                                                                'Loading...',
                                                                style: TextStyle(
                                                                  fontSize:
                                                                      18.sp,
                                                                  color: AppTheme
                                                                      .whiteText,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              error: (error, stack) => Text(
                                                                'Riyadh, Saudi Arabia',
                                                                style: TextStyle(
                                                                  fontSize:
                                                                      18.sp,
                                                                  color: AppTheme
                                                                      .whiteText,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                              ),
                                                              data: (city) => Text(
                                                                city,
                                                                style: TextStyle(
                                                                  fontSize:
                                                                      18.sp,
                                                                  color: AppTheme
                                                                      .whiteText,
                                                                  fontWeight:
                                                                      FontWeight
                                                                          .w600,
                                                                ),
                                                                overflow:
                                                                    TextOverflow
                                                                        .ellipsis,
                                                              ),
                                                            ),
                                                          ),
                                                        ],
                                                      ),
                                                      Row(
                                                        crossAxisAlignment:
                                                            CrossAxisAlignment
                                                                .end,
                                                        children: [
                                                          Icon(
                                                            Icons.access_time,
                                                            color: AppTheme
                                                                .beigeAccent,
                                                            size: 32.sp,
                                                          ),
                                                          SizedBox(width: 12.w),
                                                          Text(
                                                            _currentTime.isEmpty
                                                                ? '00:00'
                                                                : _currentTime,
                                                            style: TextStyle(
                                                              fontSize: 56.sp,
                                                              color: AppTheme
                                                                  .whiteText,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              height: 1.0,
                                                              shadows: [
                                                                Shadow(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                        0.3,
                                                                      ),
                                                                  offset:
                                                                      const Offset(
                                                                        0,
                                                                        2,
                                                                      ),
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
                                    SizedBox(width: 12.w),

                                    // Right side - Stacked Weather & Prayer Cards
                                    Expanded(
                                      flex: 1,
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.spaceBetween,
                                        // take the full height of the column
                                        crossAxisAlignment:
                                            CrossAxisAlignment.stretch,
                                        children: [
                                          // Weather Card - Top
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(24.r),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                  sigmaX: 20,
                                                  sigmaY: 20,
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                      colors: [
                                                        Colors.white
                                                            .withOpacity(0.2),
                                                        Colors.white
                                                            .withOpacity(0.1),
                                                      ],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          24.r,
                                                        ),
                                                  ),
                                                  padding: EdgeInsets.all(16.w),
                                                  child: weatherAsync.when(
                                                    loading: () => Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                          width: 24.sp,
                                                          height: 24.sp,
                                                          child:
                                                              CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                                color: AppTheme
                                                                    .beigeAccent,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    error: (error, stack) =>
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons.wb_sunny,
                                                              color: AppTheme
                                                                  .beigeAccent,
                                                              size: 36.sp,
                                                            ),
                                                            SizedBox(
                                                              height: 6.h,
                                                            ),
                                                            Text(
                                                              '28°C',
                                                              style: TextStyle(
                                                                fontSize: 28.sp,
                                                                color: AppTheme
                                                                    .whiteText,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                    data: (weather) {
                                                      if (weather == null) {
                                                        return Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons.wb_sunny,
                                                              color: AppTheme
                                                                  .beigeAccent,
                                                              size: 36.sp,
                                                            ),
                                                            SizedBox(
                                                              height: 6.h,
                                                            ),
                                                            Text(
                                                              '28°C',
                                                              style: TextStyle(
                                                                fontSize: 28.sp,
                                                                color: AppTheme
                                                                    .whiteText,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                              ),
                                                            ),
                                                          ],
                                                        );
                                                      }
                                                      return Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Text(
                                                            weather['icon'] ??
                                                                Icons.wb_sunny,
                                                            style: TextStyle(
                                                              fontSize: 36.sp,
                                                            ),
                                                          ),
                                                          SizedBox(height: 6.h),
                                                          Text(
                                                            '${weather['temperature']}°C',
                                                            style: TextStyle(
                                                              fontSize: 28.sp,
                                                              color: AppTheme
                                                                  .whiteText,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              shadows: [
                                                                Shadow(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                        0.3,
                                                                      ),
                                                                  offset:
                                                                      const Offset(
                                                                        0,
                                                                        2,
                                                                      ),
                                                                  blurRadius: 6,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                          SizedBox(height: 12.h),

                                          // Prayer Time Card - Bottom
                                          Expanded(
                                            child: ClipRRect(
                                              borderRadius:
                                                  BorderRadius.circular(24.r),
                                              child: BackdropFilter(
                                                filter: ImageFilter.blur(
                                                  sigmaX: 20,
                                                  sigmaY: 20,
                                                ),
                                                child: Container(
                                                  decoration: BoxDecoration(
                                                    gradient: LinearGradient(
                                                      begin: Alignment.topLeft,
                                                      end:
                                                          Alignment.bottomRight,
                                                      colors: [
                                                        Colors.white
                                                            .withOpacity(0.2),
                                                        Colors.white
                                                            .withOpacity(0.1),
                                                      ],
                                                    ),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                          24.r,
                                                        ),
                                                  ),
                                                  padding: EdgeInsets.all(16.w),
                                                  child: prayerAsync.when(
                                                    loading: () => Column(
                                                      mainAxisAlignment:
                                                          MainAxisAlignment
                                                              .center,
                                                      children: [
                                                        SizedBox(
                                                          width: 20.sp,
                                                          height: 20.sp,
                                                          child:
                                                              CircularProgressIndicator(
                                                                strokeWidth: 2,
                                                                color: AppTheme
                                                                    .beigeAccent,
                                                              ),
                                                        ),
                                                      ],
                                                    ),
                                                    error: (error, stack) =>
                                                        Column(
                                                          mainAxisAlignment:
                                                              MainAxisAlignment
                                                                  .center,
                                                          children: [
                                                            Icon(
                                                              Icons.mosque,
                                                              color: AppTheme
                                                                  .beigeAccent,
                                                              size: 28.sp,
                                                            ),
                                                            SizedBox(
                                                              height: 6.h,
                                                            ),
                                                            Text(
                                                              'Maghrib',
                                                              style: TextStyle(
                                                                fontSize: 14.sp,
                                                                color: AppTheme
                                                                    .beigeAccent,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w600,
                                                              ),
                                                            ),
                                                            Text(
                                                              '18:30',
                                                              style: TextStyle(
                                                                fontSize: 24.sp,
                                                                color: AppTheme
                                                                    .whiteText,
                                                                fontWeight:
                                                                    FontWeight
                                                                        .w900,
                                                              ),
                                                            ),
                                                          ],
                                                        ),
                                                    data: (prayer) {
                                                      final time =
                                                          PrayerTimeService.formatTime(
                                                            prayer['time'],
                                                          );
                                                      return Column(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .center,
                                                        children: [
                                                          Icon(
                                                            Icons.mosque,
                                                            color: AppTheme
                                                                .beigeAccent,
                                                            size: 28.sp,
                                                          ),
                                                          SizedBox(height: 6.h),
                                                          Text(
                                                            prayer['name'],
                                                            style: TextStyle(
                                                              fontSize: 14.sp,
                                                              color: AppTheme
                                                                  .beigeAccent,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w600,
                                                            ),
                                                          ),
                                                          Text(
                                                            time,
                                                            style: TextStyle(
                                                              fontSize: 24.sp,
                                                              color: AppTheme
                                                                  .whiteText,
                                                              fontWeight:
                                                                  FontWeight
                                                                      .w900,
                                                              shadows: [
                                                                Shadow(
                                                                  color: Colors
                                                                      .black
                                                                      .withOpacity(
                                                                        0.3,
                                                                      ),
                                                                  offset:
                                                                      const Offset(
                                                                        0,
                                                                        2,
                                                                      ),
                                                                  blurRadius: 6,
                                                                ),
                                                              ],
                                                            ),
                                                          ),
                                                        ],
                                                      );
                                                    },
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              SizedBox(height: 60.h),

                              // Animated Welcome Text
                              SizedBox(
                                height: 150.h,
                                child: FadeTransition(
                                  opacity: _fadeAnimation,
                                  child: Column(
                                    children: [
                                      Text(
                                        _welcomeMessages[_currentWelcomeIndex]['text']!,
                                        textAlign: TextAlign.center,
                                        style: TextStyle(
                                          fontSize: 48.sp,
                                          color: AppTheme.whiteText,
                                          fontWeight: FontWeight.w900,
                                          height: 1.3,
                                          letterSpacing: 1.2,
                                          shadows: [
                                            Shadow(
                                              color: Colors.black.withOpacity(
                                                0.4,
                                              ),
                                              offset: const Offset(0, 3),
                                              blurRadius: 12,
                                            ),
                                          ],
                                        ),
                                      ),
                                      SizedBox(height: 16.h),
                                      Text(
                                        _welcomeMessages[_currentWelcomeIndex]['lang']!,
                                        style: TextStyle(
                                          fontSize: 24.sp,
                                          color: AppTheme.beigeAccent,
                                          fontWeight: FontWeight.w700,
                                          letterSpacing: 3,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ),

                              SizedBox(height: 80.h),

                              // Start Now Button with cycling language - Primary Green Glassmorphic
                              ClipRRect(
                                borderRadius: BorderRadius.circular(30.r),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 20,
                                    sigmaY: 20,
                                  ),
                                  child: Material(
                                    color: Colors.transparent,
                                    child: InkWell(
                                      onTap: _goToLanguageSelection,
                                      borderRadius: BorderRadius.circular(30.r),
                                      splashColor: AppTheme.lightGreen
                                          .withOpacity(0.3),
                                      child: Container(
                                        width: double.infinity,
                                        constraints: BoxConstraints(
                                          maxWidth: 600.w,
                                        ),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: 60.w,
                                          vertical: 45.h,
                                        ),
                                        decoration: BoxDecoration(
                                          gradient: LinearGradient(
                                            begin: Alignment.topLeft,
                                            end: Alignment.bottomRight,
                                            colors: [
                                              AppTheme.primaryGreen.withOpacity(
                                                0.5,
                                              ),
                                              AppTheme.secondaryGreen
                                                  .withOpacity(0.4),
                                            ],
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            30.r,
                                          ),
                                          boxShadow: [
                                            BoxShadow(
                                              color: Colors.black.withOpacity(
                                                0.3,
                                              ),
                                              blurRadius: 35,
                                              offset: const Offset(0, 20),
                                              spreadRadius: -5,
                                            ),
                                            BoxShadow(
                                              color: AppTheme.primaryGreen
                                                  .withOpacity(0.4),
                                              blurRadius: 30,
                                              offset: const Offset(0, 10),
                                              spreadRadius: -5,
                                            ),
                                            BoxShadow(
                                              color: AppTheme.beigeAccent
                                                  .withOpacity(0.2),
                                              blurRadius: 25,
                                              offset: const Offset(0, 5),
                                            ),
                                          ],
                                        ),
                                        child: FadeTransition(
                                          opacity: _fadeAnimation,
                                          child: Text(
                                            _getStartNowText(
                                              _currentWelcomeIndex,
                                            ),
                                            textAlign: TextAlign.center,
                                            style: TextStyle(
                                              fontSize: 42.sp,
                                              color: AppTheme.whiteText,
                                              fontWeight: FontWeight.w900,
                                              letterSpacing: 2,
                                              shadows: [
                                                Shadow(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  offset: const Offset(0, 4),
                                                  blurRadius: 15,
                                                ),
                                                Shadow(
                                                  color: AppTheme.primaryGreen
                                                      .withOpacity(0.8),
                                                  offset: const Offset(0, 2),
                                                  blurRadius: 8,
                                                ),
                                              ],
                                            ),
                                          ),
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

  String _getStartNowText(int index) {
    final startNowTexts = [
      'Start Now',
      'ابدأ الآن',
      'Commencer',
      'Empezar',
      '开始',
      'शुरू करें',
      'شروع کریں',
    ];
    return startNowTexts[index];
  }
}

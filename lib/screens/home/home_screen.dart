import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import '../../theme/app_theme.dart';
import '../../widgets/category_tile.dart';
import '../../widgets/glass_container.dart';
import '../../router/app_router.dart';
import '../../providers/location_provider.dart';
import '../../services/prayer_time_service.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final isArabic = Locales.currentLocale(context)?.languageCode == 'ar';
    final weatherAsync = ref.watch(weatherProvider);
    final cityAsync = ref.watch(cityNameProvider);
    final prayerAsync = ref.watch(nextPrayerProvider);

    return Scaffold(
      body: Stack(
        children: [
          // Background image
          Positioned.fill(
            child: Image.asset(
              'assets/images/desset.jpg',
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
                  top: -50,
                  right: -80,
                  child: Container(
                    width: 300,
                    height: 300,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: AppTheme.beigeAccent.withOpacity(0.1),
                    ),
                  ),
                ),
                Positioned(
                  bottom: 100,
                  left: -100,
                  child: Container(
                    width: 400,
                    height: 400,
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
                    LocaleText(
                      'home',
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
                      'Explore amazing places and experiences',
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize: 20.sp,
                        color: AppTheme.beigeAccent,
                        fontWeight: FontWeight.w600,
                      ),
                    ),

                    SizedBox(height: 60.h),

                    // Main Content - Asymmetric Bento Grid
                    Expanded(
                      child: Column(
                        children: [
                          // Row 1 - Large + Medium
                          Expanded(
                            flex: 2,
                            child: Row(
                              children: [
                                // Large tile - Explore
                                Expanded(
                                  flex: 2,
                                  child: CategoryTile(
                                    icon: Icons.explore,
                                    titleKey: 'explore_nearby',
                                    isLarge: true,
                                    onTap: () {
                                      context.push(AppRouter.explore);
                                    },
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                // Medium tile - Heritage
                                Expanded(
                                  flex: 1,
                                  child: CategoryTile(
                                    icon: Icons.mosque,
                                    titleKey: 'heritage_culture',
                                    onTap: () {
                                      context.push(AppRouter.heritageCulture);
                                    },
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // Row 2 - Three Equal Tiles
                          Expanded(
                            flex: 1,
                            child: Row(
                              children: [
                                Expanded(
                                  child: CategoryTile(
                                    icon: Icons.restaurant,
                                    titleKey: 'food_restaurants',
                                    onTap: () {
                                      context.push(AppRouter.foodRestaurants);
                                    },
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: CategoryTile(
                                    icon: Icons.event,
                                    titleKey: 'events_mice',
                                    onTap: () {
                                      context.push(AppRouter.events);
                                    },
                                  ),
                                ),
                                SizedBox(width: 16.w),
                                Expanded(
                                  child: Opacity(
                                    opacity: 0.5,
                                    child: CategoryTile(
                                      icon: Icons.directions_bus,
                                      titleKey: 'transport_directions',
                                      onTap: null,
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: 16.h),

                          // Row 3 - Single Full Width Emergency
                          Expanded(
                            flex: 1,
                            child: CategoryTile(
                              icon: Icons.help_outline,
                              titleKey: 'emergency_support',
                              isEmergency: true,
                              onTap: () {
                                _showEmergencyDialog(context);
                              },
                            ),
                          ),
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

  String _getCurrentDate() {
    final now = DateTime.now();
    final months = [
      'Jan',
      'Feb',
      'Mar',
      'Apr',
      'May',
      'Jun',
      'Jul',
      'Aug',
      'Sep',
      'Oct',
      'Nov',
      'Dec'
    ];
    return '${months[now.month - 1]} ${now.day}, ${now.year}';
  }

  void _showComingSoonDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: Colors.white,
        title: const Row(
          children: [
            Icon(Icons.info_outline, color: AppTheme.primaryGreen),
            SizedBox(width: 12),
            Text('Coming Soon'),
          ],
        ),
        content: const Text('This feature is coming soon!'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('OK'),
          ),
        ],
      ),
    );
  }

  void _showEmergencyDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierColor: Colors.black.withOpacity(0.7),
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(32.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.red.withOpacity(0.3),
                    Colors.red.shade900.withOpacity(0.2),
                  ],
                ),
                borderRadius: BorderRadius.circular(32.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.red.withOpacity(0.4),
                    blurRadius: 30,
                    offset: const Offset(0, 15),
                    spreadRadius: -5,
                  ),
                ],
              ),
              padding: EdgeInsets.all(48.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    Icons.emergency_rounded,
                    size: 80.sp,
                    color: Colors.red.shade100,
                  ),
                  SizedBox(height: 24.h),
                  Text(
                    'Emergency Contacts',
                    style: TextStyle(
                      fontSize: 32.sp,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.whiteText,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.3),
                          offset: const Offset(0, 2),
                          blurRadius: 6,
                        ),
                      ],
                    ),
                  ),
                  SizedBox(height: 32.h),
                  _EmergencyContact(
                    icon: Icons.local_police_rounded,
                    label: 'Police',
                    number: '999',
                  ),
                  SizedBox(height: 16.h),
                  _EmergencyContact(
                    icon: Icons.local_hospital_rounded,
                    label: 'Ambulance',
                    number: '997',
                  ),
                  SizedBox(height: 16.h),
                  _EmergencyContact(
                    icon: Icons.fire_extinguisher_rounded,
                    label: 'Fire Department',
                    number: '998',
                  ),
                  SizedBox(height: 32.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(20.r),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Material(
                        color: Colors.transparent,
                        child: InkWell(
                          onTap: () => Navigator.pop(context),
                          borderRadius: BorderRadius.circular(20.r),
                          splashColor: Colors.red.withOpacity(0.3),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  Colors.red.withOpacity(0.8),
                                  Colors.red.shade900.withOpacity(0.6),
                                ],
                              ),
                              borderRadius: BorderRadius.circular(20.r),
                              boxShadow: [
                                BoxShadow(
                                  color: Colors.black.withOpacity(0.2),
                                  blurRadius: 15,
                                  offset: const Offset(0, 8),
                                ),
                              ],
                            ),
                            padding: EdgeInsets.symmetric(
                              horizontal: 64.w,
                              vertical: 20.h,
                            ),
                            child: Text(
                              'Close',
                              style: TextStyle(
                                fontSize: 18.sp,
                                fontWeight: FontWeight.w900,
                                color: AppTheme.whiteText,
                              ),
                            ),
                          ),
                        ),
                      ),
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

class _EmergencyContact extends StatelessWidget {
  final IconData icon;
  final String label;
  final String number;

  const _EmergencyContact({
    required this.icon,
    required this.label,
    required this.number,
  });

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(20.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding: EdgeInsets.all(20.w),
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
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            children: [
              Container(
                padding: EdgeInsets.all(12.w),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.2),
                  borderRadius: BorderRadius.circular(12.r),
                ),
                child: Icon(
                  icon,
                  color: Colors.red.shade100,
                  size: 28.sp,
                ),
              ),
              SizedBox(width: 16.w),
              Expanded(
                child: Text(
                  label,
                  style: TextStyle(
                    fontSize: 18.sp,
                    fontWeight: FontWeight.w700,
                    color: AppTheme.whiteText,
                  ),
                ),
              ),
              Text(
                number,
                style: TextStyle(
                  fontSize: 24.sp,
                  fontWeight: FontWeight.w900,
                  color: Colors.red.shade100,
                  shadows: [
                    Shadow(
                      color: Colors.black.withOpacity(0.3),
                      offset: const Offset(0, 2),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

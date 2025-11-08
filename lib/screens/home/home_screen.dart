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
                                      context.push(AppRouter.explore);
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
                                      context.push(AppRouter.explore);
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
                                  child: CategoryTile(
                                    icon: Icons.directions_bus,
                                    titleKey: 'transport_directions',
                                    onTap: () {
                                      _showComingSoonDialog(context);
                                    },
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
      builder: (context) => AlertDialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(24),
        ),
        backgroundColor: Colors.red.shade50,
        title: const Row(
          children: [
            Icon(Icons.emergency, color: Colors.red),
            SizedBox(width: 12),
            Text('Emergency Contacts'),
          ],
        ),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _EmergencyContact(
              icon: Icons.local_police,
              label: 'Police',
              number: '999',
            ),
            const SizedBox(height: 12),
            _EmergencyContact(
              icon: Icons.local_hospital,
              label: 'Ambulance',
              number: '997',
            ),
            const SizedBox(height: 12),
            _EmergencyContact(
              icon: Icons.fire_extinguisher,
              label: 'Fire Department',
              number: '998',
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Close'),
          ),
        ],
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
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.red.shade200),
      ),
      child: Row(
        children: [
          Icon(icon, color: Colors.red),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              label,
              style: const TextStyle(fontWeight: FontWeight.w600),
            ),
          ),
          Text(
            number,
            style: const TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.red,
            ),
          ),
        ],
      ),
    );
  }
}

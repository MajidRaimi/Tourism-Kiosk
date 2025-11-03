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
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
            colors: [
              AppTheme.primaryGreen,
              AppTheme.secondaryGreen,
              AppTheme.lightGray,
            ],
            stops: const [0.0, 0.4, 1.0],
          ),
        ),
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
              child: Column(
                children: [
                  // Glass Header
                  Padding(
                    padding: const EdgeInsets.all(24),
                    child: Column(
                      children: [
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Location & Weather Glass Container
                            Expanded(
                              flex: 2,
                              child: GlassContainer(
                                borderRadius: 20.r,
                                blur: 12,
                                padding: EdgeInsets.all(20.w),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    // Location
                                    cityAsync.when(
                                      data: (city) => Row(
                                        children: [
                                          Icon(
                                            Icons.location_on,
                                            color: AppTheme.beigeAccent,
                                            size: 20.sp,
                                          ),
                                          SizedBox(width: 8.w),
                                          Expanded(
                                            child: Text(
                                              city,
                                              style: TextStyle(
                                                fontSize: 16.sp,
                                                color: AppTheme.whiteText
                                                    .withOpacity(0.9),
                                                fontWeight: FontWeight.w600,
                                              ),
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ],
                                      ),
                                      loading: () => Row(
                                        children: [
                                          Icon(Icons.location_on,
                                              color: AppTheme.beigeAccent,
                                              size: 20.sp),
                                          SizedBox(width: 8.w),
                                          Text('Loading...',
                                              style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: AppTheme.whiteText)),
                                        ],
                                      ),
                                      error: (_, __) => Row(
                                        children: [
                                          Icon(Icons.location_on,
                                              color: AppTheme.beigeAccent,
                                              size: 20.sp),
                                          SizedBox(width: 8.w),
                                          Text('Saudi Arabia',
                                              style: TextStyle(
                                                  fontSize: 16.sp,
                                                  color: AppTheme.whiteText)),
                                        ],
                                      ),
                                    ),
                                    SizedBox(height: 16.h),
                                    // Weather
                                    weatherAsync.when(
                                      data: (weather) {
                                        if (weather != null) {
                                          return Row(
                                            children: [
                                              Text(
                                                weather['icon'],
                                                style: TextStyle(fontSize: 40.sp),
                                              ),
                                              SizedBox(width: 12.w),
                                              Column(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.start,
                                                children: [
                                                  Text(
                                                    '${weather['temperature']}°C',
                                                    style: TextStyle(
                                                      fontSize: 32.sp,
                                                      color: AppTheme.whiteText,
                                                      fontWeight: FontWeight.bold,
                                                    ),
                                                  ),
                                                  Text(
                                                    _getCurrentDate(),
                                                    style: TextStyle(
                                                      fontSize: 12.sp,
                                                      color: AppTheme.whiteText
                                                          .withOpacity(0.8),
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          );
                                        }
                                        return const SizedBox.shrink();
                                      },
                                      loading: () => const CircularProgressIndicator(
                                        color: AppTheme.whiteText,
                                      ),
                                      error: (_, __) => Row(
                                        children: [
                                          const Icon(Icons.wb_sunny,
                                              color: AppTheme.beigeAccent,
                                              size: 32),
                                          const SizedBox(width: 12),
                                          Text('--°C',
                                              style: TextStyle(
                                                  fontSize: 24.sp,
                                                  color: AppTheme.whiteText)),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),

                            SizedBox(width: 16.w),

                            // Prayer Time Container
                            Expanded(
                              child: GlassContainer(
                                borderRadius: 20.r,
                                blur: 12,
                                padding: EdgeInsets.all(20.w),
                                child: prayerAsync.when(
                                  data: (prayer) => Column(
                                    crossAxisAlignment: CrossAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(
                                        Icons.mosque,
                                        color: AppTheme.beigeAccent,
                                        size: 32.sp,
                                      ),
                                      SizedBox(height: 8.h),
                                      Text(
                                        isArabic
                                            ? prayer['nameAr']
                                            : prayer['name'],
                                        style: TextStyle(
                                          fontSize: 16.sp,
                                          color: AppTheme.whiteText,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                                      SizedBox(height: 4.h),
                                      Text(
                                        PrayerTimeService.formatTime(
                                            prayer['time']),
                                        style: TextStyle(
                                          fontSize: 20.sp,
                                          color: AppTheme.whiteText,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                    ],
                                  ),
                                  loading: () => const CircularProgressIndicator(
                                    color: AppTheme.whiteText,
                                  ),
                                  error: (_, __) => Column(
                                    children: [
                                      Icon(Icons.mosque,
                                          color: AppTheme.beigeAccent,
                                          size: 32.sp),
                                      SizedBox(height: 8.h),
                                      Text('--:--',
                                          style: TextStyle(
                                              fontSize: 20.sp,
                                              color: AppTheme.whiteText)),
                                    ],
                                  ),
                                ),
                              ),
                            ),

                            SizedBox(width: 16.w),

                            // Accessibility Button
                            ClipRRect(
                              borderRadius: BorderRadius.circular(20.r),
                              child: BackdropFilter(
                                filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                                child: Material(
                                  color: Colors.transparent,
                                  child: InkWell(
                                    onTap: () {
                                      context.push(AppRouter.accessibility);
                                    },
                                    borderRadius: BorderRadius.circular(20.r),
                                    child: Container(
                                      padding: EdgeInsets.all(20.w),
                                      decoration: BoxDecoration(
                                        color: Colors.white.withOpacity(0.15),
                                        borderRadius: BorderRadius.circular(20.r),
                                        border: Border.all(
                                          color: Colors.white.withOpacity(0.25),
                                          width: 1.5,
                                        ),
                                      ),
                                      child: Icon(
                                        Icons.accessibility_new,
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

                        const SizedBox(height: 24),

                        // Home Title
                        LocaleText(
                          'home',
                          style: Theme.of(context)
                              .textTheme
                              .displaySmall
                              ?.copyWith(
                                color: AppTheme.whiteText,
                                fontWeight: FontWeight.bold,
                                shadows: [
                                  Shadow(
                                    color: Colors.black.withOpacity(0.2),
                                    offset: const Offset(0, 2),
                                    blurRadius: 8,
                                  ),
                                ],
                              ),
                        ),
                      ],
                    ),
                  ),

                  // Main Content - Category Tiles
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(24),
                      child: GridView.count(
                        crossAxisCount: 2,
                        crossAxisSpacing: 20,
                        mainAxisSpacing: 20,
                        childAspectRatio: 1.1,
                        children: [
                          CategoryTile(
                            icon: Icons.explore,
                            titleKey: 'explore_nearby',
                            onTap: () {
                              context.push(AppRouter.explore);
                            },
                          ),
                          CategoryTile(
                            icon: Icons.mosque,
                            titleKey: 'heritage_culture',
                            onTap: () {
                              context.push(AppRouter.explore);
                            },
                          ),
                          CategoryTile(
                            icon: Icons.restaurant,
                            titleKey: 'food_restaurants',
                            onTap: () {
                              context.push(AppRouter.explore);
                            },
                          ),
                          CategoryTile(
                            icon: Icons.event,
                            titleKey: 'events_mice',
                            onTap: () {
                              context.push(AppRouter.events);
                            },
                          ),
                          CategoryTile(
                            icon: Icons.directions_bus,
                            titleKey: 'transport_directions',
                            onTap: () {
                              _showComingSoonDialog(context);
                            },
                          ),
                          CategoryTile(
                            icon: Icons.help_outline,
                            titleKey: 'emergency_support',
                            onTap: () {
                              _showEmergencyDialog(context);
                            },
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
      ),

      // Glass Floating Voice Assistant Button
      floatingActionButton: ClipRRect(
        borderRadius: BorderRadius.circular(30),
        child: BackdropFilter(
          filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
          child: Material(
            color: Colors.transparent,
            child: InkWell(
              onTap: () {
                _showComingSoonDialog(context);
              },
              borderRadius: BorderRadius.circular(30),
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                decoration: BoxDecoration(
                  color: AppTheme.beigeAccent.withOpacity(0.95),
                  borderRadius: BorderRadius.circular(30),
                  border: Border.all(
                    color: Colors.white.withOpacity(0.3),
                    width: 2,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppTheme.primaryGreen.withOpacity(0.2),
                      blurRadius: 20,
                      offset: const Offset(0, 10),
                    ),
                  ],
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.mic, size: 28, color: AppTheme.primaryGreen),
                    const SizedBox(width: 12),
                    LocaleText(
                      'voice_assistant',
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppTheme.primaryGreen,
                            fontWeight: FontWeight.bold,
                          ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
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

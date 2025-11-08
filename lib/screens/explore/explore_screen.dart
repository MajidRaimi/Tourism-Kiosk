import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:qr_flutter/qr_flutter.dart';
import '../../theme/app_theme.dart';
import '../../widgets/attraction_card.dart';
import '../../providers/attractions_provider.dart';
import '../../router/app_router.dart';

class ExploreScreen extends ConsumerWidget {
  const ExploreScreen({super.key});

  void _showQRCodeDialog(BuildContext context, String attractionName, String qrData) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        backgroundColor: Colors.transparent,
        child: ClipRRect(
          borderRadius: BorderRadius.circular(24.r),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: [
                    Colors.white.withOpacity(0.9),
                    Colors.white.withOpacity(0.8),
                  ],
                ),
                borderRadius: BorderRadius.circular(24.r),
              ),
              padding: EdgeInsets.all(32.w),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    'Scan QR Code',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.primaryGreen,
                    ),
                  ),
                  SizedBox(height: 8.h),
                  Text(
                    attractionName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 18.sp,
                      color: AppTheme.primaryGreen.withOpacity(0.7),
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  Container(
                    padding: EdgeInsets.all(16.w),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(16.r),
                    ),
                    child: QrImageView(
                      data: qrData,
                      version: QrVersions.auto,
                      size: 200.sp,
                      backgroundColor: Colors.white,
                    ),
                  ),
                  SizedBox(height: 24.h),
                  ElevatedButton(
                    onPressed: () => Navigator.pop(context),
                    style: ElevatedButton.styleFrom(
                      backgroundColor: AppTheme.primaryGreen,
                      padding: EdgeInsets.symmetric(
                        horizontal: 48.w,
                        vertical: 16.h,
                      ),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20.r),
                      ),
                    ),
                    child: Text(
                      'Close',
                      style: TextStyle(
                        fontSize: 16.sp,
                        fontWeight: FontWeight.w700,
                        color: Colors.white,
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

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final attractions = ref.watch(attractionsProvider);
    final isArabic = Locales.currentLocale(context)?.languageCode == 'ar';

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
          // Sliver Content
          CustomScrollView(
            slivers: [
              // Sliver App Bar
              SliverAppBar(
                expandedHeight: 200.h,
                floating: false,
                pinned: true,
                backgroundColor: Colors.transparent,
                automaticallyImplyLeading: false,
                leadingWidth: 120.w,
                leading: Row(
                  children: [
                    SizedBox(width: 48.w),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(20.r),
                      child: BackdropFilter(
                        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
                        child: Material(
                          color: Colors.transparent,
                          child: InkWell(
                            onTap: () => context.pop(),
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
                flexibleSpace: FlexibleSpaceBar(
                  title: Text(
                    'Explore Nearby',
                    style: TextStyle(
                      fontSize: 24.sp,
                      fontWeight: FontWeight.w900,
                      color: AppTheme.whiteText,
                      shadows: [
                        Shadow(
                          color: Colors.black.withOpacity(0.4),
                          offset: const Offset(0, 2),
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  centerTitle: true,
                  background: Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        begin: Alignment.topCenter,
                        end: Alignment.bottomCenter,
                        colors: [
                          Colors.transparent,
                          AppTheme.primaryGreen.withOpacity(0.3),
                        ],
                      ),
                    ),
                  ),
                ),
              ),

              // Attractions Grid
              SliverPadding(
                padding: EdgeInsets.all(24.w),
                sliver: SliverGrid(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                    crossAxisCount: 2,
                    crossAxisSpacing: 16.w,
                    mainAxisSpacing: 16.h,
                    childAspectRatio: 0.75,
                  ),
                  delegate: SliverChildBuilderDelegate(
                    (context, index) {
                      final attraction = attractions[index];
                      return AttractionCard(
                        attraction: attraction,
                        isArabic: isArabic,
                        onTap: () {
                          _showQRCodeDialog(
                            context,
                            isArabic ? attraction.nameAr : attraction.name,
                            'https://maps.google.com/?q=${attraction.name}',
                          );
                        },
                      );
                    },
                    childCount: attractions.length,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _MapMarker extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: AppTheme.primaryGreen,
        shape: BoxShape.circle,
        border: Border.all(color: Colors.white, width: 3),
        boxShadow: [
          BoxShadow(
            color: AppTheme.primaryGreen.withOpacity(0.4),
            blurRadius: 8,
            spreadRadius: 2,
          ),
        ],
      ),
      child: const Icon(
        Icons.location_on,
        color: Colors.white,
        size: 24,
      ),
    );
  }
}

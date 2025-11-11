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
import '../../models/attraction.dart';

class HeritageCultureScreen extends ConsumerStatefulWidget {
  const HeritageCultureScreen({super.key});

  @override
  ConsumerState<HeritageCultureScreen> createState() => _HeritageCultureScreenState();
}

class _HeritageCultureScreenState extends ConsumerState<HeritageCultureScreen> {
  final TextEditingController _searchController = TextEditingController();
  List<Attraction> _filteredAttractions = [];
  bool _isSearching = false;

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.removeListener(_onSearchChanged);
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _isSearching = _searchController.text.isNotEmpty;
      if (_isSearching) {
        ref.read(attractionsProvider).whenData((attractions) {
          final heritageAttractions = attractions.where((a) => a.category == 'heritage').toList();
          final query = _searchController.text.toLowerCase();
          final isArabic = Locales.currentLocale(context)?.languageCode == 'ar';

          _filteredAttractions = heritageAttractions.where((attraction) {
            final name = isArabic ? attraction.nameAr.toLowerCase() : attraction.name.toLowerCase();
            final description = isArabic ? attraction.descriptionAr.toLowerCase() : attraction.description.toLowerCase();
            return name.contains(query) || description.contains(query);
          }).toList();
        });
      }
    });
  }

  void _showQRCodeDialog(BuildContext context, String attractionName, String qrData) {
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
                    Colors.white.withOpacity(0.2),
                    Colors.white.withOpacity(0.1),
                  ],
                ),
                borderRadius: BorderRadius.circular(32.r),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.3),
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
                  Text(
                    'Scan QR Code',
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
                  SizedBox(height: 12.h),
                  Text(
                    attractionName,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 20.sp,
                      color: AppTheme.beigeAccent,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  SizedBox(height: 32.h),
                  ClipRRect(
                    borderRadius: BorderRadius.circular(24.r),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
                      child: Container(
                        padding: EdgeInsets.all(24.w),
                        decoration: BoxDecoration(
                          gradient: LinearGradient(
                            begin: Alignment.topLeft,
                            end: Alignment.bottomRight,
                            colors: [
                              Colors.white.withOpacity(0.95),
                              Colors.white.withOpacity(0.9),
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
                        child: Container(
                          padding: EdgeInsets.all(16.w),
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topLeft,
                              end: Alignment.bottomRight,
                              colors: [
                                AppTheme.beigeAccent.withOpacity(0.15),
                                AppTheme.beigeAccent.withOpacity(0.05),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(16.r),
                          ),
                          child: QrImageView(
                            data: qrData,
                            version: QrVersions.auto,
                            size: 250.sp,
                            backgroundColor: Colors.transparent,
                            eyeStyle: QrEyeStyle(
                              eyeShape: QrEyeShape.square,
                              color: AppTheme.primaryGreen,
                            ),
                            dataModuleStyle: QrDataModuleStyle(
                              dataModuleShape: QrDataModuleShape.square,
                              color: AppTheme.primaryGreen,
                            ),
                          ),
                        ),
                      ),
                    ),
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
                          splashColor: AppTheme.lightGreen.withOpacity(0.3),
                          child: Container(
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                begin: Alignment.topLeft,
                                end: Alignment.bottomRight,
                                colors: [
                                  AppTheme.primaryGreen.withOpacity(0.8),
                                  AppTheme.primaryGreen.withOpacity(0.6),
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

  @override
  Widget build(BuildContext context) {
    final attractionsAsync = ref.watch(attractionsProvider);
    final isArabic = Locales.currentLocale(context)?.languageCode == 'ar';

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
                    'Heritage & Culture',
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

              // Search Bar
              SliverToBoxAdapter(
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 24.h),
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
                        child: TextField(
                          controller: _searchController,
                          style: TextStyle(
                            fontSize: 18.sp,
                            color: AppTheme.whiteText,
                            fontWeight: FontWeight.w600,
                          ),
                          decoration: InputDecoration(
                            hintText: 'Search heritage sites...',
                            hintStyle: TextStyle(
                              fontSize: 18.sp,
                              color: AppTheme.beigeAccent.withOpacity(0.7),
                              fontWeight: FontWeight.w600,
                            ),
                            prefixIcon: Icon(
                              Icons.search_rounded,
                              color: AppTheme.beigeAccent,
                              size: 28.sp,
                            ),
                            suffixIcon: _searchController.text.isNotEmpty
                                ? IconButton(
                                    icon: Icon(
                                      Icons.clear_rounded,
                                      color: AppTheme.beigeAccent,
                                      size: 24.sp,
                                    ),
                                    onPressed: () {
                                      _searchController.clear();
                                    },
                                  )
                                : null,
                            border: InputBorder.none,
                            contentPadding: EdgeInsets.symmetric(
                              horizontal: 24.w,
                              vertical: 20.h,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ),

              // Attractions Grid or Empty State
              attractionsAsync.when(
                loading: () => SliverFillRemaining(
                  child: Center(
                    child: CircularProgressIndicator(
                      color: AppTheme.beigeAccent,
                    ),
                  ),
                ),
                error: (error, stack) => SliverFillRemaining(
                  child: Center(
                    child: Text(
                      'Error loading attractions',
                      style: TextStyle(
                        color: AppTheme.whiteText,
                        fontSize: 18.sp,
                      ),
                    ),
                  ),
                ),
                data: (allAttractions) {
                  final heritageAttractions = allAttractions.where((a) => a.category == 'heritage').toList();
                  final attractions = _isSearching ? _filteredAttractions : heritageAttractions;

                  if (attractions.isEmpty && !_isSearching) {
                    // Empty State - No attractions at all
                    return SliverFillRemaining(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(48.w),
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
                                      Colors.white.withOpacity(0.2),
                                      Colors.white.withOpacity(0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(32.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                      spreadRadius: -5,
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(48.w),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.museum_outlined,
                                      size: 120.sp,
                                      color: AppTheme.beigeAccent.withOpacity(0.5),
                                    ),
                                    SizedBox(height: 24.h),
                                    Text(
                                      'No Heritage Sites Available',
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
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 12.h),
                                    Text(
                                      'Check back later for cultural experiences',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        color: AppTheme.beigeAccent,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else if (attractions.isEmpty && _isSearching) {
                    // No Results State - Search returned nothing
                    return SliverFillRemaining(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(48.w),
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
                                      Colors.white.withOpacity(0.2),
                                      Colors.white.withOpacity(0.1),
                                    ],
                                  ),
                                  borderRadius: BorderRadius.circular(32.r),
                                  boxShadow: [
                                    BoxShadow(
                                      color: Colors.black.withOpacity(0.2),
                                      blurRadius: 20,
                                      offset: const Offset(0, 10),
                                      spreadRadius: -5,
                                    ),
                                  ],
                                ),
                                padding: EdgeInsets.all(48.w),
                                child: Column(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Icon(
                                      Icons.search_off_rounded,
                                      size: 120.sp,
                                      color: AppTheme.beigeAccent.withOpacity(0.5),
                                    ),
                                    SizedBox(height: 24.h),
                                    Text(
                                      'No Results Found',
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
                                      textAlign: TextAlign.center,
                                    ),
                                    SizedBox(height: 12.h),
                                    Text(
                                      'Try searching with different keywords',
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        color: AppTheme.beigeAccent,
                                        fontWeight: FontWeight.w600,
                                      ),
                                      textAlign: TextAlign.center,
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        ),
                      ),
                    );
                  } else {
                    // Attractions Grid
                    return SliverPadding(
                      padding: EdgeInsets.symmetric(horizontal: 48.w, vertical: 24.h),
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
                    );
                  }
                },
              ),
            ],
          ),
        ],
      ),
    );
  }
}

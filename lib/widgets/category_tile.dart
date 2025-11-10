import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter_locales/flutter_locales.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../theme/app_theme.dart';

class CategoryTile extends StatelessWidget {
  final IconData icon;
  final String titleKey;
  final VoidCallback? onTap;
  final Color? backgroundColor;
  final bool isLarge;
  final bool isEmergency;

  const CategoryTile({
    super.key,
    required this.icon,
    required this.titleKey,
    this.onTap,
    this.backgroundColor,
    this.isLarge = false,
    this.isEmergency = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconSize = isLarge ? 140.sp : 100.sp;
    final textSize = isLarge ? 32.sp : 20.sp;

    final gradientColors = isEmergency
        ? [
            Colors.red.withOpacity(0.4),
            Colors.red.shade900.withOpacity(0.3),
          ]
        : [
            Colors.white.withOpacity(0.2),
            Colors.white.withOpacity(0.1),
          ];

    final iconColor = isEmergency ? Colors.red.shade100 : AppTheme.beigeAccent;
    final splashColor = isEmergency
        ? Colors.red.withOpacity(0.3)
        : AppTheme.lightGreen.withOpacity(0.3);

    return ClipRRect(
      borderRadius: BorderRadius.circular(24.r),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 20, sigmaY: 20),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(24.r),
            splashColor: splashColor,
            child: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: gradientColors,
                ),
                borderRadius: BorderRadius.circular(24.r),
                boxShadow: [
                  BoxShadow(
                    color: isEmergency
                        ? Colors.red.withOpacity(0.3)
                        : Colors.black.withOpacity(0.2),
                    blurRadius: 20,
                    offset: const Offset(0, 10),
                    spreadRadius: -5,
                  ),
                ],
              ),
              child: Stack(
                children: [
                  // Icon as background shade
                  Positioned(
                    right: 10,
                    top: 10,
                    child: Opacity(
                      opacity: 0.15,
                      child: Icon(
                        icon,
                        size: iconSize,
                        color: iconColor,
                      ),
                    ),
                  ),
                  // Content
                  Padding(
                    padding: EdgeInsets.symmetric(
                      horizontal: 24.w,
                      vertical: 20.h,
                    ),
                    child: Align(
                      alignment: Alignment.bottomLeft,
                      child: LocaleText(
                        titleKey,
                        maxLines: 3,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          fontSize: textSize,
                          color: AppTheme.whiteText,
                          fontWeight: FontWeight.w900,
                          height: 1.2,
                          shadows: [
                            Shadow(
                              color: Colors.black.withOpacity(0.4),
                              offset: const Offset(0, 2),
                              blurRadius: 8,
                            ),
                          ],
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

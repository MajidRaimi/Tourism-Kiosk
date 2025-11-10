import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../screens/splash/splash_screen.dart';
import '../screens/language/language_selection_screen.dart';
import '../screens/home/home_screen.dart';
import '../screens/explore/explore_screen.dart';
import '../screens/details/attraction_details_screen.dart';
import '../screens/events/events_screen.dart';
import '../screens/accessibility/accessibility_screen.dart';
import '../screens/heritage/heritage_culture_screen.dart';
import '../screens/food/food_restaurants_screen.dart';
import '../models/attraction.dart';

class AppRouter {
  static const String splash = '/';
  static const String languageSelection = '/language-selection';
  static const String home = '/home';
  static const String explore = '/explore';
  static const String attractionDetails = '/attraction-details';
  static const String events = '/events';
  static const String accessibility = '/accessibility';
  static const String heritageCulture = '/heritage-culture';
  static const String foodRestaurants = '/food-restaurants';

  static final GoRouter router = GoRouter(
    initialLocation: splash,
    routes: [
      GoRoute(
        path: splash,
        name: 'splash',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const SplashScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: child,
            );
          },
        ),
      ),
      GoRoute(
        path: languageSelection,
        name: 'languageSelection',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const LanguageSelectionScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.1),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
        ),
      ),
      GoRoute(
        path: home,
        name: 'home',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const HomeScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.1),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
        ),
      ),
      GoRoute(
        path: explore,
        name: 'explore',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const ExploreScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.1, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
        ),
      ),
      GoRoute(
        path: attractionDetails,
        name: 'attractionDetails',
        pageBuilder: (context, state) {
          final attraction = state.extra as Attraction;
          return CustomTransitionPage(
            key: state.pageKey,
            child: AttractionDetailsScreen(attraction: attraction),
            transitionsBuilder:
                (context, animation, secondaryAnimation, child) {
              return FadeTransition(
                opacity: animation,
                child: SlideTransition(
                  position: Tween<Offset>(
                    begin: const Offset(0.1, 0.0),
                    end: Offset.zero,
                  ).animate(animation),
                  child: child,
                ),
              );
            },
          );
        },
      ),
      GoRoute(
        path: events,
        name: 'events',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const EventsScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.1, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
        ),
      ),
      GoRoute(
        path: accessibility,
        name: 'accessibility',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const AccessibilityScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.0, 0.1),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
        ),
      ),
      GoRoute(
        path: heritageCulture,
        name: 'heritageCulture',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const HeritageCultureScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.1, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
        ),
      ),
      GoRoute(
        path: foodRestaurants,
        name: 'foodRestaurants',
        pageBuilder: (context, state) => CustomTransitionPage(
          key: state.pageKey,
          child: const FoodRestaurantsScreen(),
          transitionsBuilder: (context, animation, secondaryAnimation, child) {
            return FadeTransition(
              opacity: animation,
              child: SlideTransition(
                position: Tween<Offset>(
                  begin: const Offset(0.1, 0.0),
                  end: Offset.zero,
                ).animate(animation),
                child: child,
              ),
            );
          },
        ),
      ),
    ],
  );
}

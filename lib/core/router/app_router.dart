import 'package:flutter/material.dart';

import '../constants/app_routes.dart';
import '../../models/booking_model.dart';
import '../../models/service_model.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/profile_screen.dart';
import '../../screens/booking/booking_detail_screen.dart';
import '../../screens/booking/booking_form_screen.dart';
import '../../screens/booking/booking_list_screen.dart';
import '../../screens/common/chat_screen.dart';
import '../../screens/common/map_screen.dart';
import '../../screens/common/splash_screen.dart';
import '../../screens/home/home_screen.dart';
import '../../screens/home/search_screen.dart';
import '../../screens/home/service_detail_screen.dart';
import '../../screens/home/service_list_screen.dart';
import '../../screens/provider/provider_bookings.dart';
import '../../screens/provider/provider_dashboard.dart';
import '../../screens/provider/provider_services.dart';

class AppRouter {
  static Route<dynamic> onGenerateRoute(RouteSettings settings) {
    final String routeName = settings.name ?? '';

    // Handle Supabase OAuth deep links and provider error callbacks.
    if (_isOAuthCallbackRoute(routeName)) {
      return _page(const SplashScreen(), settings);
    }

    switch (routeName) {
      case AppRoutes.splash:
        return _page(const SplashScreen(), settings);
      case AppRoutes.login:
        return _page(const LoginScreen(), settings);
      case AppRoutes.home:
        return _page(const HomeScreen(), settings);
      case AppRoutes.profile:
        return _page(const ProfileScreen(), settings);
      case AppRoutes.services:
        return _page(const ServiceListScreen(), settings);
      case AppRoutes.serviceDetail:
        _expectArgument<ServiceModel>(settings);
        return _page(const ServiceDetailScreen(), settings);
      case AppRoutes.bookingForm:
        _expectArgument<ServiceModel>(settings);
        return _page(const BookingFormScreen(), settings);
      case AppRoutes.bookings:
        return _page(const BookingListScreen(), settings);
      case AppRoutes.bookingDetail:
        _expectArgument<BookingModel>(settings);
        return _page(const BookingDetailScreen(), settings);
      case AppRoutes.providerDashboard:
        return _page(const ProviderDashboard(), settings);
      case AppRoutes.providerServices:
        return _page(const ProviderServices(), settings);
      case AppRoutes.providerBookings:
        return _page(const ProviderBookings(), settings);
      case AppRoutes.map:
        return _page(const MapScreen(), settings);
      case AppRoutes.chat:
        return _page(const ChatScreen(), settings);
      case AppRoutes.search:
        final args = settings.arguments as Map<String, dynamic>?;
        return _page(SearchScreen(
          initialQuery: args?['query'] as String?,
          initialCategory: args?['category'] as String?,
        ), settings);
      default:
        return _unknown(settings);
    }
  }

  static MaterialPageRoute<dynamic> _page(
    Widget child,
    RouteSettings settings,
  ) {
    return MaterialPageRoute(
      builder: (_) => child,
      settings: settings,
    );
  }

  static Route<dynamic> _unknown(RouteSettings settings) {
    return MaterialPageRoute(
      builder: (_) => Scaffold(
        appBar: AppBar(title: const Text('Ruta no encontrada')),
        body: Center(
          child: Text('No existe la ruta: ${settings.name}'),
        ),
      ),
      settings: settings,
    );
  }

  static void _expectArgument<T>(RouteSettings settings) {
    final argument = settings.arguments;
    if (argument is! T) {
      throw ArgumentError(
        'La ruta ${settings.name} requiere un argumento de tipo $T',
      );
    }
  }

  static bool _isOAuthCallbackRoute(String routeName) {
    if (routeName.isEmpty) {
      return false;
    }

    return routeName.startsWith('/?') ||
        routeName.startsWith('/#') ||
        routeName.startsWith('/login-callback');
  }
}

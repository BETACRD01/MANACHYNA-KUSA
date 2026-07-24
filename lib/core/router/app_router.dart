import 'package:flutter/material.dart';

import '../constants/app_routes.dart';
import '../../models/booking_model.dart';
import '../../models/service_model.dart';
import '../../screens/auth/login_screen.dart';
import '../../screens/auth/profile_screen.dart';
import '../../screens/auth/edit_profile_screen.dart';
import '../../screens/admin/admin_dashboard.dart';
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
import '../../screens/notifications/notification_list_screen.dart';
import '../../screens/auth/perfil/language_screen.dart';
import '../../screens/auth/perfil/help_center_screen.dart';
import '../../screens/auth/perfil/contact_screen.dart';
import '../../screens/auth/perfil/legal_document_screen.dart';
import '../../screens/booking/custom_task_request_screen.dart';
import '../../screens/booking/client_custom_tasks_screen.dart';
import '../../screens/provider/provider_task_feed_screen.dart';

// Argumento tipado para SearchScreen
class SearchArgs {
  final String? query;
  final String? category;

  const SearchArgs({this.query, this.category});
}

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

      case AppRoutes.editProfile:
        return _page(const EditProfileScreen(), settings);

      case AppRoutes.services:
        return _page(const ServiceListScreen(), settings);

      case AppRoutes.serviceDetail:
        return _guardedPage<ServiceModel>(
          const ServiceDetailScreen(),
          settings,
        );

      case AppRoutes.bookingForm:
        return _guardedPage<ServiceModel>(
          const BookingFormScreen(),
          settings,
        );

      case AppRoutes.bookings:
        return _page(const BookingListScreen(), settings);

      case AppRoutes.bookingDetail:
        return _guardedPage<BookingModel>(
          const BookingDetailScreen(),
          settings,
        );

      case AppRoutes.providerDashboard:
        return _page(const ProviderDashboard(), settings);

      case AppRoutes.adminDashboard:
        return _page(const AdminDashboard(), settings);

      case AppRoutes.providerServices:
        return _page(const ProviderServices(), settings);

      case AppRoutes.providerBookings:
        return _page(const ProviderBookings(), settings);

      case AppRoutes.map:
        return _page(const MapScreen(), settings);

      case AppRoutes.chat:
        return _page(const ChatScreen(), settings);

      case AppRoutes.search:
        final args = settings.arguments as SearchArgs?;
        return _page(
          SearchScreen(
            initialQuery: args?.query,
            initialCategory: args?.category,
          ),
          settings,
        );

      case AppRoutes.notifications:
        return _page(const NotificationListScreen(), settings);

      case AppRoutes.language:
        return _page(const LanguageScreen(), settings);

      case AppRoutes.helpCenter:
        return _page(const HelpCenterScreen(), settings);

      case AppRoutes.contactUs:
        return _page(const ContactScreen(), settings);

      case AppRoutes.privacyPolicy:
        return _page(
          const LegalDocumentScreen(type: LegalDocumentType.privacy),
          settings,
        );

      case AppRoutes.termsOfService:
        return _page(
          const LegalDocumentScreen(type: LegalDocumentType.terms),
          settings,
        );

      case AppRoutes.customTaskForm:
        return _page(const CustomTaskRequestScreen(), settings);

      case AppRoutes.clientCustomTasks:
        return _page(const ClientCustomTasksScreen(), settings);

      case AppRoutes.providerTaskFeed:
        return _page(const ProviderTaskFeedScreen(), settings);

      default:
        return _unknown(settings);
    }
  }

  // Navegación simple sin validación de argumento
  static MaterialPageRoute<dynamic> _page(
    Widget child,
    RouteSettings settings,
  ) {
    return MaterialPageRoute(
      builder: (_) => child,
      settings: settings,
    );
  }

  // Navegación con validación de tipo — redirige a _unknown si el argumento
  // no coincide con T, evitando crash en runtime
  static Route<dynamic> _guardedPage<T>(
    Widget child,
    RouteSettings settings,
  ) {
    if (settings.arguments is! T) {
      return _unknown(settings);
    }
    return _page(child, settings);
  }

  // Ruta de fallback para rutas no definidas o argumentos inválidos
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

  static bool _isOAuthCallbackRoute(String routeName) {
    if (routeName.isEmpty) return false;

    return routeName.startsWith('/?') ||
        routeName.startsWith('/#') ||
        routeName.startsWith('/login-callback');
  }
}

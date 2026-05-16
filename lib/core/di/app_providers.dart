import 'package:provider/provider.dart';
import 'package:provider/single_child_widget.dart';

import '../../features/auth/data/auth_repository.dart';
import '../../features/bookings/data/booking_repository.dart';
import '../../features/services/data/service_repository.dart';
import '../../features/users/data/user_repository.dart';
import '../../providers/auth_provider.dart';
import '../../providers/booking_provider.dart';
import '../../providers/service_provider.dart';
import '../../providers/user_provider.dart';

class AppProviders {
  static List<SingleChildWidget> build() {
    return [
      Provider<AuthRepository>(create: (_) => AuthRepository()),
      Provider<ServiceRepository>(create: (_) => ServiceRepository()),
      Provider<BookingRepository>(create: (_) => BookingRepository()),
      Provider<UserRepository>(create: (_) => UserRepository()),
      ChangeNotifierProvider<AuthProvider>(
        create: (context) => AuthProvider(
          authRepository: context.read<AuthRepository>(),
        ),
      ),
      ChangeNotifierProvider<ServiceProvider>(
        create: (context) => ServiceProvider(
          repository: context.read<ServiceRepository>(),
        ),
      ),
      ChangeNotifierProvider<BookingProvider>(
        create: (context) => BookingProvider(
          repository: context.read<BookingRepository>(),
        ),
      ),
      ChangeNotifierProvider<UserProvider>(
        create: (context) => UserProvider(
          repository: context.read<UserRepository>(),
        ),
      ),
    ];
  }
}

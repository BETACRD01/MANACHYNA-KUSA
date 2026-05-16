import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'core/constants/app_routes.dart';
import 'core/di/app_providers.dart';
import 'core/router/app_router.dart';
import 'core/theme/app_theme.dart';

class ManachiyKanKusataApp extends StatelessWidget {
  const ManachiyKanKusataApp({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: AppProviders.build(),
      child: MaterialApp(
        title: 'Mañachiy kan Kusata',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.light,
        initialRoute: AppRoutes.login,
        onGenerateRoute: AppRouter.onGenerateRoute,
      ),
    );
  }
}

import 'package:material_ui/material_ui.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:campus_lost_found/app/router.dart';
import 'package:campus_lost_found/app/theme/app_theme.dart';
import 'package:campus_lost_found/core/constants/app_constants.dart';

class CampusLostFoundApp extends ConsumerWidget {
  const CampusLostFoundApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp.router(
      title: AppConstants.appName,
      debugShowCheckedModeBanner: false,
      theme: AppTheme.light(),
      routerConfig: ref.watch(goRouterProvider),
    );
  }
}
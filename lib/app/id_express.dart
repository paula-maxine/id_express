import '../app_exporter.dart';

/// Root app widget
class IdExpress extends ConsumerWidget {
  /// Creates the ID Express app
  const IdExpress({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final goRouter = ref.watch(goRouterProvider);
    final appTheme = ref.watch(appThemeProvider);

    return MaterialApp.router(
      title: 'ID Express',
      debugShowCheckedModeBanner: false,
      theme: appTheme,
      themeMode: ThemeMode.light,
      routerConfig: goRouter,
    );
  }
}

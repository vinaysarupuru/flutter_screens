abstract class RoutePaths {
  const RoutePaths._();

  static const String splash = '/';
  static const String intro = '/intro';
  static const String login = '/login';
  static const String register = '/register';
  static const String forgotPassword = '/forgot-password';
  static const String home = '/home';

  // Idea related routes
  static const String createIdea = '/create-idea';
  static const String ideaDetails = '/idea/:id';

  // User related routes
  static const String settings = '/settings';
  static const String profile = '/profile';

  // App related routes
  static const String about = '/about';
  static const String privacyPolicy = '/privacy-policy';
  static const String termsOfService = '/terms-of-service';
}

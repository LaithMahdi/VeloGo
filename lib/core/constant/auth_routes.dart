// import 'package:flutter/material.dart';
// import 'package:provider/provider.dart';
// import '../../providers/login_provider.dart';
// import '../../views/login/login_screen.dart';
// import '../../views/login/signup_screen.dart';

// /// Example of how to set up navigation between login and signup screens
// ///
// /// Usage in main.dart:
// /// ```dart
// /// MaterialApp(
// ///   routes: AuthRoutes.routes,
// ///   initialRoute: AuthRoutes.login,
// /// )
// /// ```

// class AuthRoutes {
//   static const String login = '/login';
//   static const String signup = '/signup';
//   static const String forgotPassword = '/forgot-password';

//   static Map<String, WidgetBuilder> get routes => {
//     login: (context) => ChangeNotifierProvider(
//       create: (_) => LoginProvider(),
//       child: const LoginScreen(),
//     ),
//     signup: (context) => const SignupScreen(),
//     // Add more routes as needed
//   };

//   /// Navigate to Login Screen
//   static void navigateToLogin(BuildContext context) {
//     Navigator.pushNamedAndRemoveUntil(context, login, (route) => false);
//   }

//   /// Navigate to Signup Screen
//   static void navigateToSignup(BuildContext context) {
//     Navigator.pushNamed(context, signup);
//   }

//   /// Navigate to Forgot Password Screen
//   static void navigateToForgotPassword(BuildContext context) {
//     Navigator.pushNamed(context, forgotPassword);
//   }
// }

// /// Example implementation in main.dart:
// /// 
// /// ```dart
// /// import 'package:flutter/material.dart';
// /// import 'package:flutter_screenutil/flutter_screenutil.dart';
// /// import 'core/constant/app_theme.dart';
// /// import 'core/constant/auth_routes.dart';
// /// 
// /// void main() {
// ///   runApp(const MyApp());
// /// }
// /// 
// /// class MyApp extends StatelessWidget {
// ///   const MyApp({super.key});
// /// 
// ///   @override
// ///   Widget build(BuildContext context) {
// ///     return ScreenUtilInit(
// ///       designSize: const Size(375, 812),
// ///       minTextAdapt: true,
// ///       splitScreenMode: true,
// ///       builder: (context, child) {
// ///         return MaterialApp(
// ///           title: 'VeloGo',
// ///           theme: AppTheme.lightTheme,
// ///           debugShowCheckedModeBanner: false,
// ///           routes: AuthRoutes.routes,
// ///           initialRoute: AuthRoutes.login,
// ///         );
// ///       },
// ///     );
// ///   }
// /// }
// /// ```

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constant/app_color.dart';
import '../../core/constant/app_router.dart';
import '../../providers/login_provider.dart';
import '../../shared/auth/auth_header.dart';
import '../../shared/auth/auth_text_line.dart';
import '../../shared/auth/divider_with_text.dart';
import '../../shared/logo.dart';
import '../../shared/spacer.dart';
import 'widgets/login_form_body.dart';
import 'widgets/social_login_section.dart';

class LoginScreen extends StatelessWidget {
  const LoginScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<LoginProvider>();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          children: [
            VerticalSpacer(20),
            Logo(color: AppColor.primary),
            VerticalSpacer(32),
            AuthHeader(
              title: "Welcome Back",
              description: "Sign in to continue your journey with VeloGo",
            ),
            VerticalSpacer(32),
            LoginFormBody(provider: provider),
            VerticalSpacer(24),
            DividerWithText(text: "Or continue with"),
            VerticalSpacer(24),
            SocialLoginSection(),
            VerticalSpacer(32),
            AuthTextLine(
              text: "Don't have an account? ",
              subText: "Sign Up",
              onPressed: () => GoRouter.of(context).go(AppRouter.signup),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import '../../core/constant/app_color.dart';
import '../../core/constant/app_router.dart';
import '../../providers/signup_provider.dart';
import '../../shared/auth/auth_header.dart';
import '../../shared/auth/auth_text_line.dart';
import '../../shared/logo.dart';
import '../../shared/spacer.dart';
import 'widgets/sign_up_form_body.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignupProvider(),
      child: Scaffold(
        body: SafeArea(
          child: ListView(
            padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
            children: [
              VerticalSpacer(20),
              Logo(color: AppColor.primary),
              VerticalSpacer(32),
              const AuthHeader(
                title: "Create Account",
                description: "Fill in your details to get started with VeloGo",
              ),
              VerticalSpacer(32),
              // Use Consumer to access the provider
              Consumer<SignupProvider>(
                builder: (context, provider, child) {
                  return SignupFormBody(provider: provider);
                },
              ),
              VerticalSpacer(32),
              AuthTextLine(
                text: "Already have an account? ",
                subText: "Log In",
                onPressed: () => GoRouter.of(context).go(AppRouter.login),
              ),
              VerticalSpacer(20),
            ],
          ),
        ),
      ),
    );
  }
}

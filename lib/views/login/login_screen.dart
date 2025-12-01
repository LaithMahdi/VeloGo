import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:go_router/go_router.dart';
import 'package:provider/provider.dart';
import 'package:rent_bike/core/constant/app_router.dart';
import '../../core/constant/app_color.dart';
import '../../core/constant/app_style.dart';
import '../../core/functions/validate_input.dart';
import '../../providers/login_provider.dart';
import '../../shared/auth/auth_header.dart';
import '../../shared/auth/auth_label.dart';
import '../../shared/auth/social_login_button.dart';
import '../../shared/auth/divider_with_text.dart';
import '../../shared/input.dart';
import '../../shared/logo.dart';
import '../../shared/spacer.dart';

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
            _SocialLoginSection(),
            VerticalSpacer(32),
            _SignUpPrompt(),
          ],
        ),
      ),
    );
  }
}

class LoginFormBody extends StatelessWidget {
  const LoginFormBody({super.key, required this.provider});

  final LoginProvider provider;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: provider.loginFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          AuthLabel("Email Address"),
          VerticalSpacer(12),
          Input(
            hintText: "user@gmail.com",
            keyboardType: TextInputType.emailAddress,
            validator: (value) =>
                validateInput(value, min: 7, max: 200, type: InputType.email),
            controller: provider.email,
            prefixIcon: Icon(
              Icons.email_outlined,
              size: 20.w,
              color: AppColor.lightGray,
            ),
          ),
          VerticalSpacer(20),
          AuthLabel("Password"),
          VerticalSpacer(12),
          Input(
            hintText: "Enter your password",
            validator: (value) => validateInput(value, min: 8, max: 200),
            controller: provider.password,
            obscureText: provider.isPasswordVisible,
            prefixIcon: Icon(
              Icons.lock_outline,
              size: 20.w,
              color: AppColor.lightGray,
            ),
            suffixIcon: IconButton(
              onPressed: () => provider.togglePasswordVisibility(),
              icon: Icon(
                provider.isPasswordVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20.w,
                color: AppColor.lightGray,
              ),
            ),
          ),
          VerticalSpacer(12),
          Align(
            alignment: Alignment.centerRight,
            child: TextButton(
              onPressed: () {
                // Navigate to forgot password
              },
              child: Text(
                "Forgot Password?",
                style: AppStyle.styleMedium14.copyWith(color: AppColor.primary),
              ),
            ),
          ),
          VerticalSpacer(24),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: provider.onSubmit,
              child: Text(
                "Sign In",
                style: AppStyle.styleSemiBold16.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _SocialLoginSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SocialLoginButton(
            icon: Icons.g_mobiledata,
            label: "Google",
            onPressed: () {
              // Handle Google login
            },
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: SocialLoginButton(
            icon: Icons.apple,
            label: "Apple",
            onPressed: () {
              // Handle Apple login
            },
          ),
        ),
      ],
    );
  }
}

class _SignUpPrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Don't have an account? ",
          style: AppStyle.styleRegular14.copyWith(color: AppColor.darkGray),
        ),
        TextButton(
          onPressed: () {
            GoRouter.of(context).go(AppRouter.signup);
            // Navigate to signup screen
            // Navigator.pushNamed(context, '/signup');
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            "Sign Up",
            style: AppStyle.styleSemiBold14.copyWith(color: AppColor.primary),
          ),
        ),
      ],
    );
  }
}

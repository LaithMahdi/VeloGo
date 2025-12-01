import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:provider/provider.dart';
import '../../core/constant/app_color.dart';
import '../../core/constant/app_style.dart';
import '../../core/functions/validate_input.dart';
import '../../providers/signup_provider.dart';
import '../../shared/auth/auth_header.dart';
import '../../shared/auth/auth_label.dart';
import '../../shared/auth/social_login_button.dart';
import '../../shared/auth/divider_with_text.dart';
import '../../shared/input.dart';
import '../../shared/logo.dart';
import '../../shared/spacer.dart';

class SignupScreen extends StatelessWidget {
  const SignupScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider(
      create: (_) => SignupProvider(),
      child: const _SignupScreenBody(),
    );
  }
}

class _SignupScreenBody extends StatelessWidget {
  const _SignupScreenBody();

  @override
  Widget build(BuildContext context) {
    final provider = context.watch<SignupProvider>();

    return Scaffold(
      body: SafeArea(
        child: ListView(
          padding: EdgeInsets.symmetric(horizontal: 24.w, vertical: 20.h),
          children: [
            VerticalSpacer(20),
            Logo(color: AppColor.primary),
            VerticalSpacer(32),
            AuthHeader(
              title: "Create Account",
              description: "Fill in your details to get started with VeloGo",
            ),
            VerticalSpacer(32),
            _SignupFormBody(provider: provider),
            VerticalSpacer(24),
            DividerWithText(text: "Or sign up with"),
            VerticalSpacer(24),
            _SocialSignupSection(),
            VerticalSpacer(32),
            _LoginPrompt(),
            VerticalSpacer(20),
          ],
        ),
      ),
    );
  }
}

class _SignupFormBody extends StatelessWidget {
  const _SignupFormBody({required this.provider});

  final SignupProvider provider;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: provider.signupFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Full Name Field
          AuthLabel("Full Name"),
          VerticalSpacer(12),
          Input(
            hintText: "Enter your full name",
            keyboardType: TextInputType.name,
            validator: (value) => validateInput(value, min: 3, max: 100),
            controller: provider.fullName,
            prefixIcon: Icon(
              Icons.person_outline,
              size: 20.w,
              color: AppColor.lightGray,
            ),
          ),
          VerticalSpacer(20),

          // Email Field
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

          // Phone Number Field
          AuthLabel("Phone Number"),
          VerticalSpacer(12),
          Input(
            hintText: "+1 234 567 8900",
            keyboardType: TextInputType.phone,
            validator: (value) => validateInput(value, min: 10, max: 15),
            controller: provider.phoneNumber,
            prefixIcon: Icon(
              Icons.phone_outlined,
              size: 20.w,
              color: AppColor.lightGray,
            ),
          ),
          VerticalSpacer(20),

          // Password Field
          AuthLabel("Password"),
          VerticalSpacer(12),
          Input(
            hintText: "Create a password",
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
          VerticalSpacer(20),

          // Confirm Password Field
          AuthLabel("Confirm Password"),
          VerticalSpacer(12),
          Input(
            hintText: "Confirm your password",
            validator: provider.validateConfirmPassword,
            controller: provider.confirmPassword,
            obscureText: provider.isConfirmPasswordVisible,
            prefixIcon: Icon(
              Icons.lock_outline,
              size: 20.w,
              color: AppColor.lightGray,
            ),
            suffixIcon: IconButton(
              onPressed: () => provider.toggleConfirmPasswordVisibility(),
              icon: Icon(
                provider.isConfirmPasswordVisible
                    ? Icons.visibility_off_outlined
                    : Icons.visibility_outlined,
                size: 20.w,
                color: AppColor.lightGray,
              ),
            ),
          ),
          VerticalSpacer(20),

          // Terms & Conditions Checkbox
          _TermsAndConditionsCheckbox(provider: provider),
          VerticalSpacer(28),

          // Sign Up Button
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: provider.onSubmit,
              child: Text(
                "Sign Up",
                style: AppStyle.styleSemiBold16.copyWith(color: Colors.white),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TermsAndConditionsCheckbox extends StatelessWidget {
  const _TermsAndConditionsCheckbox({required this.provider});

  final SignupProvider provider;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          width: 24.w,
          height: 24.h,
          child: Checkbox(
            value: provider.agreeToTerms,
            onChanged: provider.toggleAgreeToTerms,
            activeColor: AppColor.primary,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(4.r),
            ),
          ),
        ),
        SizedBox(width: 8.w),
        Expanded(
          child: GestureDetector(
            onTap: () => provider.toggleAgreeToTerms(!provider.agreeToTerms),
            child: RichText(
              text: TextSpan(
                style: AppStyle.styleRegular14.copyWith(
                  color: AppColor.darkGray,
                ),
                children: [
                  TextSpan(text: "I agree to the "),
                  TextSpan(
                    text: "Terms & Conditions",
                    style: AppStyle.styleMedium14.copyWith(
                      color: AppColor.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                  TextSpan(text: " and "),
                  TextSpan(
                    text: "Privacy Policy",
                    style: AppStyle.styleMedium14.copyWith(
                      color: AppColor.primary,
                      decoration: TextDecoration.underline,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _SocialSignupSection extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SocialLoginButton(
            icon: Icons.g_mobiledata,
            label: "Google",
            onPressed: () {
              // Handle Google signup
            },
          ),
        ),
        SizedBox(width: 16.w),
        Expanded(
          child: SocialLoginButton(
            icon: Icons.apple,
            label: "Apple",
            onPressed: () {
              // Handle Apple signup
            },
          ),
        ),
      ],
    );
  }
}

class _LoginPrompt extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(
          "Already have an account? ",
          style: AppStyle.styleRegular14.copyWith(color: AppColor.darkGray),
        ),
        TextButton(
          onPressed: () {
            // Navigate back to login screen
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(
            padding: EdgeInsets.zero,
            minimumSize: Size.zero,
            tapTargetSize: MaterialTapTargetSize.shrinkWrap,
          ),
          child: Text(
            "Sign In",
            style: AppStyle.styleSemiBold14.copyWith(color: AppColor.primary),
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_color.dart';
import '../../../core/constant/app_style.dart';
import '../../../core/functions/validate_input.dart';
import '../../../providers/signup_provider.dart';
import '../../../shared/auth/auth_label.dart';
import '../../../shared/input.dart';
import '../../../shared/spacer.dart';
import 'terms_and_conditions_checkbox.dart';

class SignupFormBody extends StatelessWidget {
  const SignupFormBody({super.key, required this.provider});

  final SignupProvider provider;

  @override
  Widget build(BuildContext context) {
    return Form(
      key: provider.signupFormKey,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
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
          AuthLabel("Phone Number"),
          VerticalSpacer(12),
          Input(
            hintText: "+1 234 567 8900",
            keyboardType: TextInputType.phone,
            validator: (value) => validateInput(value, min: 8, max: 8),
            controller: provider.phoneNumber,
            prefixIcon: Icon(
              Icons.phone_outlined,
              size: 20.w,
              color: AppColor.lightGray,
            ),
          ),
          VerticalSpacer(20),
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
          TermsAndConditionsCheckbox(provider: provider),
          VerticalSpacer(28),
          SizedBox(
            width: double.infinity,
            height: 50.h,
            child: ElevatedButton(
              onPressed: () =>
                  provider.isLoading ? null : provider.onSubmit(context),
              child: provider.isLoading
                  ? SizedBox(
                      height: 20.h,
                      width: 20.w,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                      ),
                    )
                  : Text(
                      "Sign Up",
                      style: AppStyle.styleSemiBold16.copyWith(
                        color: Colors.white,
                      ),
                    ),
            ),
          ),
        ],
      ),
    );
  }
}

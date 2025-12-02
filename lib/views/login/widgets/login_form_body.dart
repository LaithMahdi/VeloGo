import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_color.dart';
import '../../../core/constant/app_style.dart';
import '../../../core/functions/validate_input.dart';
import '../../../providers/login_provider.dart';
import '../../../shared/auth/auth_label.dart';
import '../../../shared/input.dart';
import '../../../shared/spacer.dart';

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
              onPressed: () {},
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

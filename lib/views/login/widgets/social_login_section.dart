import 'package:flutter/material.dart';
import '../../../shared/auth/social_login_button.dart';
import '../../../shared/spacer.dart';

class SocialLoginSection extends StatelessWidget {
  const SocialLoginSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: SocialLoginButton(
            icon: Icons.g_mobiledata_rounded,
            label: "Google",
            onPressed: () {},
          ),
        ),
        HorizontalSpacer(16),
        Expanded(
          child: SocialLoginButton(
            icon: Icons.apple,
            label: "Apple",
            onPressed: () {},
          ),
        ),
      ],
    );
  }
}

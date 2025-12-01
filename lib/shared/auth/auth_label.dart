import 'package:flutter/material.dart';
import '../../core/constant/app_style.dart';

class AuthLabel extends StatelessWidget {
  const AuthLabel(this.label, {super.key});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(label, style: AppStyle.styleMedium14);
  }
}

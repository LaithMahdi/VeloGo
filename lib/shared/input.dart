import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../../core/constant/app_color.dart';
import '../../../core/constant/app_style.dart';

class Input extends StatelessWidget {
  const Input({
    super.key,
    required this.hintText,
    required this.controller,
    this.keyboardType,
    this.obscureText,
    this.validator,
    this.suffixIcon,
    this.prefixIcon,
    this.height,
    this.readOnly,
    this.maxLines,
    this.focusNode,
    this.onTap,
    this.backgroundColor,
    this.borderColor,
    this.errorText,
    this.contentPadding,
    this.cursorHeight,
    this.maxLength,
    this.inputFormatters,
    this.onChanged,
  });

  final String hintText;
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool? obscureText;
  final String? Function(String? value)? validator;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? readOnly;
  final int? maxLines;
  final double? height;
  final int? maxLength;
  final FocusNode? focusNode;
  final VoidCallback? onTap;
  final String? errorText;
  final Color? borderColor, backgroundColor;
  final EdgeInsetsGeometry? contentPadding;
  final double? cursorHeight;
  final List<TextInputFormatter>? inputFormatters;
  final void Function(String value)? onChanged;

  @override
  Widget build(BuildContext context) {
    final bool isReadOnly = readOnly == true;

    return SizedBox(
      // height: height ?? 70.h,
      child: TextFormField(
        onTap: onTap,
        onChanged: onChanged,
        maxLength: maxLength,
        focusNode: focusNode,
        cursorHeight: cursorHeight ?? 25.h,
        readOnly: isReadOnly,
        controller: controller,
        maxLines: maxLines ?? 1,
        onTapOutside: (event) => FocusScope.of(context).unfocus(),
        keyboardType: keyboardType ?? TextInputType.text,
        cursorColor: AppColor.black,
        obscureText: obscureText == null || obscureText == false ? false : true,
        obscuringCharacter: "*",
        validator: validator,
        style: AppStyle.styleMedium14.copyWith(
          color: isReadOnly ? AppColor.lightGray : AppColor.black,
        ),
        inputFormatters: inputFormatters,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        decoration: InputDecoration(
          filled: true,
          fillColor: isReadOnly
              ? AppColor.lightGray
              : backgroundColor ?? AppColor.background,
          suffixIcon: suffixIcon,
          prefixIcon: prefixIcon,
          contentPadding:
              contentPadding ??
              EdgeInsets.symmetric(horizontal: 14.w, vertical: 13.h),
          hintText: hintText,
          hintStyle: AppStyle.styleRegular12.copyWith(
            color: AppColor.lightGray,
          ),
          helperStyle: AppStyle.styleSemiBold11,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              color: isReadOnly
                  ? AppColor.greyDD
                  : borderColor ?? AppColor.lightGray,
              width: 1.5.w,
            ),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              color: isReadOnly
                  ? AppColor.greyDD
                  : borderColor ?? AppColor.lightGray,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(
              color: isReadOnly
                  ? AppColor.greyDD
                  : borderColor ?? AppColor.primary,
              width: 1.5.w,
            ),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: AppColor.red, width: 1),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10.r),
            borderSide: BorderSide(color: AppColor.black, width: 1),
          ),
          errorText: errorText,
          errorStyle: AppStyle.styleMedium12.copyWith(
            color: AppColor.red,
            overflow: TextOverflow.visible,
          ),
          errorMaxLines: 3,
          focusColor: AppColor.primary,
          prefixIconColor: AppColor.primary,
        ),
      ),
    );
  }
}

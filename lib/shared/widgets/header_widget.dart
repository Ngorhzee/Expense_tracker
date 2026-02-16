import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import '../../core/theme/app_theme.dart';

class HeaderWidget extends StatelessWidget {
  final String title;
  final VoidCallback? onBack;

  const HeaderWidget({super.key, required this.title, this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(top: 24.h, right: 16.w, left: 16.w),
      child: Row(
        children: [
          IconButton(
            onPressed: onBack ?? () => Navigator.of(context).pop(),
            icon: Icon(Icons.keyboard_arrow_left_rounded, size: 24.sp),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.surfaceVariant,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.r),
              ),
            ),
          ),

          const Spacer(),

          Text(title, style: Theme.of(context).textTheme.titleMedium),

          const Spacer(),
        ],
      ),
    );
  }
}

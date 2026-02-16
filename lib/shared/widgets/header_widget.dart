import 'package:flutter/material.dart';
import '../../core/theme/app_theme.dart';
class HeaderWidget extends StatelessWidget {

  final String title;
  final VoidCallback? onBack;

  const HeaderWidget({
    super.key,
    required this.title,
    
    this.onBack,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(8, 8, 20, 0),
      child: Row(
        children: [
        
          IconButton(
            onPressed: onBack ?? () => Navigator.of(context).pop(),
            icon: const Icon(Icons.keyboard_arrow_left_rounded, size: 24),
            style: IconButton.styleFrom(
              backgroundColor: AppColors.surfaceVariant,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12),
              ),
            ),
          ),

          const Spacer(),

         
          Text(
            title,
            style: Theme.of(context).textTheme.titleMedium,
          ),

          const Spacer(),

        ],
      ),
    );
  }
}
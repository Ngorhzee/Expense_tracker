import 'package:expense_traker/features/transactions/providers/transaction_provider.dart';
import 'package:expense_traker/shared/widgets/app_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';


class SearchBarWidget extends ConsumerStatefulWidget {
  const SearchBarWidget({super.key});

  @override
  ConsumerState<SearchBarWidget> createState() => _SearchBarWidgetState();
}

class _SearchBarWidgetState extends ConsumerState<SearchBarWidget> {
 

  @override
  void dispose() {
 
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 20.w),
      child: AppTextField(
          hint: "Search by merchant name...",
          prefixIcon:  Icons.search,
          textInputAction: TextInputAction.search,
          onChanged: (value) {
            ref.read(searchQueryProvider.notifier).state = value;
          },
      )
    );
  }
}
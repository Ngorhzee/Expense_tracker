import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../../core/theme/app_theme.dart';


class AppTextField extends StatefulWidget {
  
  final String? hint;
  final String? label;
  final TextEditingController? controller;
  final FocusNode? focusNode;
  final ValueChanged<String>? onChanged;
  final ValueChanged<String>? onSubmitted;
  final String? Function(String?)? validator;
  final IconData? prefixIcon;
  final IconData? suffixIcon;
  final Widget? suffixWidget;
  final String? prefixText;
  final bool showClearButton;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final TextCapitalization textCapitalization;
  final int maxLines;
  final bool readOnly;
  final bool enabled;
  final VoidCallback? onTap;
  final bool autofocus;
  final bool obscureText;
  final TextStyle? textStyle;
  final TextInputAction? textInputAction;

  const AppTextField({
    super.key,
    this.hint,
    this.label,
    this.controller,
    this.focusNode,
    this.onChanged,
    this.onSubmitted,
    this.validator,
    this.prefixIcon,
    this.suffixIcon,
    this.suffixWidget,
    this.prefixText,
    this.showClearButton = false,
    this.keyboardType,
    this.inputFormatters,
    this.textCapitalization = TextCapitalization.none,
    this.maxLines = 1,
    this.readOnly = false,
    this.enabled = true,
    this.onTap = null,
    this.autofocus = false,
    this.obscureText = false,
    this.textStyle,
    this.textInputAction,
  });

  @override
  State<AppTextField> createState() => _AppTextFieldState();
}

class _AppTextFieldState extends State<AppTextField> {
  late final TextEditingController _controller;
  late final FocusNode _focusNode;
  bool _ownsController = false;
  bool _ownsFocusNode = false;
  bool _hasText = false;

  @override
  void initState() {
    super.initState();

    // Use provided controller or create an internal one.
    if (widget.controller != null) {
      _controller = widget.controller!;
    } else {
      _controller = TextEditingController();
      _ownsController = true;
    }

    if (widget.focusNode != null) {
      _focusNode = widget.focusNode!;
    } else {
      _focusNode = FocusNode();
      _ownsFocusNode = true;
    }

    _hasText = _controller.text.isNotEmpty;
    _controller.addListener(_onTextChanged);
  }

  void _onTextChanged() {
    final hasText = _controller.text.isNotEmpty;
    if (hasText != _hasText) {
      setState(() => _hasText = hasText);
    }
  }

  void _clearField() {
    _controller.clear();
    widget.onChanged?.call('');
    _focusNode.unfocus();
  }

  @override
  void dispose() {
    _controller.removeListener(_onTextChanged);
    if (_ownsController) _controller.dispose();
    if (_ownsFocusNode) _focusNode.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisSize: MainAxisSize.min,
      children: [
      
        if (widget.label != null) ...[
          Text(
            widget.label!,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                  color: AppColors.textSecondary,
                  fontSize: 13,
                ),
          ),
          const SizedBox(height: 8),
        ],

    
        TextFormField(
          controller: _controller,
          focusNode: _focusNode,
          onChanged: widget.onChanged,
          onFieldSubmitted: widget.onSubmitted,
          validator: widget.validator,
          keyboardType: widget.keyboardType,
          inputFormatters: widget.inputFormatters,
          textCapitalization: widget.textCapitalization,
          maxLines: widget.maxLines,
          readOnly: widget.readOnly,
          enabled: widget.enabled,
          onTap: widget.onTap,
          autofocus: widget.autofocus,
          obscureText: widget.obscureText,
          textInputAction: widget.textInputAction,
          style: widget.textStyle ??
              Theme.of(context).textTheme.bodyLarge?.copyWith(
                    fontWeight: FontWeight.w500,
                    color: AppColors.textPrimary,
                  ),
          decoration: InputDecoration(
            hintText: widget.hint,

            // ── Prefix ──
            prefixIcon: _buildPrefix(),

            // ── Suffix ──
            suffixIcon: _buildSuffix(),

            // Align hint to top for multiline fields
            alignLabelWithHint: widget.maxLines > 1,
          ),
        ),
      ],
    );
  }

  /// Builds the prefix area: icon or text prefix.
  Widget? _buildPrefix() {
    if (widget.prefixText != null) {
      return Container(
        width: 44,
        alignment: Alignment.center,
        child: Text(
          widget.prefixText!,
          style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: AppColors.textSecondary,
                fontWeight: FontWeight.w600,
              ),
        ),
      );
    }

    if (widget.prefixIcon != null) {
      return Icon(
        widget.prefixIcon,
        size: 20,
        color: AppColors.textTertiary,
      );
    }

    return null;
  }

  /// Builds the suffix area: clear button, custom widget, or static icon.
  Widget? _buildSuffix() {
    // Clear button takes priority when text is present
    if (widget.showClearButton && _hasText) {
      return GestureDetector(
        onTap: _clearField,
        child: const Icon(
          Icons.close_rounded,
          size: 20,
          color: AppColors.textTertiary,
        ),
      );
    }

    // Custom suffix widget
    if (widget.suffixWidget != null) {
      return widget.suffixWidget;
    }

    // Static suffix icon
    if (widget.suffixIcon != null) {
      return Icon(
        widget.suffixIcon,
        size: 20,
        color: AppColors.textTertiary,
      );
    }

    return null;
  }
}
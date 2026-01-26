import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:klicum/config/style/app_style.dart';

class InputField extends StatefulWidget {
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? textInputFormatters;
  final bool autoValidateMode;
  final String? Function(String?)? validator;
  final TextEditingController? controller;
  final bool isPassword;
  final bool readOnly;
  final bool showCursor;
  final VoidCallback? callback;
  final Function(String)? onChanged;

  final TextStyle? textStyle;

  final String labelText;
  final TextStyle? labelStyle;

  final bool filled;
  final Color fillColor;
  final double fillColorOpacity;

  final Color enabledBorderColor;
  final double enabledBorderWith;
  final double enabledBorderColorOpacity;

  final Color focusedBorderColor;
  final double focusedBorderWith;
  final double focusedBorderColorOpacity;

  final Color? errorBorderColor;
  final double errorBorderWith;
  final double errorBorderColorOpacity;
  
  final double borderRadius;

  final EdgeInsetsGeometry? contentPadding;

  const InputField({
    super.key, 
    this.keyboardType,
    this.textInputFormatters,
    required this.autoValidateMode,
    this.validator,
    this.controller,
    this.isPassword = false,
    this.readOnly = false,
    this.showCursor = false,
    this.callback,
    this.onChanged,

    this.textStyle,

    required this.labelText,
    this.labelStyle,

    this.filled = true,
    this.fillColor = Colors.white,
    this.fillColorOpacity = 0.1,

    this.enabledBorderColor = Colors.white,
    this.enabledBorderWith = 1,
    this.enabledBorderColorOpacity = 0.15,

    this.focusedBorderColor = AppStyle.primaryColor,
    this.focusedBorderWith = 1,
    this.focusedBorderColorOpacity = 1,

    this.errorBorderColor,
    this.errorBorderWith = 1,
    this.errorBorderColorOpacity = 1,
  
    this.borderRadius = 15,

    this.contentPadding
  });

  @override
  State<InputField> createState() => _InputFieldState();
}

class _InputFieldState extends State<InputField> {
  late bool _obscure;

  @override
  void initState() {
    super.initState();
    _obscure = widget.isPassword;
  }

  @override
  Widget build(BuildContext context) {
    final labelLargeStyle = Theme.of(context).textTheme.labelLarge ?? const TextStyle();

    return TextFormField(
      onTap: widget.callback,
      onChanged: widget.onChanged,
      showCursor: widget.showCursor,
      readOnly: widget.readOnly,
      keyboardType: widget.keyboardType,
      inputFormatters: widget.textInputFormatters,
      autovalidateMode: widget.autoValidateMode ? AutovalidateMode.onUserInteraction : AutovalidateMode.disabled,
      obscureText: _obscure,
      validator: widget.validator,
      controller: widget.controller,
      style: widget.textStyle ?? labelLargeStyle.copyWith(color: Colors.white, fontWeight: FontWeight.normal),
      decoration: InputDecoration(
        labelText: widget.labelText,
        labelStyle: widget.labelStyle ?? labelLargeStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w200),
        filled: widget.filled,
        fillColor: widget.fillColor.withValues(alpha: widget.fillColorOpacity),

        suffixIcon: widget.isPassword ? 
          IconButton(
            onPressed: () => mounted ? setState(() => _obscure = !_obscure) : (), 
            icon: Icon(_obscure ? Icons.visibility_off : Icons.visibility, color: Colors.white.withValues(alpha: 0.1) )) 
          : null,

        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.enabledBorderColor.withValues(alpha: widget.enabledBorderColorOpacity),
            width: widget.enabledBorderWith
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius)
        ),
        
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: widget.focusedBorderColor.withValues(alpha: widget.focusedBorderColorOpacity),
            width: widget.focusedBorderWith
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius)
        ),

        errorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: (widget.errorBorderColor ?? Theme.of(context).colorScheme.errorContainer).withValues(alpha: widget.errorBorderColorOpacity),
            width: widget.errorBorderWith
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius)
        ),

        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: (widget.errorBorderColor ?? Theme.of(context).colorScheme.errorContainer).withValues(alpha: widget.errorBorderColorOpacity),
            width: widget.errorBorderWith
          ),
          borderRadius: BorderRadius.circular(widget.borderRadius)
        ),

        errorStyle: TextStyle(
          color: widget.errorBorderColor ?? Theme.of(context).colorScheme.errorContainer,
          fontSize: 12,
          height: 0.9,
          overflow: TextOverflow.visible
        ),
        
        contentPadding: widget.contentPadding ?? EdgeInsets.symmetric(
          vertical: 15,
          horizontal: 20
        )
      )
    );
  }
}
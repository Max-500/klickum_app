import 'package:flutter/material.dart';

class InputTile extends StatefulWidget {
  final VoidCallback? onTap;

  final Widget? leading;
  final Widget? trailing;

  /// Texto principal (como label/value)
  final String title;

  /// Texto secundario (opcional)
  final String? subtitle;

  final TextStyle? titleStyle;
  final TextStyle? subtitleStyle;

  /// Si quieres mostrar un “label” arriba (como labelText del TextFormField)
  final String? labelText;
  final TextStyle? labelStyle;

  /// Estados
  final bool enabled;
  final bool hasError;

  /// Colores/estilos como tu InputField
  final bool filled;
  final Color fillColor;
  final double fillColorOpacity;

  final Color enabledBorderColor;
  final double enabledBorderWidth;
  final double enabledBorderColorOpacity;

  final Color focusedBorderColor;
  final double focusedBorderWidth;
  final double focusedBorderColorOpacity;

  final Color? errorBorderColor;
  final double errorBorderWidth;
  final double errorBorderColorOpacity;

  final double borderRadius;

  /// Padding interno tipo contentPadding
  final EdgeInsetsGeometry? contentPadding;

  const InputTile({
    super.key,
    required this.title,
    this.subtitle,
    this.onTap,
    this.leading,
    this.trailing,

    this.titleStyle,
    this.subtitleStyle,

    this.labelText,
    this.labelStyle,

    this.enabled = true,
    this.hasError = false,

    this.filled = true,
    this.fillColor = Colors.white,
    this.fillColorOpacity = 0.1,

    this.enabledBorderColor = Colors.white,
    this.enabledBorderWidth = 1,
    this.enabledBorderColorOpacity = 0.15,

    this.focusedBorderColor = Colors.blue,
    this.focusedBorderWidth = 1,
    this.focusedBorderColorOpacity = 1,

    this.errorBorderColor,
    this.errorBorderWidth = 1,
    this.errorBorderColorOpacity = 1,

    this.borderRadius = 15,

    this.contentPadding,
  });

  @override
  State<InputTile> createState() => _InputTileState();
}

class _InputTileState extends State<InputTile> {
  bool _pressed = false;
  bool _focused = false;
  final FocusNode _focusNode = FocusNode(debugLabel: 'InputTileFocus');

  @override
  void initState() {
    super.initState();
    _focusNode.addListener(() {
      if (!mounted) return;
      setState(() => _focused = _focusNode.hasFocus);
    });
  }

  @override
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  BorderSide _borderSide(BuildContext context) {
    final errorColor = (widget.errorBorderColor ?? Theme.of(context).colorScheme.errorContainer);

    if (widget.hasError) {
      return BorderSide(
        color: errorColor.withValues(alpha: widget.errorBorderColorOpacity),
        width: widget.errorBorderWidth,
      );
    }

    final isActive = widget.enabled && (_focused || _pressed);

    return BorderSide(
      color: (isActive ? widget.focusedBorderColor : widget.enabledBorderColor).withValues(
        alpha: isActive ? widget.focusedBorderColorOpacity : widget.enabledBorderColorOpacity,
      ),
      width: isActive ? widget.focusedBorderWidth : widget.enabledBorderWidth,
    );
  }

  @override
  Widget build(BuildContext context) {
    final labelLargeStyle = Theme.of(context).textTheme.labelLarge ?? const TextStyle();
    final titleStyle = widget.titleStyle ??
        labelLargeStyle.copyWith(color: Colors.white, fontWeight: FontWeight.normal);

    final subtitleStyle = widget.subtitleStyle ??
        (Theme.of(context).textTheme.bodySmall ?? const TextStyle())
            .copyWith(color: Colors.white.withValues(alpha: 0.75));

    final labelStyle = widget.labelStyle ??
        labelLargeStyle.copyWith(color: Colors.white, fontWeight: FontWeight.w200);

    final border = _borderSide(context);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (widget.labelText != null) ...[
          Padding(
            padding: const EdgeInsets.only(left: 6, bottom: 6),
            child: Text(widget.labelText!, style: labelStyle),
          ),
        ],

        Focus(
          focusNode: _focusNode,
          child: GestureDetector(
            onTapDown: widget.enabled ? (_) => setState(() => _pressed = true) : null,
            onTapCancel: widget.enabled ? () => setState(() => _pressed = false) : null,
            onTapUp: widget.enabled ? (_) => setState(() => _pressed = false) : null,
            onTap: widget.enabled
                ? () {
                    _focusNode.requestFocus(); // para que se pinte como "focusedBorder"
                    widget.onTap?.call();
                  }
                : null,
            child: AnimatedContainer(
              duration: const Duration(milliseconds: 140),
              curve: Curves.easeOut,
              decoration: BoxDecoration(
                color: widget.filled
                    ? widget.fillColor.withValues(alpha: widget.fillColorOpacity)
                    : Colors.transparent,
                borderRadius: BorderRadius.circular(widget.borderRadius),
                border: Border.fromBorderSide(border),
              ),
              child: ListTile(
                enabled: widget.enabled,
                leading: widget.leading,
                trailing: widget.trailing,
                title: Text(widget.title, style: titleStyle),
                subtitle: widget.subtitle != null ? Text(widget.subtitle!, style: subtitleStyle) : null,
                contentPadding: widget.contentPadding ??
                    const EdgeInsets.symmetric(vertical: 4, horizontal: 20),
                dense: true,
                visualDensity: VisualDensity.compact,
              ),
            ),
          ),
        ),
      ],
    );
  }
}
import 'package:flutter/material.dart';

class Helper {
  static String extractErrorMessage(dynamic json, String? text) {
    if (json is Map && json['message'] != null) {
      final msg = json['message'];

      if (msg is String) return msg;

      if (msg is List && msg.isNotEmpty) {
        if (msg.first is String) return msg.first;
      }
    }

    return text ?? 'Error, intentalo más tarde';
  }

  static String normalizeError(dynamic e) {
    final raw = e.toString();
    return raw.startsWith('Exception: ')
        ? raw.replaceFirst('Exception: ', '')
        : raw;
  }

  static SnackBar getSnackbar({ required String text, IconData? icon, Color? color, TextStyle? style }) => SnackBar(
    backgroundColor: Colors.transparent,
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(16),
    content: Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.black.withValues(alpha: 0.7),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: Colors.white.withValues(alpha: 0.15),
          width: 1,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha:  0.5),
            blurRadius: 20,
            offset: const Offset(0, 10),
          )
        ],
      ),
      child: Row(
        children: [
          Icon(icon ?? Icons.error_outline_outlined, color: color ?? Colors.orangeAccent),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              text,
              style: style ?? const TextStyle(color: Colors.white),
            )
          )
        ]
      )
    )
  );
}
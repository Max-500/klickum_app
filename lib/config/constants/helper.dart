import 'dart:async';
import 'dart:io';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:http/http.dart';
import 'package:klicum/config/router/app_router.dart';
import 'package:shared_preferences/shared_preferences.dart';

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

  static SnackBar getSnackbar({ 
    required String text, 
    bool isWarning = true, 
    Color? color,
    TextStyle? style, 
    Duration? duration,
    VoidCallback? callback
  }) => 
    SnackBar(
    duration: duration ?? Duration(days: 1),
    backgroundColor: Colors.transparent,
    elevation: 0,
    behavior: SnackBarBehavior.floating,
    margin: const EdgeInsets.all(16),
    content: GestureDetector(
      onTap: callback,
      child: Container(
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
            Icon(isWarning ? Icons.warning_amber_rounded : Icons.cloud_off_outlined, color: isWarning ? Colors.orangeAccent : color ?? Colors.redAccent),
            const SizedBox(width: 12),
            Expanded(
              child: Text(
                text,
                style: style ?? const TextStyle(color: Colors.white),
              )
            )
          ]
        )
      ),
    )
  );

  static bool isNetworkError(Object error) => error is SocketException || error is TimeoutException || error is ClientException || error is HandshakeException || error is TlsException || error is HttpException;

  static bool _handling = false;

  static void handleTokenExpired() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.clear();

    final ctx = rootNavigatorKey.currentContext;
    if (_handling || ctx == null || !ctx.mounted) return;
    
    final router = GoRouter.of(ctx);
    final currentLoc = router.routeInformationProvider.value.location;
    if(currentLoc == '/') return;
    _handling = true;
    try {
      if (!ctx.mounted) return;
      ctx.go('/sign-in');
    } finally {
      _handling = false;
    }


  }
}
import 'package:flutter/material.dart';
import 'package:safe_guard/utils/extensions/padding.dart';

import 'loading_screen_controller.dart';

/// loading overlay when authentication process is ongoing
class AuthenticationLoadingScreen {
  /// factory constructor authentication loading screen
  factory AuthenticationLoadingScreen.instance() => _shared;
  AuthenticationLoadingScreen._sharedInstance();
  static final _shared = AuthenticationLoadingScreen._sharedInstance();
  AuthenticationLoadingScreenController? _controller;

  /// opens the loading overlay
  void show({
    required BuildContext context,
    String text = 'AuthStrings.loading',
  }) {
    if (_controller?.update(text) ?? false) {
      return;
    } else {
      _controller = showOverlay(context: context, text: text);
    }
  }

  /// closes the loading overlay
  void hide() {
    _controller?.close();
    _controller = null;
  }

  /// overlay view
  AuthenticationLoadingScreenController? showOverlay({
    required BuildContext context,
    required String text,
  }) {
    final state = Overlay.of(context);

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final size = renderBox.size;
      final overlay = OverlayEntry(
        builder: (context) => Material(
          color: Colors.black.withAlpha(180),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(12),
              constraints: BoxConstraints(
                maxHeight: size.height * 0.8,
                maxWidth: size.width * 0.8,
                minWidth: size.width * 0.5,
              ),
              decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(10)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const CircularProgressIndicator().paddingOnly(bottom: 16),
                  Text('Please wait...', style: Theme.of(context).textTheme.bodyMedium),
                ],
              ),
            ),
          ),
        ),
      );
      state.insert(overlay);
      return AuthenticationLoadingScreenController(
        close: () {
          overlay.remove();
          return true;
        },
        update: (text) {
          return true;
        },
      );
    }
    return null;
  }
}

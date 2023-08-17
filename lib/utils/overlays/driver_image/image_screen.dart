import 'dart:ui';

import 'package:flutter/material.dart';

import 'image_screen_controller.dart';

/// loading overlay when authentication process is ongoing
class ImageScreen {
  /// factory constructor authentication loading screen
  factory ImageScreen.instance() => _shared;
  ImageScreen._sharedInstance();
  static final _shared = ImageScreen._sharedInstance();
  ImageScreenController? _controller;

  /// opens the loading overlay
  void show({
    required BuildContext context,
  }) {
    _controller = showOverlay(context: context);
  }

  /// closes the loading overlay
  void hide() {
    _controller?.close();
    _controller = null;
  }

  /// overlay view
  ImageScreenController? showOverlay({required BuildContext context}) {
    final state = Overlay.of(context);

    final renderBox = context.findRenderObject() as RenderBox?;
    if (renderBox != null) {
      final size = renderBox.size;
      final overlay = OverlayEntry(
        builder: (context) => GestureDetector(
          onTap: hide,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: DecoratedBox(
              decoration: BoxDecoration(
                color: Colors.black.withOpacity(0.48),
                backgroundBlendMode: BlendMode.luminosity,
              ),
              child: Center(
                child: SizedBox(
                  height: size.width * 0.9,
                  width: size.width * 0.9,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(20),
                    child: Image.asset('assets/images/goose.jpeg', fit: BoxFit.cover),
                  ),
                ),
              ),
            ),
          ),
        ),
      );
      state.insert(overlay);
      return ImageScreenController(close: () {
        overlay.remove();
        return true;
      }, update: (text) {
        return true;
      });
    }
    return null;
  }
}

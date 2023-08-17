import 'package:flutter/widgets.dart';

/// did build mixin
mixin DidBuild<T extends StatefulWidget> on State<T> {
  @protected

  ///
  void didBuild(BuildContext context);

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      didBuild(context);
    });
  }
}

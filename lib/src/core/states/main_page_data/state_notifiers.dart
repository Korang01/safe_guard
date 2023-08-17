import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:safe_guard/src/core/states/user/state_notifiers.dart';

part 'providers.dart';
part 'states.dart';

class MainPageStateNotifier extends StateNotifier<MainPageStates> {
  MainPageStateNotifier({required this.ref}) : super(MainPageInitial());
  final Ref ref;
  Future<void> fetchUserInfo() async {
    try {
      await ref.read(userStateProvider.notifier).fetchUserInfo();
      final userInfo = ref.read(userStateProvider);
      if (userInfo is UserSuccess) {
        state = MainPageSuccess();
      } else {
        state = MainPageFailure(error: "Couldn't load data");
      }
    } catch (err) {
      state = MainPageFailure(error: err.toString());
    }
  }
}

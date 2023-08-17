import 'package:equatable/equatable.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safe_guard/src/core/models/user.dart';
import 'package:safe_guard/src/core/repository/repositories.dart';

part 'providers.dart';
part 'states.dart';

class UserStateNotifier extends StateNotifier<UserStates> {
  UserStateNotifier() : super(UserInitial());
  final UserRepository _userRepository = UserRepository();
  Future<void> fetchUserInfo() async {
    try {
      state = UserLoading();
      final response = await _userRepository.fetchUserInfo();
      if (response.status) {
        state = UserSuccess(user: response.data!);
      } else {
        state = UserFailure(error: response.message);
      }
    } catch (err) {
      state = UserFailure(error: err.toString());
    }
  }

  Future<void> updateUser({required SafeGuardUser user, XFile? image}) async {
    try {
      state = UserUpdateLoading();
      final response = await _userRepository.updateUser(user: user, profileImage: image);
      if (response.status) {
        state = UserSuccess(user: response.data!);
      } else {
        state = UserFailure(error: response.message);
      }
    } catch (err) {
      state = UserFailure(error: err.toString());
    }
  }
}

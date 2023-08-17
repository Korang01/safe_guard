part of 'repositories.dart';

class UserRepository {
  Future<BaseResponse<SafeGuardUser>> fetchUserInfo() async {
    try {
      final firebaseUser = await FirebaseFirestore.instance
          .collection('users')
          .where(
            'user_id',
            isEqualTo: LocalPreference.userID,
          )
          .get();

      final user = SafeGuardUser.fromJson(firebaseUser.docs.first.data());
      return BaseResponse.success(user);
    } on FirebaseException catch (err) {
      return BaseResponse.error(message: err.message);
    } catch (err) {
      return BaseResponse.error(message: err.toString());
    }
  }

  Future<BaseResponse<SafeGuardUser>> updateUser({required SafeGuardUser user, XFile? profileImage}) async {
    try {
      if (profileImage != null) {
        await uploadImage(file: profileImage);
      }
      FirebaseFirestore.instance.collection('users').doc(LocalPreference.userID).update(
            user.toJson(),
          );
      final firebaseUser = await FirebaseFirestore.instance
          .collection('users')
          .where('user_id', isEqualTo: LocalPreference.userID)
          .get();
      final updatedUser = SafeGuardUser.fromJson(firebaseUser.docs.first.data());
      return BaseResponse.success(updatedUser);
    } on FirebaseException catch (err) {
      return BaseResponse.error(message: err.message);
    } catch (err) {
      return BaseResponse.error(message: err.toString());
    }
  }

  Future<void> uploadImage({required XFile file}) async {
    final fileUpload = await FirebaseStorage.instance
        .ref()
        .child('users')
        .child('/${LocalPreference.userID}.${file.path.split('.').last}')
        .putFile(File(file.path));
    if (fileUpload.state == TaskState.success) {
      final imageDownloadUrl = await fileUpload.ref.getDownloadURL();

      FirebaseFirestore.instance.collection('users').doc(LocalPreference.userID).update(
        {'image_url': imageDownloadUrl},
      );
    }
  }
}

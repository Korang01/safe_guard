import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';

import '../extensions/object/log.dart';

/// Handle all platform image related utilities
class ImagePickerUtil {
  /// Image picker library object

  static final ImagePicker _picker = ImagePicker();

  /// open the device camera
  static Future<XFile?> openCamera() async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.camera,
      );
      return file!;
    } catch (error) {
      /// print the error to console on debug mode
      error.log();
      rethrow;
    }
  }

  /// open device gallery
  static Future<XFile?> openGallery() async {
    try {
      final file = await _picker.pickImage(
        source: ImageSource.gallery,
      );
      return file!;
    } catch (error) {
      /// print the error to console on debug mode
      error.log();
      rethrow;
    }
  }

  /// crop selected image
  static Future<CroppedFile?> cropImage({required String imagePath, String? title}) async {
    try {
      final croppedFile = await ImageCropper().cropImage(
        sourcePath: imagePath,

        /// default aspect ratio
        aspectRatio: const CropAspectRatio(ratioX: 1, ratioY: 1),

        /// Presets crop aspect ratios
        aspectRatioPresets: [
          CropAspectRatioPreset.square,
          CropAspectRatioPreset.original,
          CropAspectRatioPreset.ratio4x3,
        ],
        uiSettings: [
          /// android crop image settings
          AndroidUiSettings(
            toolbarTitle: 'Cropper',
            initAspectRatio: CropAspectRatioPreset.original,
            lockAspectRatio: false,
          ),

          /// ios crop settings
          IOSUiSettings(
            title: 'Resize',
            showCancelConfirmationDialog: true,
          ),
        ],
      );
      return croppedFile!;
    } catch (error) {
      /// print the error to console on debug mode
      error.log();
      rethrow;
    }
  }
}

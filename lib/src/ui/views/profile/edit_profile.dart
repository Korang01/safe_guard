import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:hooks_riverpod/hooks_riverpod.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:safe_guard/src/core/models/user.dart';
import 'package:safe_guard/src/core/states/user/state_notifiers.dart';
import 'package:safe_guard/utils/extensions/dismiss_keyboard.dart';
import 'package:safe_guard/utils/extensions/padding.dart';
import 'package:safe_guard/utils/overlays/authentication_loading_overlay/loading_screen.dart';
import 'package:safe_guard/utils/platform/image.dart';

class EditProfileView extends ConsumerStatefulWidget {
  const EditProfileView({super.key});

  @override
  ConsumerState createState() => _EditProfileState();
}

class _EditProfileState extends ConsumerState<EditProfileView> {
  late final TextEditingController fullName;
  late final TextEditingController email;
  late final TextEditingController phoneNumber;
  late final TextEditingController height;
  late final TextEditingController weight;

  final ValueNotifier<DateTime?> dateOfBirth = ValueNotifier(null);
  final ValueNotifier<XFile?> profileImage = ValueNotifier(null);
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fullName = TextEditingController();
    email = TextEditingController();
    phoneNumber = TextEditingController();
    height = TextEditingController();
    weight = TextEditingController();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final user = ref.watch(userStateProvider);
    if (user is UserSuccess) {
      fullName.text = user.user.fullName ?? '';
      email.text = user.user.email;
      phoneNumber.text = user.user.phoneNumber?.replaceAll('+233', '') ?? '';
      height.text = '${user.user.height ?? ''}';
      weight.text = '${user.user.weight ?? ''}';
      dateOfBirth.value = user.user.dateOfBirth;
    }
    ref.listen(userStateProvider, (previous, state) {
      if (state is UserUpdateLoading) {
        AuthenticationLoadingScreen.instance().show(context: context);
      } else if (state is UserSuccess) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('User details updated successfully'),
          ),
        );
        AuthenticationLoadingScreen.instance().hide();

        Navigator.of(context).pop();
      } else if (state is UserFailure) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            backgroundColor: theme.colorScheme.error,
            content: Text(state.error ?? "Couldn't update user details"),
          ),
        );
        AuthenticationLoadingScreen.instance().hide();
      }
    });
    return Scaffold(
      body: CustomScrollView(
        slivers: [
          const SliverAppBar(title: Text('Edit profile')),
          if (user is UserSuccess)
            SliverList.list(children: [
              ValueListenableBuilder(
                  valueListenable: profileImage,
                  builder: (context, image, _) {
                    return GestureDetector(
                      onTap: () async {
                        await showModalBottomSheet(
                          backgroundColor: Colors.white.withOpacity(0),
                          context: context,
                          builder: (_) => CupertinoActionSheet(
                            title: const Text('Select image via'),
                            actions: [
                              CupertinoActionSheetAction(
                                onPressed: () async {
                                  Navigator.of(context).pop();

                                  profileImage.value = await ImagePickerUtil.openGallery().then(
                                    (value) => ImagePickerUtil.cropImage(imagePath: value!.path).then(
                                      (value) => XFile(value!.path),
                                    ),
                                  );
                                },
                                isDefaultAction: true,
                                child: const Text('Gallery'),
                              ),
                              CupertinoActionSheetAction(
                                onPressed: () async {
                                  Navigator.of(context).pop();

                                  profileImage.value = await ImagePickerUtil.openCamera().then(
                                    (value) => ImagePickerUtil.cropImage(imagePath: value!.path).then(
                                      (value) => XFile(value!.path),
                                    ),
                                  );
                                },
                                child: const Text('Camera'),
                              ),
                            ],
                            cancelButton: CupertinoActionSheetAction(
                              onPressed: () {
                                Navigator.pop(context);
                              },
                              isDestructiveAction: true,
                              child: const Text('Cancel'),
                            ),
                          ),
                        );
                      },
                      child: CircleAvatar(
                        radius: 48,
                        backgroundImage: image != null ? FileImage(File(image.path)) : null,
                      ).paddingSymmetric(vertical: 24),
                    );
                  }),
              TextField(
                controller: fullName,
                decoration: const InputDecoration(
                  labelText: 'Full name',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ).paddingOnly(bottom: 16),
              TextField(
                controller: email,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ).paddingOnly(bottom: 16),
              ValueListenableBuilder(
                  valueListenable: dateOfBirth,
                  builder: (context, date, _) {
                    return TextField(
                      controller:
                          TextEditingController(text: date != null ? DateFormat.yMMMMEEEEd().format(date) : null),
                      readOnly: true,
                      onTap: () async {
                        dateOfBirth.value = await showDatePicker(
                          context: context,
                          initialDate: DateTime(DateTime.now().year - 18),
                          firstDate: DateTime(1900),
                          lastDate: DateTime.now(),
                        );
                      },
                      decoration: const InputDecoration(
                        labelText: 'Date of birth',
                        floatingLabelBehavior: FloatingLabelBehavior.always,
                      ),
                    ).paddingOnly(bottom: 16);
                  }),
              TextField(
                controller: phoneNumber,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Phone number',
                  prefixText: '+233  ',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ).paddingOnly(bottom: 16),
              TextField(
                controller: height,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Height (in cm)',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ).paddingOnly(bottom: 16),
              TextField(
                controller: weight,
                keyboardType: const TextInputType.numberWithOptions(decimal: true),
                decoration: const InputDecoration(
                  labelText: 'Weight (in kg)',
                  floatingLabelBehavior: FloatingLabelBehavior.always,
                ),
              ).paddingOnly(bottom: 32),
              FilledButton(
                onPressed: () async {
                  await ref.read(userStateProvider.notifier).updateUser(
                        user: SafeGuardUser(
                          fullName: fullName.text,
                          email: email.text,
                          dateOfBirth: dateOfBirth.value,
                          phoneNumber: '+233${phoneNumber.text}',
                          height: double.tryParse(height.text),
                          weight: double.tryParse(weight.text),
                        ),
                        image: profileImage.value,
                      );
                },
                child: const Text('Update'),
              )
            ]).sliverPaddingSymmetric(horizontal: 20),
        ],
      ),
    ).dismissFocus();
  }
}

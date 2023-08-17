import 'dart:io';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:image_picker/image_picker.dart';
import 'package:safe_guard/src/core/database/shared_preference.dart';
import 'package:safe_guard/src/core/models/registration_request_data.dart';
import 'package:safe_guard/src/core/models/user.dart';

import '../models/base_response.dart';

part 'authentication.dart';
part 'user.dart';

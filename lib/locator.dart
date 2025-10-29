// ignore_for_file: strict_top_level_inference

import 'package:get_it/get_it.dart';
import 'package:girl_clan/core/services/auth_services.dart';
import 'package:girl_clan/core/services/data_base_services.dart';
import 'package:girl_clan/core/services/notification_services.dart';

GetIt locator = GetIt.instance;
setupLocator() {
  // locator.registerSingleton(LocalStorageServices()); // ✅ local storage
  locator.registerSingleton(DatabaseServices()); // ✅ Firestore service
  locator.registerSingleton(NotificationServices()); // ✅ Notification service
  locator.registerSingleton(AuthServices()); // ✅ Firebase Auth
  // locator.registerSingleton(FilePickerService()); // ✅ File/image picker
  // locator.registerSingleton(StorageService()); // ✅ Firebase Storage uploader
}

import 'package:get_it/get_it.dart';
import 'package:VoteMe/app/services/fcm_services/fcm_service.dart';
import 'package:VoteMe/app/services/fcm_services/network_service.dart';
import 'package:VoteMe/app/services/fcm_services/push_notification_service.dart';
import 'package:VoteMe/app/services/navigation_service.dart';

GetIt locator = GetIt.instance;

Future<void> setupLocator() async {
  // locator.registerLazySingleton(() => NavigationService());
  // locator.registerLazySingleton(() => PushNotificationService());
  // locator.registerLazySingleton(() => FcmService());
  // locator.registerLazySingleton<NetworkServiceRepository>(
  //     () => NetworkServiceRepositoryImpl());
}

import 'package:adm_socialmedia_app/repository/user_repository.dart';
import 'package:adm_socialmedia_app/services/bildirim_gonderme_servis.dart';
import 'package:adm_socialmedia_app/services/fake_auth_services.dart';
import 'package:adm_socialmedia_app/services/firebase_auth_service.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt as GetIt;
void setupLocator() {
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FirebaseAuthService());
  locator.registerLazySingleton(() => FakeAuthService());
  locator.registerLazySingleton(() => UserRepository());
  locator.registerLazySingleton(() => BildirimGondermeServis());
}

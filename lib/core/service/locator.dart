import 'package:get_it/get_it.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';

final getItInstance = GetIt.instance;
void initializeServiceLocator() {
  // getItInstance.registerSingleton(() => FirebaseAuth.instance);
  // getItInstance.registerSingleton(() => FirebaseStorage.instance);
  // getItInstance.registerSingleton(() => FirebaseFirestore.instance);

  // getItInstance.registerLazySingleton(
  //   () => ContactData(),
  // );
  // getItInstance.registerLazySingleton(
  //   () => AuthenticationRepoImpl(firebaseAuth: getItInstance<FirebaseAuth>()),
  // );
  // getItInstance.registerLazySingleton(
  //   () => ContactRepoImpl(
  //     contactData: getItInstance<ContactData>(),
  //     firebaseFirestore: getItInstance<FirebaseFirestore>(),
  //   ),
  // );
  // getItInstance.registerLazySingleton(
  //   () => UserData(
  //     firestore: getItInstance<FirebaseFirestore>(),
  //     firebaseStorage: getItInstance<FirebaseStorage>(),
  //     firebaseAuth: getItInstance<FirebaseAuth>(),
  //   ),
  // );
  // getItInstance.registerLazySingleton(
  //   () => UserRepositoryImpl(
  //     userData: getItInstance<UserData>(),
  //   ),
  // );
  getItInstance.registerFactory(() => UserModel());
}
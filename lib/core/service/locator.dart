import 'package:get_it/get_it.dart';
import 'package:official_chatbox_application/features/data/models/user_model/user_model.dart';

final getItInstance = GetIt.instance;
void initializeServiceLocator() {
  getItInstance.registerFactory(() => UserModel());
}
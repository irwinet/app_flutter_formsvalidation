

import 'package:app_flutter_formsvalidation/src/providers/navigation_provider.dart';
import 'package:get_it/get_it.dart';

GetIt locator = GetIt();

void setupLocator() {
  locator.registerLazySingleton(() => NavigationProvider());
}
import 'package:api_mobile/presentation/user/user_bloc.dart';

import 'data/network/dio_factory.dart';
import 'presentation/cubit/users_cubit.dart';
import 'repository/repostory.dart';
import 'package:dio/dio.dart';
import 'package:get_it/get_it.dart';

import 'data/data_sourse/web_services.dart';

final instance = GetIt.instance;

void initAppModule() {
  instance.registerFactory(() => UsersCubit(repository: instance()));
  instance.registerFactory(() => UserBloc(repository: instance()));
  instance.registerLazySingleton<Repository>(
      () => RepositoryImpl(webServices: instance()));
  instance.registerLazySingleton(() => WebServices(instance()));

  instance.registerFactory<Dio>(() => DioFactory().getDio());
}

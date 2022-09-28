import '../data/network/api_result.dart';
import '../data/network/network_exceptions.dart';

import '../data/data_sourse/web_services.dart';
import '../model/users.dart';

abstract class Repository {
  Future<ApiResult<List<User>>> getUsers();
  Future<ApiResult<User>> getUser(String id);
  Future<ApiResult<User>> creatUser(User newUser);
}

class RepositoryImpl extends Repository {
  final WebServices webServices;
  RepositoryImpl({
    required this.webServices,
  });

  @override
  Future<ApiResult<List<User>>> getUsers() async {
    try {
      return ApiResult.success(await webServices.getUsers());
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  @override
  Future<ApiResult<User>> getUser(String id) async {
    try {
      return ApiResult.success(await webServices.getUser(id));
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }

  @override
  Future<ApiResult<User>> creatUser(
    User newUser,
  ) async {
    try {
      return ApiResult.success(await webServices.creatUser(
          newUser, "Bearer XXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXXX"));
    } catch (error) {
      return ApiResult.failure(NetworkExceptions.getDioException(error));
    }
  }
}

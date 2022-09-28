import '../../model/users.dart';
import 'package:retrofit/retrofit.dart';
import 'package:dio/dio.dart';

part 'web_services.g.dart';

@RestApi(baseUrl: "https://gorest.co.in/public/v2/")
abstract class WebServices {
  factory WebServices(Dio dio, {String baseUrl}) = _WebServices;

  @GET("/users")
  Future<List<User>> getUsers();
  @GET("/users/{id}")
  Future<User> getUser(@Path("id") String id);
  @POST("/users")
  Future<User> creatUser(
      @Body() User newUser, @Header("Authorization") String token);
  @DELETE("/users/{id}")
  Future<User> deleteUser(@Path("id") String id);
}

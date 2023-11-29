part of 'user_bloc.dart';

@freezed
class UserEvent with _$UserEvent {
  const factory UserEvent.getUsers() = _GetUsers;
  const factory UserEvent.getUser(String id) = _GetUser;
  const factory UserEvent.createUser() = _CreateUser;
  const factory UserEvent.changeGender(Gender? value) = _ChangeGender;
}

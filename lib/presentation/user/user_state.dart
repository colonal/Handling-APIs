part of 'user_bloc.dart';

@freezed
class UserState<T> with _$UserState<T> {
  const factory UserState.loadInProgress() = _LoadInProgress;
  const factory UserState.success(T data) = _Success<T>;
  const factory UserState.failure(NetworkExceptions networkExceptions) =
      _Failure<T>;
}

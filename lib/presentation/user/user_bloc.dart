import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:freezed_annotation/freezed_annotation.dart';

import '../../data/network/network_exceptions.dart';
import '../../model/users.dart';
import '../../repository/repostory.dart';
import '../cubit/users_cubit.dart';

part 'user_state.dart';
part 'user_event.dart';
part 'user_bloc.freezed.dart';

class UserBloc extends Bloc<UserEvent, UserState> {
  factory UserBloc.get(context) => BlocProvider.of<UserBloc>(context);

  final Repository repository;
  UserBloc({required this.repository})
      : super(const UserState.loadInProgress()) {
    on<UserEvent>((event, emit) async {
      await event.when<Future>(
        getUsers: () async => await _getUsers(emit),
        getUser: (String id) async => await _getUser(emit, id),
        createUser: () async => await _createUser(emit),
        changeGender: (Gender? value) async => _changeGender(emit, value),
      );
    });
  }

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  Gender gender = Gender.male;

  List<User>? users;
  Future<void> _getUsers(emit) async {
    emit(const UserState.loadInProgress());
    var data = await repository.getUsers();
    data.when(success: (List<User> data) {
      users = data;
      emit(UserState.success(users));
    }, failure: (NetworkExceptions networkExceptions) {
      emit(UserState.failure(networkExceptions));
    });
  }

  Future<void> _getUser(emit, String id) async {
    emit(const UserState.loadInProgress());

    var data = await repository.getUser(id);
    data.when(success: (User user) {
      emit(UserState.success(user));
    }, failure: (NetworkExceptions networkExceptions) {
      emit(UserState.failure(networkExceptions));
    });
  }

  void _changeGender(emit, Gender? value) {
    gender = value!;
    emit(const UserState.success(null));
  }

  Future<void> _createUser(emit) async {
    emit(const UserState.loadInProgress());

    User user = User(
      name: name.text,
      email: email.text,
      gender: gender == Gender.male ? "Male" : "Female",
      status: "Active",
    );

    var data = await repository.creatUser(user);
    data.when(success: (User user) {
      users!.insert(0, user);
      emit(const UserState.success(true));
    }, failure: (NetworkExceptions networkExceptions) {
      emit(UserState.failure(networkExceptions));
    });
  }
}

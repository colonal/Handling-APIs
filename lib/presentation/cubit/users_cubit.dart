import '../../data/network/network_exceptions.dart';
import '../../repository/repostory.dart';

import 'package:flutter/cupertino.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../model/users.dart';
import 'users_state.dart';

enum Gender { male, female }

class UsersCubit extends Cubit<ResultState<dynamic>> {
  final Repository repository;
  UsersCubit({required this.repository}) : super(const Idle());

  factory UsersCubit.get(context) => BlocProvider.of<UsersCubit>(context);

  List<User>? users;
  void getUsers() async {
    emit(const ResultState.loading());
    var data = await repository.getUsers();
    data.when(success: (List<User> data) {
      users = data;
      emit(ResultState.success(data));
    }, failure: (NetworkExceptions networkExceptions) {
      emit(ResultState.error(networkExceptions));
    });
  }

  void getUser(String id) async {
    emit(const ResultState.loading());

    var data = await repository.getUser(id);
    data.when(success: (User user) {
      emit(ResultState.success(user));
    }, failure: (NetworkExceptions networkExceptions) {
      emit(ResultState.error(networkExceptions));
    });
  }

  TextEditingController name = TextEditingController();
  TextEditingController email = TextEditingController();
  Gender gender = Gender.male;

  void creatUser() async {
    emit(const ResultState.loading());
    User user = User(
        name: name.text,
        email: email.text,
        gender: gender == Gender.male ? "Male" : "Female",
        status: "Active");

    var data = await repository.creatUser(user);
    data.when(success: (User user) {
      users!.insert(0, user);
      emit(const ResultState.success(true));
    }, failure: (NetworkExceptions networkExceptions) {
      emit(ResultState.error(networkExceptions));
    });
  }

  void changeGender(Gender? value) {
    gender = value!;
    emit(const ResultState.success(null));
  }
}

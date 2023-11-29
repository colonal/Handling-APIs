import 'package:api_mobile/presentation/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/network/network_exceptions.dart';
import '../cubit/users_cubit.dart';
import '../cubit/users_state.dart';

class NewUserPage extends StatelessWidget {
  const NewUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState<dynamic>>(
      builder: (ctx, state) {
        UserBloc bloc = UserBloc.get(context);
        return Scaffold(
          appBar: AppBar(title: const Text("Home Screen"), centerTitle: true),
          body: _buildContect(context: ctx, state: state, bloc: bloc),
        );
      },
    );
  }

  _buildContect(
      {required BuildContext context,
      required UserState state,
      required UserBloc bloc}) {
    return state.when(
      loadInProgress: () {
        return _buildLoading();
      },
      success: (creatNew) {
        if (creatNew == true) {
          Future.delayed(
            const Duration(milliseconds: 300),
            () {
              // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
              bloc.emit(const UserState.success(null));
              Navigator.of(context).pop();
            },
          );
        }
        return _buildbody(context: context, bloc: bloc);
      },
      failure: (NetworkExceptions error) {
        return _buildErorr(
            message: NetworkExceptions.getErrorMessage(error), bloc: bloc);
      },
    );
  }

  _buildLoading() {
    return const Center(child: CircularProgressIndicator.adaptive());
  }

  _buildbody({required BuildContext context, required UserBloc bloc}) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            _buildItemField(bloc, title: "Name", controller: bloc.name),
            const SizedBox(height: 15),
            _buildItemField(bloc, title: "Email", controller: bloc.email),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    value: Gender.male,
                    groupValue: bloc.gender,
                    title: const Text("Male"),
                    onChanged: (value) {
                      bloc.add(UserEvent.changeGender(value));
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    value: Gender.female,
                    groupValue: bloc.gender,
                    title: const Text("Female"),
                    onChanged: (value) {
                      bloc.add(UserEvent.changeGender(value));
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            MaterialButton(
              onPressed: () {
                bloc.add(const UserEvent.createUser());
              },
              color: Colors.indigo[900],
              child: const Text(
                "Creat User",
                style: TextStyle(color: Colors.white),
              ),
            )
          ],
        ),
      ),
    );
  }

  Row _buildItemField(UserBloc bloc,
      {required String title, required TextEditingController controller}) {
    return Row(
      children: [
        Text("$title: ",
            style: const TextStyle(
                fontSize: 18,
                color: Colors.black,
                fontWeight: FontWeight.w400)),
        Expanded(
          child: TextFormField(
            controller: controller,
            decoration: InputDecoration(
              hintText: "$title ...",
              border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: const BorderSide(color: Colors.grey, width: 1)),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: const BorderSide(color: Colors.grey, width: 1),
              ),
            ),
          ),
        ),
      ],
    );
  }

  _buildErorr({required String message, required UserBloc bloc}) {
    return SizedBox(
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Text(message),
          const SizedBox(height: 10),
          MaterialButton(
            color: Colors.blueAccent,
            child: const Text("Try Agan"),
            onPressed: () => bloc.add(const UserEvent.getUsers()),
          )
        ],
      ),
    );
  }
}

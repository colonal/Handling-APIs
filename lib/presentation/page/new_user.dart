import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/network/network_exceptions.dart';
import '../cubit/users_cubit.dart';
import '../cubit/users_state.dart';

class NewUserPage extends StatelessWidget {
  const NewUserPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UsersCubit, ResultState<dynamic>>(
      builder: (ctx, state) {
        UsersCubit cubit = UsersCubit.get(context);
        return Scaffold(
          appBar: AppBar(title: const Text("Home Screen"), centerTitle: true),
          body: _buildContect(context: ctx, state: state, cubit: cubit),
        );
      },
    );
  }

  _buildContect(
      {required BuildContext context,
      required ResultState state,
      required UsersCubit cubit}) {
    return state.when(
      idle: () {
        return _buildLoading();
      },
      loading: () {
        return _buildLoading();
      },
      success: (creatNew) {
        if (creatNew == true) {
          Future.delayed(
            const Duration(milliseconds: 300),
            () {
              // ignore: invalid_use_of_visible_for_testing_member, invalid_use_of_protected_member
              cubit.emit(const ResultState.success(null));
              Navigator.of(context).pop();
            },
          );
        }
        return _buildbody(context: context, cubit: cubit);
      },
      error: (NetworkExceptions error) {
        return _buildErorr(
            message: NetworkExceptions.getErrorMessage(error), cubit: cubit);
      },
    );
  }

  _buildLoading() {
    return const Center(child: CircularProgressIndicator.adaptive());
  }

  _buildbody({required BuildContext context, required UsersCubit cubit}) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: size.width,
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          children: [
            _buildItemField(cubit, title: "Name", controller: cubit.name),
            const SizedBox(height: 15),
            _buildItemField(cubit, title: "Email", controller: cubit.email),
            const SizedBox(height: 15),
            Row(
              children: [
                Expanded(
                  child: RadioListTile(
                    value: Gender.male,
                    groupValue: cubit.gender,
                    title: const Text("Male"),
                    onChanged: (value) {
                      cubit.changeGender(value);
                    },
                  ),
                ),
                Expanded(
                  child: RadioListTile(
                    value: Gender.female,
                    groupValue: cubit.gender,
                    title: const Text("Female"),
                    onChanged: (value) {
                      cubit.changeGender(value);
                    },
                  ),
                ),
              ],
            ),
            const SizedBox(height: 15),
            MaterialButton(
              onPressed: () {
                cubit.creatUser();
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

  Row _buildItemField(UsersCubit cubit,
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

  _buildErorr({required String message, required UsersCubit cubit}) {
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
            onPressed: () => cubit.getUsers(),
          )
        ],
      ),
    );
  }
}

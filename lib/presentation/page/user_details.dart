import 'package:api_mobile/presentation/user/user_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/network/network_exceptions.dart';
import '../../model/users.dart';
import '../cubit/users_cubit.dart';
import '../cubit/users_state.dart';

class UserDetails extends StatelessWidget {
  const UserDetails({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState>(
      builder: (ctx, state) {
        return Scaffold(
          appBar: AppBar(title: const Text("User Details"), centerTitle: true),
          body: _buildContect(context: ctx, state: state),
        );
      },
    );
  }

  _buildContect({
    required BuildContext context,
    required UserState state,
  }) {
    return state.when(
      loadInProgress: () {
        return _buildLoading();
      },
      success: (userData) {
        if (userData is User) {
          return _buildbody(context: context, user: userData);
        }
      },
      failure: (NetworkExceptions error) {
        return _buildErorr(
            message: NetworkExceptions.getErrorMessage(error),
            context: context);
      },
    );
  }

  _buildLoading() {
    return const Center(child: CircularProgressIndicator.adaptive());
  }

  _buildbody({required User user, required BuildContext context}) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
        height: size.height,
        width: size.width,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Hero(
              tag: user.id!,
              child: Container(
                width: size.width * 0.4,
                height: size.height * 0.2,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: user.gender == "male"
                        ? Colors.blueAccent
                        : Colors.redAccent),
                child: Center(
                  child: Icon(
                    user.gender == "male" ? Icons.male : Icons.female,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
            const SizedBox(height: 20),
            Text(
              user.name ?? "",
              style: const TextStyle(
                  fontSize: 25,
                  color: Colors.black,
                  fontWeight: FontWeight.w600),
            ),
            const SizedBox(height: 10),
            Text(
              user.email ?? "",
              style: const TextStyle(
                  fontSize: 20,
                  color: Colors.black87,
                  fontWeight: FontWeight.w400),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("status",
                    style: TextStyle(
                        fontSize: 18,
                        color: user.status == "active"
                            ? Colors.greenAccent
                            : Colors.grey,
                        fontWeight: FontWeight.w400)),
                const SizedBox(width: 5),
                CircleAvatar(
                  radius: 5,
                  backgroundColor: user.status == "active"
                      ? Colors.greenAccent
                      : Colors.grey,
                ),
              ],
            ),
          ],
        ));
  }

  _buildErorr({required String message, required BuildContext context}) {
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
            onPressed: () => Navigator.of(context).pop(),
          )
        ],
      ),
    );
  }
}

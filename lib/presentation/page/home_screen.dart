import '../../model/users.dart';
import '../cubit/users_cubit.dart';
import '../user/user_bloc.dart';
import 'new_user.dart';
import 'user_details.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import '../../data/network/network_exceptions.dart';
import '../cubit/users_state.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<UserBloc, UserState<dynamic>>(
      builder: (ctx, state) {
        UserBloc bloc = UserBloc.get(context);
        return Scaffold(
          appBar: AppBar(title: const Text("Home Screen"), centerTitle: true),
          body: _buildContect(context: ctx, state: state, bloc: bloc),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.of(context)
                  .push(MaterialPageRoute(builder: (_) => const NewUserPage()));
            },
            child: const Icon(Icons.add),
          ),
        );
      },
    );
  }

  _buildContect(
      {required BuildContext context,
      required UserState state,
      required UserBloc bloc}) {
    return state.when(loadInProgress: () {
      return _buildLoading();
    }, success: (data) {
      return _buildbody(context: context, bloc: bloc, users: bloc.users ?? []);
    }, failure: (NetworkExceptions error) {
      return _buildErorr(
          message: NetworkExceptions.getErrorMessage(error), bloc: bloc);
    });
  }

  _buildLoading() {
    return const Center(child: CircularProgressIndicator.adaptive());
  }

  _buildbody(
      {required List<User> users,
      required BuildContext context,
      required UserBloc bloc}) {
    final Size size = MediaQuery.of(context).size;
    return SizedBox(
      height: size.height,
      width: size.width,
      child: ListView.separated(
        itemCount: users.length,
        shrinkWrap: true,
        separatorBuilder: ((context, index) => const SizedBox(height: 10)),
        itemBuilder: (context, index) => InkWell(
          onTap: () {
            bloc.add(UserEvent.getUser(users[index].id.toString()));
            Navigator.of(context)
                .push(MaterialPageRoute(builder: (_) => const UserDetails()));
          },
          child: SizedBox(
            height: 60,
            width: size.width,
            child: ListTile(
              title: Text(users[index].name ?? ""),
              subtitle: Text(users[index].email ?? ""),
              leading: Hero(
                tag: users[index].id!,
                child: Container(
                  width: size.width * 0.2,
                  height: 60,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(8),
                      color: users[index].gender == "male"
                          ? Colors.blueAccent
                          : Colors.redAccent),
                  child: Center(
                    child: Icon(
                      users[index].gender == "male" ? Icons.male : Icons.female,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
              trailing: CircleAvatar(
                radius: 5,
                backgroundColor: users[index].status == "active"
                    ? Colors.greenAccent
                    : Colors.grey,
              ),
            ),
          ),
        ),
      ),
    );
  }

  _buildErorr({required String message, required UserBloc bloc}) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Text(message),
        const SizedBox(height: 10),
        MaterialButton(
          child: const Text("Try Agan"),
          onPressed: () => bloc.add(const UserEvent.getUsers()),
        )
      ],
    );
  }
}

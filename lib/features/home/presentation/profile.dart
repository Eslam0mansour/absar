
import 'package:absar/features/auth/cubit/auth_cubit.dart';
import 'package:absar/features/auth/cubit/auth_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Profile extends StatelessWidget {
  const Profile({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('error:'),
            ),
          );
        }
        if (state is AuthSignOutSuccess) {
          Navigator.of(context).pushNamedAndRemoveUntil( '/login', (route) => false);
        }
      },
      builder: (context, state) {
        if (state is AuthSuccess ||
            state is DataCompletedDone ||
            state is GetUserSuccess) {
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Center(
                child: Text(
                    'Welcome ${context.read<AuthCubit>().userDoc!['name']}'),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                  'Your email is ${context.read<AuthCubit>().userDoc!['email']}'),
              const SizedBox(
                height: 20,
              ),
              ElevatedButton(
                onPressed: () {
                  context.read<AuthCubit>().signOut();
                },
                child: const Text('Sign Out'),
              ),
            ],
          );
        } else {
          return const Center(
            child: Text('Something went wrong'),
          );
        }
      },
    );
  }
}
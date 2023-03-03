
import 'package:absar/features/auth/cubit/auth_cubit.dart';
import 'package:absar/features/auth/cubit/auth_states.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class LoginWithGoogle extends StatelessWidget {
  LoginWithGoogle({Key? key}) : super(key: key);

  final _formKey = GlobalKey<FormState>();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is AuthSuccess) {
          context.read<AuthCubit>().testIfUserIsExists().then((value) {
            if (value == true) {
              Navigator.of(context)
                  .pushNamedAndRemoveUntil('/home', (r) => false);
            } else {
              Navigator.of(context).pushNamedAndRemoveUntil(
                  '/complete', (r) => false);
            }
          });
        }
        if (state is AuthError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              duration: const Duration(microseconds: 3000),
              content: Text(state.message),
            ),
          );
          isLoading = false;
        }
        if (state is AuthLoading) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              duration: Duration(seconds: 3),
              content: Text('Loading...'),
              backgroundColor: Colors.blue,
            ),
          );
          isLoading = true;
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                isLoading
                    ? const Center(
                        child: CircularProgressIndicator(),
                      )
                    : ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          textStyle: const TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          minimumSize: const Size(double.infinity, 50),
                          padding: const EdgeInsets.symmetric(
                            horizontal: 30,
                            vertical: 15,
                          ),
                        ),
                        onPressed: () async {
                            FocusScope.of(context).unfocus();
                            context.read<AuthCubit>().signInWithGoogle();
                        },
                        child: const Text('login with gmail'),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }
}

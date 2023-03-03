

import 'package:absar/features/auth/cubit/auth_cubit.dart';
import 'package:absar/features/auth/cubit/auth_states.dart';
import 'package:absar/features/auth/widgets/my_form_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';


class CompleteData extends StatelessWidget {
   CompleteData({Key? key}) : super(key: key);
  final _formKey = GlobalKey<FormState>();
  TextEditingController nameController = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthCubit, AuthState>(
      listener: (context, state) {
        if (state is DataCompletedDone) {
          Navigator.of(context).pushNamedAndRemoveUntil(
              '/home', (r) => false);
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: Colors.white,
          body: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 15,
            ),
            child: Form(
                key: _formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                     const Align(
                      alignment: Alignment.centerLeft,
                      child: Text(
                        'Complete Your Data',
                        style: TextStyle(
                          fontSize: 30,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    const SizedBox(height: 20),
                    MyFormField(
                      controller: nameController,
                      hint: 'Name',
                      onSubmit: (value) {
                        context.read<AuthCubit>().saveMyUser(
                          nameController.text,
                        );
                      },
                      validator: (value) {
                        if (value.isEmpty) {
                          return 'Please enter your name';
                        }
                        return null;
                      },
                    ),
                    const SizedBox(height: 20),
                    ElevatedButton(
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
                        if (_formKey.currentState!.validate()) {
                          FocusScope.of(context).unfocus();
                          context.read<AuthCubit>().saveMyUser(
                            nameController.text,
                          );
                        }
                      },
                      child: const Text('Save'),
                    ),
                  ],
                )),
          ),
        );
      },
    );

  }
}

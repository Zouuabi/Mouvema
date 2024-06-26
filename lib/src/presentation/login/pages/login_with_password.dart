import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mouvema/src/core/utils/string_manager.dart';

import '../../../config/routes/routes.dart';
import '../../../injector.dart';
import '../../shared/text_field.dart';
import '../cubit/login_cubit.dart';

// ?Login = sign in
// ?register = sign up

class LoginWithPassword extends StatelessWidget {
  const LoginWithPassword({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => instance<LoginScreenCubit>(),
      child: Scaffold(
        appBar: AppBar(elevation: 4),
        body: Padding(
          padding: const EdgeInsets.all(20),
          child: BlocConsumer<LoginScreenCubit, LoginScreenState>(
              builder: (context, state) {
            return state.status == Status.loading
                ? const Center(child: CircularProgressIndicator())
                : _screenContent(context, state);
          }, listener: (context, state) {
            if (state.status == Status.failed) {
              AwesomeDialog(
                btnOkColor: Colors.teal,
                context: context,
                dialogType: DialogType.error,
                animType: AnimType.topSlide,
                title: state.errorMessage,
              ).show();
            } else if (state.status == Status.success) {
              Navigator.pushReplacementNamed(context, Routes.main);
            }
          }),
        ),
      ),
    );
  }

  Column _screenContent(BuildContext context, LoginScreenState state) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
            child: Text(
          StringManager.loginToYourAccount,
          textAlign: TextAlign.start,
          style: Theme.of(context).textTheme.displayMedium,
        )),
        Expanded(
          flex: 3,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                // email field
                MyTextField(
                    errorMessage: StringManager.emailIsRequired,
                    keyboardType: TextInputType.emailAddress,
                    icon: Icons.email_outlined,
                    controller: BlocProvider.of<LoginScreenCubit>(context)
                        .emailController,
                    hintText: 'user@example.com',
                    isError: state.status == Status.emailEmpty ? true : false),
                const SizedBox(
                  height: 30,
                ),
                // password field
                MyTextField(
                    isPassword: true,
                    errorMessage: StringManager.passwordIsRequired,
                    keyboardType: TextInputType.emailAddress,
                    icon: Icons.lock_open_sharp,
                    controller: BlocProvider.of<LoginScreenCubit>(context)
                        .passwordController,
                    hintText: StringManager.enterYourPassword,
                    isError:
                        state.status == Status.passwordEmpty ? true : false),
                const SizedBox(height: 30),
                // remember me button
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    GestureDetector(
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.grey,
                            borderRadius: BorderRadius.circular(10)),
                        height: 30,
                        width: 30,
                      ),
                    ),
                    const SizedBox(width: 10),
                    Text(
                      'Remember me',
                      style: Theme.of(context).textTheme.labelMedium,
                    )
                  ],
                ),
                const SizedBox(height: 30),
                SizedBox(
                  height: 70,
                  child: ElevatedButton(
                      onPressed: () {
                        BlocProvider.of<LoginScreenCubit>(context).logIn();
                      },
                      child: Text(StringManager.singIn)),
                ),
                const SizedBox(height: 10),
                TextButton(
                    onPressed: () {
                      Navigator.pushNamed(context, Routes.forgotPassword);
                    },
                    child: Text(StringManager.forgotPassword)),
                const SizedBox(height: 30),
                Center(
                    child: Text(
                  StringManager.orContinueWith,
                  style: Theme.of(context).textTheme.bodyLarge,
                )),
                const SizedBox(height: 30),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    Icon(
                      Icons.facebook,
                      size: 60,
                    ),
                    Icon(
                      Icons.g_mobiledata,
                      size: 60,
                    ),
                    Icon(
                      Icons.apple,
                      size: 60,
                    )
                  ],
                ),
                const SizedBox(height: 30),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      StringManager.dontHaveAccount,
                      style: Theme.of(context).textTheme.labelMedium,
                    ),
                    TextButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        child: Text(StringManager.signUp)),
                  ],
                )
              ],
            ),
          ),
        )
      ],
    );
  }
}

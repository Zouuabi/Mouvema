import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mouvema/src/config/routes/routes.dart';

import '../../../core/helpers/email_checker.dart';
import '../../../core/utils/image_manager.dart';
import '../../../data/repository/repository_impl.dart';
import '../../../injector.dart';
import '../../shared/show_alert.dart';
import '../../shared/text_field.dart';
import '../cubit/forgot_password_cubit.dart';

class ResetAccountScreen extends StatelessWidget {
  // torichika l tandhim l code
  ResetAccountScreen({super.key});

  final TextEditingController controller = TextEditingController();
  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => ForgotPasswordCubit(instance<RepositoryImpl>()),
      child: Scaffold(
        appBar: AppBar(
          elevation: 4,
          title: const Text('Rest your account'),
        ),
        body: Padding(
          padding: const EdgeInsets.all(20.0),
          child: SingleChildScrollView(
            child: BlocConsumer<ForgotPasswordCubit, ForgotPasswordState>(
              listener: (context, state) {
                if (state.status == Status.failed) {
                  showAlert(
                      context: context,
                      message: state.errorMessage!,
                      title: 'Oops!');
                } else if (state.status == Status.emailSent) {
                  Navigator.pushReplacementNamed(
                      context, Routes.login);
                  showAlert(
                      message: 'We sent you an email Check inbox',
                      context: context,
                      title: 'Success');
                }
              },
              builder: (context, state) => state.status == Status.loading
                  ? const Center(
                      child: CircularProgressIndicator(),
                    )
                  : Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                          Container(
                              margin: const EdgeInsets.only(bottom: 30),
                              height: 200,
                              alignment: Alignment.center,
                              child: Image.asset(ImageManager.resetPassword)),
                          Text(
                            'Enter your account adrress',
                            style: Theme.of(context).textTheme.bodyLarge,
                          ),
                          const SizedBox(height: 20),
                          MyTextField(
                              errorMessage: 'You must enter your email ',
                              keyboardType: TextInputType.visiblePassword,
                              icon: Icons.email,
                              controller: controller,
                              hintText: 'user@example.com',
                              isError:
                                  BlocProvider.of<ForgotPasswordCubit>(context)
                                      .isEmailEmpty),
                          const SizedBox(height: 20),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text('Didn\'t recieve an email ?'),
                              TextButton(
                                  onPressed: () {
                                    if (controller.text.isNotEmpty &&
                                        isValidEmail(controller.text.trim())) {
                                      BlocProvider.of<ForgotPasswordCubit>(
                                              context)
                                          .sendPasswordResetEmail(
                                              email: controller.text.trim());
                                    }
                                  },
                                  child: const Text('Resend'))
                            ],
                          ),
                          SizedBox(
                              height: 70,
                              width: double.infinity,
                              child: ElevatedButton(
                                child: const Text('Send'),
                                onPressed: () {
                                  if (controller.text.isNotEmpty &&
                                      isValidEmail(controller.text.trim())) {
                                    BlocProvider.of<ForgotPasswordCubit>(
                                            context)
                                        .sendPasswordResetEmail(
                                            email: controller.text.trim());
                                  }
                                },
                              ))
                        ]),
            ),
          ),
        ),
      ),
    );
  }
}

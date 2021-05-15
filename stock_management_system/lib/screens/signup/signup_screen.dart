import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_system/repositories/auth/auth_repository.dart';
import 'package:stock_management_system/screens/signup/cubit/signup_cubit.dart';
import 'package:stock_management_system/screens/signup/widgets/widgets.dart';
import 'package:stock_management_system/widgets/widgets.dart';

class SignupScreen extends StatelessWidget {
  static const String routeName = '/signup';

  static Route route() {
    return MaterialPageRoute(
      settings: const RouteSettings(name: routeName),
      builder: (context) => BlocProvider<SignupCubit>(
        create: (_) =>
            SignupCubit(authRepository: context.read<AuthRepository>()),
        child: SignupScreen(),
      ),
    );
  }

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async => false,

      /// Prevents a user from sliding back to the previous screen
      child: GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: BlocConsumer<SignupCubit, SignupState>(
            listener: (context, state) {
              if (state.status == SignupStatus.error) {
                showDialog(
                  context: context,
                  builder: (context) =>
                      ErrorDialog(content: state.failure.message),
                );
              }
            },
            builder: (context, state) {
              return Scaffold(
                  resizeToAvoidBottomInset: false,
                  body: Center(
                    child: Card(
                      color: Colors.white,
                      child: Padding(
                        padding: const EdgeInsets.all(24.0),
                        child: Form(
                          key: _formKey,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              const Text(
                                'Register',
                                style: TextStyle(
                                  fontSize: 28.0,
                                  fontWeight: FontWeight.bold,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 12.0),
                              TextFormField(
                                decoration:
                                    InputDecoration(hintText: 'username'),
                                onChanged: (value) => context
                                    .read<SignupCubit>()
                                    .usernameChanged(value),
                                validator: (value) => value.trim().isEmpty
                                    ? "Please enter a valid email."
                                    : null,
                              ),
                              const SizedBox(height: 12.0),
                              TextFormField(
                                decoration: InputDecoration(hintText: 'Email'),
                                onChanged: (value) => context
                                    .read<SignupCubit>()
                                    .emailChanged(value),
                                validator: (value) => !value.contains('@')
                                    ? 'Please entered valid email'
                                    : null,
                              ),
                              const SizedBox(height: 16.0),
                              TextFormField(
                                decoration:
                                    InputDecoration(hintText: 'Password'),
                                obscureText: true,
                                onChanged: (value) => context
                                    .read<SignupCubit>()
                                    .passwordChanged(value),
                                validator: (value) => value.length < 6
                                    ? 'Must be at least 6 characters'
                                    : null,
                              ),
                              const SizedBox(height: 25.0),
                              BlocProvider.value(
                                value: context.read<SignupCubit>(),
                                child: DropDownButton(
                                  items: ['Admin', 'Other'],
                                  hintMessage: 'Account Type',
                                ),
                              ),
                              const SizedBox(height: 28.0),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Theme.of(context).primaryColor,
                                  onPrimary: Colors.white,
                                  shadowColor: Colors.grey,
                                ),
                                onPressed: () => _submitForm(context,
                                    state.status == SignupStatus.submitting),
                                child: Text('Signup'),
                              ),
                              const SizedBox(height: 12.0),
                              ElevatedButton(
                                style: ElevatedButton.styleFrom(
                                  primary: Colors.grey[200],
                                  onPrimary: Colors.black,
                                  shadowColor: Colors.grey,
                                ),
                                onPressed: () => Navigator.of(context).pop(),
                                child: Text('Back to Login'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ));
            },
          )),
    );
  }

  void _submitForm(BuildContext context, bool isSubmitting) {
    if (_formKey.currentState.validate() && !isSubmitting) {
      /// isSubmitting means the user has signup in progress
      context.read<SignupCubit>().signUpWithCredentials();
    }
  }
}

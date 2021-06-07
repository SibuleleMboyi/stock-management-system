import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_system/blocs/blocs.dart';
import 'package:stock_management_system/repositories/repositories.dart';
import 'package:stock_management_system/screens/profile/preload_data.dart';
import 'package:stock_management_system/screens/profile/cubit/profile_cubit.dart';
import 'package:stock_management_system/widgets/widgets.dart';

/// Contains brands this company is currently ordering from or is in partnership with

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final GlobalKey<FormState> _formkey = GlobalKey<FormState>();
  static String initialAdminEmail = '';
  static String initialAdminEmailPassword = '';
  static String initialManagerEmail = '';
  static String initialUsername = '';
  bool _showPass1 = true;
  bool _showPass2 = true;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProfileCubit, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.submitting) {
          const LinearProgressIndicator();
        } else if (state.status == ProfileStatus.success) {
          context.read<ProfileCubit>().reset();
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.green,
              duration: const Duration(seconds: 3),
              content: const Text('Profile successfully updated'),
            ),
          );
        } else if (state.status == ProfileStatus.error) {
          showDialog(
            context: context,
            builder: (context) => ErrorDialog(content: state.failure.message),
          );
        }
      },
      builder: (context, state) {
        context.read<ProfileCubit>().loadExtraData();
        loadCheckData(context: context);

        print([
          state.username,
          state.managerEmail,
          state.adminEmail,
          state.adminPassword
        ]);

        return (initialAdminEmail == null &&
                initialAdminEmailPassword == null &&
                initialManagerEmail == null)
            ? const LinearProgressIndicator()
            : Scaffold(
                appBar: AppBar(
                  title: Center(child: Text('Edit Profile')),
                  actions: [
                    IconButton(
                        icon: const Icon(Icons.exit_to_app),
                        onPressed: () {
                          context.read<ProfileCubit>().logOut();
                        })
                  ],
                ),
                body: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Form(
                      key: _formkey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.stretch,
                        children: [
                          const SizedBox(height: 20.0),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Manager Email'),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: Colors.black12,
                              ),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    initialValue: initialManagerEmail,
                                    decoration: InputDecoration(
                                      hintText: 'Manager Email',
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (email) => context
                                        .read<ProfileCubit>()
                                        .managerEmailChanged(email),
                                    validator: (email) => email.trim().isEmpty
                                        ? 'Manager Email is required'
                                        : null,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40.0),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('Admin Email and Password'),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: Colors.black12,
                              ),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    initialValue: initialAdminEmail,
                                    decoration: InputDecoration(
                                      hintText: 'Valid Admin Email',
                                    ),
                                    onChanged: (email) => context
                                        .read<ProfileCubit>()
                                        .adminEmailChanged(email),
                                    validator: (email) => email.trim().isEmpty
                                        ? 'Admin Email is required'
                                        : null,
                                  ),
                                ),
                                Stack(
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: TextFormField(
                                        obscureText: _showPass1,
                                        initialValue: initialAdminEmailPassword,
                                        decoration: InputDecoration(
                                          hintText:
                                              'Valid Admin Email Password',
                                          border: InputBorder.none,
                                        ),
                                        onChanged: (password) => context
                                            .read<ProfileCubit>()
                                            .adminPasswordChanged(password),
                                        validator: (password) => password
                                                .trim()
                                                .isEmpty
                                            ? 'Admin Email Password is required'
                                            : null,
                                      ),
                                    ),
                                    Positioned(
                                      top: 0.0,
                                      right: 18.0,
                                      child: IconButton(
                                        icon: _showPass1
                                            ? Icon(
                                                Icons.visibility_off,
                                                color: Colors.black45,
                                                size: 20.0,
                                              )
                                            : Icon(Icons.visibility),
                                        onPressed: () {
                                          setState(
                                            () {
                                              _showPass1 = !_showPass1;
                                            },
                                          );
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 40.0),
                          Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Text('My Login Details'),
                          ),
                          Container(
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(10.0),
                              border: Border.all(
                                color: Colors.black12,
                              ),
                            ),
                            child: Column(
                              children: [
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: TextFormField(
                                    initialValue: initialUsername,
                                    decoration: InputDecoration(
                                      hintText: 'username',
                                    ),
                                    onChanged: (username) => context
                                        .read<ProfileCubit>()
                                        .usernameChanged(username),
                                    validator: (username) =>
                                        username.trim().isEmpty
                                            ? 'Username is required'
                                            : null,
                                  ),
                                ),
                                Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Stack(
                                    children: [
                                      TextFormField(
                                        readOnly: true,
                                        initialValue: state.adminPassword,
                                        obscureText: _showPass2,
                                        decoration: InputDecoration(
                                          hintText: 'Password',
                                          border: InputBorder.none,
                                        ),
                                        onChanged: (password) => context
                                            .read<ProfileCubit>()
                                            .passwordChanged(password),
                                        validator: (password) =>
                                            password.trim().isEmpty
                                                ? 'Password is required'
                                                : null,
                                      ),
                                      Positioned(
                                        top: 0.0,
                                        right: 18.0,
                                        child: IconButton(
                                          icon: _showPass2
                                              ? Icon(
                                                  Icons.visibility_off,
                                                  color: Colors.black45,
                                                  size: 20.0,
                                                )
                                              : Icon(Icons.visibility),
                                          onPressed: () {
                                            setState(
                                              () {
                                                _showPass2 = !_showPass2;
                                              },
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 45.0),
                          ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              primary: Theme.of(context).primaryColor,
                              onPrimary: Colors.white,
                              shadowColor: Colors.grey,
                            ),
                            onPressed: () =>
                                context.read<ProfileCubit>().submit(),
                            child: Text('Update'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
      },
    );
  }

  Future<List<String>> loadCheckData({BuildContext context}) async {
    final checkList = await PreloadData(
      userRepository: context.read<UserRepository>(),
      authBloc: context.read<AuthBloc>(),
    ).loadInitialData();
    if (checkList[0].isNotEmpty) {
      initialAdminEmail = checkList[0][0];
      initialAdminEmailPassword = checkList[0][1];
      initialManagerEmail = checkList[1];
    }
    initialUsername = checkList[2].username;

    print('mmmmmmmmmmmmmm');
    print(checkList[2].toString());

    return [
      initialAdminEmail,
      initialAdminEmailPassword,
      initialManagerEmail,
      initialUsername
    ];
  }
}

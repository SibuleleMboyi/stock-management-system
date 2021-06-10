import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:stock_management_system/screens/profile/bloc/profile_bloc.dart';
import 'package:stock_management_system/widgets/widgets.dart';

class ProfileScreen extends StatefulWidget {
  @override
  _ProfileScreenState createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  @override
  Widget build(BuildContext context) {
    final GlobalKey<FormState> _formkey = GlobalKey<FormState>();

    return BlocConsumer<ProfileBloc, ProfileState>(
      listener: (context, state) {
        if (state.status == ProfileStatus.success) {
          //context.read<ProfileBloc>().add(Reset());
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
        return GestureDetector(
          onTap: () => FocusScope.of(context).unfocus(),
          child: Scaffold(
            appBar: AppBar(
              title: Center(child: Text('Edit Profile')),
              actions: [
                IconButton(
                    icon: const Icon(Icons.exit_to_app),
                    onPressed: () {
                      context.read<ProfileBloc>().add(LogOut());
                    })
              ],
            ),
            body: SingleChildScrollView(
              child: Stack(
                children: [
                  (state.status == ProfileStatus.submitting)
                      ? const LinearProgressIndicator()
                      : SizedBox.shrink(),
                  Padding(
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
                                    initialValue: state.managerEmail,
                                    decoration: InputDecoration(
                                      hintText: 'Manager Email',
                                      border: InputBorder.none,
                                    ),
                                    onChanged: (email) => context
                                        .read<ProfileBloc>()
                                        .add(ManagerEmailChanged(
                                            managerEmail: email)),
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
                                    initialValue: state.adminEmail,
                                    decoration: InputDecoration(
                                      hintText: 'Valid Admin Email',
                                    ),
                                    onChanged: (email) => context
                                        .read<ProfileBloc>()
                                        .add(AdminEmailChanged(
                                            adminEmail: email)),
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
                                        obscureText: state.isPassVisible,
                                        initialValue: state.adminPassword,
                                        decoration: InputDecoration(
                                          hintText:
                                              'Valid Admin Email Password',
                                          border: InputBorder.none,
                                        ),
                                        onChanged: (password) => context
                                            .read<ProfileBloc>()
                                            .add(AdminEmailPasswordChanged(
                                                adminEmailPassword: password)),
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
                                        icon: state.isPassVisible
                                            ? Icon(
                                                Icons.visibility_off,
                                                color: Colors.black45,
                                                size: 20.0,
                                              )
                                            : Icon(Icons.visibility),
                                        onPressed: () {
                                          context.read<ProfileBloc>().add(
                                                ToogleViewPassword(
                                                  isVisible:
                                                      state.isPassVisible,
                                                ),
                                              );
                                          //print(state.isPassVisible);
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
                            child: Text('My Details'),
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
                                    initialValue: state.username,
                                    decoration: InputDecoration(
                                      hintText: 'username',
                                    ),
                                    onChanged: (username) => context
                                        .read<ProfileBloc>()
                                        .add(UsernameChanged(
                                            username: username)),
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
                                        //initialValue: state.adminPassword,
                                        obscureText: false,
                                        decoration: InputDecoration(
                                          hintText: 'Password',
                                          border: InputBorder.none,
                                        ),
                                        onChanged: (password) => {},
                                        validator: (password) =>
                                            password.trim().isEmpty
                                                ? 'Password is required'
                                                : null,
                                      ),
                                      Positioned(
                                        top: 0.0,
                                        right: 18.0,
                                        child: IconButton(
                                          icon: Icon(
                                            Icons.visibility_off,
                                            color: Colors.black45,
                                            size: 20.0,
                                          ),
                                          onPressed: () => {},
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
                            onPressed: () {
                              context.read<ProfileBloc>().add(SubmitChanges());
                            },
                            child: Text('Update'),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        );
      },
    );
  }
}

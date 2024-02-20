import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:nugget/common/constants/gaps.dart';
import 'package:nugget/common/constants/sizes.dart';
import 'package:nugget/common/data/data.dart';
import 'package:nugget/common/utils/account_validate.dart';

import 'package:nugget/features/authentication/models/user_info_model.dart';
import 'package:nugget/features/authentication/view_models/user_info_view_model.dart';
import 'package:nugget/features/guardian/views/guardian_map_screen.dart';
import 'package:nugget/features/member/views/camera_screen.dart';

class SignUpScreen extends ConsumerStatefulWidget {
  const SignUpScreen({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends ConsumerState<SignUpScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  final Map<String, String> _formData = {};

  final bool _isEmailAvailable = false;

  late Role _role;

  @override
  void dispose() {
    // Dispose the controller when the state is disposed
    _passwordController.dispose();
    super.dispose();
  }

  void _onTapSignUpButton() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      print(_formData);

      final email = _formData['email'];
      final password = _formData['password'];
      final name = _formData['name'];
      final phoneNumber = _formData['phone'];

      // Perform the POST request to sign up
      final userInfo = await ref.read(authProvider.notifier).signUp(
            email: email!,
            password: password!,
            name: name!,
            phoneNumber: phoneNumber!,
            role: _role,
          );

      if (userInfo.role == Role.guardian) {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const GuardianMapScreen()),
            (route) => false);
      } else {
        if (!mounted) return;
        Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => const CameraScreen()),
            (route) => false);
      }
    }
  }

  Future<bool> checkEmailExist(String email) async {
    final Dio dio = Dio();
    try {
      final response = await dio.get(
        '$commonUrl/member/checkEmail',
        queryParameters: {
          'email': email,
        },
      );
      final result = response.data['result'];

      if (result == 'true') {
        return true;
      } else {
        return false;
      }
    } catch (e) {
      print(e);
      rethrow;
    }
  }

  // 이메일 중복확인을 위한 함수
  void handleDuplication() async {
    if (validateEmail(_emailController.text) != null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Email format is not valid.'),
        ),
      );
      return;
    }
    // 이메일 중복확인을 위한 GET request
    final result = await checkEmailExist(_emailController.text);
    if (result) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Email is available')),
      );
    } else {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Failed to check email duplication'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        FocusScope.of(context).unfocus();
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Sign Up'),
        ),
        body: SingleChildScrollView(
          keyboardDismissBehavior: ScrollViewKeyboardDismissBehavior.onDrag,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: Sizes.size20,
            ),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Gaps.v16,
                  Text(
                    'Email',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: TextFormField(
                          controller: _emailController,
                          autocorrect: false,
                          keyboardType: TextInputType.emailAddress,
                          validator: (value) {
                            validateEmail(value);

                            if (_isEmailAvailable == false) {
                              return 'Check email duplication first';
                            }

                            return null;
                          },
                          onSaved: (newValue) {
                            _formData['email'] = newValue!;
                          },
                          decoration: InputDecoration(
                            hintText: 'Enter your email address',
                            filled: false,
                            enabledBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: Sizes.size2,
                              ),
                            ),
                            focusedBorder: UnderlineInputBorder(
                              borderSide: BorderSide(
                                color: Theme.of(context).primaryColor,
                                width: Sizes.size2,
                              ),
                            ),
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: handleDuplication,
                        child: const Text('Check duplication'),
                      ),
                    ],
                  ),
                  Gaps.v16,
                  Text(
                    'Password',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    controller: _passwordController,
                    onSaved: (newValue) {
                      _formData['password'] = newValue!;
                    },
                    validator: validatePassword,
                    decoration: InputDecoration(
                      hintText: 'Enter your password',
                      filled: false,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: Sizes.size2,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: Sizes.size2,
                        ),
                      ),
                    ),
                  ),
                  Gaps.v16,
                  Text(
                    'Confirm Password',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.visiblePassword,
                    obscureText: true,
                    validator: (value) {
                      if (value != _passwordController.text) {
                        return 'Passwords do not match';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Confirm your password',
                      filled: false,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: Sizes.size2,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: Sizes.size2,
                        ),
                      ),
                    ),
                  ),
                  Gaps.v16,
                  Text(
                    'Name',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.name,
                    onSaved: (newValue) {
                      _formData['name'] = newValue!;
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Enter your name';
                      }
                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your name',
                      filled: false,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: Sizes.size2,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: Sizes.size2,
                        ),
                      ),
                    ),
                  ),
                  Gaps.v16,
                  Text(
                    'Phone Number',
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                  TextFormField(
                    keyboardType: TextInputType.phone,
                    onSaved: (newValue) {
                      _formData['phone'] = newValue!;
                    },
                    validator: (value) {
                      final phoneRegExp =
                          RegExp(r'^010-?([0-9]{4})-?([0-9]{4})$');
                      if (value == null || value.isEmpty) {
                        return 'Enter your phone number';
                      }

                      if (!phoneRegExp.hasMatch(value)) {
                        return 'Invalid phone number';
                      }

                      return null;
                    },
                    decoration: InputDecoration(
                      hintText: 'Enter your phone number',
                      filled: false,
                      enabledBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: Sizes.size2,
                        ),
                      ),
                      focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(
                          color: Theme.of(context).primaryColor,
                          width: Sizes.size2,
                        ),
                      ),
                    ),
                  ),
                  Gaps.v16,
                  const Text('User Type'),
                  Row(
                    children: [
                      Expanded(
                        child: RadioListTile(
                          title: const Text('Member'),
                          value: Role.member,
                          groupValue: _role,
                          onChanged: (value) {
                            setState(() {
                              _role = value as Role;
                            });
                          },
                        ),
                      ),
                      Expanded(
                        child: RadioListTile(
                          title: const Text('Guardian'),
                          value: Role.guardian,
                          groupValue: _role,
                          onChanged: (value) {
                            setState(() {
                              _role = value as Role;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        bottomNavigationBar: BottomAppBar(
          color: Theme.of(context).colorScheme.primaryContainer,
          child: TextButton(
            style: TextButton.styleFrom(
              splashFactory: NoSplash.splashFactory,
            ),
            onPressed: _onTapSignUpButton,
            child: Text(
              'Sign Up',
              style: TextStyle(
                fontSize: Sizes.size24,
                color: Theme.of(context).colorScheme.onPrimaryContainer,
              ),
            ),
          ),
        ),
      ),
    );
  }
}

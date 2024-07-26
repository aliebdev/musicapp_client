import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_pallete.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/widgets/custom_field.dart';
import '../../../../core/widgets/loader.dart';
import '../../viewmodel/auth_viewmodel.dart';
import '../widgets/auth_gradient_button.dart';
import 'login_page.dart';

class SignUpPage extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const SignUpPage());
  const SignUpPage({super.key});

  @override
  ConsumerState<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends ConsumerState<SignUpPage> {
  final formKey = GlobalKey<FormState>();
  late String name = "";
  late String email = "";
  late String password = "";

  @override
  Widget build(BuildContext context) {
    final bool isLoading = ref.watch(authViewModelProvider.select(
      (value) => value?.isLoading == true,
    ));
    ref.listen(
      authViewModelProvider,
      (_, next) {
        next?.when(
          data: (data) {
            AppSnackbar.showSnackabar(
              context,
              content: "Account created successfully! Please login.",
              isError: false,
            );
            Navigator.push(context, LoginPage.route());
          },
          error: (error, stackTrace) {
            AppSnackbar.showSnackabar(
              context,
              content: error.toString(),
            );
          },
          loading: () {},
        );
      },
    );
    return Scaffold(
      appBar: AppBar(),
      body: isLoading
          ? const Loader()
          : SingleChildScrollView(
              child: Padding(
                padding: const EdgeInsets.all(15),
                child: Form(
                  key: formKey,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Sign Up.",
                        style: TextStyle(
                          fontSize: 50,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      const SizedBox(height: 30),
                      CustomField(
                        initValue: name,
                        hintText: "Name",
                        onSaved: (value) => name = value ?? "",
                      ),
                      const SizedBox(height: 15),
                      CustomField(
                        initValue: email,
                        hintText: "Email",
                        onSaved: (value) => email = value ?? "",
                      ),
                      const SizedBox(height: 15),
                      CustomField(
                        initValue: password,
                        hintText: "Password",
                        obscureText: true,
                        onSaved: (value) => password = value ?? "",
                      ),
                      const SizedBox(height: 20),
                      AuthGradientButton(
                        text: "Sign Up",
                        onTap: () {
                          if (!formKey.currentState!.validate()) return;
                          formKey.currentState!.save();

                          ref.read(authViewModelProvider.notifier).signUpUser(
                                name: name,
                                email: email,
                                password: password,
                              );
                        },
                      ),
                      const SizedBox(height: 20),
                      GestureDetector(
                        onTap: () => Navigator.push(
                          context,
                          LoginPage.route(),
                        ),
                        child: Text.rich(
                          TextSpan(
                              text: "Already have an account? ",
                              style: Theme.of(context).textTheme.titleMedium,
                              children: [
                                TextSpan(
                                  text: "Sign In",
                                  style: Theme.of(context)
                                      .textTheme
                                      .titleMedium!
                                      .copyWith(
                                        color: Pallete.gradient2,
                                        fontWeight: FontWeight.bold,
                                      ),
                                ),
                              ]),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
    );
  }
}

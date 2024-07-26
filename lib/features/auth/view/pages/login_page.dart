import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_pallete.dart';
import '../../../../core/utils/app_snackbar.dart';
import '../../../../core/widgets/custom_field.dart';
import '../../../../core/widgets/loader.dart';
import '../../../home/view/pages/home_page.dart';
import '../../viewmodel/auth_viewmodel.dart';
import '../widgets/auth_gradient_button.dart';
import 'signup_page.dart';

class LoginPage extends ConsumerStatefulWidget {
  static route() => MaterialPageRoute(builder: (_) => const LoginPage());
  const LoginPage({super.key});

  @override
  ConsumerState<LoginPage> createState() => LoginPageState();
}

class LoginPageState extends ConsumerState<LoginPage> {
  final formKey = GlobalKey<FormState>();
  late String email;
  late String password;

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
            Navigator.pushAndRemoveUntil(
              context,
              HomePage.route(),
              (route) => false,
            );
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
      body: isLoading
          ? const Loader()
          : Padding(
              padding: const EdgeInsets.all(15),
              child: Form(
                key: formKey,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Sign in.",
                      style: TextStyle(
                        fontSize: 50,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 15),
                    CustomField(
                      hintText: "Email",
                      onSaved: (value) => email = value ?? "",
                    ),
                    const SizedBox(height: 15),
                    CustomField(
                      hintText: "Password",
                      obscureText: true,
                      onSaved: (value) => password = value ?? "",
                    ),
                    const SizedBox(height: 20),
                    AuthGradientButton(
                      text: "Sign in",
                      onTap: () async {
                        if (!formKey.currentState!.validate()) return;
                        formKey.currentState!.save();

                        ref.read(authViewModelProvider.notifier).loginUser(
                              email: email,
                              password: password,
                            );
                      },
                    ),
                    const SizedBox(height: 20),
                    GestureDetector(
                      onTap: () => Navigator.push(
                        context,
                        SignUpPage.route(),
                      ),
                      child: Text.rich(
                        TextSpan(
                            text: "Don't have an account? ",
                            style: Theme.of(context).textTheme.titleMedium,
                            children: [
                              TextSpan(
                                text: "Sign Up",
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
    );
  }
}

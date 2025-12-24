import 'package:audavis_time_management/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:audavis_time_management/presentation/widgets/email_text_field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class ForgotPasswordPage extends StatefulWidget {
  final VoidCallback onClose;

  const ForgotPasswordPage({
    required this.onClose,
    required this.onBackPress,
    required this.size,
    super.key,
  });

  final VoidCallback onBackPress;
  final Size size;

  @override
  State<ForgotPasswordPage> createState() => _ForgotPasswordPageState();
}

class _ForgotPasswordPageState extends State<ForgotPasswordPage> {
  final emailController = TextEditingController();
  @override
  void dispose() {
    super.dispose();
    emailController.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.max,
      children: [
        Row(
          children: [
            const Expanded(child: SizedBox(width: 10)),
            Expanded(
              flex: 2,
              child: Column(
                children: [
                  SizedBox(height: widget.size.height * 0.2),
                  GestureDetector(
                    onTap: widget.onBackPress,
                    child: Padding(
                      padding: const EdgeInsets.only(bottom: 42),
                      child: MouseRegion(
                        cursor: SystemMouseCursors.click,
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Padding(
                              padding: const EdgeInsets.only(right: 8),
                              child: Icon(Icons.arrow_back),
                            ),
                            Text('Zurück'),
                          ],
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: Text(
                      'Passwort vergessen',
                      style: Theme.of(
                        context,
                      ).textTheme.bodyMedium!.apply(fontWeightDelta: 2),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 32),
                    child: Text('Passwort zurücksetzen'),
                  ),
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: EmailTextField(emailController: emailController),
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: ElevatedButton(
                          onPressed: () async {
                            await context
                                .read<AuthCubit>()
                                .sendPasswordResetEmail(
                                  emailController.text,
                                  context,
                                );
                          },
                          child: Text('Passwort zurücksetzen'),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            const Expanded(child: SizedBox(width: 10)),
          ],
        ),
      ],
    );
  }
}

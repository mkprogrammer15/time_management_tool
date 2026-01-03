import 'dart:math';

import 'package:audavis_time_management/const.dart';
import 'package:audavis_time_management/presentation/blocs/auth_cubit/auth_cubit.dart';
import 'package:audavis_time_management/presentation/pages/forgot_password_page.dart';
import 'package:audavis_time_management/presentation/widgets/input_widgets/email_text_field.dart';
import 'package:audavis_time_management/presentation/widgets/input_widgets/password_text_field.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final emailCtrl = TextEditingController();
  final _passwordCtrl = TextEditingController();
  final _nameCtrl = TextEditingController();
  final _teamCtrl = TextEditingController();

  bool _isRegister = false;
  bool _loading = false;
  String? _error;
  String _selectedTeam = workingAreas.first;

  @override
  void dispose() {
    emailCtrl.dispose();
    _passwordCtrl.dispose();
    _nameCtrl.dispose();
    _teamCtrl.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    setState(() {
      _loading = true;
      _error = null;
    });

    final email = emailCtrl.text.trim();
    final password = _passwordCtrl.text.trim();
    final name = _nameCtrl.text.trim();

    if (email.isEmpty || password.isEmpty) {
      setState(() {
        _error = "Email and password are required";
        _loading = false;
      });
      return;
    }

    if (_isRegister && name.isEmpty) {
      setState(() {
        _error = "Name is required for registration";
        _loading = false;
      });
      return;
    }

    try {
      final auth = context.read<AuthCubit>();

      if (_isRegister) {
        await auth.register(
          email: email,
          password: password,
          name: name,
          team: _teamCtrl.text.trim(),
        );
      } else {
        await auth.login(email: email, password: password);
      }
    } catch (e) {
      setState(() => _error = e.toString());
    } finally {
      if (mounted) setState(() => _loading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.sizeOf(context);
    final logo = Padding(
      padding: const EdgeInsets.all(16),
      child: Image.asset(
        kDebugMode ? kDebugAudavisAssetPath : kAudavisAssetPath,
        isAntiAlias: true,
        fit: BoxFit.contain,
        width: min(size.width * 0.4, 300),
        height: min(size.height * 0.2, 50),
      ),
    );
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: Text(
          'Abwesenheiten',
          style: Theme.of(context).textTheme.bodyMedium!.copyWith(
            fontWeight: FontWeight.w300,
            fontSize: 30,
          ),
        ),
      ),
      body: Center(
        child: ConstrainedBox(
          constraints: const BoxConstraints(maxWidth: 420),
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 50),
                  child: Text(
                    _isRegister ? "Registrieren" : "Log in",
                    style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                logo,
                if (_isRegister) ...[
                  TextField(
                    controller: _nameCtrl,
                    decoration: const InputDecoration(
                      labelText: "Name",
                      border: OutlineInputBorder(),
                    ),
                  ),
                  const SizedBox(height: 12),
                  DropdownButtonFormField<String>(
                    initialValue: _selectedTeam,
                    decoration: const InputDecoration(
                      labelText: "Team",
                      border: OutlineInputBorder(),
                    ),
                    items: workingAreas
                        .map(
                          (area) => DropdownMenuItem<String>(
                            value: area,
                            child: Text(area),
                          ),
                        )
                        .toList(),
                    onChanged: (value) {
                      setState(() {
                        _selectedTeam = value!;
                        _teamCtrl.text = value;
                      });
                    },
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Please select a team';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 12),
                ],
                EmailTextField(emailController: emailCtrl),
                const SizedBox(height: 12),
                PasswordTextField(
                  passwordController: _passwordCtrl,
                  doLogin: (l) => _submit(),
                ),
                const SizedBox(height: 12),

                if (_error != null)
                  Text(_error!, style: const TextStyle(color: Colors.red)),

                const SizedBox(height: 16),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: _loading ? null : _submit,
                    child: Text(
                      _loading
                          ? "Bitte warten..."
                          : (_isRegister ? "Registrieren" : "Einloggen"),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
                TextButton(
                  onPressed: _loading
                      ? null
                      : () => setState(() => _isRegister = !_isRegister),
                  child: Text(
                    _isRegister
                        ? "Konto vorhanden? Einloggen"
                        : "Kein Account? Registrieren",
                  ),
                ),
                TextButton(
                  onPressed: () async {
                    await showDialog(
                      context: context,
                      builder: (ctx) => Dialog.fullscreen(
                        child: ForgotPasswordPage(
                          size: size,
                          onClose: () => context.pop(),
                          onBackPress: () => context.pop(),
                        ),
                      ),
                    );
                  },
                  child: const Text('Passwort vergessen?'),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

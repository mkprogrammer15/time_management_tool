import 'package:flutter/material.dart';

class PasswordTextField extends StatefulWidget {
  const PasswordTextField({
    super.key,
    required this.passwordController,
    required this.doLogin,
  });

  final TextEditingController passwordController;
  final Function(String p1)? doLogin;

  @override
  State<PasswordTextField> createState() => _PasswordTextFieldState();
}

class _PasswordTextFieldState extends State<PasswordTextField> {
  bool _obscureText = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      obscureText: _obscureText,
      controller: widget.passwordController,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      autofillHints: const [AutofillHints.password],
      decoration: InputDecoration(
        suffixIcon: IconButton(
          onPressed: () {
            setState(() {
              _obscureText = !_obscureText;
            });
          },
          icon: Icon(_obscureText ? Icons.visibility : Icons.visibility_off),
        ),
        label: Text('Passwort'),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        hintText: 'Gebe ein Passwort ein',
      ),
      validator: (value) {
        if (value == null || value.isEmpty) {
          return 'Bitte gebe ein Passwort ein';
        }
        return null;
      },
      onFieldSubmitted: widget.doLogin,
    );
  }
}

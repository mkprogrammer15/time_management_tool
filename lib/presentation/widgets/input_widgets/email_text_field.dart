import 'package:email_validator/email_validator.dart';
import 'package:flutter/material.dart';

class EmailTextField extends StatelessWidget {
  const EmailTextField({super.key, required this.emailController});

  final TextEditingController emailController;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      autovalidateMode: AutovalidateMode.onUserInteraction,
      controller: emailController,
      decoration: InputDecoration(
        label: Text('Email'),
        hintText: 'Gib Deine Emailadresse ein',
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
      ),

      validator: (value) {
        if (EmailValidator.validate(value!) == false) {
          return 'Keine valide Emailadresse';
        }
        if (value.isEmpty) {
          return 'E-Mail darf nicht leer sein';
        }
        return null;
      },
    );
  }
}

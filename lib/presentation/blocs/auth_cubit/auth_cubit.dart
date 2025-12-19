import 'dart:async';

import 'package:audavis_time_management/utils.dart';
import 'package:bloc/bloc.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';

part 'auth_state.dart';

class AuthCubit extends Cubit<AuthState> {
  AuthCubit({FirebaseAuth? auth, FirebaseFirestore? firestore})
    : _auth = auth ?? FirebaseAuth.instance,
      _db = firestore ?? FirebaseFirestore.instance,
      super(AuthUnknown()) {
    _sub = _auth.authStateChanges().listen(_onAuthChanged);
  }

  final FirebaseAuth _auth;
  final FirebaseFirestore _db;
  StreamSubscription<User?>? _sub;

  Future<void> _onAuthChanged(User? user) async {
    if (user == null) {
      emit(LoggedOut());
      return;
    }

    try {
      final doc = await _db.collection('users').doc(user.uid).get();
      final data = doc.data();

      final name = (data?['name'] as String?) ?? (user.displayName ?? '');

      emit(LoggedIn(uid: user.uid, name: name, email: user.email ?? ''));
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> register({
    required String email,
    required String password,
    required String name,
    required String team,
  }) async {
    try {
      final cred = await _auth.createUserWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );

      final uid = cred.user!.uid;

      await _db.collection('colleagues').doc(uid).set({
        'id': uid,
        'name': name.trim(),
        'team': team.trim(),
        'email': email.trim(),
        'takenVacations': 0,
        'totalVacations': 25,
        'role': 'employee',
        'createdAt': FieldValue.serverTimestamp(),
        'updatedAt': FieldValue.serverTimestamp(),
      });

      // authStateChanges will trigger LoggedIn automatically
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> login({required String email, required String password}) async {
    try {
      await _auth.signInWithEmailAndPassword(
        email: email.trim(),
        password: password.trim(),
      );
    } catch (e) {
      emit(AuthError(e.toString()));
    }
  }

  Future<void> logout() async {
    await _auth.signOut();
  }

  Future<void> sendPasswordResetEmail(
    String email,
    BuildContext context,
  ) async {
    try {
      await _auth.sendPasswordResetEmail(email: email);
      if (!context.mounted) return;
      Utils.showCommonDialog(
        context: context,
        title: 'Passwort zurückgesetzt',
        content:
            'Es wurde eine E-Mail zum Zurücksetzen des Passworts an $email gesendet.',
      );
    } on FirebaseAuthException catch (e) {
      Utils.showCommonDialog(
        context: context,
        title: 'Fehler',
        content: 'Passwort konnte nicht zurückgesetzt werden. ${e.message}',
      );
    }
  }

  @override
  Future<void> close() async {
    await _sub?.cancel();
    return super.close();
  }
}

class GoRouterRefreshStream extends ChangeNotifier {
  GoRouterRefreshStream(Stream<dynamic> stream) {
    _sub = stream.listen((_) => notifyListeners());
  }
  late final StreamSubscription<dynamic> _sub;

  @override
  void dispose() {
    _sub.cancel();
    super.dispose();
  }
}

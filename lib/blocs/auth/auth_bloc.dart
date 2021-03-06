import 'dart:async';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:firebase_auth/firebase_auth.dart' as auth;
import 'package:flash_card/repositories/repositories.dart';

part 'auth_event.dart';
part 'auth_state.dart';

class AuthBloc extends Bloc<AuthEvent, AuthState> {
  final AuthRepository _authRepository;
  late StreamSubscription<auth.User?> _userSubscription;

  AuthBloc({required AuthRepository authRepository})
      : _authRepository = authRepository,
        super(AuthState.initial()) {
    _userSubscription = _authRepository.userChanged.listen(
      (user) => add(AuthUserChanged(user: user)),
    );
  }

  @override
  Future<void> close() {
    _userSubscription.cancel();
    return super.close();
  }

  @override
  Stream<AuthState> mapEventToState(
    AuthEvent event,
  ) async* {
    if (event is AuthLogoutRequest) {
      await _authRepository.logout();
    } else if (event is AuthUserChanged) {
      yield* _mapAuthUserChangedTodState(event);
    }
  }

  Stream<AuthState> _mapAuthUserChangedTodState(AuthUserChanged event) async* {
    yield event.user != null
        ? AuthState.authenticated(user: event.user!)
        : AuthState.unauthenticated();
  }
}

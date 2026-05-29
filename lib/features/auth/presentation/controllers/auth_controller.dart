import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../core/theme/theme_provider.dart';

class AuthState {
  final bool isLoggedIn;
  final bool isLoading;
  final String? errorMessage;

  AuthState({
    this.isLoggedIn = false,
    this.isLoading = false,
    this.errorMessage,
  });

  AuthState copyWith({
    bool? isLoggedIn,
    bool? isLoading,
    String? errorMessage,
  }) {
    return AuthState(
      isLoggedIn: isLoggedIn ?? this.isLoggedIn,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: errorMessage, // Note: We allow setting errorMessage to null explicitly
    );
  }
}

class AuthNotifier extends StateNotifier<AuthState> {
  final Ref _ref;
  static const _authKey = 'is_logged_in';

  AuthNotifier(this._ref) : super(AuthState()) {
    _checkLoginStatus();
  }

  void _checkLoginStatus() {
    final prefs = _ref.read(sharedPreferencesProvider);
    final loggedIn = prefs.getBool(_authKey) ?? false;
    state = AuthState(isLoggedIn: loggedIn);
  }

  Future<bool> login(String email, String password) async {
    state = state.copyWith(isLoading: true, errorMessage: null);

    // Simulate API connection delay as per html transition specs
    await Future.delayed(const Duration(seconds: 2));

    // Email address formatting check
    final emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    if (!emailRegex.hasMatch(email.trim())) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Please enter a valid email address.',
      );
      return false;
    }

    // Password length validation
    if (password.length < 6) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: 'Password must be at least 6 characters long.',
      );
      return false;
    }

    // Save login session to SharedPreferences
    final prefs = _ref.read(sharedPreferencesProvider);
    await prefs.setBool(_authKey, true);
    state = AuthState(isLoggedIn: true);
    return true;
  }

  Future<void> logout() async {
    final prefs = _ref.read(sharedPreferencesProvider);
    await prefs.remove(_authKey);
    state = AuthState(isLoggedIn: false);
  }
}

final authControllerProvider = StateNotifierProvider<AuthNotifier, AuthState>((ref) {
  return AuthNotifier(ref);
});

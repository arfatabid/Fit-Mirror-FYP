class AuthService {
  Future<void> loginUser(String email, String password) async {
    // TODO: Implement actual login logic (e.g., Firebase or API call)
    await Future.delayed(const Duration(seconds: 2)); // Simulate network delay
    print("User logged in with email: $email");
  }
}

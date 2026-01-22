import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'home_screen.dart';
import '../providers/settings_provider.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool _isPasswordVisible = false;
  String? _emailError;
  String? _passwordError;

  bool _validateEmail(String email) {
    // Basic email validation
    final emailRegex = RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
    return emailRegex.hasMatch(email);
  }

  bool _validatePassword(String password) {
    // At least 8 characters, contains letters and numbers
    if (password.length < 8) return false;
    
    final hasLetters = RegExp(r'[a-zA-Z]').hasMatch(password);
    final hasNumbers = RegExp(r'[0-9]').hasMatch(password);
    
    return hasLetters && hasNumbers;
  }

  void _validateForm() {
    setState(() {
      _emailError = null;
      _passwordError = null;
      
      final email = _emailController.text.trim();
      final password = _passwordController.text.trim();
      
      if (email.isEmpty) {
        _emailError = 'Email is required';
      } else if (!_validateEmail(email)) {
        _emailError = 'Please enter a valid email address';
      }
      
      if (password.isEmpty) {
        _passwordError = 'Password is required';
      } else if (password.length < 8) {
        _passwordError = 'Password must be at least 8 characters';
      } else if (!_validatePassword(password)) {
        _passwordError = 'Password must contain letters and numbers';
      }
    });
  }

  void _login(BuildContext context) {
    final email = _emailController.text.trim();
    final password = _passwordController.text.trim();

    // Validate form
    _validateForm();
    
    // Check if there are any errors
    if (_emailError != null || _passwordError != null) {
      return;
    }

    // Сохраняем email в провайдере
    final settings = Provider.of<SettingsProvider>(context, listen: false);
    settings.saveLoginEmail(email);

    // Mock login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => const HomeScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.scaffoldBackgroundColor,
      body: Center(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              // Login Card/Block
              Container(
                constraints: const BoxConstraints(maxWidth: 400),
                padding: const EdgeInsets.all(32),
                decoration: BoxDecoration(
                  color: theme.colorScheme.surface,
                  borderRadius: BorderRadius.circular(20),
                  boxShadow: [
                    BoxShadow(
                      color: theme.colorScheme.shadow.withOpacity(0.1),
                      blurRadius: 20,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    // Логотип
                    Container(
                      width: 80,
                      height: 80,
                      decoration: BoxDecoration(
                        color: theme.colorScheme.primary,
                        borderRadius: BorderRadius.circular(16),
                      ),
                      child: Icon(
                        Icons.business,
                        size: 40,
                        color: theme.colorScheme.onPrimary,
                      ),
                    ),
                    const SizedBox(height: 24),
                    
                    // Заголовок
                    Text(
                      'Welcome Back',
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: theme.colorScheme.onSurface,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      'Sign in to continue',
                      style: TextStyle(
                        fontSize: 16,
                        color: theme.colorScheme.onSurface.withOpacity(0.6),
                      ),
                    ),
                    const SizedBox(height: 32),
                    
                    // Поле email с валидацией
                    TextField(
                      controller: _emailController,
                      keyboardType: TextInputType.emailAddress,
                      decoration: InputDecoration(
                        labelText: 'Email',
                        prefixIcon: const Icon(Icons.email_outlined),
                        hintText: 'your.email@company.com',
                        errorText: _emailError,
                        errorStyle: const TextStyle(fontSize: 12),
                      ),
                      onChanged: (value) {
                        if (_emailError != null) {
                          _validateForm();
                        }
                      },
                    ),
                    const SizedBox(height: 20),
                    
                    // Поле password с валидацией
                    TextField(
                      controller: _passwordController,
                      obscureText: !_isPasswordVisible,
                      decoration: InputDecoration(
                        labelText: 'Password',
                        prefixIcon: const Icon(Icons.lock_outline),
                        suffixIcon: IconButton(
                          icon: Icon(
                            _isPasswordVisible 
                              ? Icons.visibility 
                              : Icons.visibility_off,
                          ),
                          onPressed: () {
                            setState(() {
                              _isPasswordVisible = !_isPasswordVisible;
                            });
                          },
                        ),
                        errorText: _passwordError,
                        errorStyle: const TextStyle(fontSize: 12),
                        helperText: 'At least 8 characters with letters and numbers',
                        helperStyle: TextStyle(
                          fontSize: 11,
                          color: theme.colorScheme.onSurface.withOpacity(0.5),
                        ),
                      ),
                      onChanged: (value) {
                        if (_passwordError != null) {
                          _validateForm();
                        }
                      },
                    ),
                    const SizedBox(height: 30),
                    
                    // Кнопка Login
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () => _login(context),
                        child: const Text('LOGIN'),
                      ),
                    ),
                    const SizedBox(height: 20),
                    
                    // Ссылка на регистрацию
                    TextButton(
                      onPressed: () {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Register screen will be in next release'),
                          ),
                        );
                      },
                      child: const Text('No account? Register'),
                    ),
                    
                    // Password requirements
                    const SizedBox(height: 16),
                    Card(
                      elevation: 0,
                      color: theme.colorScheme.surfaceVariant.withOpacity(0.3),
                      child: Padding(
                        padding: const EdgeInsets.all(12),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Password Requirements:',
                              style: TextStyle(
                                fontSize: 12,
                                fontWeight: FontWeight.w600,
                                color: theme.colorScheme.onSurface.withOpacity(0.7),
                              ),
                            ),
                            const SizedBox(height: 4),
                            Text(
                              '• At least 8 characters\n• Must contain letters and numbers',
                              style: TextStyle(
                                fontSize: 11,
                                color: theme.colorScheme.onSurface.withOpacity(0.5),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
              
              // Footer
              const SizedBox(height: 40),
              Text(
                'Corporate App v1.0',
                style: TextStyle(
                  fontSize: 14,
                  color: theme.colorScheme.onSurface.withOpacity(0.6),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
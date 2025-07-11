import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);
  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final _nameCtrl     = TextEditingController();
  final _emailCtrl    = TextEditingController();
  final _mobileCtrl   = TextEditingController();
  final _passwordCtrl = TextEditingController();

  bool _isLoading        = false;
  bool _isPasswordVisible = false;

  // Example of reading from SharedPreferences
  String _storedUsername = "";
  @override
  void initState() {
    super.initState();
    _readUsername();
  }

  Future<void> _readUsername() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      _storedUsername = prefs.getString('username') ?? '';
    });
  }

  Future<void> _register() async {
    setState(() => _isLoading = true);

    final fullName = _nameCtrl.text.trim();
    final email    = _emailCtrl.text.trim();
    final mobile   = _mobileCtrl.text.trim();
    final password = _passwordCtrl.text;

    if (fullName.isEmpty || email.isEmpty || mobile.isEmpty || password.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill all fields')),
      );
      setState(() => _isLoading = false);
      return;
    }

    try {
      // NOTE: if you're on Android emulator, use 10.0.2.2
      final uri = Uri.parse('http://10.41.235.199/barberApp/register.php');

      final response = await http.post(uri, body: {
        'full_name': fullName,
        'email':     email,
        'mobile':    mobile,
        'password':  password,
      });

      print('Status: ${response.statusCode}');
      print('Body: ${response.body}');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        if (data['status'] == 'success') {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Registration successful!')),
          );
          Navigator.pushNamed(context, '/login');
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(data['message'] ?? 'Unknown error')),
          );
        }
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Server error, try again later')),
        );
      }
    } catch (e) {
      print('Error: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Network error, please try again')),
      );
    } finally {
      setState(() => _isLoading = false);
    }
  }

  @override
  void dispose() {
    _nameCtrl.dispose();
    _emailCtrl.dispose();
    _mobileCtrl.dispose();
    _passwordCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF000000), Color(0xFF004D40)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 36),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 40),
                // Replace BarberFiq text with the logo image
                Center(
                  child: Image.asset(
                    'assets/logo.png',  // Path to your logo image
                    height: 80,  // Adjust the size of the logo as needed
                  ),
                ),
                const SizedBox(height: 16),
                Center(
                  child: Text('Registration',
                      style: theme.textTheme.titleLarge
                          ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                ),
                const SizedBox(height: 32),

                Text(' $_storedUsername',
                    style: theme.textTheme.bodyMedium
                        ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600)),
                const SizedBox(height: 16),

                // Full Name
                _buildLabel('Full Name', theme),
                TextField(
                  controller: _nameCtrl,
                  style: const TextStyle(color: Colors.white),  // Text color set to white
                  decoration: _buildInputDecoration(''),
                ),
                const SizedBox(height: 16),

                // Email
                _buildLabel('Email', theme),
                TextField(
                  controller: _emailCtrl,
                  keyboardType: TextInputType.emailAddress,
                  style: const TextStyle(color: Colors.white),  // Text color set to white
                  decoration: _buildInputDecoration(''),
                ),
                const SizedBox(height: 16),

                // Mobile
                _buildLabel('Mobile No', theme),
                TextField(
                  controller: _mobileCtrl,
                  keyboardType: TextInputType.phone,
                  style: const TextStyle(color: Colors.white),  // Text color set to white
                  decoration: _buildInputDecoration(''),
                ),
                const SizedBox(height: 16),

                // Password
                _buildLabel('Password', theme),
                TextField(
                  controller: _passwordCtrl,
                  obscureText: !_isPasswordVisible,
                  style: const TextStyle(color: Colors.white),  // Text color set to white
                  decoration: _buildInputDecoration(
                    '',
                    suffix: IconButton(
                      icon: Icon(_isPasswordVisible
                          ? Icons.visibility
                          : Icons.visibility_off),
                      onPressed: () => setState(() => _isPasswordVisible = !_isPasswordVisible),
                    ),
                  ),
                ),
                const SizedBox(height: 20),

                ElevatedButton(
                  onPressed: _isLoading ? null : _register,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF004D40),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                    textStyle:
                    const TextStyle(fontSize: 16, fontWeight: FontWeight.w600),
                  ),
                  child: _isLoading
                      ? const SizedBox(
                    width: 20,
                    height: 20,
                    child:
                    CircularProgressIndicator(strokeWidth: 2),
                  )
                      : const Text('Register'),
                ),

                const Spacer(),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Already have an account? ',
                        style: theme.textTheme.bodyMedium
                            ?.copyWith(color: Colors.white)),
                    TextButton(
                      onPressed: () => Navigator.pushNamed(context, '/login'),
                      child: const Text('Sign In',
                          style: TextStyle(
                              fontWeight: FontWeight.bold,
                              color: Colors.white)),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildLabel(String text, ThemeData theme) {
    return Text(text,
        style: theme.textTheme.bodyMedium
            ?.copyWith(color: Colors.white, fontWeight: FontWeight.w600));
  }

  InputDecoration _buildInputDecoration(String hint,
      {Widget? suffix}) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.black,  // Set background color to black
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.white),  // Hint text color set to white
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(8),
        borderSide: BorderSide.none,
      ),
      contentPadding:
      const EdgeInsets.symmetric(vertical: 16, horizontal: 20),
      suffixIcon: suffix,
    );
  }
}

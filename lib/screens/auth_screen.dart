import 'package:flutter/material.dart';
import 'package:weather_app/screens/email_auth_screen.dart';
import 'package:weather_app/services/auth_service.dart';

class AuthScreen extends StatefulWidget {
  const AuthScreen({Key? key}) : super(key: key);
  @override
  _AuthScreenState createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen>
    with SingleTickerProviderStateMixin {
  final AuthService _authService = AuthService();
  late AnimationController _controller;
  late Animation<double> _opacityAnimation;
  late Animation<double> _translateAnimation;

  @override
  void initState() {
    super.initState();

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1000),
    );

    _opacityAnimation = Tween(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeIn),
      ),
    );

    _translateAnimation = Tween(begin: 30.0, end: 0.0).animate(
      CurvedAnimation(parent: _controller, curve: Curves.fastOutSlowIn),
    );

    _controller.forward();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  Future<void> _signInWithGoogle() async {
    try {
      final user = await _authService.signInWithGoogle();
      if (user != null) {
        Navigator.pushReplacementNamed(context, '/weather');
      }
    } catch (e) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Google sign in failed: $e')));
    }
  }

  void _navigateToEmailAuth(BuildContext context, {required bool isLogin}) {
    Navigator.push(
      context,
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) =>
            EmailAuthScreen(isLogin: isLogin),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  Widget _buildAuthButton({
    required IconData icon,
    required String text,
    required VoidCallback onPressed,
    Color? backgroundColor,
    Color? textColor,
    BorderSide? border,
  }) {
    return ElevatedButton(
      onPressed: onPressed,
      style: ElevatedButton.styleFrom(
        foregroundColor: textColor ?? Colors.white,
        backgroundColor: backgroundColor ?? Colors.white.withOpacity(0.2),
        padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 24),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
          side: border ?? BorderSide(color: Colors.white.withOpacity(0.5)),
        ),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: textColor ?? Colors.white),
          const SizedBox(width: 10),
          Text(
            text,
            style: TextStyle(fontSize: 16, color: textColor ?? Colors.white),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Colors.blue.shade800, Colors.blue.shade300],
          ),
        ),
        child: Center(
          child: AnimatedBuilder(
            animation: _controller,
            builder: (context, child) {
              return Opacity(
                opacity: _opacityAnimation.value,
                child: Transform.translate(
                  offset: Offset(0, _translateAnimation.value),
                  child: child,
                ),
              );
            },
            child: Padding(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Hero(tag: 'app-logo', child: FlutterLogo(size: 100)),
                  const SizedBox(height: 40),
                  _buildAuthButton(
                    icon: Icons.login,
                    text: 'Sign in with Email',
                    onPressed: () =>
                        _navigateToEmailAuth(context, isLogin: true),
                  ),
                  const SizedBox(height: 16),
                  _buildAuthButton(
                    icon: Icons.person_add,
                    text: 'Create New Account',
                    onPressed: () =>
                        _navigateToEmailAuth(context, isLogin: false),
                  ),
                  const SizedBox(height: 20),
                  const Text('OR', style: TextStyle(color: Colors.white70)),
                  const SizedBox(height: 20),
                  _buildAuthButton(
                    icon: Icons.g_mobiledata,
                    text: 'Continue with Google',
                    onPressed: _signInWithGoogle,
                    backgroundColor: Colors.white,
                    textColor: Colors.black,
                    border: BorderSide(color: Colors.grey.shade400),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

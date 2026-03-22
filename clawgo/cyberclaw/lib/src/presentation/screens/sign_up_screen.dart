import 'package:cyberclaw/src/core/auth_service.dart';
import 'package:cyberclaw/src/core/theme.dart';
import 'package:cyberclaw/src/presentation/widgets/scanline_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignUpScreen extends StatefulWidget {
  const SignUpScreen({super.key});

  @override
  State<SignUpScreen> createState() => _SignUpScreenState();
}

class _SignUpScreenState extends State<SignUpScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  final _codenameController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;
  bool _agreeToTerms = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    _codenameController.dispose();
    super.dispose();
  }

  Future<void> _handleSignUp() async {
    if (_emailController.text.isEmpty ||
        _passwordController.text.isEmpty ||
        _codenameController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    if (_passwordController.text != _confirmPasswordController.text) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Passwords do not match')),
      );
      return;
    }

    if (!_agreeToTerms) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please agree to the override terms')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      final credential = await _authService.signUp(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (credential?.user != null) {
        await credential!.user!.updateDisplayName(_codenameController.text);
      }
      if (mounted) context.go('/chat');
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Registration failed')),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ScanlineBackground(
        child: Stack(
          children: [
            // Top Accent Bar
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              child: Container(
                height: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primary,
                      Theme.of(context).colorScheme.secondaryContainer,
                      Theme.of(context).colorScheme.primary,
                    ],
                  ),
                  boxShadow: [
                    BoxShadow(
                      color:
                          Theme.of(context).colorScheme.primary.withOpacity(0.5),
                      blurRadius: 4,
                    ),
                  ],
                ),
              ),
            ),
            // Bottom Status
            Positioned(
              bottom: 24,
              left: 24,
              child: Row(
                children: [
                  Container(
                    width: 8,
                    height: 8,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Theme.of(context).colorScheme.primary,
                      boxShadow: [
                        BoxShadow(
                          color: Theme.of(context).colorScheme.primary,
                          blurRadius: 8,
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'ENROLLMENT_UPLINK_STABLE',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontSize: 9,
                          letterSpacing: 2,
                          color: Theme.of(context)
                              .colorScheme
                              .primary
                              .withOpacity(0.6),
                        ),
                  ),
                ],
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Header Cluster
                      Container(
                        padding: const EdgeInsets.symmetric(vertical: 8),
                        decoration: BoxDecoration(
                          border: Border(
                            left: BorderSide(
                              color: Theme.of(context).colorScheme.primary,
                              width: 4,
                            ),
                          ),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(left: 24),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                'UNAUTHORIZED ACCESS PROHIBITED',
                                style: Theme.of(context)
                                    .textTheme
                                    .labelSmall
                                    ?.copyWith(
                                      color:
                                          Theme.of(context).colorScheme.primary,
                                      fontWeight: FontWeight.bold,
                                      letterSpacing: 3,
                                      fontSize: 10,
                                    ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                'NEW_RECRUIT',
                                style: Theme.of(context)
                                    .textTheme
                                    .headlineMedium
                                    ?.copyWith(
                                      fontWeight: FontWeight.w900,
                                      letterSpacing: -1,
                                    ),
                              ),
                              const SizedBox(height: 16),
                              Row(
                                children: [
                                  Container(
                                    height: 4,
                                    width: 48,
                                    color: Theme.of(context)
                                        .colorScheme
                                        .secondaryContainer,
                                  ),
                                  const SizedBox(width: 12),
                                  Text(
                                    'ESTABLISHING SECURE UPLINK...',
                                    style: Theme.of(context)
                                        .textTheme
                                        .labelSmall
                                        ?.copyWith(
                                          fontSize: 10,
                                          letterSpacing: 1,
                                          color: Theme.of(context)
                                              .colorScheme
                                              .outline,
                                        ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 48),
                      // Enrollment Form
                      _SignUpForm(
                        emailController: _emailController,
                        passwordController: _passwordController,
                        confirmPasswordController: _confirmPasswordController,
                        codenameController: _codenameController,
                        agreeToTerms: _agreeToTerms,
                        onTermsChanged: (value) {
                          setState(() => _agreeToTerms = value ?? false);
                        },
                        isLoading: _isLoading,
                        onSignUp: _handleSignUp,
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SignUpForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final TextEditingController confirmPasswordController;
  final TextEditingController codenameController;
  final bool agreeToTerms;
  final ValueChanged<bool?> onTermsChanged;
  final bool isLoading;
  final VoidCallback onSignUp;

  const _SignUpForm({
    required this.emailController,
    required this.passwordController,
    required this.confirmPasswordController,
    required this.codenameController,
    required this.agreeToTerms,
    required this.onTermsChanged,
    required this.isLoading,
    required this.onSignUp,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        _FormField(
          label: 'CODENAME',
          hintText: 'ENTER_IDENTIFIER',
          icon: Icons.person,
          controller: codenameController,
        ),
        const SizedBox(height: 24),
        _FormField(
          label: 'SECURE_EMAIL',
          hintText: 'USER@IRONCLAW.SYS',
          icon: Icons.alternate_email,
          keyboardType: TextInputType.emailAddress,
          controller: emailController,
        ),
        const SizedBox(height: 24),
        Row(
          children: [
            Expanded(
              child: _FormField(
                label: 'AUTHORIZATION_PASSCODE',
                hintText: '********',
                icon: Icons.lock,
                obscureText: true,
                controller: passwordController,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: _FormField(
                label: 'REPEAT_PASSCODE',
                hintText: '********',
                icon: Icons.security,
                obscureText: true,
                controller: confirmPasswordController,
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        // Terms
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              width: 24,
              height: 24,
              child: Checkbox(
                value: agreeToTerms,
                onChanged: onTermsChanged,
                side: BorderSide(
                    color: Theme.of(context).colorScheme.outlineVariant),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    'AGREE_TO_OVERRIDE_TERMS',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontSize: 10,
                          letterSpacing: 1,
                          color: Theme.of(context).colorScheme.outline,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    'I acknowledge total system control protocols and sensory data logging.',
                    style: Theme.of(context).textTheme.labelSmall?.copyWith(
                          fontSize: 9,
                          fontStyle: FontStyle.italic,
                          color: Theme.of(context).colorScheme.outlineVariant,
                        ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 48),
        // Action Section
        ClipPath(
          clipper: BeveledEdgeClipper(cutSize: 15),
          child: SizedBox(
            height: 60,
            child: ElevatedButton(
              onPressed: isLoading ? null : onSignUp,
              child: isLoading
                  ? const SizedBox(
                      width: 24,
                      height: 24,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: AppTheme.onPrimaryContainer,
                      ),
                    )
                  : const Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'REGISTER_UNIT',
                          style: TextStyle(
                              letterSpacing: -0.5,
                              fontWeight: FontWeight.w900,
                              fontSize: 18),
                        ),
                        Icon(Icons.arrow_forward),
                      ],
                    ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        TextButton(
          onPressed: () => context.go('/sign-in'),
          child: RichText(
            text: TextSpan(
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    fontSize: 10,
                    letterSpacing: 2,
                    color: Theme.of(context).colorScheme.outlineVariant,
                  ),
              children: [
                const TextSpan(text: 'ALREADY_AUTHORIZED? '),
                TextSpan(
                  text: 'LOG_IN_INTERFACE',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.secondary,
                    decoration: TextDecoration.underline,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
    );
  }
}

class _FormField extends StatelessWidget {
  final String label;
  final String hintText;
  final IconData icon;
  final bool obscureText;
  final TextInputType? keyboardType;
  final TextEditingController? controller;

  const _FormField({
    required this.label,
    required this.hintText,
    required this.icon,
    this.obscureText = false,
    this.keyboardType,
    this.controller,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
                fontSize: 10,
                fontWeight: FontWeight.bold,
                letterSpacing: 2,
                color: Theme.of(context).colorScheme.outline,
              ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          obscureText: obscureText,
          keyboardType: keyboardType,
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                letterSpacing: 1.5,
              ),
          decoration: InputDecoration(
            hintText: hintText,
            prefixIcon: Icon(icon, size: 18),
            contentPadding: const EdgeInsets.symmetric(vertical: 16),
          ),
        ),
      ],
    );
  }
}

import 'package:cyberclaw/src/core/auth_service.dart';
import 'package:cyberclaw/src/core/theme.dart';
import 'package:cyberclaw/src/presentation/widgets/scanline_background.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class SignInScreen extends StatefulWidget {
  const SignInScreen({super.key});

  @override
  State<SignInScreen> createState() => _SignInScreenState();
}

class _SignInScreenState extends State<SignInScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  final _authService = AuthService();
  bool _isLoading = false;

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _handleSignIn() async {
    if (_emailController.text.isEmpty || _passwordController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Please fill in all fields')),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await _authService.signIn(
        _emailController.text.trim(),
        _passwordController.text.trim(),
      );
      if (mounted) context.go('/chat');
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(e.message ?? 'Authentication failed')),
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
            // Ambient HUD Elements
            Positioned(
              top: 40,
              left: 40,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  border: Border(
                    left: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .outlineVariant
                            .withOpacity(0.3)),
                    top: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .outlineVariant
                            .withOpacity(0.3)),
                  ),
                ),
              ),
            ),
            Positioned(
              bottom: 40,
              right: 40,
              child: Container(
                width: 120,
                height: 120,
                decoration: BoxDecoration(
                  border: Border(
                    right: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .outlineVariant
                            .withOpacity(0.3)),
                    bottom: BorderSide(
                        color: Theme.of(context)
                            .colorScheme
                            .outlineVariant
                            .withOpacity(0.3)),
                  ),
                ),
              ),
            ),
            // Side Bars
            Positioned(
              top: 0,
              bottom: 0,
              left: 0,
              child: Container(
                width: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Positioned(
              top: 0,
              bottom: 0,
              right: 0,
              child: Container(
                width: 1,
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    begin: Alignment.topCenter,
                    end: Alignment.bottomCenter,
                    colors: [
                      Colors.transparent,
                      Theme.of(context)
                          .colorScheme
                          .secondaryContainer
                          .withOpacity(0.2),
                      Colors.transparent,
                    ],
                  ),
                ),
              ),
            ),
            Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      // Logo/Header Area
                      const _HeaderArea(),
                      const SizedBox(height: 48),
                      // Login Terminal Card
                      ClipPath(
                        clipper: BeveledEdgeClipper(cutSize: 20),
                        child: Container(
                          color:
                              Theme.of(context).colorScheme.surfaceContainerLow,
                          padding: const EdgeInsets.all(32),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              // Tactical Corner Accent
                              Align(
                                alignment: Alignment.topRight,
                                child: Container(
                                  width: 64,
                                  height: 4,
                                  color: Theme.of(context)
                                      .colorScheme
                                      .primaryContainer,
                                ),
                              ),
                              const SizedBox(height: 24),
                              _SignInForm(
                                emailController: _emailController,
                                passwordController: _passwordController,
                                isLoading: _isLoading,
                                onSignIn: _handleSignIn,
                              ),
                              const SizedBox(height: 40),
                              const _FooterLinks(),
                            ],
                          ),
                        ),
                      ),
                      const SizedBox(height: 32),
                      const _TerminalReadoutMeta(),
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

class _HeaderArea extends StatelessWidget {
  const _HeaderArea();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: 96,
              height: 96,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                boxShadow: [
                  BoxShadow(
                    color:
                        Theme.of(context).colorScheme.primary.withOpacity(0.2),
                    blurRadius: 20,
                    spreadRadius: 5,
                  ),
                ],
              ),
            ),
            Container(
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                border: Border.all(
                  color: Theme.of(context).colorScheme.primary.withOpacity(0.2),
                ),
                color: Theme.of(context).colorScheme.background.withOpacity(0.5),
              ),
              child: Image.asset(
                'assets/images/logo.png',
                width: 96,
                height: 96,
                fit: BoxFit.contain,
              ),
            ),
          ],
        ),
        const SizedBox(height: 24),
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color:
                Theme.of(context).colorScheme.primaryContainer.withOpacity(0.1),
            border: Border(
              left: BorderSide(
                color: Theme.of(context).colorScheme.primaryContainer,
                width: 4,
              ),
            ),
          ),
          child: Text(
            'IRONCLAW COMMAND UNIT',
            style: Theme.of(context).textTheme.labelLarge?.copyWith(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  fontSize: 12,
                ),
          ),
        ),
        const SizedBox(height: 16),
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: Theme.of(context).textTheme.displayLarge?.copyWith(
                  fontSize: 48,
                  height: 0.9,
                ),
            children: [
              const TextSpan(text: 'ACCESS_\n'),
              TextSpan(
                text: 'GRANTED?',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.primaryContainer,
                  shadows: [
                    Shadow(
                      color: Theme.of(context)
                          .colorScheme
                          .primaryContainer
                          .withOpacity(0.3),
                      blurRadius: 10,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _SignInForm extends StatelessWidget {
  final TextEditingController emailController;
  final TextEditingController passwordController;
  final bool isLoading;
  final VoidCallback onSignIn;

  const _SignInForm({
    required this.emailController,
    required this.passwordController,
    required this.isLoading,
    required this.onSignIn,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.stretch,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'OPERATOR_IDENTITY',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                    letterSpacing: 2,
                  ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: emailController,
              keyboardType: TextInputType.emailAddress,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    letterSpacing: 2,
                  ),
              decoration: const InputDecoration(
                hintText: 'USER@IRONCLAW.SYS',
                suffixIcon: Icon(Icons.fingerprint, size: 20),
              ),
            ),
          ],
        ),
        const SizedBox(height: 32),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'ENCRYPTION_SEQUENCE',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.outline,
                    letterSpacing: 2,
                  ),
            ),
            const SizedBox(height: 8),
            TextField(
              controller: passwordController,
              obscureText: true,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                    letterSpacing: 8,
                  ),
              decoration: const InputDecoration(
                hintText: 'ENCRYPTION_KEY',
                suffixIcon: Icon(Icons.security, size: 20),
              ),
            ),
          ],
        ),
        const SizedBox(height: 48),
        SizedBox(
          height: 60,
          child: ElevatedButton(
            onPressed: isLoading ? null : onSignIn,
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
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'INITIATE_SESSION',
                        style: TextStyle(
                            letterSpacing: 2, fontWeight: FontWeight.bold),
                      ),
                      SizedBox(width: 12),
                      Icon(Icons.bolt, size: 20),
                    ],
                  ),
          ),
        ),
      ],
    );
  }
}

class _FooterLinks extends StatelessWidget {
  const _FooterLinks();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.only(top: 24),
      decoration: BoxDecoration(
        border: Border(
          top: BorderSide(
            color: Theme.of(context).colorScheme.outlineVariant.withOpacity(0.1),
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          TextButton(
            onPressed: () => context.push('/forgot-password'),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'PROTOCOL_RECOVERY',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.outlineVariant,
                    letterSpacing: 1.5,
                  ),
            ),
          ),
          TextButton(
            onPressed: () => context.push('/sign-up'),
            style: TextButton.styleFrom(
              padding: EdgeInsets.zero,
              minimumSize: Size.zero,
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
            child: Text(
              'NEW_OPERATOR?',
              style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.secondaryContainer
                        .withOpacity(0.6),
                    letterSpacing: 1.5,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

class _TerminalReadoutMeta extends StatelessWidget {
  const _TerminalReadoutMeta();

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.4,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            'NODE: OBSIDIAN_MAIN_01\nUPTIME: 492.12.04\nLAT: 35.6895° N',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  fontSize: 9,
                  height: 1.5,
                ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Row(
                children: [
                  Container(
                      width: 4, height: 4, color: AppTheme.primaryContainer),
                  const SizedBox(width: 2),
                  Container(
                      width: 4, height: 4, color: AppTheme.primaryContainer),
                  const SizedBox(width: 2),
                  Container(width: 4, height: 4, color: AppTheme.outlineVariant),
                  const SizedBox(width: 2),
                  Container(width: 4, height: 4, color: AppTheme.outlineVariant),
                ],
              ),
              const SizedBox(height: 4),
              Text(
                'OS_VER: OPENCLAW_CORE_v.4.1',
                style: Theme.of(context).textTheme.labelSmall?.copyWith(
                      fontSize: 9,
                      letterSpacing: -0.5,
                    ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

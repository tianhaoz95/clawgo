import 'package:cyberclaw/src/core/theme.dart';
import 'package:cyberclaw/src/presentation/widgets/scanline_background.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ForgotPasswordScreen extends StatelessWidget {
  const ForgotPasswordScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(64),
        child: ClipPath(
          clipper: AppBarClipper(),
          child: AppBar(
            backgroundColor: Theme.of(context).colorScheme.surface,
            elevation: 0,
            leading: IconButton(
              icon: Icon(
                Icons.arrow_back,
                color: Theme.of(context).colorScheme.primaryContainer,
              ),
              onPressed: () => context.pop(),
            ),
            title: Text(
              'IRONCLAW',
              style: Theme.of(context).textTheme.displaySmall?.copyWith(
                color: Theme.of(context).colorScheme.primaryContainer,
                fontSize: 24,
                letterSpacing: -1,
              ),
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 24),
                child: Row(
                  children: [
                    _NavLabel(label: 'TERMINAL'),
                    const SizedBox(width: 24),
                    _NavLabel(label: 'SECURITY'),
                    const SizedBox(width: 24),
                    _NavLabel(label: 'SETTINGS'),
                  ],
                ),
              ),
            ],
            shape: Border(
              bottom: BorderSide(
                color: Theme.of(context).colorScheme.surfaceBright,
                width: 2,
              ),
            ),
          ),
        ),
      ),
      body: ScanlineBackground(
        child: Stack(
          children: [
            // Peripheral Data
            Positioned(
              top: 100,
              left: 40,
              child: Opacity(
                opacity: 0.1,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    _DataLine(text: '// ENCRYPTION_MODE: AES_256'),
                    _DataLine(text: '// HANDSHAKE: IN_PROGRESS'),
                    _DataLine(text: '// ENTITY: IRONCLAW'),
                  ],
                ),
              ),
            ),
            Center(
              child: Padding(
                padding: const EdgeInsets.all(24.0),
                child: Container(
                  constraints: const BoxConstraints(maxWidth: 400),
                  decoration: BoxDecoration(
                    border: Border.all(color: Colors.white.withOpacity(0.05)),
                  ),
                  child: ClipPath(
                    clipper: BeveledEdgeClipper(cutSize: 20),
                    child: Container(
                      color: Theme.of(context).colorScheme.surface,
                      padding: const EdgeInsets.all(32),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          // Status Header
                          Row(
                            children: [
                              Container(
                                height: 2,
                                width: 32,
                                color: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,
                              ),
                              const SizedBox(width: 8),
                              Text(
                                'SECURE_RECOVERY_INTERFACE',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.primary,
                                      fontSize: 10,
                                      letterSpacing: 2,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'RECOVER_PROTOCOL',
                            style: Theme.of(context).textTheme.headlineSmall
                                ?.copyWith(
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: -0.5,
                                ),
                          ),
                          const SizedBox(height: 16),
                          Container(
                            padding: const EdgeInsets.only(left: 16),
                            decoration: BoxDecoration(
                              border: Border(
                                left: BorderSide(
                                  color: Theme.of(
                                    context,
                                  ).colorScheme.outlineVariant.withOpacity(0.4),
                                ),
                              ),
                            ),
                            child: Text(
                              'ENTER_SECURE_EMAIL_FOR_RESET_LINK',
                              style: Theme.of(context).textTheme.bodySmall
                                  ?.copyWith(
                                    color: Theme.of(
                                      context,
                                    ).colorScheme.onSurfaceVariant,
                                    letterSpacing: 0.5,
                                  ),
                            ),
                          ),
                          const SizedBox(height: 40),
                          // Input
                          Text(
                            'RECOVERY_EMAIL',
                            style: Theme.of(context).textTheme.labelSmall
                                ?.copyWith(
                                  color: Theme.of(context).colorScheme.outline,
                                  fontSize: 10,
                                  letterSpacing: 1.5,
                                ),
                          ),
                          const SizedBox(height: 8),
                          TextField(
                            decoration: const InputDecoration(
                              hintText: 'IDENT_ID@NODE.OPS',
                              prefixIcon: Icon(Icons.alternate_email, size: 18),
                            ),
                            style: const TextStyle(letterSpacing: 2),
                          ),
                          const SizedBox(height: 40),
                          // Actions
                          SizedBox(
                            width: double.infinity,
                            height: 56,
                            child: ElevatedButton(
                              onPressed: () {},
                              child: const Text(
                                'SEND_RECOVERY_SIGNAL',
                                style: TextStyle(
                                  letterSpacing: 2,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 24),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              TextButton.icon(
                                onPressed: () => context.pop(),
                                icon: const Icon(Icons.arrow_left, size: 18),
                                label: const Text('RETURN_TO_AUTH'),
                                style: TextButton.styleFrom(
                                  textStyle: const TextStyle(
                                    fontSize: 10,
                                    letterSpacing: 1.5,
                                  ),
                                ),
                              ),
                              Text(
                                'EST_RTT: 124MS',
                                style: Theme.of(context).textTheme.labelSmall
                                    ?.copyWith(
                                      color: Theme.of(
                                        context,
                                      ).colorScheme.outlineVariant,
                                      fontSize: 10,
                                      letterSpacing: 1,
                                    ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 40),
                          // Pulse Meter
                          const _PulseMeter(),
                        ],
                      ),
                    ),
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

class _NavLabel extends StatelessWidget {
  final String label;
  const _NavLabel({required this.label});

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: Theme.of(context).textTheme.labelSmall?.copyWith(
        color: Theme.of(context).colorScheme.surfaceBright,
        letterSpacing: 1,
        fontWeight: FontWeight.bold,
      ),
    );
  }
}

class _DataLine extends StatelessWidget {
  final String text;
  const _DataLine({required this.text});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8.0),
      child: Text(
        text,
        style: const TextStyle(
          fontFamily: 'monospace',
          fontSize: 10,
          color: AppTheme.primary,
        ),
      ),
    );
  }
}

class _PulseMeter extends StatelessWidget {
  const _PulseMeter();

  @override
  Widget build(BuildContext context) {
    return Opacity(
      opacity: 0.5,
      child: Column(
        children: [
          Container(
            height: 4,
            width: double.infinity,
            color: Theme.of(context).colorScheme.surfaceContainerHighest,
            child: FractionallySizedBox(
              alignment: Alignment.centerLeft,
              widthFactor: 0.65,
              child: Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      Theme.of(context).colorScheme.primaryContainer,
                      Theme.of(context).colorScheme.secondaryContainer,
                    ],
                  ),
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _PulseLabel(text: 'SYS_IDLE'),
              _PulseLabel(text: 'LINKING_SATELLITE_UPLINK'),
              _PulseLabel(text: '65%'),
            ],
          ),
        ],
      ),
    );
  }
}

class _PulseLabel extends StatelessWidget {
  final String text;
  const _PulseLabel({required this.text});

  @override
  Widget build(BuildContext context) {
    return Text(text, style: const TextStyle(fontSize: 8, letterSpacing: -0.5));
  }
}

class AppBarClipper extends CustomClipper<Path> {
  @override
  Path getClip(Size size) {
    return Path()
      ..moveTo(0, 0)
      ..lineTo(size.width, 0)
      ..lineTo(size.width, size.height * 0.9)
      ..lineTo(size.width * 0.98, size.height)
      ..lineTo(0, size.height)
      ..close();
  }

  @override
  bool shouldReclip(covariant CustomClipper<Path> oldClipper) => false;
}

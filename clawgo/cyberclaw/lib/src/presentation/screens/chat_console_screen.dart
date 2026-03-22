import 'package:cyberclaw/src/core/theme.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class ChatConsoleScreen extends StatelessWidget {
  const ChatConsoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Theme.of(context).colorScheme.surface,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.terminal, color: Theme.of(context).colorScheme.primary),
            const SizedBox(width: 12),
            Text(
              'IRONCLAW CONTROL',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                color: Theme.of(context).colorScheme.primary,
                fontWeight: FontWeight.w900,
                fontSize: 20,
              ),
            ),
          ],
        ),
        actions: [
          if (MediaQuery.of(context).size.width > 600)
            Row(
              children: [
                _NavButton(label: 'CHAT', isSelected: true),
                _NavButton(label: 'SETTINGS', isSelected: false),
                _NavButton(label: 'SYSTEM', isSelected: false),
              ],
            ),
          IconButton(
            icon: Icon(
              Icons.tune,
              color: Theme.of(context).colorScheme.secondary.withOpacity(0.8),
            ),
            onPressed: () => context.push('/settings'),
          ),
          const SizedBox(width: 8),
        ],
        shape: Border(
          bottom: BorderSide(
            color: Theme.of(context).colorScheme.primary.withOpacity(0.15),
            width: 1,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.background,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: GridPainter(
                    color: Theme.of(
                      context,
                    ).colorScheme.primary.withOpacity(0.03),
                  ),
                ),
              ),
            ),
            Column(
              children: [
                Expanded(
                  child: ListView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 24,
                    ),
                    children: const [
                      _AiMessage(
                        sender: 'IRONCLAW',
                        text:
                            'Initialization complete. Neural pathways synchronized at 99.8% fidelity. Hardware control modules for ARM_SYSTEM_ALPHA are now responsive. Awaiting tactical deployment commands or system diagnostics request.',
                        timestamp: '09:42:11 // SYS_READY',
                      ),
                      SizedBox(height: 24),
                      _UserMessage(
                        sender: 'OPERATOR_01',
                        text:
                            'Run full diagnostic on the kinetic dampeners. The last stress test indicated a 4% variance in recoil compensation.',
                      ),
                      SizedBox(height: 24),
                      _AiMessage(
                        sender: 'IRONCLAW',
                        text:
                            'Diagnostic sequence engaged. Analyzing stress-point telemetry from previous engagement cycles...',
                        showPulse: true,
                        pulseLabel: 'SCANNING DAMPENER_FLUID_PRESSURE',
                        pulseValue: 0.76,
                        footerText:
                            '"I am observing a micro-fissure in the secondary bypass valve. Recalibrating compensators to offset the pressure drop."',
                      ),
                    ],
                  ),
                ),
                const _MessageInputGutter(),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _NavButton extends StatelessWidget {
  final String label;
  final bool isSelected;
  const _NavButton({required this.label, required this.isSelected});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: TextButton(
        onPressed: () {},
        child: Text(
          label,
          style: Theme.of(context).textTheme.labelSmall?.copyWith(
            color: isSelected
                ? Theme.of(context).colorScheme.primary
                : Theme.of(context).colorScheme.secondary.withOpacity(0.7),
            letterSpacing: 1,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
    );
  }
}

class _AiMessage extends StatelessWidget {
  final String sender;
  final String text;
  final String? timestamp;
  final bool showPulse;
  final String? pulseLabel;
  final double? pulseValue;
  final String? footerText;

  const _AiMessage({
    required this.sender,
    required this.text,
    this.timestamp,
    this.showPulse = false,
    this.pulseLabel,
    this.pulseValue,
    this.footerText,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Text(
                  sender,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.primary,
                    letterSpacing: 2,
                  ),
                ),
                const SizedBox(width: 8),
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.primary,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.primaryContainer,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerLow,
                border: Border(
                  left: BorderSide(
                    color: Theme.of(context).colorScheme.primaryContainer,
                    width: 2,
                  ),
                ),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(text, style: const TextStyle(height: 1.5)),
                  if (showPulse) ...[
                    const SizedBox(height: 16),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          pulseLabel!,
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 10,
                          ),
                        ),
                        Text(
                          '${(pulseValue! * 100).toInt()}%',
                          style: TextStyle(
                            color: Theme.of(context).colorScheme.primary,
                            fontSize: 10,
                          ),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Container(
                      height: 8,
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Theme.of(
                          context,
                        ).colorScheme.surfaceContainerHighest,
                        border: Border.all(
                          color: Theme.of(
                            context,
                          ).colorScheme.outlineVariant.withOpacity(0.3),
                        ),
                      ),
                      child: FractionallySizedBox(
                        alignment: Alignment.centerLeft,
                        widthFactor: pulseValue,
                        child: Container(
                          decoration: BoxDecoration(
                            color: Theme.of(
                              context,
                            ).colorScheme.primaryContainer,
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(
                                  context,
                                ).colorScheme.primaryContainer,
                                blurRadius: 10,
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                  if (footerText != null) ...[
                    const SizedBox(height: 16),
                    Text(
                      footerText!,
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Theme.of(context).colorScheme.onSurfaceVariant,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ],
              ),
            ),
            if (timestamp != null) ...[
              const SizedBox(height: 4),
              Opacity(
                opacity: 0.4,
                child: Text(
                  timestamp!,
                  style: Theme.of(
                    context,
                  ).textTheme.labelSmall?.copyWith(fontSize: 9),
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

class _UserMessage extends StatelessWidget {
  final String sender;
  final String text;

  const _UserMessage({required this.sender, required this.text});

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        constraints: BoxConstraints(
          maxWidth: MediaQuery.of(context).size.width * 0.8,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Container(
                  width: 6,
                  height: 6,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    boxShadow: [
                      BoxShadow(
                        color: Theme.of(context).colorScheme.secondaryContainer,
                        blurRadius: 5,
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  sender,
                  style: Theme.of(context).textTheme.labelSmall?.copyWith(
                    color: Theme.of(context).colorScheme.secondary,
                    letterSpacing: 2,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: Theme.of(context).colorScheme.surfaceContainerHigh,
                border: Border(
                  right: BorderSide(
                    color: Theme.of(context).colorScheme.secondary,
                    width: 2,
                  ),
                ),
                boxShadow: [
                  BoxShadow(
                    color: Theme.of(
                      context,
                    ).colorScheme.secondaryContainer.withOpacity(0.05),
                    blurRadius: 15,
                  ),
                ],
              ),
              child: Text(text, style: const TextStyle(height: 1.5)),
            ),
          ],
        ),
      ),
    );
  }
}

class _MessageInputGutter extends StatelessWidget {
  const _MessageInputGutter();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color(0xFF0E0E0E),
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
      child: SafeArea(
        child: Row(
          children: [
            IconButton(
              icon: Icon(
                Icons.add,
                color: Theme.of(context).colorScheme.primary,
                size: 32,
              ),
              onPressed: () {},
            ),
            const SizedBox(width: 8),
            Expanded(
              child: Container(
                decoration: BoxDecoration(
                  color: Theme.of(context).colorScheme.surfaceContainerLowest,
                  border: Border(
                    bottom: BorderSide(
                      color: Theme.of(
                        context,
                      ).colorScheme.outlineVariant.withOpacity(0.5),
                      width: 2,
                    ),
                  ),
                ),
                child: TextField(
                  decoration: InputDecoration(
                    hintText: 'ENTER COMMAND PROTOCOL...',
                    hintStyle: TextStyle(
                      color: Theme.of(
                        context,
                      ).colorScheme.outline.withOpacity(0.4),
                      fontSize: 14,
                      letterSpacing: 2,
                    ),
                    border: InputBorder.none,
                    enabledBorder: InputBorder.none,
                    focusedBorder: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16,
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 8),
            IconButton(
              icon: Icon(
                Icons.send,
                color: Theme.of(context).colorScheme.primary,
                size: 32,
              ),
              onPressed: () {},
            ),
          ],
        ),
      ),
    );
  }
}

class GridPainter extends CustomPainter {
  final Color color;
  final double spacing;

  GridPainter({required this.color, this.spacing = 40.0});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1.0;

    for (double x = 0; x <= size.width; x += spacing) {
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    for (double y = 0; y <= size.height; y += spacing) {
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => false;
}

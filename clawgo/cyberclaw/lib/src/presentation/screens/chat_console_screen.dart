import 'dart:convert';
import 'package:cyberclaw/src/presentation/widgets/ironclaw_chat_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';
import 'package:go_router/go_router.dart';

class ChatConsoleScreen extends StatelessWidget {
  const ChatConsoleScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      appBar: AppBar(
        backgroundColor: theme.colorScheme.surface,
        elevation: 0,
        title: Row(
          children: [
            Icon(Icons.terminal, color: theme.colorScheme.primary),
            const SizedBox(width: 12),
            Text(
              'IRONCLAW CONTROL',
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
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
                const _NavButton(label: 'CHAT', isSelected: true),
                const _NavButton(label: 'SETTINGS', isSelected: false),
                const _NavButton(label: 'SYSTEM', isSelected: false),
              ],
            ),
          IconButton(
            icon: Icon(
              Icons.tune,
              color: theme.colorScheme.secondary.withOpacity(0.8),
            ),
            onPressed: () => context.push('/settings'),
          ),
          const SizedBox(width: 8),
        ],
        shape: Border(
          bottom: BorderSide(
            color: theme.colorScheme.primary.withOpacity(0.15),
            width: 1,
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
        ),
        child: Stack(
          children: [
            Positioned.fill(
              child: IgnorePointer(
                child: CustomPaint(
                  painter: GridPainter(
                    color: theme.colorScheme.primary.withOpacity(0.03),
                  ),
                ),
              ),
            ),
            LlmChatView(
              provider: IronClawChatProvider(),
              responseBuilder: (context, response) {
                // Check for [GENUI:...] marker
                final genuiMatch = RegExp(r'\[GENUI:(.*?)\]').firstMatch(response);
                Widget? genuiWidget;
                String cleanResponse = response;

                if (genuiMatch != null) {
                  cleanResponse = response.replaceAll(RegExp(r'\[GENUI:.*?\]'), '').trim();
                  try {
                    final data = jsonDecode(genuiMatch.group(1)!);
                    if (data['type'] == 'status_panel') {
                      genuiWidget = _AiMessage(
                        sender: 'IRONCLAW_SYS',
                        text: 'RECALIBRATION STATUS',
                        showPulse: true,
                        pulseLabel: 'VALVE: ${data['valve']}',
                        pulseValue: (data['pressure'] as num).toDouble(),
                        footerText: 'STATUS: ${data['status']}',
                      );
                    }
                  } catch (e) {
                    // JSON parsing failed, fallback to plain text
                  }
                }

                bool isDiagnostic = cleanResponse.contains('SCANNING');
                
                final mainMessage = _AiMessage(
                  sender: 'IRONCLAW',
                  text: cleanResponse,
                  showPulse: isDiagnostic,
                  pulseLabel: isDiagnostic ? 'SCANNING DAMPENER_FLUID_PRESSURE' : null,
                  pulseValue: isDiagnostic ? 0.76 : null,
                );

                if (genuiWidget != null) {
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if (cleanResponse.isNotEmpty) ...[
                        mainMessage,
                        const SizedBox(height: 16),
                      ],
                      genuiWidget,
                    ],
                  );
                }
                return mainMessage;
              },
              style: LlmChatViewStyle(
                backgroundColor: Colors.transparent,
                messageSpacing: 24,
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
                userMessageStyle: UserMessageStyle(
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerHigh,
                    border: Border(
                      right: BorderSide(
                        color: theme.colorScheme.secondary,
                        width: 2,
                      ),
                    ),
                  ),
                  textStyle: const TextStyle(height: 1.5, color: Colors.white),
                ),
                llmMessageStyle: LlmMessageStyle(
                  icon: Icons.terminal,
                  iconColor: theme.colorScheme.primary,
                  iconDecoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  decoration: const BoxDecoration(
                    color: Colors.transparent,
                  ),
                  padding: EdgeInsets.zero,
                  margin: EdgeInsets.zero,
                ),
                chatInputStyle: ChatInputStyle(
                  backgroundColor: const Color(0xFF0E0E0E),
                  hintText: 'ENTER COMMAND PROTOCOL...',
                  hintStyle: TextStyle(
                    color: theme.colorScheme.outline.withOpacity(0.4),
                    fontSize: 14,
                    letterSpacing: 2,
                  ),
                  decoration: BoxDecoration(
                    color: theme.colorScheme.surfaceContainerLowest,
                    border: Border(
                      bottom: BorderSide(
                        color: theme.colorScheme.outlineVariant.withOpacity(0.5),
                        width: 2,
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
  final bool showPulse;
  final String? pulseLabel;
  final double? pulseValue;
  final String? footerText;

  const _AiMessage({
    required this.sender,
    required this.text,
    this.showPulse = false,
    this.pulseLabel,
    this.pulseValue,
    this.footerText,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: Alignment.centerLeft,
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
        ],
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

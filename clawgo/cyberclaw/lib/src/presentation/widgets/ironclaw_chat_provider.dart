import 'package:flutter/foundation.dart';
import 'package:flutter_ai_toolkit/flutter_ai_toolkit.dart';

class IronClawChatProvider extends ChangeNotifier implements LlmProvider {
  final List<ChatMessage> _history = [
    ChatMessage(
      origin: MessageOrigin.llm,
      text: 'Initialization complete. Neural pathways synchronized at 99.8% fidelity. Hardware control modules for ARM_SYSTEM_ALPHA are now responsive. Awaiting tactical deployment commands or system diagnostics request.',
      attachments: [],
    ),
  ];

  @override
  Iterable<ChatMessage> get history => _history;

  @override
  set history(Iterable<ChatMessage> history) {
    _history.clear();
    _history.addAll(history);
    notifyListeners();
  }

  @override
  Stream<String> sendMessageStream(String prompt, {Iterable<Attachment> attachments = const []}) async* {
    _history.add(ChatMessage.user(prompt, attachments));
    notifyListeners();

    final llmMessage = ChatMessage.llm();
    _history.add(llmMessage);
    notifyListeners();

    await for (final chunk in generateStream(prompt, attachments: attachments)) {
      llmMessage.append(chunk);
      notifyListeners();
      yield chunk;
    }
  }

  @override
  Stream<String> generateStream(String prompt, {Iterable<Attachment> attachments = const []}) async* {
    // Simulate thinking
    await Future.delayed(const Duration(milliseconds: 500));
    
    // Check for specific commands as in the original mock
    if (prompt.toLowerCase().contains('diagnostic')) {
      yield 'Diagnostic sequence engaged. Analyzing stress-point telemetry from previous engagement cycles...';
      await Future.delayed(const Duration(milliseconds: 500));
      yield '\n\nSCANNING DAMPENER_FLUID_PRESSURE: 76%';
      await Future.delayed(const Duration(milliseconds: 500));
      yield '\n\n"I am observing a micro-fissure in the secondary bypass valve. Recalibrating compensators to offset the pressure drop."';
      await Future.delayed(const Duration(milliseconds: 500));
      yield '\n\n[GENUI:{"type":"status_panel","pressure":0.76,"valve":"SECONDARY_BYPASS","status":"RECALIBRATING"}]';
    } else {
      yield 'Command received: $prompt. Processing neural pathway mapping...';
      await Future.delayed(const Duration(milliseconds: 500));
      yield '\n\nOperational efficiency maintained at optimal levels. Awaiting further tactical deployment protocols.';
    }
  }
}

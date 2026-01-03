import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_provider.dart';
import '../provider/ai_chat_provider.dart';

class AIChatScreen extends StatelessWidget {
  const AIChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();

    return ChangeNotifierProvider(
      create: (_) => AIChatProvider(),
      child: Scaffold(
        appBar: AppBar(
          title: const Text('ISA AI Assistant'),
        ),
        body: Column(
          children: [
            /// Chat messages
            Expanded(
              child: Consumer<AIChatProvider>(
                builder: (context, chat, _) {
                  if (chat.messages.isEmpty) {
                    return const Center(
                      child: Text(
                        'Ask any Islamic question\n(Text only)',
                        textAlign: TextAlign.center,
                      ),
                    );
                  }

                  return ListView.builder(
                    padding: const EdgeInsets.all(12),
                    itemCount: chat.messages.length,
                    itemBuilder: (context, index) {
                      final msg = chat.messages[index];
                      final isUser = msg['role'] == 'user';

                      return Align(
                        alignment:
                            isUser ? Alignment.centerRight : Alignment.centerLeft,
                        child: Container(
                          margin: const EdgeInsets.symmetric(vertical: 6),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isUser
                                ? Colors.blue.shade100
                                : Colors.grey.shade200,
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Text(msg['text'] ?? ''),
                        ),
                      );
                    },
                  );
                },
              ),
            ),

            /// Free limit info
            Consumer<AIChatProvider>(
              builder: (context, chat, _) {
                if (appProvider.isPremium) return const SizedBox();

                return Padding(
                  padding: const EdgeInsets.all(8),
                  child: Text(
                    'Free questions left: ${chat.freeQuestionsLeft}',
                    style: const TextStyle(color: Colors.red),
                  ),
                );
              },
            ),

            /// Input box
            _InputBar(isPremium: appProvider.isPremium),
          ],
        ),
      ),
    );
  }
}

class _InputBar extends StatefulWidget {
  final bool isPremium;
  const _InputBar({required this.isPremium});

  @override
  State<_InputBar> createState() => _InputBarState();
}

class _InputBarState extends State<_InputBar> {
  final controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    final chat = context.read<AIChatProvider>();

    return Padding(
      padding: const EdgeInsets.all(8),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              decoration: const InputDecoration(
                hintText: 'Ask your question...',
                border: OutlineInputBorder(),
              ),
            ),
          ),
          const SizedBox(width: 8),
          IconButton(
            icon: const Icon(Icons.send),
            onPressed: () {
              if (controller.text.trim().isEmpty) return;

              chat.sendMessage(
                controller.text.trim(),
                isPremium: widget.isPremium,
              );
              controller.clear();
            },
          ),
        ],
      ),
    );
  }
}

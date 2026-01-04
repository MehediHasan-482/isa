import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../core/providers/app_provider.dart';
import '../provider/ai_chat_provider.dart';
import '../../../core/localization/app_localization.dart';

class AIChatScreen extends StatelessWidget {
  const AIChatScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final appProvider = context.watch<AppProvider>();
    final locale = appProvider.locale.languageCode;

    return Directionality(
      textDirection: locale == 'ar' ? TextDirection.rtl : TextDirection.ltr,
      child: ChangeNotifierProvider(
        create: (_) => AIChatProvider(),
        child: Scaffold(
          appBar: AppBar(
            title: Text(AppLocalization.of(context).translate('ai_assistant')),
          ),
          body: Column(
            children: [
              Expanded(
                child: Consumer<AIChatProvider>(
                  builder: (context, chat, _) {
                    if (chat.messages.isEmpty) {
                      return Center(child: Text('Ask any Islamic question'));
                    }
                    return ListView.builder(
                      itemCount: chat.messages.length,
                      itemBuilder: (context, index) {
                        final msg = chat.messages[index];
                        final isUser = msg['role'] == 'user';
                        return Align(
                          alignment: isUser
                              ? Alignment.centerRight
                              : Alignment.centerLeft,
                          child: Container(
                            margin: const EdgeInsets.all(6),
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
              _InputBar(isPremium: appProvider.isPremium),
            ],
          ),
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
              ),
            ),
          ),
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

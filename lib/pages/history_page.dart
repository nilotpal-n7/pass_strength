import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pass_strength/components/animated_toast.dart';
import 'package:pass_strength/services/storage_service.dart';
import 'package:provider/provider.dart';

class HistoryPage extends StatefulWidget {
  const HistoryPage({super.key});

  @override
  State<HistoryPage> createState() => _HistoryPageState();
}

class _HistoryPageState extends State<HistoryPage> {
  @override
  Widget build(BuildContext context) {
    final history = context.watch<HistoryProvider>().history;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Password History',
          style: TextStyle(
            fontSize: 20,
            fontWeight: FontWeight.bold,
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        ),
        const SizedBox(height: 20),

        if (history.isEmpty)
          Text(
            'No passwords generated yet.',
            style: TextStyle(
              color: Theme.of(context).colorScheme.inversePrimary,
            ),
          )
        else
          // Constrain height to show max 8 passwords, scroll beyond that
          SizedBox(
            height: history.length > 8 ? 325 : history.length * 40.0 + 10,
            child: ListView.builder(
              itemCount: history.length,
              itemBuilder: (context, index) {
                final password = history[index];
                return Dismissible(
                  key: Key(password + index.toString()),
                  direction: DismissDirection.endToStart,
                  background: Container(
                    alignment: Alignment.centerRight,
                    padding: const EdgeInsets.symmetric(horizontal: 20),
                    color: Colors.red,
                    child: const Icon(Icons.delete, color: Colors.white),
                  ),
                  onDismissed: (_) {
                    context.read<HistoryProvider>().removePasswordAt(index);
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Password deleted')),
                    );
                  },
                  child: ListTile(
                    title: Text(
                      password,
                      style: const TextStyle(fontSize: 16),
                    ),
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: password));
                      AnimatedToast.show(
                        context,
                        'Copied to clipboard',
                        isAdded: true,
                      );
                    },
                  ),
                );
              }
            ),
          ),
      ],
    );
  }
}

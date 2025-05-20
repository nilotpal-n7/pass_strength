import 'package:Passify/components/animated_toast.dart';
import 'package:Passify/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
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
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Password History',
              style: TextStyle(
                fontSize: 20,
                fontWeight: FontWeight.bold,
                color: Theme.of(context).colorScheme.inversePrimary,
              ),
              textAlign: TextAlign.center,
            ),
            GestureDetector(
              onTap: () {
                Provider.of<HistoryProvider>(context, listen: false).clearPassHistory();
              },
              child: Text(
                'Clear all',
                style: TextStyle(
                    color: Colors.redAccent,
                    fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        if(history.isEmpty) Text(
          'No passwords generated yet.',
          style: TextStyle(
            color: Theme.of(context).colorScheme.inversePrimary,
          ),
        )
        else SizedBox(
          height: history.length > 5 ? 400 : history.length * 60.0 + 20,
          child: ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) {
              final password = history[index];
              return Dismissible(
                key: Key(password + index.toString()),
                direction: DismissDirection.endToStart,
                background: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    color: Colors.redAccent,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  alignment: Alignment.centerRight,
                  child: const Icon(Icons.delete, color: Colors.white),
                ),
                onDismissed: (_) {
                  context.read<HistoryProvider>().removePasswordAt(index);
                  AnimatedToast.show(
                    context,
                    'Password deleted',
                    isAdded: true,
                  );
                },
                child: Container(
                  margin: const EdgeInsets.symmetric(vertical: 4),
                  padding: const EdgeInsets.symmetric(horizontal: 4),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: !context.read<ThemeProvider>().isDarkMode
                      ? Colors.grey.shade800
                      : Colors.grey.shade100,
                  ),
                  child: ListTile(
                    title: Text(
                      password,
                      style: TextStyle(
                        color: !context.read<ThemeProvider>().isDarkMode
                          ? Colors.white
                          : Colors.grey.shade900,
                      ),
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
                ),
              );
            }
          ),
        ),
      ],
    );
  }
}

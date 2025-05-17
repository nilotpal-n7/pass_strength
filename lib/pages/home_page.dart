import 'package:flutter/material.dart';
import 'package:pass_strength/components/my_switch.dart';
import 'package:pass_strength/components/my_toggler.dart';
import 'package:pass_strength/pages/history_page.dart';
import 'package:pass_strength/pages/password_page.dart';
import 'package:pass_strength/services/storage_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isRandom = true;
  
  void toggleRandom(bool isRandomSelected) {
    setState(() {
      isRandom = isRandomSelected;
      saveSettings();
    });
  }

   void loadSettings() async {
    isRandom = await StorageService.loadBool('isRandom');
    setState(() {}); // 👈 update UI
  }

  void saveSettings() {
    StorageService.saveBool('isRandom', isRandom);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      appBar: AppBar(
        title: Text(
          'Passify',
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          MySwitch(
            mainAxisAlignment: MainAxisAlignment.start,
            text: 'Dark',
            value: Provider.of<ThemeProvider>(context).isDarkMode,
            onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
          )
        ],
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        child: Center(
          child: Container(
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.tertiary,
              borderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
            padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 50),
            child: Column(
              children: [
                Text(
                  'Choose password type',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                const SizedBox(height: 10),
                Container(
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.secondary,
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      MyToggler(
                        isSelected: isRandom,
                        onTap: () => toggleRandom(true),
                        text: 'Random',
                        icon: Icons.shuffle,
                      ),
                      MyToggler(
                        isSelected: !isRandom,
                        onTap: () => toggleRandom(false),
                        text: 'History',
                        icon: Icons.history,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                isRandom ? PasswordPage() : HistoryPage(),
              ],
            ),
          ),
        ),
      )
    );
  }
}

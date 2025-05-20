import 'package:Passify/components/my_switch.dart';
import 'package:Passify/components/my_toggler.dart';
import 'package:Passify/pages/history_page.dart';
import 'package:Passify/pages/password_page.dart';
import 'package:Passify/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isRandom = true;

  @override
  void initState() {
    super.initState();
    loadSettings();
  }

  void loadSettings() async {
    isRandom = await StorageService.loadBool('isRandom');
    setState(() {});
  }

  void saveSettings() {
    StorageService.saveBool('isRandom', isRandom);
  }

  void toggleRandom(bool isRandomSelected) {
    setState(() {
      isRandom = isRandomSelected;
      saveSettings();
    });
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
            padding: const EdgeInsets.only(top: 50, bottom: 10, left: 25, right: 25),
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
                const SizedBox(height: 25),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      'Click to Copy',
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                    Text(
                      'Slide to delete',
                      style: TextStyle(
                        fontSize: 10,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      )
    );
  }
}

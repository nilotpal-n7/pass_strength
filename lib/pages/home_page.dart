import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:pass_strength/components/my_toggler.dart';
import 'package:pass_strength/themes/theme_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  bool isRandom = true;
  double sliderValue = 6;
  
  void toggleRandom(bool isRandomSelected) {
    setState(() {
      isRandom = isRandomSelected;
    });
  }

  void toggleSlider(double value) {
    setState(() {
      sliderValue = value;
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
          Transform.scale(
            scale: 0.7,
            child: CupertinoSwitch(
              value: Provider.of<ThemeProvider>(context).isDarkMode,
              onChanged: (value) => Provider.of<ThemeProvider>(context, listen: false).toggleTheme(),
              activeTrackColor: Colors.blueAccent.shade400,
              
            ),
          )
        ],
        centerTitle: true,
        backgroundColor: Theme.of(context).colorScheme.surface,
        foregroundColor: Theme.of(context).colorScheme.primary,
        elevation: 0,
      ),
      body: Center(
        child: Container(
          height: 500,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.tertiary,
            borderRadius: BorderRadius.circular(12),
          ),
          margin: const EdgeInsets.symmetric(horizontal: 25),
          padding: const EdgeInsets.symmetric(horizontal: 25, vertical: 30),
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
                    ),
                    MyToggler(
                      isSelected: !isRandom,
                      onTap: () => toggleRandom(false),
                      text: 'Pin',
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 10),
              Text(
                'Customize your new password',
                style: TextStyle(
                  color: Theme.of(context).colorScheme.inversePrimary,
                ),
              ),
              const SizedBox(),
              Slider(
                value: sliderValue,
                onChanged: (value) => toggleSlider(value),
                min: 4,
                max: 16,
                thumbColor: Theme.of(context).colorScheme.inversePrimary,
              ),

            ],
          ),
        ),
      )
    );
  }
}

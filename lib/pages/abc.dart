import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pass_strength/components/animated_toast.dart';
import 'package:pass_strength/components/my_switch.dart';
import 'package:pass_strength/components/my_textfield.dart';
import 'package:pass_strength/components/my_toggler.dart';
import 'package:pass_strength/services/storage_service.dart';
import 'package:provider/provider.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final String smallAlpha = 'abcdefghijklmnopqrstuvwxyz';
  final String capitalAlpha = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  final String numbers = '1234567890';
  final String symbols = '~`!@#\$%^&*()_-+=<,>.?/:;"\'{[}]|\\';

  bool isRandom = true;
  double sliderValue = 6;
  bool isSmallAlpha = true;
  bool isCapitalAplpha = false;
  bool isNum = true;
  bool isSymbols = false;
  
  void toggleRandom(bool isRandomSelected) {
    setState(() {
      isRandom = isRandomSelected;
    });
  }

  void toggleSlider(double value) {
    setState(() {
      sliderValue = value.toInt().toDouble();
    });
  }

  void toggleNum(bool value) {
    setState(() {
      isNum = value;
    });
    AnimatedToast.show(
      context,
      value ? 'Numbers added' : 'Numbers removed',
      isAdded: value,
    );
  }

  void toggleSmallAlpha(bool value) {
    setState(() {
      isSmallAlpha = value;
    });
    AnimatedToast.show(
      context,
      value ? 'Small-Alpha added' : 'Small-Alpha removed',
      isAdded: value,
    );
  }

  void toggleCapitalAlpha(bool value) {
    setState(() {
      isCapitalAplpha = value;
    });
    AnimatedToast.show(
      context,
      value ? 'Capital-Alpha added' : 'Capital-Alpha removed',
      isAdded: value,
    );
  }

  void toggleSymbols(bool value) {
    setState(() {
      isSymbols = value;
    });
    AnimatedToast.show(
      context,
      value ? 'Symbols added' : 'Symbols removed',
      isAdded: value,
    );
  }

  String generatedPassword = 'Customize...';

  void setPassword(String pass) {
    setState(() {
      generatedPassword = pass;
    });

    AnimatedToast.show(
      context,
      'Password generated!',
      isAdded: true,
    );
  }

  void generatePassword() {
    String included = '';
    included += isNum ? numbers : '';
    included += isSmallAlpha ? smallAlpha : '';
    included += isCapitalAplpha ? capitalAlpha : '';
    included += isSymbols ? symbols : '';

    if(included == '') {
      AnimatedToast.show(
        context,
        'Enable atleast one field!',
        isAdded: false,
      );
    } else {
      String password = '';
      for(int i = 0; i < sliderValue; i++) {
        password += included[Random().nextInt(included.length)];
      }
      setPassword(password);
    }
  }

  void onTap(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: generatedPassword));
      AnimatedToast.show(
        context,
        'Copied to clipboard',
        isAdded: true,
      );
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
                        text: 'Pin',
                        icon: Icons.numbers,
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 50),
                Text(
                  'Customize your new password',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                  ),
                ),
                const SizedBox(),
                Row(
                  children: [
                    Text(
                      'Length: ',
                      style: TextStyle(
                        color: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                    Text(
                      '${sliderValue.toInt()}',
                      style: TextStyle(
                        color: Colors.blue,
                      ),
                    ),
                    Expanded(
                      child: Slider(
                        value: sliderValue,
                        onChanged: toggleSlider,
                        min: 4,
                        max: 16,
                        thumbColor: Theme.of(context).colorScheme.inversePrimary,
                      ),
                    ),
                  ],
                ),
                MySwitch(
                  value: isNum,
                  onChanged: toggleNum,
                  text: 'Numbers',
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                MySwitch(
                  value: isSmallAlpha,
                  onChanged: toggleSmallAlpha,
                  text: 'Small-Alpha',
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                MySwitch(
                  value: isCapitalAplpha,
                  onChanged: toggleCapitalAlpha,
                  text: 'Capital-Alpha',
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                MySwitch(
                  value: isSymbols,
                  onChanged: toggleSymbols,
                  text: 'Symbols',
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                ),
                const SizedBox(height: 25),
                Text(
                  'Generated password',
                  style: TextStyle(
                    color: Theme.of(context).colorScheme.inversePrimary,
                    fontWeight: FontWeight.w500,
                    fontSize: 16,
                  ),
                ),
                const SizedBox(height: 10),
                MyTextfield(
                  text: generatedPassword,
                  richText: buildStyledPassword(generatedPassword),
                  onPressed: generatePassword,
                  onTap: () => onTap(context),
                ),
              ],
            ),
          ),
        ),
      )
    );
  }


  TextSpan buildStyledPassword(String password) {
    return TextSpan(
      children: password.split('').map((char) {
        Color color;

        if (numbers.contains(char)) {
          color = Colors.orange;
        } else if (smallAlpha.contains(char)) {
          color = Colors.lightBlue;
        } else if (capitalAlpha.contains(char)) {
          color = Colors.deepPurple;
        } else {
          color = Colors.teal;
        }

        return TextSpan(
          text: char,
          style: TextStyle(color: color, fontSize: 18, fontWeight: FontWeight.bold),
        );
      }).toList(),
    );
  }
}

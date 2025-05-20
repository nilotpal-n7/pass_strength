import 'dart:math';
import 'package:Passify/components/animated_toast.dart';
import 'package:Passify/components/my_switch.dart';
import 'package:Passify/components/my_textfield.dart';
import 'package:Passify/services/storage_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:password_strength_checker/password_strength_checker.dart';
import 'package:provider/provider.dart';

class PasswordPage extends StatefulWidget {
  const PasswordPage({super.key});

  @override
  State<PasswordPage> createState() => _PasswordPageState();
}

class _PasswordPageState extends State<PasswordPage> {
  final String smallAlpha = 'abcdefghijklmnopqrstuvwxyz';
  final String capitalAlpha = 'ABCDEFGHIJKLMNOPQRSTUVWXYZ';
  final String numbers = '1234567890';
  final String symbols = '~`!@#\$%^&*()_-+=<,>.?/:;"\'{[}]|\\';
  final passNotifier = ValueNotifier<PasswordStrength?>(null);

  double sliderValue = 6;
  bool isSmallAlpha = true;
  bool isCapitalAplpha = false;
  bool isNum = true;
  bool isSymbols = false;

  String generatedPassword = 'Customize...';

  @override
  void initState() {
    super.initState();
    loadSettings();
    passNotifier.value = PasswordStrength.calculate(text: generatedPassword);
  }

  void loadSettings() async {
    isNum = await StorageService.loadBool('isNum');
    isSmallAlpha = await StorageService.loadBool('isSmallAlpha');
    isCapitalAplpha = await StorageService.loadBool('isCapitalAlpha');
    isSymbols = await StorageService.loadBool('isSymbols');
    sliderValue = await StorageService.loadDouble('sliderValue');
    generatedPassword = await StorageService.loadString('currentPassword');
    passNotifier.value = PasswordStrength.calculate(text: generatedPassword);
    setState(() {});
  }

  void saveSettings() {
    StorageService.saveBool('isNum', isNum);
    StorageService.saveBool('isSmallAlpha', isSmallAlpha);
    StorageService.saveBool('isCapitalAlpha', isCapitalAplpha);
    StorageService.saveBool('isSymbols', isSymbols);
    StorageService.saveDouble('sliderValue', sliderValue);
    StorageService.saveString('currentPassword', generatedPassword);
  }

  void toggleSlider(double value) {
    setState(() {
      sliderValue = value.toInt().toDouble();
      saveSettings();
    });
  }

  void toggleNum(bool value) {
    setState(() {
      isNum = value;
      saveSettings();
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
      saveSettings();
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
      saveSettings();
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
      saveSettings();
    });

    AnimatedToast.show(
      context,
      value ? 'Symbols added' : 'Symbols removed',
      isAdded: value,
    );
  }

  void setPassword(String pass) {
    setState(() {
      generatedPassword = pass;
      saveSettings();
      passNotifier.value = PasswordStrength.calculate(text: generatedPassword);
    });

    Provider.of<HistoryProvider>(context, listen: false).addPassword(pass);

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
    return Column(
      children: [
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
        const SizedBox(height: 20),
        PasswordStrengthChecker(
          strength: passNotifier,
        ),
      ],
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

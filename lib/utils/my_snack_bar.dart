import 'package:flutter/material.dart';
import 'package:bot_toast/bot_toast.dart';

// {} is used to make the parameter optional
void MySnackBar(context, String text, {Color color = Colors.black}) {
  BotToast.showCustomText(
    toastBuilder: (_) => Container(
      padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(25),
      ),
      child: Text(
        text,
        style: const TextStyle(color: Colors.white),
      ),
    ),
    duration: const Duration(seconds: 3),
    crossPage: true,
    clickClose: true,
    backButtonBehavior: BackButtonBehavior.ignore,
    enableKeyboardSafeArea: true,
  );
}

// BotToast.showNotification(
//     title: (_) => const Text("Notification"),
//     subtitle: (_) => const Text("This is a message from notification"),
//     leading: (_) => SizedBox.fromSize(
//       size: const Size(40, 40),
//       child: const Icon(Icons.info_outline, color: Colors.white),
//     ),
//     trailing: (cancelFunc) => TextButton(
//       onPressed: cancelFunc,
//       child: const Text("Cancel"),
//     ),
//     enableSlideOff: true,
//     crossPage: true,
//     backButtonBehavior: BackButtonBehavior.ignore,
//     enableKeyboardSafeArea: true,
//   );
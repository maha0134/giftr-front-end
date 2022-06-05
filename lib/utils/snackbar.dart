import 'package:flutter/material.dart';
class CustomErrorPrompt {
CustomErrorPrompt.snackbar(dynamic err, BuildContext context) {
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
      duration: const Duration(seconds: 3),
      backgroundColor: Theme.of(context).colorScheme.primary,
      content: Text(err.toString()),
    ));
}
}
 import 'package:flutter/material.dart';

void showSnackbar(BuildContext context,String message) {
      ScaffoldMessenger.of(context).showSnackBar(
                 SnackBar(
                    backgroundColor: Colors.red,
                    content: Text(message),
                  ),
                );
  }
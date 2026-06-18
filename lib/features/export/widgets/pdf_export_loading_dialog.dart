import 'package:flutter/material.dart';

class PdfExportLoadingDialog extends StatelessWidget {
  const PdfExportLoadingDialog({super.key, this.message = 'Preparing PDF...'});

  final String message;

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      content: Row(
        children: [
          const CircularProgressIndicator(),
          const SizedBox(width: 18),
          Expanded(child: Text(message)),
        ],
      ),
    );
  }
}

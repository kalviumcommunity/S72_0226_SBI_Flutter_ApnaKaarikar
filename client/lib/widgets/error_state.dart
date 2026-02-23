import 'package:flutter/material.dart';
import 'custom_button.dart';

/// Reusable error state widget
/// Works on iOS, Android, and Web
class ErrorState extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const ErrorState({
    Key? key,
    required this.message,
    required this.onRetry,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 80.0,
              color: Colors.red[400],
            ),
            const SizedBox(height: 16.0),
            const Text(
              'Oops! Something went wrong',
              style: TextStyle(
                fontSize: 18.0,
                fontWeight: FontWeight.bold,
              ),
            ),
            const SizedBox(height: 8.0),
            Text(
              message,
              style: TextStyle(
                fontSize: 14.0,
                color: Colors.grey[600],
              ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: 24.0),
            CustomButton(
              text: 'Retry',
              onPressed: onRetry,
              backgroundColor: Colors.red,
              icon: Icons.refresh,
            ),
          ],
        ),
      ),
    );
  }
}

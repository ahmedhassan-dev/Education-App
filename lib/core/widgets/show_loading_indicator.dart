import 'package:flutter/material.dart';

class ShowLoadingIndicator extends StatelessWidget {
  const ShowLoadingIndicator({super.key});

  @override
  Widget build(BuildContext context) {
    return const Center(
      child: CircularProgressIndicator(
        color: Colors.white,
      ),
    );
  }
}

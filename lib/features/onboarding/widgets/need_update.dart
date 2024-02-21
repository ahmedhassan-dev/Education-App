import 'package:flutter/material.dart';

class NeedToUpdate extends StatelessWidget {
  const NeedToUpdate({super.key});
  //TODO: this widget need to be completed
  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        "Please Update The App❤️",
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
              fontWeight: FontWeight.bold,
              color: Colors.white,
            ),
      ),
    );
  }
}

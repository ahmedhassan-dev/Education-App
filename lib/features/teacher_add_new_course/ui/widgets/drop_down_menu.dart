import 'package:education_app/core/theming/app_colors.dart';
import 'package:flutter/material.dart';

class DropDownMenuComponent extends StatelessWidget {
  final void Function(String? value) onChanged;
  final List<String> items;
  final String hint;
  const DropDownMenuComponent({
    super.key,
    required this.onChanged,
    required this.items,
    required this.hint,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownButtonFormField<String>(
      value: null,
      icon: const Icon(Icons.arrow_drop_down),
      isExpanded: true,
      elevation: 16,
      style: Theme.of(context).textTheme.displaySmall!,
      iconEnabledColor: AppColors.whiteColor,
      focusColor: AppColors.primaryColor,
      dropdownColor: AppColors.secondaryColor,
      hint: FittedBox(
        fit: BoxFit.contain,
        child: Container(
          // color: AppColors.secondaryColor,
          child: Text(hint,
              style: TextStyle(color: AppColors.whiteColor, fontSize: 50)),
        ),
      ),
      onChanged: onChanged,
      items: items.map<DropdownMenuItem<String>>((String value) {
        return DropdownMenuItem<String>(
          value: value,
          child: Text(
            value,
            style: Theme.of(context)
                .textTheme
                .titleMedium!
                .copyWith(color: AppColors.whiteColor),
          ),
        );
      }).toList(),
    );
  }
}
// Theme.of(context)
//                   .textTheme
//                   .titleMedium!
//                   .copyWith(color: Colors.white),
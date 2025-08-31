import 'package:dakeh_service_provider/core/utils/colors_manager.dart';
import 'package:flutter/material.dart';

class CheckboxFormFiled extends FormField<bool> {
  final Widget title;
  final bool isChecked;
  final void Function(bool?) onChanged;

  CheckboxFormFiled({
    super.key,
    required this.title,
    required this.isChecked,
    required this.onChanged,
    required super.validator,
  }) : super(
          initialValue: isChecked,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          builder: (FormFieldState<bool> state) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Checkbox(
                      visualDensity: const VisualDensity(
                        vertical: VisualDensity.minimumDensity,
                        horizontal: VisualDensity.minimumDensity,
                      ),
                      side: state.hasError
                          ? const BorderSide(
                              color: ColorsManager.kRed, width: 2)
                          : null,
                      value: isChecked,
                      onChanged: (value) {
                        state.didChange(value);
                        onChanged(value);
                      },
                    ),
                    Expanded(
                      child: title,
                    ),
                  ],
                ),
                if (state.hasError)
                  Text(
                    '* ${state.errorText}',
                    style: const TextStyle(
                        color: ColorsManager.kRed,
                        fontSize: 12,
                        fontWeight: FontWeight.bold),
                  )
              ],
            );
          },
        );
}

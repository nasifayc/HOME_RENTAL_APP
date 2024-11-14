import 'package:flutter/material.dart';
import 'package:home_app/core/theme/app_theme.dart';

class FormComponents {
  final BuildContext context;
  FormComponents({required this.context}) {
    theme = AppTheme.of(context);
  }
  late AppTheme theme;
  Widget buildSearchBar(
      TextEditingController controller, String hintText, bool isReadOnly,
      {String? Function(String?)? validator, void Function()? onTap}) {
    return TextFormField(
      controller: controller,
      readOnly: isReadOnly,
      decoration: InputDecoration(
        hintText: hintText,
        prefixIcon: Icon(
          Icons.search,
          color: theme.primary,
        ),
        filled: true,
        fillColor: theme.secondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
      onTap: onTap,
    );
  }

  Widget buildDatePickerField(
      BuildContext context, TextEditingController controller, Text labelText,
      {String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        label: labelText,
        suffixIcon: const Icon(Icons.calendar_today),
        filled: true,
        fillColor: theme.secondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
      onTap: () async {
        DateTime? pickedDate = await showDatePicker(
          context: context,
          initialDate: DateTime.now(),
          firstDate: DateTime(2000),
          lastDate: DateTime(2101),
        );
        if (pickedDate != null) {
          controller.text = "${pickedDate.toLocal()}".split(' ')[0];
        }
      },
      validator: validator,
    );
  }

  Widget buildTimePickerField(
      BuildContext context, TextEditingController controller, Text labelText,
      {String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      readOnly: true,
      decoration: InputDecoration(
        label: labelText,
        suffixIcon: const Icon(Icons.access_time),
        filled: true,
        fillColor: theme.secondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
      onTap: () async {
        TimeOfDay? pickedTime = await showTimePicker(
          context: context,
          initialTime: TimeOfDay.now(),
        );
        if (pickedTime != null) {
          // ignore: use_build_context_synchronously
          controller.text = pickedTime.format(context);
        }
      },
      validator: validator,
    );
  }

  Widget buildDropdownInputField(Text? labelText, List<String> items,
      String? selectedItem, void Function(String?) onChanged,
      {String? Function(String?)? validator}) {
    return DropdownButtonFormField<String>(
      value: selectedItem,
      decoration: InputDecoration(
        label: labelText,
        filled: true,
        fillColor: theme.secondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
      items: items.map((item) {
        return DropdownMenuItem<String>(
          value: item,
          child: Text(
            item,
            style: theme.typography.titleSmall,
          ),
        );
      }).toList(),
      onChanged: onChanged,
      validator: validator,
    );
  }

  Widget buildNormalTextField(TextEditingController controller, Text labelText,
      {Widget? prefixIcon, String? Function(String?)? validator}) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        label: labelText,
        prefixIcon: prefixIcon != null
            ? Padding(
                padding: const EdgeInsets.symmetric(horizontal: 12.0),
                child: prefixIcon,
              )
            : null,
        prefixIconConstraints: const BoxConstraints(
          minWidth: 40,
          minHeight: 40,
        ),
        filled: false,
        fillColor: theme.secondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
        ),
      ),
      validator: validator,
    );
  }

  Widget buildWideTextField(TextEditingController controller, Text labelText,
      {String? Function(String?)? validator, int? minLines, int? maxLines}) {
    return TextFormField(
      controller: controller,
      minLines: minLines ?? 5,
      maxLines: maxLines,
      decoration: InputDecoration(
        label: labelText,
        filled: true,
        fillColor: theme.secondary,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(12.0),
          borderSide: BorderSide.none,
        ),
      ),
      validator: validator,
    );
  }

  Widget buildPhoneNumberField(
      TextEditingController phoneController,
      Text lable,
      String selectedCountryCode,
      List<String> countryCodes,
      void Function(String?) onCountryCodeChanged,
      {String? Function(String?)? validator}) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: DropdownButtonFormField<String>(
            value: selectedCountryCode,
            decoration: InputDecoration(
              filled: true,
              fillColor: theme.secondary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
            ),
            items: countryCodes.map((code) {
              return DropdownMenuItem<String>(
                value: code,
                child: Text(
                  code,
                  style: theme.typography.displaySmall,
                ),
              );
            }).toList(),
            onChanged: onCountryCodeChanged,
            validator: validator,
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          flex: 5,
          child: TextFormField(
            controller: phoneController,
            decoration: InputDecoration(
              label: lable,
              filled: true,
              fillColor: theme.secondary,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(12.0),
                borderSide: BorderSide.none,
              ),
            ),
            keyboardType: TextInputType.phone,
            validator: validator,
          ),
        ),
      ],
    );
  }

  Widget buildPasswordField(TextEditingController controller, Text label,
      {Widget? prefixIcon, String? Function(String?)? validator}) {
    bool obscureText = true;

    return StatefulBuilder(
      builder: (BuildContext context, StateSetter setState) {
        return TextFormField(
          controller: controller,
          obscureText: obscureText,
          decoration: InputDecoration(
            label: label,
            prefixIcon: prefixIcon,
            suffixIcon: IconButton(
              icon: Icon(
                obscureText ? Icons.visibility : Icons.visibility_off,
                color: theme.secondary,
              ),
              onPressed: () {
                setState(() {
                  obscureText = !obscureText;
                });
              },
            ),
            filled: false,
            fillColor: theme.secondary,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12.0),
            ),
          ),
          validator: validator,
        );
      },
    );
  }
}

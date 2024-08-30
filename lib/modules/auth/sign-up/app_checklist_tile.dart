import 'package:flutter/material.dart';

class AppCheckListTile extends StatefulWidget {
  const AppCheckListTile({required this.title, required this.onChanged});

  final void Function(bool value) onChanged;
  final String title;

  @override
  State<AppCheckListTile> createState() => _AppCheckListTileState();
}

class _AppCheckListTileState extends State<AppCheckListTile> {
  bool _isChecked = false;

  @override
  Widget build(BuildContext context) {
    return CheckboxListTile(
      secondary: const Icon(
        Icons.admin_panel_settings_outlined,
        size: 40,
      ),
      value: _isChecked,
      selected: _isChecked,
      onChanged: (value) {
        setState(() {
          _isChecked = value!;
        });

        widget.onChanged.call(value!);
      },
      title: Text(
        widget.title,
        style: const TextStyle(fontWeight: FontWeight.bold),
      ),
    );
  }
}

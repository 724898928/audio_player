import 'package:flutter/material.dart';

class DDbutton extends StatefulWidget {
  DDbutton({
    super.key,
    required this.labels,
    this.dropdownValue = 1.0,
    required this.onChange,
    this.menuWidth,
  });
  final ValueChanged<dynamic?> onChange;
  final List<Map<String, dynamic>> labels;
  dynamic? dropdownValue;
  double? menuWidth;

  @override
  State<DDbutton> createState() => _DDbuttonState();
}

class _DDbuttonState extends State<DDbutton> {
  // double? dropdownValue = 1.0;
  @override
  Widget build(BuildContext context) {
    return DropdownButton<dynamic>(
      menuWidth: widget.menuWidth,
      padding: EdgeInsets.all(0),
      value: widget.dropdownValue,
      onChanged: (val) {
        widget.dropdownValue = val;
        widget.onChange(val);
        setState(() {});
      },
      style: const TextStyle(color: Colors.blueAccent),
      items: widget.labels.map((a) {
        return DropdownMenuItem<dynamic>(
            alignment: Alignment.center,
            value: a['value'],
            child: Text(a['label']));
      }).toList(),
    );
  }
}

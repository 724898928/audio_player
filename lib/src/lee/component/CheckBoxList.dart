import 'package:flutter/material.dart';

import '../model/Song.dart';

class CheckBoxList extends StatefulWidget {
  CheckBoxList(
      {super.key, required this.searchSelected, required this.callback});
  List<SearchSong> searchSelected;
  Function(int, dynamic) callback;

  _CheckBoxListState checkBoxListState = _CheckBoxListState();
  void selectedAll(bool v) {
    checkBoxListState.selectedAll(v);
  }

  @override
  State<CheckBoxList> createState() => checkBoxListState;
}

class _CheckBoxListState extends State<CheckBoxList> {
  void selectedAll(bool v) {
    for (var i = 0; i < widget.searchSelected.length; i++) {
      widget.searchSelected[i].setSelected = v;
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      itemBuilder: (context, idx) {
        return GestureDetector(
          child: Row(children: [
            Icon(widget.searchSelected[idx].selected == true
                ? Icons.check_box
                : Icons.check_box_outline_blank),
            Text(widget.searchSelected[idx].name ?? ""),
          ]),
          onTap: () {
            setState(() {
              widget.searchSelected[idx].setSelected =
                  !widget.searchSelected[idx].selected!;
            });
            widget.callback(idx, widget.searchSelected[idx].selected);
          },
        );
      },
      separatorBuilder: (ctx, idx) {
        return const Divider();
      },
      itemCount: widget.searchSelected.length,
    );
  }
}

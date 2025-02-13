import 'package:audio_player/src/lee/common/Utils.dart';
import 'package:flutter/material.dart';

import '../model/Song.dart';

class CheckBoxWidget extends StatefulWidget {
  CheckBoxWidget({super.key, required this.isCheck, required this.callback});
  bool isCheck;
  ValueChanged callback;
  @override
  State<CheckBoxWidget> createState() => _CheckBoxWidgetState();
}

class _CheckBoxWidgetState extends State<CheckBoxWidget> {
  @override
  Widget build(BuildContext context) {
    return Checkbox(
        value: widget.isCheck,
        onChanged: (v) {
          if (null != widget.callback) {
            setState(() {
              widget.isCheck = !widget.isCheck;
              widget.callback.call(v);
            });
          }
        });
  }
}

class CheckBoxList extends StatefulWidget {
  CheckBoxList(
      {super.key, required this.searchSelected, required this.callback});
  List<SearchSong> searchSelected;
  Function(int, dynamic) callback;

  static _CheckBoxListState checkBoxListState = _CheckBoxListState();
  static void selectedAll(bool v) {
    checkBoxListState.selectedAll(v);
  }

  @override
  State<CheckBoxList> createState() => checkBoxListState;
}

class _CheckBoxListState extends State<CheckBoxList>
    with SingleTickerProviderStateMixin, AutomaticKeepAliveClientMixin {
  void selectedAll(bool v) {
    if (null != widget.searchSelected && widget.searchSelected.isNotEmpty) {
      for (var i = 0; i < widget.searchSelected.length; i++) {
        widget.searchSelected[i].setSelected = v;
        if (v) {
          widget.searchSelected[i].getPlaySong();
        } else {
          widget.searchSelected[i].removeSong();
        }
      }
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
            Text(
                '${widget.searchSelected[idx].name} ${widget.searchSelected[idx].singers?.last['name']}'),
          ]),
          onTap: () {
            widget.searchSelected[idx].setSelected =
                !widget.searchSelected[idx].selected!;
            widget.callback(idx, widget.searchSelected[idx].selected);
            setState(() {});
          },
        );
      },
      separatorBuilder: (ctx, idx) {
        return const Divider();
      },
      itemCount: widget.searchSelected.length,
    );
  }

  @override
  bool get wantKeepAlive => true;
}

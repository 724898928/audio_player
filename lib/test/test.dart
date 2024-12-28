import 'package:flutter/material.dart';

class DynamicCheckboxList extends StatefulWidget {
  @override
  _DynamicCheckboxListState createState() => _DynamicCheckboxListState();
}

class _DynamicCheckboxListState extends State<DynamicCheckboxList> {
  List<String> items = ['苹果', '香蕉', '橘子'];
  late List<bool> isChecked;

  Widget getWidget(ctx, Function(int, dynamic) callback) {
    print("getWidget: " + isChecked.toString());
    return ListView.builder(
      itemBuilder: (ctx, idx) {
        return ListTile(
          title: Text(items![idx].toString() ?? ""),
          subtitle: Text(items![idx].toString() ?? ""),
          trailing: Checkbox(
            key: Key(idx.toString()),
            value: isChecked[idx],
            onChanged: (v) {
              callback(idx, v);
              // setState(() {});
              print("play ${isChecked[idx]}");
            },
          ),
        );
      },
      itemCount: isChecked!.length,
    );
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    isChecked = List.generate(items.length, (index) => false);
  }

  void _addItem() {
    setState(() {
      items.add('新水果');
      isChecked.add(false);
    });
  }

  void _removeItem(int index) {
    setState(() {
      items.removeAt(index);
      isChecked.removeAt(index);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('动态Checkbox列表'),
      ),
      body: Column(
        children: [
          // 添加按钮
          ElevatedButton(
            onPressed: _addItem,
            child: Text('添加水果'),
          ),
          // 列表
          Expanded(
            child: getWidget(context, (idx, v) {
              isChecked[idx] = v!;
              print('回调函数：$v');
              print('isChecked$isChecked');
              setState(() {});
            }),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: DynamicCheckboxList(),
  ));
}

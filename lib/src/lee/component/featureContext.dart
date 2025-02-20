import 'package:flutter/material.dart';

class FeatureContext extends StatefulWidget {
  final Widget child;
  final Function(VoidCallback)? callback;
  _FeatureContextState FeatureContextState = _FeatureContextState();
  FeatureContext({super.key, required this.child, this.callback}) {
    print("callback");
    callback?.call(() => FeatureContextState.update());
  }

  @override
  State<FeatureContext> createState() => FeatureContextState;
}

class _FeatureContextState extends State<FeatureContext> {
  @override
  void initState() {
    super.initState();
  }

  void update() {
    print("update");
    if (mounted) {
      setState(() {});
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          border: Border.all(color: Colors.blueAccent),
          borderRadius: BorderRadius.circular(12),
        ),
        child: widget.child,
      ),
    );
  }
}

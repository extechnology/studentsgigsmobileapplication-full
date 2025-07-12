import 'package:flutter/cupertino.dart';

class Cutom<T> extends StatefulWidget {
  const Cutom({super.key});

  @override
  State<Cutom<T>> createState() => _CutomState<T>();
}

class _CutomState<T> extends State<Cutom<T>> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}

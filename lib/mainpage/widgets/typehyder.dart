import 'package:flutter/material.dart';

class CustomTypeAhead<T> extends StatefulWidget {
  final TextStyle? textStyle; // 👈 ADD THIS

  final TextEditingController controller;
  final FocusNode? focusNode;
  final Future<List<T>> Function(String) suggestionsCallback;
  final Widget Function(BuildContext, T) itemBuilder;
  final void Function(T) onSuggestionSelected;
  final InputDecoration? decoration;
  final VoidCallback? onTap; // 👈 NEW
  final int? maxLength;



  const CustomTypeAhead({
    super.key,
    required this.controller,
    required this.suggestionsCallback,
    required this.itemBuilder,
    required this.onSuggestionSelected,
    this.focusNode,
    this.decoration,
    this.onTap, // 👈 NEW
    this.textStyle, // 👈 ADD THIS
    this.maxLength, // 👈 Add here



  });

  @override
  State<CustomTypeAhead<T>> createState() => _CustomTypeAheadState<T>();
}

class _CustomTypeAheadState<T> extends State<CustomTypeAhead<T>> {
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _textFieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  List<T> _suggestions = [];

  @override
  void initState() {
    super.initState();

    widget.controller.addListener(_onChanged);

    widget.focusNode?.addListener(() {
      if (widget.focusNode!.hasFocus) {
        _ensureFieldVisible();
        _onChanged(forceShow: true);
      } else {
        _removeOverlay();
      }
    });
  }

  void _onChanged({bool forceShow = false}) async {
    final query = widget.controller.text;
    final results = await widget.suggestionsCallback(query);
    _suggestions = results;
    _showOverlay();
  }

  void _showOverlay() {
    _removeOverlay();

    final overlay = Overlay.of(context);
    final renderBox = _textFieldKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;
    final offset = renderBox.localToGlobal(Offset.zero);

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        left: offset.dx,
        top: offset.dy + size.height + 5,
        child: CompositedTransformFollower(
          link: _layerLink,
          showWhenUnlinked: false,
          offset: Offset(0.0, size.height + 8),
          child: Material(
            elevation: 4.0,
            borderRadius: BorderRadius.circular(8),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxHeight: MediaQuery.of(context).size.height * 0.4,
              ),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                ),
                child: ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  itemCount: _suggestions.length,
                  itemBuilder: (context, index) {
                    final suggestion = _suggestions[index];
                    return InkWell(
                      onTap: () {
                        widget.onSuggestionSelected(suggestion);
                        widget.controller
                          ..removeListener(_onChanged)
                          ..text = suggestion.toString()
                          ..addListener(_onChanged);
                        _removeOverlay();
                        FocusScope.of(context).unfocus();
                      },
                      child: widget.itemBuilder(context, suggestion),
                    );
                  },
                ),
              ),
            ),
          ),
        ),
      ),
    );

    overlay.insert(_overlayEntry!);
  }

  void _removeOverlay() {
    _overlayEntry?.remove();
    _overlayEntry = null;
  }

  void _ensureFieldVisible() {

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final context = _textFieldKey.currentContext;
      if (context != null) {
        Scrollable.ensureVisible(
          context,
          duration: Duration(milliseconds: 300),
          alignment: 0.3,
        );
      }
    });
  }

  @override
  void dispose() {
    widget.controller.removeListener(_onChanged);
    _removeOverlay();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: TextField(
        maxLength: widget.maxLength, // 👈 Add here
        key: _textFieldKey,
        controller: widget.controller,
        focusNode: widget.focusNode,
        decoration: widget.decoration ?? const InputDecoration(),
        onTap: widget.onTap, // 👈 CALL IT
        style: widget.textStyle, // 👈 APPLY THE TEXT COLOR HERE


      ),
    );
  }
}

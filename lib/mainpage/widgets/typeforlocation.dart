import 'package:flutter/material.dart';

  class CustomTypeAheadWithEmptyCheck<T> extends StatefulWidget {
    final TextStyle? textStyle; // 👈 ADD THIS

    final TextEditingController controller;
    final FocusNode? focusNode;
    final Future<List<T>> Function(String) suggestionsCallback;
    final Widget Function(BuildContext, T) itemBuilder;
    final void Function(T) onSuggestionSelected;
    final InputDecoration? decoration;
    final VoidCallback? onTap;
    final ValueChanged<String>? onChanged;

    const CustomTypeAheadWithEmptyCheck({
      super.key,
      required this.controller,
      required this.suggestionsCallback,
      required this.itemBuilder,
      required this.onSuggestionSelected,
      this.focusNode,
      this.decoration,
      this.onTap,
      this.onChanged,
      this.textStyle, // 👈 ADD THIS

    });

  @override
  State<CustomTypeAheadWithEmptyCheck<T>> createState() =>
      _CustomTypeAheadWithEmptyCheckState<T>();
}

class _CustomTypeAheadWithEmptyCheckState<T> extends State<CustomTypeAheadWithEmptyCheck<T>> {
  final LayerLink _layerLink = LayerLink();
  final GlobalKey _textFieldKey = GlobalKey();
  OverlayEntry? _overlayEntry;
  List<T> _suggestions = [];
  bool _isSelectingSuggestion = false;

  // ✅ New State Variable
  bool _userHasPicked = false;

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
    if (_isSelectingSuggestion) {
      return;
    }

    final query = widget.controller.text;

    // 🔥 IMPORTANT: Always remove overlay if text is empty.
    if (query.isEmpty) {
      _userHasPicked = false;
      _removeOverlay();
      return;
    }

    if (_userHasPicked && !forceShow) {
      return;
    }

    // 👉 Capture the current query when making async call
    final currentQuery = query;

    final results = await widget.suggestionsCallback(currentQuery);

    // ✅ IMPORTANT:
    // Check if the text has changed while waiting for the results
    if (widget.controller.text != currentQuery) {
      return; // Don't show outdated results
    }

    _suggestions = results;

    if (_suggestions.isNotEmpty) {
      _showOverlay();
    } else {
      _removeOverlay();
    }
  }  void _showOverlay() {
    _removeOverlay();

    final overlay = Overlay.of(context);
    final renderBox = _textFieldKey.currentContext!.findRenderObject() as RenderBox;
    final size = renderBox.size;

    _overlayEntry = OverlayEntry(
      builder: (context) => Positioned(
        width: size.width,
        left: renderBox.localToGlobal(Offset.zero).dx,
        top: renderBox.localToGlobal(Offset.zero).dy + size.height + 5,
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
                        _isSelectingSuggestion = true;
                        _userHasPicked = true;

                        widget.onSuggestionSelected(suggestion);
                        widget.controller
                          ..removeListener(_onChanged)
                          ..text = suggestion.toString()
                          ..addListener(_onChanged);

                        _removeOverlay();
                        FocusScope.of(context).unfocus();

                        // Reset state AFTER this frame
                        WidgetsBinding.instance.addPostFrameCallback((_) {
                          _isSelectingSuggestion = false;
                        });
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
      final ctx = _textFieldKey.currentContext;
      if (ctx != null) {
        Scrollable.ensureVisible(
          ctx,
          duration: const Duration(milliseconds: 300),
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
        key: _textFieldKey,
        controller: widget.controller,
        focusNode: widget.focusNode,
        decoration: widget.decoration ?? const InputDecoration(),
        onTap: widget.onTap,
        onChanged: (val) {
          // ✅ IMPORTANT:
          // User started typing again -> reset `_userHasPicked`
          _userHasPicked = false;

          if (widget.onChanged != null) {
            widget.onChanged!(val);
          }
        },
        style: widget.textStyle, // 👈 APPLY THE TEXT COLOR HERE

      ),
    );
  }
}

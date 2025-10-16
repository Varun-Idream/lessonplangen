import 'package:flutter/material.dart';

class CustomDropdown<T> extends StatefulWidget {
  final List<T> items;
  final Widget child;
  final void Function(T value) onChange;
  final Widget Function(int count, T item, int index) itemBuilder;

  const CustomDropdown({
    super.key,
    required this.items,
    required this.child,
    required this.onChange,
    required this.itemBuilder,
  });

  @override
  State<CustomDropdown<T>> createState() => _CustomDropdownState<T>();
}

class _CustomDropdownState<T> extends State<CustomDropdown<T>> {
  final LayerLink _layerLink = LayerLink();
  OverlayEntry? _overlayEntry;
  bool _isOpen = false;

  @override
  void dispose() {
    _hideDropdown();
    super.dispose();
  }

  void _toggleDropdown() {
    if (_isOpen) {
      _hideDropdown();
    } else {
      _showDropdown();
    }
  }

  void _showDropdown() {
    _overlayEntry = _createOverlayEntry();
    Overlay.of(context).insert(_overlayEntry!);
    setState(() {
      _isOpen = true;
    });
  }

  void _hideDropdown() {
    _overlayEntry?.remove();
    _overlayEntry = null;
    if (context.mounted) {
      setState(() {
        _isOpen = false;
      });
    }
  }

  OverlayEntry _createOverlayEntry() {
    final renderBox = context.findRenderObject() as RenderBox;
    final size = renderBox.size;

    return OverlayEntry(
      builder: (context) => Stack(
        children: [
          Positioned.fill(
            child: GestureDetector(
              onTap: _hideDropdown,
              behavior: HitTestBehavior.translucent,
              child: Container(
                color: Colors.transparent,
              ),
            ),
          ),
          Positioned(
            width: size.width,
            child: CompositedTransformFollower(
              link: _layerLink,
              showWhenUnlinked: false,
              offset: Offset(0.0, size.height + 5.0),
              child: TweenAnimationBuilder<double>(
                tween: Tween<double>(begin: 0.8, end: 1),
                duration: const Duration(milliseconds: 300),
                curve: Curves.ease,
                builder: (context, value, child) {
                  return Transform.scale(
                    scale: value,
                    origin: Offset(0, 0),
                    child: Opacity(
                      opacity: value,
                      child: child,
                    ),
                  );
                },
                child: Material(
                  color: Colors.white,
                  elevation: 4.0,
                  shape: RoundedRectangleBorder(
                    // side: BorderSide(
                    //   color: Colors.grey,
                    //   width: 1,
                    // ),
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                  clipBehavior: Clip.antiAlias,
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height * 0.3,
                    ),
                    child: ListView.separated(
                      shrinkWrap: true,
                      itemCount: widget.items.length,
                      separatorBuilder: (context, index) => const Divider(
                        height: 1,
                        thickness: 1,
                        color: Colors.white,
                      ),
                      itemBuilder: (context, index) {
                        final item = widget.items[index];
                        return InkWell(
                          onTap: () {
                            widget.onChange(item);
                            _hideDropdown();
                          },
                          child: widget.itemBuilder(
                            widget.items.length,
                            item,
                            index,
                          ),
                        );
                      },
                    ),
                  ),
                ),
              ),
            ),
          )
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return CompositedTransformTarget(
      link: _layerLink,
      child: GestureDetector(
        onTap: _toggleDropdown,
        child: widget.child,
      ),
    );
  }
}

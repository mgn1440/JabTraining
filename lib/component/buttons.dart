import 'package:flutter/material.dart';
import 'package:jab_training/const/color.dart';

enum ButtonType { filled, outlined, text }

class CustomButton extends StatefulWidget {
  final bool isEnabled;
  final ButtonType buttonType;
  final Future<void> Function()? onPressed;
  final Widget child;
  final int columnCount;

  const CustomButton({
    super.key,
    required this.isEnabled,
    required this.buttonType,
    required this.onPressed,
    required this.child,
    this.columnCount = 6,
  });

  @override
  CustomButtonState createState() => CustomButtonState();
}

class CustomButtonState extends State<CustomButton> {
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      final screenWidth = MediaQuery.of(context).size.width;
      const margin = 24.0;
      const gutter = 16.0;
      const totalGutterWidth = gutter * 5; // 6개의 컬럼 사이에 5개의 거터
      const totalMarginWidth = margin * 2;
      final availableWidth = screenWidth - totalMarginWidth - totalGutterWidth;
      final columnWidth = availableWidth / 6;
      final buttonWidth =
          columnWidth * widget.columnCount + gutter * (widget.columnCount - 1);
      switch (widget.buttonType) {
        case ButtonType.filled:
          return SizedBox(
            width: buttonWidth,
            height: 51,
            child: ElevatedButton(
              onPressed: widget.isEnabled ? widget.onPressed : null,
              style: ButtonStyle(
                foregroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.disabled)) {
                      return grayscaleSwatch[200]!;
                    }
                    return grayscaleSwatch[600]!;
                  },
                ),
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.disabled)) {
                      return primarySwatch[200]!;
                    }
                    return primarySwatch[500]!;
                  },
                ),
                textStyle: WidgetStateProperty.all<TextStyle>(
                  TextStyle(
                    fontSize: 16, // 텍스트 크기
                    color: widget.isEnabled
                        ? grayscaleSwatch[600]
                        : grayscaleSwatch[200],
                  ),
                ),
              ),
              child: widget.child,
            ),
          );

        case ButtonType.outlined:
          return SizedBox(
            width: buttonWidth,
            height: 51,
            child: OutlinedButton(
              onPressed: widget.isEnabled ? widget.onPressed : null,
              style: OutlinedButton.styleFrom(
                foregroundColor:
                    widget.isEnabled ? primarySwatch[500] : primarySwatch[200],
                side: BorderSide(
                  color: widget.isEnabled
                      ? primarySwatch[500]!
                      : primarySwatch[200]!,
                ),
                textStyle: TextStyle(
                  fontSize: 16, // 텍스트 크기
                  fontWeight: FontWeight.normal, // 텍스트 굵기
                  color: widget.isEnabled
                      ? grayscaleSwatch[600]
                      : grayscaleSwatch[200],
                ),
              ),
              child: widget.child,
            ),
          );
        case ButtonType.text:
          return TextButton(
            onPressed: widget.isEnabled ? widget.onPressed : null,
            style: TextButton.styleFrom(
              foregroundColor:
                  widget.isEnabled ? primarySwatch[500] : primarySwatch[200],
              textStyle: TextStyle(
                fontWeight: FontWeight.w900,
              ),
            ),
            child: widget.child,
          );
        default:
          return Container();
      }
    });
  }
}

class SelectButtonGroup extends StatefulWidget {
  final List<String> buttonLabels;
  final ValueChanged<int> onSelected;
  final int columnCount;

  const SelectButtonGroup({
    super.key,
    required this.buttonLabels,
    required this.onSelected,
    this.columnCount = 6,
  });

  @override
  SelectButtonGroupState createState() => SelectButtonGroupState();
}

class SelectButtonGroupState extends State<SelectButtonGroup> {
  int _selectedIndex = 0;

  void _onButtonPressed(int index) {
    setState(() {
      _selectedIndex = index;
    });
    widget.onSelected(index);
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    const margin = 24.0;
    const gutter = 16.0;
    const totalGutterWidth = gutter * 5; // 6개의 컬럼 사이에 5개의 거터
    const totalMarginWidth = margin * 2;
    final availableWidth = screenWidth - totalMarginWidth - totalGutterWidth;
    final columnWidth = availableWidth / 6;
    final buttonWidth =
        columnWidth * widget.columnCount + gutter * (widget.columnCount - 1);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: List.generate(widget.buttonLabels.length, (index) {
        return SizedBox(
          width: buttonWidth / widget.buttonLabels.length,
          height: 51,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: TextButton(
              onPressed: () => _onButtonPressed(index),
              style: TextButton.styleFrom(
                backgroundColor: background,
                foregroundColor: _selectedIndex == index
                    ? Theme.of(context).primaryColor
                    : grayscaleSwatch[100],
                side: BorderSide(
                  color: _selectedIndex == index
                      ? Theme.of(context).primaryColor
                      : grayscaleSwatch[100]!,
                ),
              ),
              child: Text(widget.buttonLabels[index],
                  style: const TextStyle(fontWeight: FontWeight.w100)),
            ),
          ),
        );
      }),
    );
  }
}

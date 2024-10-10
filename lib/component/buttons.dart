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
                      return grayscaleSwatch[600]!;
                    }
                    return grayscaleSwatch[600]!;
                  },
                ),
                backgroundColor: WidgetStateProperty.resolveWith<Color>(
                  (Set<WidgetState> states) {
                    if (states.contains(WidgetState.disabled)) {
                      return primarySwatch[800]!;
                    }
                    return primarySwatch[500]!;
                  },
                ),
                textStyle: WidgetStateProperty.all<TextStyle>(
                  const TextStyle(
                    fontSize: 16, // 텍스트 크기
                    fontWeight: FontWeight.normal, // 텍스트 굵기
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
                    widget.isEnabled ? primarySwatch[500] : primarySwatch[800],
                side: BorderSide(
                  color: widget.isEnabled
                      ? primarySwatch[500]!
                      : primarySwatch[800]!,
                ),
                textStyle: const TextStyle(
                  fontSize: 16, // 텍스트 크기
                  fontWeight: FontWeight.normal, // 텍스트 굵기
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
                  widget.isEnabled ? primarySwatch[500] : primarySwatch[800],
            ),
            child: widget.child,
          );
        default:
          return Container();
      }
    });
  }
}

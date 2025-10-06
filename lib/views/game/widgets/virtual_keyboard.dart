import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VirtualKeyboard extends StatelessWidget {
  const VirtualKeyboard({super.key, required this.onKeyPressed});
  final Function(String) onKeyPressed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final screenWidth = constraints.maxWidth;
        
        // Responsive sizing
        final double keyHeight;
        final double keyPadding;
        final double fontSize;
        final double iconSize;
        
        if (screenWidth > 900) {
          // Desktop
          keyHeight = 55.0;
          keyPadding = 6.0;
          fontSize = 20.0;
          iconSize = 28.0;
        } else if (screenWidth > 600) {
          // Tablet
          keyHeight = 50.0;
          keyPadding = 4.0;
          fontSize = 18.0;
          iconSize = 26.0;
        } else {
          // Mobile
          keyHeight = 48.0;
          keyPadding = 2.0;
          fontSize = 18.0;
          iconSize = 24.0;
        }

        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 700),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildKeyRow(
                ['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'],
                fontSize: fontSize,
                keyPadding: keyPadding,
                keyHeight: keyHeight,
                iconSize: iconSize,
              ),
              SizedBox(height: 4),
              _buildKeyRow(
                ['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'],
                fontSize: fontSize,
                keyPadding: keyPadding,
                keyHeight: keyHeight,
                iconSize: iconSize,
              ),
              SizedBox(height: 4),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ..._buildKeys(
                    ['Z', 'X', 'C', 'V', 'B', 'N', 'M'],
                    fontSize: fontSize,
                    keyPadding: keyPadding,
                    keyHeight: keyHeight,
                    iconSize: iconSize,
                  ),
                  _buildKey(
                    '❌',
                    isDeleteKey: true,
                    flex: 2,
                    fontSize: fontSize,
                    iconSize: iconSize,
                    keyPadding: keyPadding,
                    keyHeight: keyHeight,
                  ),
                ],
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildKey(
    String key, {
    bool isDeleteKey = false,
    int flex = 1,
    required double keyHeight,
    required double keyPadding,
    required double fontSize,
    required double iconSize,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        padding: EdgeInsets.all(keyPadding),
        child: Material(
          color: Colors.transparent,
          child: InkWell(
            onTap: () => onKeyPressed(key),
            borderRadius: BorderRadius.circular(8),
            child: Container(
              height: keyHeight,
              decoration: BoxDecoration(
                color: isDeleteKey ? Color(0xffA78BFA) : Color(0xff6C5CE7),
                borderRadius: BorderRadius.circular(8),
                boxShadow: [
                  BoxShadow(
                    color: Color(0xff5D5771).withOpacity(0.3),
                    offset: Offset(0, 4),
                    blurRadius: 4,
                  ),
                ],
              ),
              alignment: Alignment.center,
              child: isDeleteKey
                  ? SvgPicture.asset(
                      'assets/backspace.svg',
                      width: iconSize,
                      height: iconSize,
                    )
                  : Text(
                      key,
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: fontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeyRow(
    List<String> keys, {
    required double keyHeight,
    required double keyPadding,
    required double fontSize,
    required double iconSize,
  }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        for (String key in keys)
          _buildKey(
            key,
            fontSize: fontSize,
            keyHeight: keyHeight,
            keyPadding: keyPadding,
            iconSize: iconSize,
          )
      ],
    );
  }

  List<Widget> _buildKeys(
    List<String> keys, {
    required double keyHeight,
    required double keyPadding,
    required double fontSize,
    required double iconSize,
  }) {
    return [
      for (String key in keys)
        _buildKey(
          key,
          fontSize: fontSize,
          iconSize: iconSize,
          keyPadding: keyPadding,
          keyHeight: keyHeight,
        )
    ];
  }
}
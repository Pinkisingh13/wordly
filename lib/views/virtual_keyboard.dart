import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class VirtualKeyboard extends StatelessWidget {
  const VirtualKeyboard({super.key, required this.onKeyPressed});
  final Function(String) onKeyPressed;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate key size based on screen width
        final screenWidth = constraints.maxWidth;
        final isLargeScreen = screenWidth > 600;
        final keySize = isLargeScreen ? 60.0 : 48.0;
        final keyPadding = isLargeScreen ? 4.0 : 2.0;
        final fontSize = isLargeScreen ? 24.0 : 22.0;
        final iconSize = isLargeScreen ? 36.0 : 33.0;
        return ConstrainedBox(
          constraints: BoxConstraints(maxWidth: 600),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _buildKeyRow(['Q', 'W', 'E', 'R', 'T', 'Y', 'U', 'I', 'O', 'P'], fontSize: fontSize,keyPadding: keyPadding, keySize: keySize, iconSize: iconSize),
              _buildKeyRow(['A', 'S', 'D', 'F', 'G', 'H', 'J', 'K', 'L'], fontSize: fontSize,keyPadding: keyPadding, keySize: keySize, iconSize: iconSize),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ..._buildKeys(['Z', 'X', 'C', 'V', 'B', 'N', 'M'],fontSize: fontSize,keyPadding: keyPadding, keySize: keySize, iconSize: iconSize),
                  _buildKey(
                    '❌',
                    isDeleteKey: true,
                    flex: 2,
                    fontSize: fontSize,
                    iconSize: iconSize,
                    keyPadding: keyPadding,
                    keySize: keySize,
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
    required double keySize,
    required double keyPadding,
    required double fontSize,
    required double iconSize,
  }) {
    return Expanded(
      flex: flex,
      child: Padding(
        // padding: const EdgeInsets.all(2.0),
        padding: EdgeInsets.all(keyPadding),
        child: GestureDetector(
          onTap: () => onKeyPressed(key),
          child: Container(
            // height: 48,
            height: keySize,
            decoration: BoxDecoration(
              // color: isDeleteKey ? Color(0xff5D5771) : const Color(0xff5D5771).withOpacity(0.5),
              color: isDeleteKey ? Color(0xffA78BFA) : Color(0xff6C5CE7),
              borderRadius: BorderRadius.circular(7),
              boxShadow: [
                BoxShadow(
                  color: Color(0xff5D5771).withOpacity(0.3),
                  offset: Offset(0, 5),
                  blurRadius: 3,
                ),
              ],
            ),
            alignment: Alignment.center,
            child:
                isDeleteKey
                    ? SvgPicture.asset(
                      'assets/backspace.svg',
                      // width: 33,
                      // height: 33,
                      width: iconSize,
                      height: iconSize,
                    )
                    : Text(
                      key,
                      style: TextStyle(
                        color: Colors.white,
                        // fontSize: 22,
                        fontSize: fontSize,

                        fontWeight: FontWeight.bold,
                      ),
                    ),
          ),
        ),
      ),
    );
  }

  Widget _buildKeyRow(List<String> keys, {required double keySize,
    required double keyPadding,
    required double fontSize,
    required double iconSize,
    }) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [for (String key in keys) _buildKey(key, fontSize: fontSize, keySize: keySize, keyPadding: keyPadding, iconSize: iconSize)],
    );
  }

  List<Widget> _buildKeys(List<String> keys, {    
    required double keySize,
    required double keyPadding,
    required double fontSize,
    required double iconSize,}) {
    return [for (String key in keys) _buildKey(key,fontSize: fontSize, iconSize: iconSize,keyPadding: keyPadding,keySize: keySize)];
  }
}

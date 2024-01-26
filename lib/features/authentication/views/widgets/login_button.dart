import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:knock_at/constants/sizes.dart';

class LoginButton extends StatelessWidget {
  const LoginButton({
    super.key,
    required this.iconPath,
    required this.text,
    required this.color,
  });

  final String iconPath;
  final String text;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      widthFactor: 0.8,
      child: Container(
        decoration: BoxDecoration(
          border: Border.all(
            color: Colors.black26,
            width: 1.0,
          ),
          borderRadius: BorderRadius.circular(Sizes.size32),
          color: Color(color.value),
        ),
        padding: const EdgeInsets.symmetric(
          horizontal: Sizes.size16,
          vertical: Sizes.size12,
        ), // Add padding if needed
        child: Stack(
          alignment: Alignment.center,
          children: [
            Align(
              alignment: Alignment.centerLeft,
              child: SvgPicture.asset(
                iconPath,
                width: Sizes.size32,
                height: Sizes.size32,
              ),
            ),
            Text(
              text,
              style: Theme.of(context).textTheme.titleMedium,
            ),
          ],
        ),
      ),
    );
  }
}

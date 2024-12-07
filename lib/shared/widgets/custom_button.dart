import 'package:realestate/shared/utils/responsive_helper/responsive_helper.dart';
import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String buttonText;
  final VoidCallback? onPress;
  final Color color;
  final Border? border;
  final Color textColor;
  final BorderRadius? borderRadius;
  final double? height;
  final double? width;
  final bool isLoading; // Optional loading state

  const CustomButton({
    super.key,
    required this.buttonText,
    this.onPress,
    required this.color,
    this.border,
    this.borderRadius,
    this.height,
    this.width,
    required this.textColor,
    this.isLoading = false, // Default to false
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isLoading ? null : onPress, // Disable onTap if loading
      child: Container(
        width: width,
        height: height,
        padding: EdgeInsets.symmetric(vertical: ResponsiveHelper.getHeight(context, .02)),
        decoration: BoxDecoration(
          color: color,
          borderRadius: borderRadius,
          border: border,
        ),
        child: Center(
          child: isLoading
              ? CircularProgressIndicator(
            color: Colors.white,
          )
              : Text(
            buttonText,
            style: TextStyle(
              color: textColor,
              fontSize: 16,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:realestate/shared/utils/responsive_helper/responsive_helper.dart';


class CustomContainer extends StatelessWidget {

  final Color color;
  final VoidCallback? onPress;


  const CustomContainer({
    Key? key,
    this.onPress,


    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(1.0),
      child: InkWell(
        onTap: onPress,

        child: Container(
          height: ResponsiveHelper.getHeight(context, 0.005),
          width: ResponsiveHelper.getWidth(context, 0.07),
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(30),


          ),
        ),
      ),
    );
  }
}

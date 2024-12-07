import 'package:flutter/material.dart';

import '../theme/app_color/app_Colors.dart';

class CustomAppbar extends StatefulWidget implements PreferredSizeWidget {
  const CustomAppbar({super.key});

  @override
  State<CustomAppbar> createState() => _CustomAppbarState();

  @override
  Size get preferredSize => const Size.fromHeight(kToolbarHeight);
}

class _CustomAppbarState extends State<CustomAppbar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(

      title:  Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          IconButton(
            icon: const Icon(Icons.home_outlined,size: 35,),
            onPressed: () {
            },
          ),
          const Text('TIPBX', style: TextStyle(fontSize: 24,color: AppColors.whiteColor)),
          Row(
            children: [
              IconButton(
                icon: const Icon(Icons.search,size: 35),
                onPressed: () {
                },
              ),
              IconButton(
                icon: const Icon(Icons.add,size: 35),
                onPressed: () {
                },
              ),
            ],
          ),

        ],
      ),

      backgroundColor: Colors.transparent,
        iconTheme: IconThemeData(
          color: AppColors.whiteColor,
        ),

    );
  }
}

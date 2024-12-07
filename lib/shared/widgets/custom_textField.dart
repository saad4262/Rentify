// import 'package:collaboration/shared/theme/app_color/app_Colors.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_mobx/flutter_mobx.dart';
// import 'package:collaboration/modules/login_screen/viewmodel/password_store.dart'; // Import the PasswordStore
//
// class CustomTextfield extends StatelessWidget {
//   final TextEditingController controller;
//   final String label;
//   final bool obscure;
//   final Icon? suffixIcon;
//   final FocusNode? focusNode;
//   final Color borderColor;
//
//   final PasswordStore? passwordStore;
//   final bool isPasswordField;
//   final TextStyle? textStyle;
//   final TextInputType? keyboardType;
//
//   const CustomTextfield({
//     Key? key,
//     required this.controller,
//     required this.label,
//     this.obscure = false,
//     this.suffixIcon,
//     this.borderColor = Colors.grey,
//     this.textStyle,
//     this.keyboardType ,
//     this.focusNode,
//     this.passwordStore,
//     this.isPasswordField = false,
//   }) : super(key: key);
//
//   @override
//   Widget build(BuildContext context) {
//     return Observer(
//       builder: (_) {
//
//
//         final isFocused = focusNode?.hasFocus ?? false;
//
//         return TextField(
//           controller: controller,
//           focusNode: focusNode,
//           obscureText: isPasswordField
//               ? !(passwordStore?.isPasswordVisible ?? false)
//               : obscure,
//
//           style: TextStyle(color: Colors.white),
//           keyboardType: keyboardType,
//
//           decoration: InputDecoration(
//
//             labelText: label,
//             labelStyle: TextStyle(color: Colors.white54),
//             hintStyle: TextStyle(color: AppColors.whiteColor),
//             suffixIcon: isPasswordField
//                 ? IconButton(
//               icon: Icon(
//                 passwordStore?.isPasswordVisible ?? false
//                     ? Icons.visibility
//                     : Icons.visibility_off,
//                 color: Colors.white,
//               ),
//               onPressed: () {
//                 passwordStore?.togglePasswordVisibility();
//               },
//             )
//                 : suffixIcon,
//
//             focusedBorder: UnderlineInputBorder(
//               borderSide: BorderSide(color: isFocused ?  borderColor : AppColors.whiteColor),
//             ),
//
//           ),
//           onChanged: (value) {
//             if (isPasswordField) {
//               if (label == 'Password') {
//                 passwordStore?.setPassword(value);
//               } else if (label == 'Confirm Password') {
//                 passwordStore?.setConfirmPassword(value);
//               }
//             }
//           },
//         );
//       },
//     );
//   }
// }

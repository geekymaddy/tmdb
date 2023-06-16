import 'package:flutter/material.dart';

import '../colors.dart';


class CustomSnackBar extends State<StatefulWidget> {
  static const _sizedBoxWidth = 8.0;
  CustomSnackBar();

  static void positiveSnackBar({
    required BuildContext context,
    String? message,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar()._customSnackBar(
        message: message ?? '',
        color: successColor,
        icon: Icons.task_alt_outlined,
        context: context,
      ),
    );
  }

  static void negativeSnackBar({
    required BuildContext context,
    String? message,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar()._customSnackBar(
        message: message ?? '',
        color: errorColor,
        icon: Icons.error,
        context: context,
      ),
    );
  }

  static void infoSnackBar({
    required BuildContext context,
    String? message,
  }) {
    ScaffoldMessenger.of(context).clearSnackBars();
    ScaffoldMessenger.of(context).showSnackBar(
      CustomSnackBar()._customSnackBar(
        message: message ?? '',
        color: Colors.black,
        icon: Icons.info,
        context: context,
      ),
    );
  }

  SnackBar _customSnackBar({
    required String message,
    required Color color,
    required IconData icon,
    required BuildContext context,
  }) =>
      SnackBar(
        content: _snackBarContent(icon, message, context),
        backgroundColor: color,
        duration: const Duration(milliseconds: 1500),
        padding: const EdgeInsets.symmetric(
          horizontal: 8.0,
          vertical: 16, // Inner padding for SnackBar content.
        ),
        behavior: SnackBarBehavior.floating,
      );

  Widget _snackBarContent(
    IconData icon,
    String message,
    BuildContext context,
  ) =>
      Row(
        children: [
          Icon(
            icon,
            color: Colors.white,
          ),
          const SizedBox(width: _sizedBoxWidth),
          Expanded(
            child: Text(
              message,
              style: Theme.of(context)
                  .textTheme
                  .subtitle1!
                  .copyWith(color: Colors.white),
              maxLines: 5,
            ),
          ),
        ],
      );

  @override
  Widget build(BuildContext context) => Container();
}

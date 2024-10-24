import 'package:flutter/material.dart';

class CustomGridMenu extends StatelessWidget {
  final String title;
  final IconData icon;
  final Function() onTap;

  const CustomGridMenu({
    Key? key,
    required this.title,
    required this.icon,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 56,
            width: 56,
            decoration: BoxDecoration(
              color: Theme.of(context).colorScheme.primary,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(icon, color: Colors.white),
          ),
          // SizedBox(height: 10),
          Flexible(child: Text(title,textAlign: TextAlign.center,selectionColor: Colors.black, style: TextStyle(fontSize: 12))),
          SizedBox(height: 1,)
        ],
      ),
    );
  }
}
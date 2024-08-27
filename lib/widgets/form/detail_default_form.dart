
import 'package:flutter/material.dart';

class DetailDefaultFormWidget extends StatelessWidget {

  final String title;
  final EdgeInsets? titlePadding;
  final Widget child;

  const DetailDefaultFormWidget({super.key, required this.title, required this.child, this.titlePadding});


  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: titlePadding ?? const EdgeInsets.only(left: 5),
          child: Text(title,
            style: TextStyle(
              fontSize: Theme.of(context).textTheme.displaySmall!.fontSize,
              fontWeight: FontWeight.w600,
              color: Theme.of(context).colorScheme.primary
            ),
          ),
        ),

        const SizedBox(height: 10,),

        child
      ],
    );
  }
}

import 'package:flutter/material.dart';

class CustomErrorWidget extends StatelessWidget {
  
  const CustomErrorWidget({
    Key? key,
    required this.errors,
  }) : super(key: key);

  final List<String> errors;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (var error in errors)
          Row(
            children: [
              const Icon(
                Icons.error_outline,
                color: Colors.red,
              ),
              const SizedBox(width: 10),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: errors.map((e) => Text(e)).toList(),
              ),
            ],
          ),
      ],
    );
  }
}
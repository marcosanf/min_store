import 'package:flutter/material.dart';

class ProductTile extends StatelessWidget {
  const ProductTile(
      {super.key,
      required this.title,
      required this.price,
      required this.image});
  final String title;
  final String price;
  final String image;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        SizedBox(
          height: 236,
          width: 157,
          child: Image.network(
            image,
            fit: BoxFit.fitHeight,
          ),
        ),
      ],
    );
  }
}

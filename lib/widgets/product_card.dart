import 'package:flutter/material.dart';
import 'package:iti_final_project/consts/app_colors.dart';
import 'package:iti_final_project/consts/app_screen_size.dart';


class ProductCard extends StatefulWidget {


  final String image;
  final String name;
  final String price;
  final void Function() onTap;


  const ProductCard({
    super.key,
    required this.image,
    required this.name,
    required this.price,
    required this.onTap
  });

  @override
  State<ProductCard> createState() => _ProductCardState();
}

class _ProductCardState extends State<ProductCard> {


  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: widget.onTap,
      child: Card(
        color: AppColors.appWhite,
        elevation: 4,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        child: Column(
          children: [
            ClipRRect(
              borderRadius: const BorderRadius.vertical(top: Radius.circular(10)),
              child: Image.network(
                  widget.image,
                  height: AppScreenSize.getScreenHeight(context)*.215/*widget.height*.7*/,
                  fit: BoxFit.cover
              ),
            ),//image
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Expanded(
                      child: Text(
                          widget.name,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            fontSize: 16,
                          )),
                    ),//title
                    const SizedBox(height: 3),
                    Expanded(
                      child: Text(
                          "\$${widget.price}",
                          style: const TextStyle(
                              fontSize: 14,
                              color: AppColors.appDarkBlue
                          )),
                    ),
                  ],
                ),
              ),
            )//name , price
          ],
        ),
      ),
    );
  }
}
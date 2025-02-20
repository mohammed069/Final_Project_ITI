import 'package:flutter/material.dart';
import 'package:iti_final_project/consts/app_colors.dart';
import 'package:iti_final_project/consts/app_screen_size.dart';


class CategoryCard extends StatefulWidget {


  final String image;
  final String name;
  final void Function() onTap;


  const CategoryCard({
    super.key,
    required this.image,
    required this.name,
    required this.onTap,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {


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
                  height: AppScreenSize.getScreenHeight(context)*.2/*widget.height*.7*/,
                  fit: BoxFit.cover
              ),
            ),//image
            Expanded(
              child: Padding(
                padding: const EdgeInsets.all(10),
                child: Text(
                    widget.name,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 16,
                    )),
              ),
            )//name , price
          ],
        ),
      ),
    );
  }
}
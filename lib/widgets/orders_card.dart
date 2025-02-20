import 'package:flutter/material.dart';
import 'package:iti_final_project/consts/app_colors.dart';
import 'package:iti_final_project/consts/app_screen_size.dart';

class OrdersCard extends StatelessWidget {
  const OrdersCard({super.key, required this.image, required this.title, required this.price, required this.quantity});

  final String image;
  final String title;
  final String price;
  final int quantity;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: ListTile(
        leading: ClipRRect(
          borderRadius: const BorderRadius.all(Radius.circular(10)),
          child: Image.network(
            image,
            height: AppScreenSize.getScreenHeight(context)*.1,
            fit: BoxFit.cover,
          ),
        ),
        title:  Text(title),
        subtitle: Text("\$$price      Quantity: $quantity",style: const TextStyle(color: AppColors.appBlue),),
      ),
    );
  }
}


import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:iti_final_project/consts/app_colors.dart';
import 'package:http/http.dart' as http;
import 'package:iti_final_project/widgets/orders_card.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class OrdersPage extends StatefulWidget {
  const OrdersPage({super.key});

  @override
  State<OrdersPage> createState() => _CartPageState();
}

class _CartPageState extends State<OrdersPage> {
  List ordersProducts = [];
  double totalPrice= 0;
  bool loading = false;
  String? userToken;


  @override
  void initState() {
    super.initState();
    loadTokenAndFetchOrders();
  }

  Future<void> loadTokenAndFetchOrders() async {
    setState(() {
      loading=true;
    });

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      setState(() => userToken = token);
      await fetchOrders(token);
    } else {
      setState(() {
        loading=false;
      });
    }
  }

  Future<void> fetchOrders(String token) async {
    try {
      final url = Uri.parse("https://ib.jamalmoallart.com/api/v2/orders?token=$token");
      var response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      var responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseBody["state"] == true) {
          setState(() {
              ordersProducts= responseBody["data"]["order"];
              totalPrice=responseBody["data"]["total"];
          });
        }
      }
    } catch (e) {
      debugPrint("Error fetching cart: $e");
    }
    setState(() {
      loading=false;
    });
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(backgroundColor: AppColors.backgroundColor,),
      body: loading
          ? ListView.builder(
        itemCount: 10,
        itemBuilder: (context, index) => Shimmer.fromColors(
          baseColor: AppColors.shimmerBaseColor,
          highlightColor: AppColors.shimmerHighlightColor,
          child: ListTile(
            leading: Container(
              width: 50,
              height: 50,
              color: Colors.white,
            ),
            title: Container(
              width: double.infinity,
              height: 10,
              color: Colors.white,
            ),
            subtitle: Container(
              width: 100,
              height: 10,
              color: Colors.white,
            ),
          ),
        ),
      )
          : Column(
            children: [
              Expanded(
                child: ordersProducts.isEmpty
                    ? const Center(
                  child: Text(
                    "You didn't buy any products yet!!",
                    style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
                  ),
                )
                    : ListView.builder(
                  itemCount: ordersProducts.length,
                  itemBuilder: (context, index) {
                    return OrdersCard(
                      title: ordersProducts[index]["name"],
                      image: ordersProducts[index]["image"],
                      price: ordersProducts[index]["price"],
                      quantity: ordersProducts[index]["quantity"],
                    );
                  },
                ),
              ),
              Card(
                elevation: 5,
                color: AppColors.backgroundColor,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 70,vertical: 15),
                  child: Text("total price: \$$totalPrice",style: TextStyle(color: Colors.blue,fontSize: 20),),
                ),
              )
            ],
          ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_add_to_cart_button/flutter_add_to_cart_button.dart';
import 'package:iti_final_project/consts/app_colors.dart';
import 'package:iti_final_project/consts/app_screen_size.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';

class ProductDetailsScreen extends StatefulWidget {
  const ProductDetailsScreen({super.key, required this.id});

  final int id;

  @override
  State<ProductDetailsScreen> createState() => _ProductDetailsScreenState();
}

class _ProductDetailsScreenState extends State<ProductDetailsScreen> {
  bool loading = false;
  Map product = {};
  AddToCartButtonStateId stateId = AddToCartButtonStateId.idle;
  String? userToken;
  int quantity = 1;

  @override
  void initState() {
    super.initState();
    loadTokenAndFetchProduct();
  }

  Future<void> loadTokenAndFetchProduct() async {
    setState(() {
      loading=true;
    });

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      setState(() {
        userToken = token;
      });
      await fetchProduct();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong, please login again")),
      );
    }
  }

  Future<void> fetchProduct() async {
    try {
      final url = Uri.parse("https://ib.jamalmoallart.com/api/v2/products/${widget.id}/show");
      var response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      var responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseBody["state"] == true) {
          setState(() {
            product = responseBody["data"];
          });
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseBody["message"])),
          );
        }
      } else {
        throw Exception("${responseBody["message"]}");
      }
    } catch (e) {
      debugPrint("$e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong")),
      );
    }

    setState(() {
      loading=false;
    });
  }

  Future<void> addToCart() async {
    if (userToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Something went wrong, please login and try again!!")),
      );
      return;
    }

    final url = Uri.parse("https://ib.jamalmoallart.com/api/v2/carts/add");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "product_id": product["id"],
          "quantity": quantity,
          "token": userToken,
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseBody["state"] == true) {
          showToastWidget(Text(responseBody["message"],style: const TextStyle(color: Colors.blue),),context:context,position: const StyledToastPosition(align: Alignment.bottomCenter));
          setState(() {
            stateId = AddToCartButtonStateId.done;
          });
        }
      } else {
        throw Exception(responseBody["message"]);
      }
    } catch (e) {
      debugPrint("$e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("something went wrong!!")),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Center(
        child: loading
            ? ListView.builder(
          itemCount: 1,
          itemBuilder: (context, index) => Shimmer.fromColors(
            baseColor: AppColors.shimmerBaseColor,
            highlightColor: AppColors.shimmerHighlightColor,
            child: Card(
              elevation: 8,
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Container(
                    width: AppScreenSize.getScreenWidth(context),
                    height: AppScreenSize.getScreenHeight(context) * .6,
                    color: Colors.white,
                  ),
                  Padding(
                    padding: const EdgeInsets.all(16),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        Container(width: 150, height: 20, color: Colors.white),
                        const SizedBox(height: 10),
                        Container(width: double.infinity, height: 15, color: Colors.white),
                        const SizedBox(height: 10),
                        Container(width: 100, height: 20, color: Colors.white),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        )
            : Padding(
          padding: const EdgeInsets.all(15),
          child: Column(
            children: [
              Card(
                elevation: 8,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
                child: Column(
                  children: [
                    ClipRRect(
                      borderRadius: const BorderRadius.vertical(top: Radius.circular(15)),
                      child: Image.network(
                        product["image"],
                        width: AppScreenSize.getScreenWidth(context),
                        height: AppScreenSize.getScreenHeight(context) * .515,
                        fit: BoxFit.cover,
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.symmetric(vertical: 10,horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(product["name"], style: const TextStyle(fontSize: 22),),
                          Text(
                            product["description"],
                            maxLines: 7,
                            overflow: TextOverflow.ellipsis,
                            style: const TextStyle(fontSize: 15),
                          ),
                          Text(
                            "\$${product["price"]}",
                            style: const TextStyle(fontSize: 20, color: Colors.blue),
                          ),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.end,
                            children: [
                              const Text("Quantity      ",style: TextStyle(color: AppColors.appDarkBlue),),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                  children: [
                                    IconButton(onPressed: (){
                                    setState(() {
                                      if(quantity>1){
                                        setState(() {
                                          quantity--;
                                        });
                                      }
                                    });
                                  }, icon: const Icon(Icons.remove,color: AppColors.appBlue,)),
                                    Text("$quantity",style: const TextStyle(color: AppColors.appDarkBlue,fontSize: 18),),
                                    IconButton(onPressed: (){
                                    setState(() {
                                    quantity++;
                                    });
                                    }, icon: const Icon(Icons.add,color: AppColors.appBlue,)),
                                  ],
                                ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 20),
              AddToCartButton(
                trolley: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
                text: const Text(
                  'Add to cart',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 14,color: AppColors.appWhite),
                ),
                check: const SizedBox(
                  width: 48,
                  height: 48,
                  child: Icon(Icons.check, color: Colors.white, size: 24),
                ),
                borderRadius: BorderRadius.circular(24),
                backgroundColor: AppColors.appLightBlue,
                onPressed: (id) {
                  if (id == AddToCartButtonStateId.idle) {
                    addToCart();
                    setState(() {
                      stateId = AddToCartButtonStateId.loading;
                    });
                  }
                },
                stateId: stateId,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

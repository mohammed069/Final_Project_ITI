import 'dart:convert';
import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_add_to_cart_button/flutter_add_to_cart_button.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:iti_final_project/consts/app_colors.dart';
import 'package:iti_final_project/widgets/cart_card.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class CartPage extends StatefulWidget {
  const CartPage({super.key});

  @override
  State<CartPage> createState() => _CartPageState();
}

class _CartPageState extends State<CartPage> {
  List cartProducts = [];
  bool loading = false;
  String? userToken;
  int? deletingId;
  AddToCartButtonStateId stateId = AddToCartButtonStateId.idle;
  List product_ids = [];
  double total=0;

  void _deleteFromCart(){
    setState(() {
      AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.bottomSlide,
        title: 'Delete',
        desc: 'Are you sure?',
        btnCancelOnPress: () {},
        btnOkOnPress: () {
          setState(() {
            fetchDeleteFromCart(userToken!, deletingId!);
          });
        },
      ).show();
    });
  }

  Future<void> _buyCart() async {
    if (userToken == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Login and try again")),
      );
      return;
    }

    final url = Uri.parse("https://ib.jamalmoallart.com/api/v2/carts/checkout");

    try {
      final response = await http.post(
        url,
        headers: {"Content-Type": "application/json"},
        body: jsonEncode({
          "product_ids": product_ids,
          "token": userToken,
        }),
      );

      final responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseBody["state"] == true) {
          showToastWidget(Text(responseBody["message"]),context:context,position: const StyledToastPosition(align: Alignment.center));
          setState(() {
            cartProducts=[];
            stateId = AddToCartButtonStateId.done;
          });
        }
      } else {
        throw Exception(responseBody["message"]);
      }
    } catch (e) {
      debugPrint("======================== $e");
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text("Error Buying Items")),
      );
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    loadTokenAndFetchCart();
  }

  Future<void> loadTokenAndFetchCart() async {
    setState(() => loading = true);

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    if (token != null) {
      setState(() {
        userToken = token;
      });
      await fetchCart(token);
    } else {
      setState(() {
        loading = false;
      });
    }
  }

  Future<void> fetchCart(String token) async {
    try {
      final url = Uri.parse("https://ib.jamalmoallart.com/api/v2/cart?token=$token");
      var response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      var responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseBody["state"] == true) {
          setState(() {
            if(responseBody["data"] is List){
              cartProducts = responseBody["data"];
            }else if(responseBody["data"] is Map){
              cartProducts = responseBody["data"].values.toList();
            }
            for(int i = 0;i<responseBody["data"].length;i++){
                total+=responseBody["data"][i]["total"];
            }
          });
          debugPrint("Cart Response: ${response.body}");
        }
      }
    } catch (e) {
      debugPrint("Error fetching cart: $e");
    }
    setState(() => loading = false);
  }

  Future<void> fetchDeleteFromCart(String token , int id) async {
    try {
      final url = Uri.parse("https://ib.jamalmoallart.com/api/v2/carts/2/remove?id=$id&token=$token");
      var response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      var responseBody = jsonDecode(response.body);

      if(response.statusCode==200 || response.statusCode==201){
        if(responseBody["state"]==true){
          setState(() {
            cartProducts.removeWhere((product) => product["id"] == id);
          });
          showToastWidget(Text(responseBody["message"]),context:context,position: const StyledToastPosition(align: Alignment.center));
        }
      }else{
      showToastWidget(Text("${responseBody["message"]} ${responseBody["data"]}"),context:context,position: const StyledToastPosition(align: Alignment.center));
      }
    } catch (e) {
      debugPrint("Error fetching cart: $e");
    }
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
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
            child: cartProducts.isEmpty
                ? const Center(
              child: Text(
                "Nothing in cart, add some products!",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
              ),
            )
                : ListView.builder(
              itemCount: cartProducts.length,
              itemBuilder: (context, index) {
                /*deletingIndex=index;*/
                product_ids.add(cartProducts[index]["id"]);
                return CartCard(
                  title: cartProducts[index]["name"],
                  image: cartProducts[index]["image"],
                  price: cartProducts[index]["price"],
                  quantity: cartProducts[index]["quantity"],
                  delete: (){
                    deletingId=cartProducts[index]["id"];
                    _deleteFromCart();
                    setState(() {

                    });
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 10),
          cartProducts.isEmpty ? const SizedBox.shrink()
              : AddToCartButton(
            trolley: const Icon(Icons.shopping_cart_outlined, color: Colors.white),
            text:  Text(
              'Buy Now   \$$total',
              textAlign: TextAlign.center,
              style: const TextStyle(fontSize: 14,color: Colors.white),
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
                _buyCart();
                setState(() {
                  stateId = AddToCartButtonStateId.loading;
                });
              }
            },
            stateId: stateId,
          ),
        ],
      ),
    );
  }
}

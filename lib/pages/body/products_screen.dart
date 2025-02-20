import 'package:flutter/material.dart';
import 'package:iti_final_project/consts/app_screen_size.dart';
import 'package:iti_final_project/pages/body/product_details_screen.dart';
import 'package:iti_final_project/widgets/product_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ProductsScreen extends StatefulWidget {
  const ProductsScreen({super.key, required this.id});

  final int id;

  @override
  State<ProductsScreen> createState() => _ProductsScreenState();
}

class _ProductsScreenState extends State<ProductsScreen> {

  bool loading = false;
  List products = [];

  @override
  void initState() {
    super.initState();
    fetchProducts();
  }

  Future<void> fetchProducts() async {
    setState(() {
      loading=true;
    });
    final url=Uri.parse("https://ib.jamalmoallart.com/api/v2/categories/${widget.id}/products");
    var response = await http.get(
      url,
      headers: {'Accept': 'application/json'},
    );
    var responseBody = jsonDecode(response.body);

    if(response.statusCode==200 || response.statusCode==201){
      if(responseBody["state"]==false){
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(responseBody["message"]))
        );
      }
    }else{
      ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text("${responseBody["message"]} ${responseBody["data"]}"))
      );
    }

    setState(() {
      loading=false;
      products = responseBody["data"];
    });

  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: const EdgeInsets.all(15),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              mainAxisExtent: AppScreenSize.getScreenHeight(context)*.3
          ),
          itemCount: products.length,
          itemBuilder: (context,index)=>ProductCard(
            image: products[index]["image"],
            name: products[index]["name"],
            price: products[index]["price"],
            onTap: (){
              Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetailsScreen(id: products[index]["id"],)));
            },
          ),
        ),
      ),
    );
  }
}

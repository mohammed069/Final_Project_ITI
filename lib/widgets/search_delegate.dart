import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:iti_final_project/consts/app_colors.dart';
import 'package:iti_final_project/pages/body/product_details_screen.dart';
import 'dart:convert';
import 'package:shimmer/shimmer.dart';

class MySearchDelegate extends SearchDelegate<String> {
  List products = [];
  bool loading = false;

  Future<void> fetchSearch(String query) async {
    if (query.isEmpty) return;

    loading = true;
    final url = Uri.parse("https://ib.jamalmoallart.com/api/v2/search?name=$query");

    try {
      var response = await http.get(
        url,
        headers: {'Accept': 'application/json'},
      );

      var responseBody = jsonDecode(response.body);

      if (response.statusCode == 200 || response.statusCode == 201) {
        if (responseBody["state"] == true) {
          products = responseBody["data"];
        } else {
          products = [];
        }
      } else {
        products = [];
      }
    } catch (e) {
      debugPrint("Error fetching data: $e");
      products = [];
    }

    loading = false;
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
          products = [];
          showSuggestions(context);
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, '');
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    return buildSuggestions(context);
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    if (query.isEmpty) {
      return const Center(
        child: Text(
          "What Are You Searching about?",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
        ),
      );
    }

    if (loading) {
      return ListView.builder(
        itemCount: 12,
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
      );
    }

    return FutureBuilder(
      future: fetchSearch(query),
      builder: (context, snapshot) {
        if (loading) {
          return ListView.builder(
            itemCount: 6,
            itemBuilder: (context, index) => Shimmer.fromColors(
              baseColor: AppColors.shimmerBaseColor,
              highlightColor: AppColors.shimmerHighlightColor,
              child: ListTile(
                leading: Container(
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(5)
                  ),
                  width: 50,
                  height: 50,
                ),
                title: Container(
                  width: 150,
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
          );
        }

        if (products.isEmpty) {
          return const Center(
            child: Text(
              "No results in products",
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.w500),
            ),
          );
        }

        return ListView.builder(
          itemCount: products.length,
          itemBuilder: (context, index) {
            return ListTile(
              leading: Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10)
                ),
                width: 50,
                height: 50,
                child: Image.network(
                  products[index]["image"],
                  fit: BoxFit.cover,
                ),
              ),
              title: Text(products[index]["name"]),
              subtitle: Text("\$${products[index]["price"]}"),
              onTap: () {
                Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>ProductDetailsScreen(id: products[index]["id"])));
              },
            );
          },
        );
      },
    );
  }
}

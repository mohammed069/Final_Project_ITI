import 'package:flutter/material.dart';
import 'package:iti_final_project/consts/app_colors.dart';
import 'package:iti_final_project/consts/app_screen_size.dart';
import 'package:iti_final_project/pages/body/products_screen.dart';
import 'package:iti_final_project/widgets/category_card.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shimmer/shimmer.dart';

class CategoriesPage extends StatefulWidget {
  const CategoriesPage({super.key});

  @override
  State<CategoriesPage> createState() => _CategoriesPageState();
}

class _CategoriesPageState extends State<CategoriesPage>
    with AutomaticKeepAliveClientMixin {
  @override
  bool get wantKeepAlive => true;

  List categories = [];
  bool loading = false;

  @override
  void initState() {
    super.initState();
    fetchCategories();
  }

  Future<void> fetchCategories() async {
    setState(() {
      loading = true;
    });
    final url = Uri.parse("https://ib.jamalmoallart.com/api/v2/categories");
    var response = await http.get(
      url,
      headers: {'Accept': 'application/json'},
    );
    var responseBody = jsonDecode(response.body);

    if (response.statusCode == 200 || response.statusCode == 201) {
      if (responseBody["state"] == false) {
        ScaffoldMessenger.of(context)
            .showSnackBar(SnackBar(content: Text(responseBody["message"])));
      }
    } else {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
          content: Text("${responseBody["message"]} ${responseBody["data"]}")));
    }

    setState(() {
      loading = false;
      categories = responseBody["data"];
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        backgroundColor: AppColors.backgroundColor,
        body: loading
            ? Center(
                child: Shimmer.fromColors(
                  baseColor: AppColors.appBlue,
                  highlightColor: AppColors.appWhite,
                  child: const Text(
                    'Shopping Store',
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize: 40.0,
                    ),
                  ),
                ),
              )
            : Padding(
                padding: const EdgeInsets.all(15),
                child: GridView.builder(
                  gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 2,
                      mainAxisSpacing: 10,
                      mainAxisExtent:
                          AppScreenSize.getScreenHeight(context) * .27),
                  itemCount: 10,
                  itemBuilder: (context, index) => CategoryCard(
                    onTap: () {
                      Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => ProductsScreen(
                                    id: categories[index]["id"],
                                  )));
                    },
                    image: categories[index]["image"],
                    name: categories[index]["name"],
                  ),
                ),
              ));
  }
}

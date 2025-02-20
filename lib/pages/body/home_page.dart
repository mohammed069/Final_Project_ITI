import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:iti_final_project/consts/app_colors.dart';
import 'package:iti_final_project/consts/app_screen_size.dart';
import 'package:iti_final_project/pages/body/product_details_screen.dart';
import 'package:iti_final_project/widgets/product_card.dart';
import 'package:iti_final_project/widgets/search_delegate.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shimmer/shimmer.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> with AutomaticKeepAliveClientMixin{

  @override
  bool get wantKeepAlive => true;

  List newArrivalProducts=[];
  bool loading= false;
  String? firstName;
  String? lastName;

  @override
  void initState() {
    super.initState();
    fetchNewArrivalProducts();
    loadData();
  }

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    firstName = prefs.getString("firstName");
    lastName = prefs.getString("lastName");
  }




  Future<void> fetchNewArrivalProducts() async {
    setState(() {
      loading=true;
    });
    final url=Uri.parse("https://ib.jamalmoallart.com/api/v2/new_arrival_products");
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
      newArrivalProducts = responseBody["data"];
    });

  }


  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: loading?AppBar(backgroundColor: AppColors.backgroundColor,): AppBar(
        backgroundColor: AppColors.backgroundColor,
        leading: InkWell(
          child: Padding(
            padding: const EdgeInsets.all(5),
            child: ProfilePicture(name: "$firstName $lastName", radius: 5, fontsize: 20),
          ),
          onTap: (){},
        ),
        title: Text(
          "$firstName $lastName",
        style: const TextStyle(
          fontSize: 15,
          fontWeight: FontWeight.w600,
          fontFamily: "puppies"
        ),),
        actions: [
          IconButton(onPressed: (){
            showSearch(context: context, delegate: MySearchDelegate(/*newArrivalProducts*/));
          }, icon: const Icon(Icons.search))
        ],
      ),
      body:loading? Center(child: Shimmer.fromColors(
        baseColor: AppColors.appBlue,
        highlightColor: AppColors.appWhite,
        child: const Text(
          'Shafey Store',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 40.0,
          ),
        ),
      ),):Padding(
        padding: const EdgeInsets.all(15),
        child: GridView.builder(
          gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              mainAxisSpacing: 10,
              mainAxisExtent: AppScreenSize.getScreenHeight(context)*.3
          ),
          itemCount: newArrivalProducts.length,
          itemBuilder: (context,index)=>ProductCard(
              image: newArrivalProducts[index]["image"],
              name: newArrivalProducts[index]["name"],
              price: newArrivalProducts[index]["price"],
              onTap: (){
                Navigator.push(context, MaterialPageRoute(builder: (context)=>ProductDetailsScreen(id: newArrivalProducts[index]["id"])));
        },
          ),
        ),
      )
    );
  }
}

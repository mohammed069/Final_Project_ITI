import 'package:bottom_bar/bottom_bar.dart';
import 'package:flutter/material.dart';
import 'package:iti_final_project/consts/app_colors.dart';
import 'package:iti_final_project/pages/body/cart_page.dart';
import 'package:iti_final_project/pages/body/categories_page.dart';
import 'package:iti_final_project/pages/body/home_page.dart';
import 'package:iti_final_project/pages/body/profile_screen.dart';

class BasicPage extends StatefulWidget {
  const BasicPage({super.key});

  @override
  State<BasicPage> createState() => _BasicPageState();
}

class _BasicPageState extends State<BasicPage> {
  int _currentPage = 0;
  final _pageController = PageController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: PageView(
        controller: _pageController,
        children: const [
          HomePage(),
          CategoriesPage(),
          CartPage(),
          ProfileScreen(),
        ],
        onPageChanged: (index) {
          setState(() => _currentPage = index);
        },
      ),
      bottomNavigationBar: BottomBar(
        selectedIndex: _currentPage,
        onTap: (int index) {
          _pageController.jumpToPage(index);
          setState(() => _currentPage = index);
        },
        items: const <BottomBarItem>[
          BottomBarItem(
            icon: Icon(Icons.home),
            title: Text('Home'),
            activeColor: AppColors.appDarkBlue,
            inactiveIcon: Icon(Icons.home_outlined)
          ),
          BottomBarItem(
            icon: Icon(Icons.category),
            inactiveIcon: Icon(Icons.category_outlined),
            title: Text('Categories'),
            activeColor: AppColors.appDarkBlue,
          ),
          BottomBarItem(
            icon: Icon(Icons.shopping_cart_rounded),
            inactiveIcon: Icon(Icons.shopping_cart_outlined),
            title: Text('Cart'),
            activeColor: AppColors.appDarkBlue,
          ),
          BottomBarItem(
            icon: Icon(Icons.person),
            inactiveIcon: Icon(Icons.person_outlined),
            title: Text('Profile'),
            activeColor: AppColors.appDarkBlue,
          ),
        ],
      ),
    );
  }
}

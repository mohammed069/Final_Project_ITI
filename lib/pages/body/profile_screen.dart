import 'package:awesome_dialog/awesome_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_profile_picture/flutter_profile_picture.dart';
import 'package:iti_final_project/consts/app_colors.dart';
import 'package:iti_final_project/pages/auth/login_page.dart';
import 'package:iti_final_project/pages/body/contact_us_page.dart';
import 'package:iti_final_project/pages/body/orders_page.dart';
import 'package:iti_final_project/widgets/my_list_tile.dart';
import 'package:shared_preferences/shared_preferences.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> with AutomaticKeepAliveClientMixin {
  String? userToken;
  String? firstName;
  String? lastName;
  String? email;

  Future<void> loadData() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      firstName = prefs.getString("firstName");
      lastName = prefs.getString("lastName");
      userToken = prefs.getString('token');
      email = prefs.getString("email");
    });
  }

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> logout() async {
     AwesomeDialog(
        context: context,
        dialogType: DialogType.info,
        animType: AnimType.bottomSlide,
        title: 'Logout?',
        desc: 'We will mess you, don\'t forget us...',
        btnCancelOnPress: () {},
        btnOkOnPress: () async{
          final prefs = await SharedPreferences.getInstance();
          await prefs.remove('token');
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>const LoginPage()));
        },
    ).show();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      body: Column(
        children: [
          const SizedBox(height: 100),
          userToken == null
              ? const Center(
                  child: Text("Not logged in",
                      style: TextStyle(fontSize: 18, color: Colors.red)))
              : Column(
                  children: [
                    ListTile(
                      leading: ProfilePicture(
                          name: "$firstName $lastName",
                          radius: 20,
                          fontsize: 15),
                      title: Text("$firstName $lastName"),
                      subtitle: Text(email!),
                    ),
                    const SizedBox(height: 80),
                    MyListTile(
                      leading: const Icon(Icons.shopping_cart_outlined),
                      title: "My Orders",
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const OrdersPage()));
                      },
                    ),
                    const SizedBox(height: 10),
                    MyListTile(
                      leading: const Icon(Icons.phone),
                      title: "Contact Us",
                      trailing: const Icon(Icons.arrow_forward_ios),
                      onTap: () {
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => const ContactUsPage()));
                      },
                    ),
                    const SizedBox(height: 20),
                    MyListTile(
                        leading: const Icon(Icons.logout_outlined),
                        title: "Logout",
                        trailing: const Icon(Icons.arrow_forward_ios),
                        onTap: () {
                          logout();
                        }),
                  ],
                ),
        ],
      ),
    );
  }
}

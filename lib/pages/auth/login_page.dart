
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:iti_final_project/consts/app_colors.dart';
import 'package:iti_final_project/pages/auth/sign_up.dart';
import 'package:iti_final_project/pages/body/basic_page.dart';
import 'package:iti_final_project/widgets/my_button.dart';
import 'package:iti_final_project/widgets/my_gradient_text.dart';
import 'package:iti_final_project/widgets/my_text_field.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';



class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
  bool loading =false;
  bool loginSuccessfully=false;
  bool _isObsecure = true;



  Future<void> saveData({
    required String firstName,
    required String lastName,
    required String phone,
    required String address,
    required String email,
    required String token,
  }) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString("firstName", firstName);
    await prefs.setString("lastName", lastName);
    await prefs.setString("phone", phone);
    await prefs.setString("address", address);
    await prefs.setString("email", email);
    await prefs.setString('token', token);
  }


  Future<void> loginUser() async{
    setState(() {
      loading=true;
    });

    final url = Uri.parse("https://ib.jamalmoallart.com/api/v2/login");

    final response= await http.post(
        url,
        headers: {"Content-Type":"application/json"},
        body: jsonEncode({
          "email":_emailController.text,
          "password":_passwordController.text
        })
    );

    final responseBody = jsonDecode(response.body);

    if(response.statusCode==200 || response.statusCode==201){
      if(responseBody["state"]==true){
        await saveData(
          firstName: responseBody["data"]["first_name"],
          lastName: responseBody["data"]["last_name"],
          phone: responseBody["data"]["phone"],
          address: responseBody["data"]["address"],
          email: responseBody["data"]["email"],
          token:responseBody["data"]["token"]
        );
        setState(() {
          loginSuccessfully=true;
        });
      }
    }else{
    showToastWidget(Text("${responseBody["message"]} ${responseBody["data"]}",style: TextStyle(color: Colors.red),),context:context);
    }
    setState(() {
      loading=false;
    });

  }




  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  const SizedBox(height: 40,),
                  const Align(
                    alignment: Alignment.topLeft,
                    child: MyGradientText(
                        fontSize: 30,
                        text: 'Login',
                        colors: [
                          Color(0XFF0C386C),
                          Color(0XFF294F97),
                        ]
                    ),
                  ),
                  const SizedBox(height: 30),
                  MyTextField(
                    text: 'Email',
                    controller: _emailController,
                    validator: (val){
                      if(val!.isEmpty){
                        return "You must Enter Your Email";
                      }else if(!RegExp("^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\\.[a-zA-Z]{2,}\$").hasMatch(val)){
                        return "Enter a valid Email";
                      }
                    },
                  ),//email
                  const SizedBox(height: 20),
                  MyTextField(
                    isObscure: _isObsecure,
                    suffixIcon: IconButton(onPressed: (){
                      setState(() {
                        _isObsecure = !_isObsecure;
                      });
                    }, icon: _isObsecure?const Icon(Icons.visibility_off,color: AppColors.appLightBlue,):const Icon(Icons.visibility,color: AppColors.appLightBlue,)),
                    text: 'Password',
                    controller: _passwordController,
                    validator: (val){
                      if(val!.isEmpty){
                        return "You must Enter password";
                      }
                    },
                  ),//password
                  const SizedBox(height: 30),
                  loading?const CircularProgressIndicator(color: Colors.blue,):
                  MyButton(
                    onPressed: ()async {
                      FocusScope.of(context).unfocus();
                      if ((_formKey.currentState!.validate())){
                        await loginUser();
                      if (loginSuccessfully) {

                          Navigator.pushReplacement(context, MaterialPageRoute(
                          builder: (context)=>const BasicPage(
                          )
                      ));
                        } else {
                          _formKey.currentState!.validate();
                        }
                      }else{
                        _formKey.currentState!.validate();
                      }
                    },

                    text: 'Login',
                  ),
                  const SizedBox(height: 30),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Don't have an account?",
                        style: TextStyle(
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(width: 4),
                      InkWell(
                        onTap: () {
                          FocusScope.of(context).unfocus();
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) => SignUpPage()),
                          );
                        },
                        child: const Text(
                          'Sign Up',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}




import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter_styled_toast/flutter_styled_toast.dart';
import 'package:iti_final_project/consts/app_colors.dart';
import 'package:iti_final_project/pages/auth/login_page.dart';
import 'package:iti_final_project/widgets/my_button.dart';
import 'package:iti_final_project/widgets/my_gradient_text.dart';
import 'package:iti_final_project/widgets/my_text_field.dart';
import 'package:http/http.dart' as http;


class SignUpPage extends StatefulWidget {
   const SignUpPage({super.key});

  @override
  State<SignUpPage> createState() => _SignUpPageState();
}

class _SignUpPageState extends State<SignUpPage> {


  final GlobalKey<FormState> _formKey = GlobalKey();
  final TextEditingController _firstNameController = TextEditingController();
  final TextEditingController _lastNameController = TextEditingController();
  final TextEditingController _phoneController = TextEditingController();
  final TextEditingController _addressController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
   bool _isObsecure = true;
   bool loading = false;
   bool registeredSuccessfully = false;

  Future<void> registerUser() async{
    setState(() {
      loading=true;
    });

    final url = Uri.parse("https://ib.jamalmoallart.com/api/v2/register");

    final response= await http.post(
        url,
        headers: {"Content-Type":"application/json"},
        body: jsonEncode({
          "first_name":_firstNameController.text,
          "last_name":_lastNameController.text,
          "phone":_phoneController.text,
          "address":_addressController.text,
          "email":_emailController.text,
          "password":_passwordController.text
        })
    );

    final responseBody = jsonDecode(response.body);

    if(response.statusCode==200 || response.statusCode==201){
      if(responseBody["state"]==true){
        showToastWidget(Text(responseBody["message"]),context:context);
        setState(() {
          registeredSuccessfully=true;
        });
      }
    }else{
    showToastWidget(Text("${responseBody["message"]} ${responseBody["data"]}"),context:context);
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
          padding: const EdgeInsets.all(20.0),
          child: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  const SizedBox(height: 20,),
                  const MyGradientText(
                      fontSize: 30,
                      text: 'Sign Up',
                      colors: [
                        Color(0XFF0C386C),
                        Color(0XFF294F97),
                      ]
                  ),
                  const SizedBox(height: 18),
                  MyTextField(
                    text: 'First Name',
                    controller: _firstNameController,
                    validator: (val){
                      if(val!.isEmpty){
                        return "You must Enter Your first Name";
                      }
                    },
                  ),//firstName
                  const SizedBox(height: 18),
                  MyTextField(
                    text: 'Last Name',
                    controller: _lastNameController,
                    validator: (val){
                      if(val!.isEmpty){
                        return "You must Enter Your last Name";
                      }
                    },
                  ),//lastName
                  const SizedBox(height: 18),
                  MyTextField(
                    text: 'Phone',
                    controller: _phoneController,
                    validator: (val){
                      if(val!.isEmpty){
                        return "You must Enter Your Phone";
                      }
                    },
                  ),//phone
                  const SizedBox(height: 18),
                  MyTextField(
                    text: 'Address',
                    controller: _addressController,
                    validator: (val){
                      if(val!.isEmpty){
                        return "You must Enter Your Address";
                      }
                    },
                  ),//address
                  const SizedBox(height: 18),
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
                  const SizedBox(height: 18),
                  MyTextField(
                    isObscure: _isObsecure,
                    suffixIcon: IconButton(onPressed: (){
                      setState(() {
                        _isObsecure = !_isObsecure;
                      });
                    }, icon: _isObsecure? const Icon(Icons.visibility_off,color: AppColors.appLightBlue):const Icon(Icons.visibility,color: AppColors.appLightBlue,)),
                    text: 'Password',
                    controller: _passwordController,
                    validator: (val){
                      if(val!.isEmpty){
                        return "You must Enter password";
                      }
                    },
                  ),//password
                  const SizedBox(height: 18,),
                  loading?const Center(child: CircularProgressIndicator(color: Colors.blue,)):
                  MyButton(
                    onPressed: () async{
                        FocusScope.of(context).unfocus();
                        if(_formKey.currentState!.validate()){
                          await registerUser();
                          if(registeredSuccessfully){
                            Navigator.push(context, MaterialPageRoute(
                                builder: (context)=>const LoginPage()
                            ));
                          }
                        }else{
                          _formKey.currentState!.validate();
                        }
                    },
                    text: 'Sign Up',
                  ),
                  const SizedBox(height: 18,),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text(
                        "Already a User? ",
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
                                builder: (context) => const LoginPage()),
                          );
                        },
                        child: const Text(
                          'Login',
                          style: TextStyle(
                            color: Colors.blue,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
                    ],
                  ),//already a user
                  const SizedBox(height: 18,),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}



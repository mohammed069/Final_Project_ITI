import 'package:flutter/material.dart';
import 'package:flutter_add_to_cart_button/flutter_add_to_cart_button.dart';
import 'package:iti_final_project/consts/app_colors.dart';


class ContactUsPage extends StatefulWidget {
  const ContactUsPage({super.key});

  @override
  _ContactUsPageState createState() => _ContactUsPageState();
}

class _ContactUsPageState extends State<ContactUsPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _messageController = TextEditingController();
  AddToCartButtonStateId stateId = AddToCartButtonStateId.idle;


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundColor,
      appBar: AppBar(backgroundColor: AppColors.backgroundColor,),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration:  InputDecoration(
                      labelText: "Full Name",
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                    )
                  ),
                  validator: (val){
                    if(val!.isEmpty){
                      return "Enter your full name";
                    }
                  }
                    ),
                const SizedBox(height: 20),
                TextFormField(
                    controller: _emailController,
                    decoration:  InputDecoration(
                        labelText: "Email",
                        border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(10),
                    ),),
                    keyboardType: TextInputType.emailAddress,
                    validator: (val){
                    if (val == null || val.isEmpty) {
                    return "Email is required";
                    }else if (!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(val)) {
                    return "Enter a valid email";
                    }
                    },
                    ),
                const SizedBox(height: 20),
                TextFormField(
                    controller: _messageController,
                    decoration: InputDecoration(
                        labelText: "Message",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(10),),
                    ),
                    maxLines: 4,
                    validator: (val){
                      if(val!.isEmpty){
                        return "You didn't write a message!!";
                      }
                    },
                    ),
                const SizedBox(height: 20),
                AddToCartButton(
                  trolley: const Icon(Icons.email_outlined, color: Colors.white),
                  text: const Text(
                    'Send',
                    textAlign: TextAlign.center,
                    style: TextStyle(fontSize: 14),
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
                      if(_formKey.currentState!.validate()){
                        setState(() {
                          stateId = AddToCartButtonStateId.loading;
                          Future.delayed(Duration(seconds: 3),(){
                            setState(() {
                              stateId = AddToCartButtonStateId.done;
                              _emailController.text='';
                              _nameController.text='';
                              _messageController.text='';
                            });
                          });
                        });
                      }
                    }
                  },
                  stateId: stateId,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}


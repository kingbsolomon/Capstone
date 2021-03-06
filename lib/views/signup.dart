import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:login_test/helper/helperFunctions.dart';
import 'package:login_test/helper/theme.dart';
import 'package:login_test/services/database.dart';
import 'package:login_test/views/feed.dart';
import 'package:login_test/widgets/widget.dart';
import 'package:login_test/services/auth.dart';
import 'package:login_test/views/chatRoomsScreen.dart';


class SignUp extends StatefulWidget {
  final Function toggle;
  SignUp(this.toggle);

  @override
  _SignUpState createState() => _SignUpState();
}

class _SignUpState extends State<SignUp> {

  final formKey = GlobalKey<FormState>();
  TextEditingController userNameController = new TextEditingController();
  TextEditingController emailController = new TextEditingController();
  TextEditingController passwordController = new TextEditingController();

  AuthService authService = new AuthService();
  DatabaseMethods databaseMethods = new DatabaseMethods();
  bool isLoading = false;

  singUp() async {

    if(formKey.currentState.validate()){
      setState(() {
        isLoading = true;
      });

      await authService.signUpWithEmailAndPassword(emailController.text,
          passwordController.text).then((result) {
        if (result != null) {
          Map<String, String> userDataMap = {
            "name": userNameController.text,
            "email": emailController.text
          };

          databaseMethods.addUserInfo(userDataMap);

          HelperFunctions.saveUserLoggedInSharedPreference(true);
          HelperFunctions.saveUserEmailSharedPreference(emailController.text);
          HelperFunctions.saveUserNameSharedPreference(userNameController.text);


          Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) => UserFeed()
          ));
        }
      }
      );
  }
      }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarMain(context),
      body: isLoading ? loadingScreen(): Container(
        padding: EdgeInsets.symmetric(horizontal: 25),
        child: Column(
          children: [
            Spacer(),
            Form(
              key: formKey,
              child: Column(
                children: [
                  TextFormField(
                    validator: (value){
                        return value.isEmpty || value.length < 4 ? "Please Enter A User Name" : null;
                    },
                    controller: userNameController,
                    style: TextStyle(
                        color: Colors.white
                    ),
                    decoration: textFieldInputDecoration("User Name"),
                  ),
                  TextFormField(
                    validator: (value1){
                      return validEmail(value1)? null: "Please Enter A Valid Email Address";
                    },
                    controller: emailController,
                    style: TextStyle(
                        color: Colors.white
                    ),
                    decoration: textFieldInputDecoration("Email"),
                  ),
                  TextFormField(
                    obscureText: true,
                    validator: (value2){
                      return value2.isEmpty ||value2.length < 6 ? "Please Enter A Password (At Least 6 Characters)" : null;
                    },
                    controller: passwordController,
                    style: TextStyle(
                        color: Colors.white
                    ),
                    decoration: textFieldInputDecoration("Password"),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8,),
            Container(
              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.centerRight,
              child: Text('Forgot Password?',style: simpleTextStyle()),
            ),
            SizedBox(height: 16,),
            GestureDetector(
              onTap:(){
              singUp();
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 16),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    gradient: LinearGradient(
                        colors: [
                          Colors.deepPurple,
                          Colors.deepPurpleAccent,
                        ]
                    ),
                    borderRadius: BorderRadius.circular(30)
                ),
                child: Text("Sign Up", style: biggerTextStyle(),
                textAlign: TextAlign.center,
                ),
              ),
            ),
            SizedBox(height: 16,),
            GestureDetector(
              onTap:(){

                //TODO
              },
              child: Container(
                alignment: Alignment.center,
                padding: EdgeInsets.symmetric(vertical: 16),
                width: MediaQuery.of(context).size.width,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                  color: Colors.white
                ),
                child: Text("Sign Up With Google", style: TextStyle(fontSize: 17, color: CustomTheme.textColor),
                    textAlign: TextAlign.center)),
              ),
            SizedBox(height: 16,),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Text("Already have an account? ", style: TextStyle(color:Colors.white)),
                GestureDetector(
                  onTap: (){
                    widget.toggle();
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 8),
                      child: Text("Sign In", style: TextStyle(color:Colors.white, decoration: TextDecoration.underline,)
                      ),
                   ),
                ),
              ],
            ),

          ],
        ),
      ),
    );
  }
}







import 'package:char_app/helper/show_snack_bar.dart';
import 'package:char_app/pages/chat_page.dart';
import 'package:char_app/widgets/custom_button.dart';
import 'package:char_app/widgets/custom_text_filed.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class RegisterPage extends StatefulWidget {
  RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  String? email;
  String? password;
  bool isLoading = false;
  String? username;
  GlobalKey<FormState> formKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor:const  Color.fromARGB(255, 31, 63, 107),
        body: Padding(
          padding:const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
               const SizedBox(height: 75),
                Image.asset(
                  'assets/scholar.png',
                  height: 100,
                ),
                const Center(
                  child: Text(
                    'Scholar Chat',
                    style: TextStyle(
                        fontSize: 30,
                        color: Colors.white,
                        fontFamily: 'pacifico'),
                  ),
                ),
                const SizedBox(height: 45),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Sign Up',
                      style: TextStyle(
                        fontSize: 24,
                        color: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomFormTextFiled(
                  onchanged: (data) {
                    email = data;
                  },
                  hintText: 'Email',
                ),
                const SizedBox(height: 10),
                CustomFormTextFiled(
                  onchanged: (data) {
                    username = data;
                  },
                  hintText: 'User Name',
                ),
                const SizedBox(height: 10),
                CustomFormTextFiled(
                  obscureText: true,
                  onchanged: (data) {
                    password = data;
                  },
                  hintText: 'Password',
                ),
                const SizedBox(height: 10),
                CustomButton(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      setState(() {
                        isLoading = true;
                      });

                      // if (email == null || password == null) {
                      //   showSnackbar(
                      //       context, 'Please enter email and password', false);
                      //   setState(() {
                      //     isLoading = false;
                      //   });
                      //   return;
                      // }

                      try { 
                         bool  exituser = await searchUsername(username!);
                        var auth = FirebaseAuth.instance;

                       

                    
                      if(exituser){ 
                        await registerUser(auth);
                        Navigator.push(
                          context,

                          MaterialPageRoute(
                            builder: (context) {
                              return ChatPage(
                                email: email,
                                username: username,
                              );
                            },
                          ),
                        );
                      }
                      else {
                        showSnackbar(context, 'Username already Used');
                      }
                      }
                       on FirebaseAuthException catch (e) {
                        if (e.code == "weak-password") {
                          showSnackbar(context, 'Weak password');
                        } else if (e.code == "email-already-in-use") {
                          showSnackbar(
                              context, 'This email is already used');
                        }
                      } catch (ex) {
                        showSnackbar(context, '$ex');
                      }
                      setState(() {
                        isLoading = false;
                      });
                    }
                  },
                  text: 'Sign Up',
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Already have an account?",
                      style: TextStyle(
                        fontSize: 16,
                        color: Colors.white,
                      ),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.pop(context);
                      },
                      child: const Text(
                        '   Sign In',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
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
    );
  }

  Future<UserCredential> registerUser(FirebaseAuth auth) async {
    return await auth.createUserWithEmailAndPassword(
        email: email!, password: password!);
  }
}
Future<bool> searchUsername(String username ) async {
  // Reference to the 'username' collection
  CollectionReference users = FirebaseFirestore.instance.collection('messages');

  // Query to search for documents where the field 'username' matches the provided username
  QuerySnapshot querySnapshot =
      await users.where('username', isEqualTo: username).get();

// QuerySnapshot querySnapshot2 =
//       await users.where('id', isEqualTo: email).get();
  // Check if any documents were found
  if (querySnapshot.docs.isNotEmpty) { 
    return false; // Return true if a user is found
  } else {
    return true; // Return false if no user is found
  }
}


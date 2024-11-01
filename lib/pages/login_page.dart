import 'dart:developer';
import 'package:char_app/helper/show_snack_bar.dart';
import 'package:char_app/pages/chat_page.dart';
import 'package:char_app/pages/register.dart';
import 'package:char_app/widgets/constants.dart';
import 'package:char_app/widgets/custom_button.dart';
import 'package:char_app/widgets/custom_text_filed.dart';
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:modal_progress_hud_nsn/modal_progress_hud_nsn.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({
    super.key,
  });

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  bool isLoading = false;
  String? email;
  String? password;
  String? username;

  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return ModalProgressHUD(
      inAsyncCall: isLoading,
      child: Scaffold(
        backgroundColor: kprimaryColor,
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 10),
          child: Form(
            key: formKey,
            child: ListView(
              children: [
                const SizedBox(height: 75),
                Image.asset(kLogo, height: 100),
                const Center(
                  child: Text(
                    'Scholar Chat',
                    style: TextStyle(
                      fontSize: 30,
                      color: Colors.white,
                      fontFamily: 'pacifico',
                    ),
                  ),
                ),
                const SizedBox(height: 45),
                const Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(
                      'Sign In',
                      style: TextStyle(fontSize: 24, color: Colors.white),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                CustomFormTextFiled(
                  onchanged: (data) => email = data,
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
                  onchanged: (data) => password = data,
                  hintText: 'Password',
                ),
                const SizedBox(height: 10),
                CustomButton(
                  onTap: () async {
                    if (formKey.currentState!.validate()) {
                      setState(() => isLoading = true);

                      try {
                        var auth = FirebaseAuth.instance;
                        await signInUser(auth);
                        // Navigator.pushNamed(context, ChatPage.id, arguments: email);
                        bool exituser = await searchUsername(username!, email!);
                        
                        if (exituser ) {
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
                        } else {
                          showSnackbar(
                              context, 'this user name not found ');
                              setState(() {
                                
                              });
                        }
                      } on FirebaseAuthException catch (e) {
                        if (e.code == 'user-not-found') {
                          showSnackbar(
                              // ignore: use_build_context_synchronously
                              context, 'This user was not found');
                        } else if (e.code == 'wrong-password') {
                          showSnackbar(context, 'Wrong password');
                        }
                      } catch (ex) {
                        showSnackbar(context, ex.toString());
                      } finally {
                        setState(() => isLoading = false);
                      }
                    }
                  },
                  text: 'Sign In',
                ),
                const SizedBox(height: 10),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    const Text(
                      "Don't have an account?",
                      style: TextStyle(fontSize: 16, color: Colors.white),
                    ),
                    GestureDetector(
                      onTap: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => RegisterPage()),
                        );
                      },
                      child: const Text(
                        '   Sign Up',
                        style: TextStyle(fontSize: 16, color: Colors.white),
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

  Future<UserCredential> signInUser(FirebaseAuth auth) async {
    return await auth.signInWithEmailAndPassword(
      email: email!,
      password: password!,
    );
  }
}

Future<bool> searchUsername(String username , String email) async {
  // Reference to the 'username' collection
  CollectionReference users = FirebaseFirestore.instance.collection('messages');

  // Query to search for documents where the field 'username' matches the provided username
  QuerySnapshot querySnapshot =
      await users.where('username', isEqualTo: username).get();

QuerySnapshot querySnapshot2 =
      await users.where('id', isEqualTo: email).get();
  // Check if any documents were found
  if (querySnapshot.docs.isNotEmpty) {
    // for (var doc in querySnapshot.docs) {
    //     log('No user found with the username: $username');
    //     // print('User found: ${doc.data()}');
    //   return true;

    // }
    String id1=querySnapshot.docs.first.id;
    String id2=querySnapshot2.docs.first.id;
    log('ID :${querySnapshot.docs.first.id}');
     log('ID2 :${querySnapshot2.docs.first.id}');
     if(id1==id2){
      return true;
     }
     else
    return false; // Return true if a user is found
  } else {
    return false; // Return false if no user is found
  }
}

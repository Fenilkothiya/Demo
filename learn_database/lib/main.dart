import 'dart:developer';

import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:learn_database/learnProvider.dart';
import 'package:provider/provider.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  runApp(
    
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (contex) => Counter()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(),
        home: const LearnProvider());
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    getData();
  }

  List groupList = [];
  void getData() {
    print("hello");
    firebaseFirestore.collection("User").get().then((value) {
      setState(() {
        groupList = value.docs;
        print(groupList[0]["name"]);
      });
    });
  }

  FirebaseFirestore firebaseFirestore = FirebaseFirestore.instance;

  void logOut() async {
    final GoogleSignIn signIn = GoogleSignIn();
    signIn.signOut();
    signIn.disconnect();
  }

  void Googlesignin() async {
    final GoogleSignIn signIn = GoogleSignIn();
    GoogleSignInAccount? _signinAccount = await signIn.signIn();
    FirebaseAuth _auth = FirebaseAuth.instance;
    log("2");

    if (_signinAccount != null) {
      log("222222");
      GoogleSignInAuthentication auth = await _signinAccount.authentication;
      AuthCredential authCredential = GoogleAuthProvider.credential(
          accessToken: auth.accessToken, idToken: auth.idToken);
      UserCredential credential =
          await _auth.signInWithCredential(authCredential);

      if (credential.user != null) {
        print("sucseseseseseseses");
        // and than after we have to create a collection (FirebaseFirestore) and set a data ..
        // and than a navigation to Home page ..

        await firebaseFirestore.collection("User").doc("1").set({
          "name": _auth.currentUser!.displayName,
          "emailId": _auth.currentUser!.email
        }).then((value) {
          print("dataaaaaaaa Set ");
        });

        // await firebaseFirestore.collection("User").doc("1").delete();
      } else {
        print("bakaiakaiaiaiaiia");
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemCount: groupList.length,
        itemBuilder: (context, index) {
          if (groupList != null) {
            return Column(
              children: [
                Text(
                  groupList[index]["name"].toString(),
                  style: const TextStyle(fontSize: 30, color: Colors.black),
                ),
                Text(groupList[index]["emailId"].toString()),
              ],
            );
          } else {
            return const CircularProgressIndicator();
          }
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          print("1");

          setState(() {
            //  logOut();
            Googlesignin();
          });
        },
      ),
    );
  }
}

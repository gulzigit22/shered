// ignore: avoid_web_libraries_in_flutter

import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shered/app_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(),
    );
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
  var emailController = TextEditingController();
  var passwordController = TextEditingController();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    cheakLogin();
  }

  void cheakLogin() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    String? val = pref.getString('login');
    if (val != null) {
      // ignore: use_build_context_synchronously
      Navigator.of(context).pushAndRemoveUntil(
          MaterialPageRoute(builder: (context) => const AppPage()),
          (route) => false);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(),
      body: Padding(
        padding: EdgeInsets.all(15.0),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              const Text(
                'login',
                style: TextStyle(fontSize: 40),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: emailController,
                decoration: const InputDecoration(
                    labelText: 'Email',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.email)),
              ),
              const SizedBox(height: 20),
              TextFormField(
                controller: passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                    labelText: 'Password',
                    border: OutlineInputBorder(),
                    suffixIcon: Icon(Icons.password)),
              ),
              const SizedBox(height: 20),
              OutlinedButton.icon(
                onPressed: () {
                  login();
                },
                label: const Text(''),
                icon: const Icon(Icons.login),
              )
            ],
          ),
        ),
      ),
    );
  }

  void login() async {
    if (passwordController.text.isNotEmpty && emailController.text.isNotEmpty) {
      var response = await http.post(
          Uri.parse("https://reqres.in/api/register"),
          body: ({
            "email": emailController.text,
            "password": passwordController.text
          }));
      if (response.statusCode == 200) {
        final body = jsonDecode(response.body);

        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(" token  : ${body['token']}")));

        pageRoute(body['token']);
      } else {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context)
            .showSnackBar(const SnackBar(content: Text("Invalid Credentials")));
      }
    } else {
      ScaffoldMessenger.of(context)
          .showSnackBar(const SnackBar(content: Text('бош маани табылды')));
    }
  }

  void pageRoute(String token) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.setString('login', token);
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const AppPage()),
        (route) => false);
  }
}

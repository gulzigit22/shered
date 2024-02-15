import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:shered/main.dart';

class AppPage extends StatefulWidget {
  const AppPage({super.key});

  @override
  State<AppPage> createState() => _AppPageState();
}

class _AppPageState extends State<AppPage> {
  String token = '';
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCread();
  }

  void getCread() async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    setState(() {
      token = pref.getString('login')!;
    });
  }

  void valueClear(BuildContext context) async {
    SharedPreferences pref = await SharedPreferences.getInstance();
    await pref.clear();
    // ignore: use_build_context_synchronously
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(builder: (context) => const MyHomePage()),
        (route) => false);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.yellow,
      appBar: AppBar(
        backgroundColor: Colors.red,
        title: ElevatedButton.icon(
          onPressed: () {
            valueClear(context); // Pass the context here
          },
          icon: const Icon(Icons.clear),
          label: const Text('Clear'),
        ),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text('welcom'),
            Text('token : ${token}'),
          ],
        ),
      ),
    );
  }
}

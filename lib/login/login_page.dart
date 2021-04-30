import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uchina_schedule/login/login_model.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<LoginModel>(
      create: (_) => LoginModel(),
      child: Scaffold(
        appBar: AppBar(title: Text("ログインページ")),
        body: Consumer<LoginModel>(builder: (context, model, child) {
          return Padding(
            padding: EdgeInsets.all(16.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                TextField(
                  controller: emailController,
                  decoration: InputDecoration(
                    labelText: "Email",
                  ),
                ),
                TextField(
                  controller: passwordController,
                  decoration: InputDecoration(
                    labelText: "Password",
                  ),
                ),
                SizedBox(height: 36.0),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await model.login(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim());
                      _showDialog(context, 'ログイン');
                    } catch (e) {
                      _showDialog(context, e.toString());
                    }
                  },
                  child: Text("Sign in"),
                )
              ],
            ),
          );
        }),
      ),
    );
  }

  _showDialog(BuildContext context, String title) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(title),
          actions: [
            ElevatedButton(
              child: Text('OK'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            )
          ],
        );
      },
    );
  }
}

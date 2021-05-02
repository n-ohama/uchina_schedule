import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uchina_schedule/login/login_model.dart';
import 'package:uchina_schedule/login/register_page.dart';

class LoginPage extends StatelessWidget {
  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final List errorList = [
    'パスワードが間違っています。',
    'そのメールアドレスのユーザーは見つかりません。',
    'メールアドレスの書き方が違います。'
  ];

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
                SizedBox(height: 16),
                Container(
                  width: double.infinity,
                  child: InkWell(
                    child: Text(
                      'まだアカウントを持ってない？',
                      textAlign: TextAlign.right,
                      style: TextStyle(color: Colors.blue),
                    ),
                    onTap: () => Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => RegisterPage(),
                      ),
                    ),
                  ),
                ),
                SizedBox(height: 36.0),
                ElevatedButton(
                  onPressed: () async {
                    try {
                      await model.login(
                          email: emailController.text.trim(),
                          password: passwordController.text.trim());
                      _showDialog(context, 'ログイン完了！');
                    } catch (e) {
                      String errorContent = '';
                      if (e.code == 'wrong-password')
                        errorContent = errorList[0];
                      if (e.code == 'user-not-found')
                        errorContent = errorList[1];
                      if (e.code == 'invalid-email')
                        errorContent = errorList[2];
                      _showDialog(context, errorContent);
                    }
                  },
                  child: Text("ログイン"),
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

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uchina_schedule/login/register_model.dart';

class RegisterPage extends StatelessWidget {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();
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

  @override
  Widget build(BuildContext context) {
    return ChangeNotifierProvider<RegisterModel>(
      create: (_) => RegisterModel(),
      child: Scaffold(
          appBar: AppBar(title: Text('新規登録ページ')),
          body: Consumer<RegisterModel>(builder: (context, model, child) {
            return Padding(
              padding: EdgeInsets.all(16.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  TextField(
                    controller: _emailController,
                    decoration: InputDecoration(
                      labelText: "Email",
                    ),
                  ),
                  TextField(
                    controller: _passwordController,
                    decoration: InputDecoration(
                      labelText: "Password",
                    ),
                  ),
                  SizedBox(height: 16),
                  Container(
                    width: double.infinity,
                    child: InkWell(
                      child: Text(
                        'もうすでにアカウントを持っている？',
                        textAlign: TextAlign.right,
                        style: TextStyle(color: Colors.blue),
                      ),
                      onTap: () => Navigator.of(context).pop(),
                    ),
                  ),
                  SizedBox(height: 36.0),
                  ElevatedButton(
                    onPressed: () async {
                      try {
                        await model.register(
                            email: _emailController.text.trim(),
                            password: _passwordController.text.trim());
                        Navigator.of(context).pop();
                        _showDialog(context, '登録完了！');
                      } catch (e) {
                        _showDialog(context, e.code);
                      }
                    },
                    child: Text("新規登録"),
                  )
                ],
              ),
            );
          })),
    );
  }
}

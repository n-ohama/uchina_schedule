import 'package:flutter/material.dart';

class FirstPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ListView.builder(
        itemBuilder: (_, i) => Container(
          child: Column(
            children: [
              ListTile(
                leading: Icon(Icons.bookmark_add_outlined),
                title: Text('hello world'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

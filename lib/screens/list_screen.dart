import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';
import 'package:uchina_schedule/model/todos.dart';
import 'package:uchina_schedule/screens/add_screen.dart';
import 'package:uchina_schedule/screens/detail_screen.dart';
import 'package:uchina_schedule/widgets/mycard_widget.dart';

class ListScreen extends StatefulWidget {
  @override
  _ListScreenState createState() => _ListScreenState();
}

class _ListScreenState extends State<ListScreen> {
  bool _isLoading = true;
  @override
  void initState() {
    Provider.of<Todos>(context, listen: false).fetchItems().then((_) {
      _isLoading = false;
      setState(() {});
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final todoList = Provider.of<Todos>(context).items;
    return Scaffold(
      appBar: AppBar(title: Text('予定リスト')),
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(builder: (_) => AddScreen()),
          );
        },
      ),
      body: Container(
        decoration: BoxDecoration(
          image: DecorationImage(image: const AssetImage('assets/images/bgImage.png')),
        ),
        child: todoList.length == 0
            ? Container(
                alignment: Alignment.center,
                child: Text(_isLoading ? '' : '下の+ボタンから予定を追加'),
              )
            : Container(
                padding: EdgeInsets.only(top: 8),
                child: ListView.builder(
                  itemCount: todoList.length,
                  itemBuilder: (_, i) => Slidable(
                    actionPane: SlidableBehindActionPane(),
                    child: InkWell(
                      onTap: () {
                        Navigator.of(context).push(
                          MaterialPageRoute(builder: (_) => DetailScreen(todo: todoList[i])),
                        );
                      },
                      onLongPress: () {},
                      child: MyCard(todoList: todoList, index: i),
                    ),
                    secondaryActions: [
                      IconSlideAction(
                        caption: '削除',
                        color: Colors.red,
                        icon: Icons.delete,
                        onTap: () {
                          showDialog(
                            context: context,
                            builder: (ctx) => AlertDialog(
                              title: Text('削除'),
                              content: Text('スケジュールを削除しますか？'),
                              actions: [
                                TextButton(
                                  child: Text('キャンセル'),
                                  onPressed: () {
                                    Navigator.of(ctx).pop();
                                  },
                                ),
                                TextButton(
                                  child: Text('削除する'),
                                  onPressed: () {
                                    Provider.of<Todos>(context, listen: false).removeItem(todoList[i].id);
                                    Navigator.of(ctx).pop();
                                  },
                                ),
                              ],
                            ),
                          );
                        },
                      )
                    ],
                  ),
                ),
              ),
      ),
    );
  }
}

// child: Column(
//   children: [
//     Card(
//       shadowColor: Colors.black54,
//       color: todoList[i].isFavorite
//           ? Colors.teal[300]!.withOpacity(0.5)
//           : Colors.white,
//       // : Colors.white.withOpacity(0.8),
//       child: Column(
//         mainAxisSize: MainAxisSize.min,
//         children: [
//           ListTile(
//             leading: IconButton(
//               padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
//               icon: Icon(
//                 Icons.star_outline_rounded,
//                 color: todoList[i].isFavorite ? Colors.white : null,
//               ),
//               onPressed: () {
//                 Provider.of<Todos>(context, listen: false)
//                     .toggleIsFavorite(todoList[i].id);
//               },
//             ),
//             title: Text(
//               todoList[i].title,
//               overflow: TextOverflow.ellipsis,
//               maxLines: 1,
//             ),
//             onTap: () {
//               Navigator.of(context).push(
//                 MaterialPageRoute(builder: (context) => DetailScreen()),
//               );
//             },
//           ),
//           UsefulButtons(todoList: todoList, index: i),
//         ],
//       ),
//     ),
//   ],
// ),
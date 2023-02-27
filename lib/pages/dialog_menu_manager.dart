/*年轻人，只管向前看，不要管自暴自弃者的话*/

import 'package:flutter/material.dart';
import 'package:images/pages/datas/IndexData.dart';
import 'package:images/pages/datas/search_menu.dart';
import 'package:images/pages/views/buttons.dart';

///create by itz on 2022/11/18 14:52
///desc :
class MenuManagerPage extends StatefulWidget {
  const MenuManagerPage({Key? key, required this.indexData}) : super(key: key);
  final IndexData indexData;

  List<SearchMenu> get menus => indexData.menuData.menus();

  @override
  State<MenuManagerPage> createState() => _MenuManagerPageState();
}

class _MenuManagerPageState extends State<MenuManagerPage> with SingleTickerProviderStateMixin {
  late AnimationController _animationController;

  @override
  void initState() {
    _animationController = AnimationController(vsync: this, duration: const Duration(milliseconds: 300));
    _animationController.forward(from: 0);
    super.initState();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 36),
      child: Stack(
        children: [
          //关闭按钮
          Row(
            children: [
              const Spacer(),
              StyleButton(
                  onPressed: () {
                    Navigator.pop(context);
                  },
                  child: const Icon(Icons.close)),
            ],
          ),

          Align(
              alignment: Alignment.topRight,
              child: SizeTransition(
                  sizeFactor: _animationController,
                  axis: Axis.horizontal,
                  axisAlignment: 0.0,
                  child: Container(
                    padding: const EdgeInsets.all(12),
                    decoration: const BoxDecoration(
                      color: Colors.black54,
                      borderRadius: BorderRadius.only(topLeft: Radius.circular(12), bottomLeft: Radius.circular(12)),
                    ),
                    margin: const EdgeInsets.only(top: 36),
                    child: ConstrainedBox(
                        constraints: const BoxConstraints(maxWidth: 320),
                        child: Column(
                          children: [
                            Expanded(
                                child: ReorderableListView.builder(
                                    itemBuilder: (context, index) {
                                      return Container(
                                          padding: const EdgeInsets.all(12),
                                          margin: const EdgeInsets.only(bottom: 4),
                                          decoration: BoxDecoration(
                                              color: Colors.white, borderRadius: BorderRadius.circular(8)),
                                          key: Key(widget.menus[index].sortKey.toString()),
                                          child: Row(children: [
                                            Expanded(
                                                child: Text(
                                              "${index + 1}   ${widget.menus[index].showText}",
                                              style: const TextStyle(fontSize: 16, color: Colors.black),
                                            )),
                                            StyleButton(
                                                onPressed: () {
                                                  _deleteMenu(widget.menus[index]);
                                                },
                                                child: const Icon(
                                                  Icons.delete,
                                                  color: Colors.red,
                                                )),
                                            const SizedBox(width: 48),
                                          ]));
                                    },
                                    itemCount: widget.menus.length,
                                    onReorder: (oldIndex, newIndex) {
                                      if (oldIndex < newIndex) {
                                        newIndex -= 1;
                                      }
                                      var temp = widget.menus.removeAt(oldIndex);
                                      widget.menus.insert(newIndex, temp);
                                      widget.indexData.menuData
                                        ..save()
                                        ..notify();
                                      setState(() {});
                                    }))
                          ],
                        )),
                  )))
        ],
      ),
    );
  }

  void _deleteMenu(SearchMenu menu) {
    setState(() {
      widget.indexData.deleteMenu(menu);
    });
  }
}

import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';

class BasicExample extends StatefulWidget {
  const BasicExample({Key? key}) : super(key: key);

  @override
  State createState() => _BasicExample();
}

class _BasicExample extends State<BasicExample> {
  List<DragAndDropList> _contents = [];

  @override
  void initState() {
    super.initState();
  }

  pushIntoList() {
    _contents.add(DragAndDropList(
      header: Row(
        children: <Widget>[
          const Expanded(
            flex: 1,
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text('Header'),
          ),
          const Expanded(
            flex: 1,
            child: Divider(),
          ),
        ],
      ),
      children: <DragAndDropItem>[
        DragAndDropItem(
          child: Text('item'),
        ),
      ],
    ));
  }

  @override
  Widget build(BuildContext context) {
    var deviceWidth = MediaQuery.of(context).size.width;
    pushIntoList();
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        ),
        foregroundColor: Theme.of(context).colorScheme.surface,
        backgroundColor: Color(0xFF4FC3F7),
        onPressed: () {
          pushIntoList();
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
        child: DragAndDropLists(
          children: _contents,
          onItemReorder: _onItemReorder,
          onListReorder: _onListReorder,
        ),
      ),
    );
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedItem = _contents[oldListIndex].children.removeAt(oldItemIndex);
      _contents[newListIndex].children.insert(newItemIndex, movedItem);
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = _contents.removeAt(oldListIndex);
      _contents.insert(newListIndex, movedList);
    });
  }
}

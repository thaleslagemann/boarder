import 'package:drag_and_drop_lists/drag_and_drop_lists.dart';
import 'package:flutter/material.dart';

class HeaderStructure {
  final int id;
  final String name;
  late DragAndDropList content;

  HeaderStructure(
      {required this.id, required this.name, required this.content});
}

class BasicExample extends StatefulWidget {
  const BasicExample({Key? key}) : super(key: key);

  @override
  State createState() => _BasicExample();
}

class _BasicExample extends State<BasicExample> {
  List<DragAndDropList> _contents = [];
  List<HeaderStructure> headers = [];
  static Size screenSize = WidgetsBinding.instance.window.physicalSize;
  double width = screenSize.width;
  double height = screenSize.height;
  final TextEditingController _textFieldController = TextEditingController();
  String newHeaderName = '';

  @override
  void initState() {
    super.initState();
  }

  bool containsElement(List<HeaderStructure> list, elementToCheck) {
    for (var element in list) {
      if (element.id == elementToCheck) {
        return true;
      }
    }
    return false; // Element not found in any pair
  }

  int getSequentialID(List<HeaderStructure> list, int id) {
    if (containsElement(list, id)) {
      id = id + 1;
      return getSequentialID(list, id);
    }
    return id;
  }

  Future<void> _displayTextInputDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: const Text('New header name'),
            content: TextField(
              onChanged: (value) {
                setState(() {
                  newHeaderName = value;
                });
              },
              controller: _textFieldController,
              decoration: const InputDecoration(hintText: "Header name"),
            ),
            actions: <Widget>[
              TextButton(
                style: TextButton.styleFrom(foregroundColor: Colors.red),
                child: const Text('cancel'),
                onPressed: () {
                  setState(() {
                    Navigator.pop(context);
                  });
                },
              ),
              TextButton(
                child: const Text('ok'),
                onPressed: () {
                  setState(() {
                    newHeaderName = _textFieldController.text;
                    print(newHeaderName);
                    pushHeaderIntoList(newHeaderName);
                    newHeaderName = '';
                    _textFieldController.clear();
                    Navigator.pop(context);
                  });
                },
              ),
            ],
          );
        });
  }

  pushHeaderIntoList(String headerName) {
    DragAndDropList content = generateHeader(headerName);
    headers.add(HeaderStructure(
        id: getSequentialID(headers, 0), name: headerName, content: content));
    for (var i = 0; i < headers.length; i++) {
      print('[${headers[i].id}, ${headers[i].name}]');
    }
  }

  pushItemIntoHeader(int headerIndex) {
    headers[headerIndex].content.children.add(
          DragAndDropItem(
            child: Row(
              children: [
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(left: 15.0, top: 10.0),
                      child: Text('item'),
                    ),
                  ],
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    SizedBox(
                      width: WidgetsBinding.instance.window.physicalSize.width *
                          0.27,
                    )
                  ],
                ),
                Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      IconButton(
                          onPressed: () => setState(() {}),
                          icon: Icon(Icons.keyboard_arrow_down_sharp)),
                    ])
              ],
            ),
          ),
        );
  }

  generateHeader(String headerName) {
    return DragAndDropList(
      header: Row(
        children: <Widget>[
          const Expanded(
            flex: 1,
            child: Divider(),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            child: Text(headerName),
          ),
          const Expanded(
            flex: 1,
            child: Divider(),
          ),
        ],
      ),
      children: <DragAndDropItem>[],
    );
  }

  List<DragAndDropList> listHeaders() {
    List<DragAndDropList> list = [];
    for (var element in headers) {
      list.add(element.content);
    }
    return list;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.all(Radius.circular(50.0)),
        ),
        foregroundColor: Theme.of(context).colorScheme.surface,
        backgroundColor: Color(0xFF4FC3F7),
        onPressed: () {
          _displayTextInputDialog(context);
          print(newHeaderName);
        },
        child: Icon(Icons.add),
      ),
      body: SafeArea(
          child: DragAndDropLists(
        children: listHeaders(),
        onItemReorder: _onItemReorder,
        onListReorder: _onListReorder,
      )),
    );
  }

  _onItemReorder(
      int oldItemIndex, int oldListIndex, int newItemIndex, int newListIndex) {
    setState(() {
      var movedItem =
          headers[oldListIndex].content.children.removeAt(oldItemIndex);
      headers[newListIndex].content.children.insert(newItemIndex, movedItem);
    });
  }

  _onListReorder(int oldListIndex, int newListIndex) {
    setState(() {
      var movedList = headers.removeAt(oldListIndex);
      headers.insert(newListIndex, movedList);
    });
  }
}

import 'package:flutter/material.dart';
import '../model/models.dart';
import '../testData/data.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        primarySwatch: Colors.blueGrey,
      ),
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  ///-----------  variables
  //people list
  List<Items> dataAtScreen = [];
  //list controller
  final myScrollController = ScrollController();
  //activate search
  bool search = false;
  //value from textFormfield
  final _controllerText = TextEditingController();

  ///---------- Methods
  //Allows do any when appear the screen
  @override
  void initState() {
    super.initState();
    loadData();
  }

  // allow show the information on screen
  void loadData() {
    dataAtScreen = data;
    setState(() {});
  }

  //search items
  void searchItem(String value) {
    dataAtScreen = data
        .where((element) =>
            element.name.toLowerCase().contains(value.toLowerCase()) ||
            element.age.toString().contains(value))
        .toList();
    setState(() {});
  }

  ///----------- UI
  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: () {
          FocusScope.of(context).unfocus();
          search = false;
        },
        child: Scaffold(
          appBar: AppBar(
            backgroundColor: const Color.fromARGB(255, 135, 181, 232),
            title: !search
                ? const Text("My Test App")
                : TextField(
                    controller: _controllerText,
                    onChanged: (value) {
                      searchItem(value);
                    },
                    decoration: InputDecoration(
                        suffix: _controllerText.text.isEmpty
                            ? null
                            : IconButton(
                                onPressed: () {
                                  _controllerText.text = "";
                                  searchItem("");
                                },
                                icon: const Icon(Icons.cancel))),
                  ),
            actions: <Widget>[
              IconButton(
                  onPressed: () {
                    search = true;
                    setState(() {});
                  },
                  icon: const Icon(Icons.search))
            ],
          ),
          body: dataAtScreen.isNotEmpty
              ? SingleChildScrollView(
                  controller: myScrollController,
                  // padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 15),
                  child: SizedBox(
                    width: MediaQuery.of(context).size.width,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: dataAtScreen
                            .map((e) => cardInformation(e, context))
                            .toList()),
                  ))
              : Center(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const CircularProgressIndicator(),
                      const SizedBox(
                        height: 10,
                      ),
                      search ? const Text("Empty") : const Text("Loading...")
                    ],
                  ),
                ),

          // This trailing comma makes auto-formatting nicer for build methods.
        ));
  }

  //Card information about each person
  Widget cardInformation(Items i, BuildContext context) {
    return InkWell(
        onTap: () {
          showAlertDialog(i, context);
        },
        child: SizedBox(
            width: MediaQuery.of(context).size.width / 2,
            child: Card(
                color: Color.fromARGB(255, 173, 206, 225),
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 10, horizontal: 10),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      const Icon(Icons.person_outline),
                      Text(
                        i.name,
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      Text("Age: ${i.age}")
                    ],
                  ),
                ))));
  }

  //Alert dialog
  void showAlertDialog(Items i, BuildContext context) {
    AlertDialog alert = AlertDialog(
      scrollable: true,
      content: contentDialog(i, context),
      actions: [
        TextButton(
          child: const Text("Close"),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return alert;
      },
    );
  }

  //Card information about each person
  Widget contentDialog(Items i, BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        const Center(
          child: Icon(
            Icons.person_outline,
            size: 40,
          ),
        ),
        const SizedBox(
          height: 15,
        ),
        Text(
          "Name: ${i.name}",
          style: const TextStyle(fontWeight: FontWeight.bold),
        ),
        const SizedBox(
          height: 15,
        ),
        Text("Age: ${i.age}"),
        const SizedBox(
          height: 15,
        ),
        const Text(
          "Hobbies:",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(i.hobbies),
        const SizedBox(
          height: 15,
        ),
        const Text(
          "Description:",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        Text(i.description),
      ],
    );
  }
}

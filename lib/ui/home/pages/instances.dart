import 'package:flutter/material.dart';

class InstancesPage extends StatelessWidget {
  const InstancesPage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[900],
      appBar: AppBar(
        backgroundColor: Colors.grey[900],
        elevation: 1.0,
        title: Text('Instances'),
      ),
      body: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ChoiceChip(label: Icon(Icons.menu_rounded), selected: true),
              SizedBox(width: 4.0),
              ChoiceChip(label: Icon(Icons.apps_rounded), selected: false),
            ],
          ),
          InstanceListView(),
        ],
      ),
    );
  }
}

class InstanceListView extends StatelessWidget {
  const InstanceListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}

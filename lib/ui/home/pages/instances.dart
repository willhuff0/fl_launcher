import 'package:flutter/material.dart';

class InstancesPage extends StatefulWidget {
  const InstancesPage({Key? key}) : super(key: key);

  @override
  State<InstancesPage> createState() => _InstancesPageState();
}

class _InstancesPageState extends State<InstancesPage> {
  var listView = true;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //backgroundColor: Colors.grey[900],
      appBar: AppBar(
        //backgroundColor: Colors.grey[900],
        //elevation: 1.0,
        title: Text('Instances'),
        flexibleSpace: Align(
          alignment: Alignment.centerRight,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              ChoiceChip(
                label: Icon(Icons.menu_rounded),
                selected: listView,
                onSelected: (value) {
                  if (value) setState(() => listView = true);
                },
              ),
              SizedBox(width: 4.0),
              ChoiceChip(
                label: Icon(Icons.apps_rounded),
                selected: !listView,
                onSelected: (value) {
                  if (value) setState(() => listView = false);
                },
              ),
              SizedBox(width: 18.0),
            ],
          ),
        ),
      ),
      body: InstanceListView(),
    );
  }
}

class InstanceListView extends StatelessWidget {
  const InstanceListView({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: EdgeInsets.only(top: 12.0, bottom: 12.0, right: 12.0),
      itemBuilder: (context, index) => InstanceListTile(
        title: 'OptiFabric',
        onLaunchPressed: () {},
        onMorePressed: () {},
        //onUpdatePressed: index.isEven ? () {} : null,
      ),
      itemCount: 44,
    );
  }
}

class InstanceListTile extends StatelessWidget {
  final String title;
  final VoidCallback onLaunchPressed;
  final VoidCallback onMorePressed;
  final VoidCallback? onUpdatePressed;

  const InstanceListTile({super.key, required this.title, required this.onLaunchPressed, required this.onMorePressed, this.onUpdatePressed});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.0),
      child: Card(
        child: SizedBox(
          height: 100.0,
          child: Padding(
            padding: const EdgeInsets.all(14.0),
            child: Row(
              children: [
                Container(
                  height: 70.0,
                  width: 70.0,
                  decoration: BoxDecoration(
                    color: Theme.of(context).colorScheme.surface,
                    borderRadius: BorderRadius.circular(8.0),
                  ),
                ),
                SizedBox(width: 12.0),
                Column(
                  children: [
                    Text(title, style: Theme.of(context).textTheme.titleMedium),
                  ],
                ),
                Expanded(child: Container()),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.end,
                  children: [
                    if (onUpdatePressed != null) ...[
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Container(
                                width: 44.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Center(child: Text('1.0.2')),
                              ),
                              SizedBox(width: 18.0, child: Icon(Icons.arrow_forward_rounded, size: 16.0)),
                              Container(
                                width: 44.0,
                                height: 30.0,
                                decoration: BoxDecoration(
                                  color: Theme.of(context).colorScheme.surfaceTint.withOpacity(0.1),
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Center(child: Text('1.0.3')),
                              ),
                            ],
                          ),
                          SizedBox(height: 6.0),
                          FilledButton.tonalIcon(
                            style: ButtonStyle(
                              backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.surfaceTint.withOpacity(0.1)),
                              padding: MaterialStatePropertyAll(EdgeInsets.zero),
                              minimumSize: MaterialStatePropertyAll(Size(110.0, 35.0)),
                              maximumSize: MaterialStatePropertyAll(Size(110.0, 35.0)),
                              shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
                            ),
                            onPressed: () {},
                            icon: Icon(Icons.cloud_download_rounded, size: 18.0),
                            label: Text('Update'),
                          ),
                        ],
                      ),
                      SizedBox(width: 6.0),
                    ],
                    FilledButton.tonal(
                      style: ButtonStyle(
                        backgroundColor: MaterialStatePropertyAll(Theme.of(context).colorScheme.surfaceTint.withOpacity(0.1)),
                        padding: MaterialStatePropertyAll(EdgeInsets.zero),
                        minimumSize: MaterialStatePropertyAll(Size(30.0, 70.0)),
                        maximumSize: MaterialStatePropertyAll(Size(30.0, 70.0)),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
                      ),
                      onPressed: () {},
                      child: Icon(Icons.more_vert_rounded),
                    ),
                    SizedBox(width: 6.0),
                    FilledButton.tonal(
                      style: ButtonStyle(
                        padding: MaterialStatePropertyAll(EdgeInsets.zero),
                        minimumSize: MaterialStatePropertyAll(Size(70.0, 70.0)),
                        maximumSize: MaterialStatePropertyAll(Size(70.0, 70.0)),
                        shape: MaterialStatePropertyAll(RoundedRectangleBorder(borderRadius: BorderRadius.circular(8.0))),
                      ),
                      onPressed: () {},
                      child: Icon(Icons.play_arrow_rounded),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

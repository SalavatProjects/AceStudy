import 'package:flutter/material.dart';

import '../functions/api.dart';

class GuidePage extends StatefulWidget {
  const GuidePage({super.key});

  @override
  _GuidePageState createState() => _GuidePageState();
}

class _GuidePageState extends State<GuidePage> {

  int? _expandedItemIndex;
  ScrollController _scrollController = new ScrollController();

  Future<List> _getGuide() async {
    return await Api.getGuide();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: 
      FutureBuilder(
        future: _getGuide(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          if (snapshot.hasData) {
            List guide = snapshot.data;
            // print(snapshot.data[0]['title']);
            return Padding(
              padding: EdgeInsets.symmetric(vertical: 8.0, horizontal: 16.0),
              child: ListView(
                controller: _scrollController,
                shrinkWrap: true,
                children: [ExpansionPanelList(
                  expansionCallback: (int panelIndex, bool isExpanded) {
                    setState(() {
                      if (isExpanded)
                      {
                        _expandedItemIndex = panelIndex;
                        _scrollController.animateTo(panelIndex * _scrollController.position.viewportDimension, 
                        duration: Duration(microseconds: 1500), 
                        curve: Curves.easeOut);
                      } else {
                        _expandedItemIndex = null;
                      }
                    });
                  },
                  children: [
                    for (var i = 0; i < guide.length; i++)
                      ExpansionPanel(headerBuilder: (context, isExpanded) {
                        return ListTile(
                          title: Text(guide[i]['title']),
                        );
                        // Text(guide[i]['title']);
                      }, body: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(guide[i]['content']),
                      ),
                      isExpanded: _expandedItemIndex == i)
                  ],
                )],
              ),
            );
          } else {
            return Center(
              child: CircularProgressIndicator(),
            );
          }
        },
        )),
    );
  }
}
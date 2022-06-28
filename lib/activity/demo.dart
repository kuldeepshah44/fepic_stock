import 'package:flutter/material.dart';
import 'package:lazy_load_scrollview/lazy_load_scrollview.dart';

class DemoScroll extends StatefulWidget {
  @override
  _DemoState createState() => _DemoState();
}

class _DemoState extends State<DemoScroll> {

  List<int> verticalData = [];
  List<int> horizontalData = [];

  final int increment = 10;

  bool isLoadingVertical = false;
  bool isLoadingHorizontal = false;
int loadData=10;
  int page=1;
  @override
  void initState() {
   // _loadMoreVertical();

    super.initState();
  }

  Future _loadMoreVertical() async {
    setState(() {
      isLoadingVertical = true;
      page=page+1;
      print("page===${page}");
      loadData=loadData+10;
    });

    // Add in an artificial delay
    await new Future.delayed(const Duration(seconds: 2));

    verticalData.addAll(
        List.generate(increment, (index) => verticalData.length + index));

    setState(() {
      isLoadingVertical = false;
    });
  }



  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Demo"),
      ),
      body: LazyLoadScrollView(
        isLoading: isLoadingVertical,
        onEndOfPage: () => _loadMoreVertical(),
        child: Scrollbar(
          child: ListView(
            children: [

              ListView.builder(
                shrinkWrap: true,
                physics: NeverScrollableScrollPhysics(),
                itemCount: loadData,
                itemBuilder: (context, position) {
                  print("postion===${position}");
                  return Container(child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Text("${position}",style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20),),
                  ),);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

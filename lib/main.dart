import 'package:flutter/material.dart';
import 'package:flutter_ijkplayer/flutter_ijkplayer.dart';

void main() {
  runApp(new MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: MainPage(),
    );
  }
}

class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  IjkMediaController controller = IjkMediaController();
  double speed = 1;
  static List<String> urls = [
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ElephantsDream.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerBlazes.mp4',
    'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/ForBiggerEscapes.mp4'
  ];
  int currentIndex = 0;

  @override
  initState() {
    super.initState();
    setUpResources();
  }

  Future<void> setUpResources() async {
    await controller.setNetworkDataSource(urls[currentIndex], autoPlay: true);
    await controller.setSpeed(speed);
    print("set data source success");
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final playBackSpeed = Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        RaisedButton(
          onPressed: () {
            if (speed > 0.25) {
              speed = speed - 0.25;
            }
            setState(() {
              controller.setSpeed(speed);
            });
          },
          child: Icon(Icons.indeterminate_check_box),
        ),
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text('$speed'),
        ),
        RaisedButton(
          onPressed: () {
            speed = speed + 0.25;
            setState(() {
              controller.setSpeed(speed);
            });
          },
          child: Icon(Icons.add),
        ),
      ],
    );
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            color: Colors.red,
            width: MediaQuery.of(context).size.width,
            height: 250,
            child: IjkPlayer(
              mediaController: controller,
              statusWidgetBuilder: _buildStatusWidget,
              controllerWidgetBuilder: _buildControllerWidget,
            ),
          ),
          playBackSpeed,
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              RaisedButton(
                onPressed: () {
                  if (currentIndex > 0) {
                    currentIndex = currentIndex - 1;

                  setState(() async {
                    await controller.setNetworkDataSource(
                      urls[currentIndex],

                    );
await                    controller.setSpeed(speed);

                  });
                }},
                child: Icon(Icons.skip_previous),
              ),
              RaisedButton(
                onPressed: () {
                  if(currentIndex<urls.length-1){
                  currentIndex = currentIndex + 1;
                  setState(() async {
                    await controller.setNetworkDataSource(
                      urls[currentIndex],
                    );
                    controller.setSpeed(speed);
                  });
                }},
                child: Icon(Icons.skip_next),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusWidget(
      BuildContext context, IjkMediaController controller, IjkStatus status) {
    if (status == IjkStatus.complete) {
      return Center(
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: <Widget>[
            Icon(Icons.skip_previous),
            Icon(Icons.refresh),
            Icon(Icons.skip_next),
          ],
        ),
      );
    }
    return IjkStatusWidget.buildStatusWidget(context, controller, status);
  }

  Widget _buildControllerWidget(IjkMediaController controller) {
    return DefaultIJKControllerWidget(
      controller: controller,
      doubleTapPlay: true,
    );
  }
}

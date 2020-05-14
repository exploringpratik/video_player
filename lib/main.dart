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

  @override
  initState() {
    super.initState();
    setUpResources();
  }

  Future<void> setUpResources() async {
    await controller.setNetworkDataSource(
      'https://commondatastorage.googleapis.com/gtv-videos-bucket/sample/BigBuckBunny.mp4',
      autoPlay: true,
    );
    await controller.playOrPause();
    controller.setSpeed(speed);

    print("set data source success");
  }

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Plugin example app'),
      ),
      body: Column(
        children: <Widget>[
          Container(
//            width: MediaQuery.of(context).size.width,
            height: 250,
            child: IjkPlayer(
              mediaController: controller,
            ),
          ),
          Row(
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
          )
        ],
      ),
    );
  }
}

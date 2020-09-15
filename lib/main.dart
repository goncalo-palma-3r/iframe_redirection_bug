import 'dart:html';
import 'dart:ui' as ui;

import 'package:flutter/material.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: HomePage(uri: "https://flutter.dev/"),
    );
  }
}

class HomePage extends StatefulWidget {
  final String uri;

  HomePage({Key key, this.uri}) : super(key: key);

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  Widget iframeWidget;

  final IFrameElement iframeElement = new IFrameElement();

  String _currentUri;

  @override
  void initState() {
    super.initState();
    _initializeState();

    _currentUri = widget.uri;

    WidgetsBinding.instance.addPostFrameCallback((timeStamp) {
      _checkCurrentUri().listen((newUri) {
        print("New URI: $newUri");
      });
    });
  }

  Stream<String> _checkCurrentUri() {
    return Stream.periodic(Duration(milliseconds: 200), (_) {
      var iFrame = iframeElement;
      if (iFrame == null) {
        return "";
      }
      var iFrameUri = iFrame.src;

      if (_currentUri == iFrameUri) {
        return '';
      }

      // Retrieve current element by id
      var iFrameElementById = document.getElementById('iframe_id');

      if (iFrameElementById != null) {
        print("We have discovered a new element by id");
      }

      print("Src has changed");

      return _currentUri = iFrameUri;
    }).where((event) => event.isNotEmpty);
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _initializeState() {
    print("IFrame code: ${widget.uri}");
    iframeElement.src = widget.uri;
    iframeElement.id = "iframe_id";
    iframeElement.width = '100%';
    iframeElement.height = '100%';
    iframeElement.style.border = 'none';

    iframeElement.onLoadedData.listen((event) {
      print("======= onLoadedData");
      print(event.composedPath());

      print("onLoadedData =======");
    });

    iframeElement.onChange.listen((event) {
      print("======= onChange");
      print(event.composedPath());

      print("onChange =======");
    });

    iframeElement.onLoad.listen((event) {
      print("======= onLoad");
      print(event.composedPath());

      for (var i in event.composedPath()) {
        if (i is ShadowRoot) {
          print(i);
          print(i.innerHtml);
          print(i.baseUri);
          print(i.ownerDocument.text);
          print("Text: ${i.text}");
          print("iFrame src: ${iframeElement.src}");
        }
      }

      print("onLoad =======");
    });

    // ignore: undefined_prefixed_name
    ui.platformViewRegistry.registerViewFactory(
      "47",
      (int viewId) => iframeElement,
    );

    iframeWidget = HtmlElementView(
      key: UniqueKey(),
      viewType: "47",
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Iframe Widget"),
      ),
      body: Center(
        child: Container(
          child: iframeWidget,
        ),
      ),
    );
  }
}
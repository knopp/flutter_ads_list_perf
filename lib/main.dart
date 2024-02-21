import 'dart:io';

import 'package:pixel_snap/material.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';

import 'my_ad.dart';

void main() {
  AdWidget.optOutOfVisibilityDetectorWorkaround = true;
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Ads Perf',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: const MyHomePage(title: 'Flutter Ads Perf'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key, required this.title});

  // This widget is the home page of your application. It is stateful, meaning
  // that it has a State object (defined below) that contains fields that affect
  // how it looks.

  // This class is the configuration for the state. It holds the values (in this
  // case the title) provided by the parent (in this case the App widget) and
  // used by the build method of the State. Fields in a Widget subclass are
  // always marked "final".

  final String title;

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final List<int> adIndexes = <int>[1, 3, 5, 7, 9, 10, 12, 14, 18];
  final int totalItems = 25;
  final List<int> colorCodes = <int>[600, 500, 100];

  final controller = ScrollController(); // scroll controller from PixelSnap

  final String _adUnitId = Platform.isAndroid
      ? 'ca-app-pub-3940256099942544/6300978111'
      : 'ca-app-pub-3940256099942544/2934735716';

  BannerAd getBanner(int index) {
    var bannerAd = BannerAd(
      adUnitId: _adUnitId,
      request: const AdRequest(),
      size: AdSize.mediumRectangle,
      listener: BannerAdListener(
        // Called when an ad is successfully received.
        onAdLoaded: (ad) {},
        // Called when an ad request failed.
        onAdFailedToLoad: (ad, err) {},
        // Called when an ad opens an overlay that covers the screen.
        onAdOpened: (Ad ad) {},
        // Called when an ad removes an overlay that covers the screen.
        onAdClosed: (Ad ad) {},
        // Called when an impression occurs on the ad.
        onAdImpression: (Ad ad) {},
      ),
    );

    bannerAd.load();
    return bannerAd;
  }

  Widget getAdWidget(int index) {
    var bannerAd = getBanner(index);
    var adWidget = MyAdWidget(ad: bannerAd);
    return adWidget;
  }

  Widget buildItem(int index) {
    if (adIndexes.contains(index)) {
      return getAdWidget(index);
    }

    final String text = 'Entry $index';
    final Color color = Colors.amber[colorCodes[index % colorCodes.length]]!;

    return Container(
        height: 100,
        color: color,
        child: Center(
            child: Text(
          text,
          style: Theme.of(context).textTheme.headlineMedium,
        )));
  }

  Widget buildList() {
    return ListView.builder(
        controller: controller,
        itemCount: totalItems,
        itemBuilder: (BuildContext context, int index) {
          return buildItem(index);
        });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        // Make sure that app bar height is pixel snapped, as it affects the layout below.
        toolbarHeight: 44.pixelSnap(PixelSnap.of(context)),
        backgroundColor: Theme.of(context).colorScheme.inversePrimary,
        title: Text(widget.title),
      ),
      body: buildList(),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:google_mobile_ads/google_mobile_ads.dart';

class MyAdWidget extends StatefulWidget {

  final BannerAd ad;

  const MyAdWidget ({ Key? key, required this.ad }): super(key: key);

  @override
  State<MyAdWidget> createState() {
    return _MyAdWidgetState();
  }

}

class _MyAdWidgetState extends State<MyAdWidget> with AutomaticKeepAliveClientMixin {

  // Keep alive the Ad to avoid reloading it while scrolling
  @override
  bool get wantKeepAlive => true;

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Align(
      alignment: Alignment.bottomCenter,
      child: SafeArea(
        child: SizedBox(
          width: 300,
          height: 150,
          child: AdWidget(ad: widget.ad),
        ),
      ),
    );

  }
}

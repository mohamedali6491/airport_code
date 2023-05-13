import 'package:airports_code/db_helper.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:google_mobile_ads/google_mobile_ads.dart';
// ignore: depend_on_referenced_packages
import 'package:package_info_plus/package_info_plus.dart';
import 'ad_helper.dart';

class Apui extends StatefulWidget {
  const Apui({super.key});

  @override
  State<Apui> createState() => _ApuiState();
}

class _ApuiState extends State<Apui> {
  BannerAd? _banner;
  int? _value = 1;
  final search = ['iata', 'icao', 'name', 'location'];
  String searchBy = 'iata';
  final _controller = TextEditingController();
  bool isDatabaseReady = false;
  DatabaseHelper db = DatabaseHelper();
  String version = '';
  String code = '';
  void packinfo() async {
    PackageInfo packageInfo = await PackageInfo.fromPlatform();
    version = packageInfo.version;
    code = packageInfo.buildNumber;
  }

  // PackageInfo _packageInfo = PackageInfo(
  //   appName: 'Unknown',
  //   packageName: 'Unknown',
  //   version: 'Unknown',
  //   buildNumber: 'Unknown',
  //   buildSignature: 'Unknown',
  // );

  @override
  void initState() {
    super.initState();
    db.initDatabase();
    _createBannerAd();
    packinfo();
  }

  void _createBannerAd() {
    _banner = BannerAd(
      size: AdSize.largeBanner,
      adUnitId: AdService.bannerAdUnitId!,
      listener: AdService.bannerLisrener,
      request: const AdRequest(),
    )..load();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey[200],
      body: SafeArea(
        child: SingleChildScrollView(
          child: Center(
            child:
                Column(mainAxisAlignment: MainAxisAlignment.start, children: [
              Column(
                children: [
                  _banner == null
                      ? Container()
                      : SizedBox(
                          height: 120,
                          child: AdWidget(ad: _banner!),
                        ),
                ],
              ),
              const SizedBox(
                height: 40.0,
              ),
              Text(
                "Airport Code",
                style: GoogleFonts.bebasNeue(
                  fontSize: 52,
                ),
              ),
              const SizedBox(
                height: 40.0,
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 25.0),
                child: Container(
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    border: Border.all(color: Colors.white),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(left: 20.0),
                    child: TextField(
                      controller: _controller,
                      decoration: const InputDecoration(
                        border: InputBorder.none,
                        hintText: 'Search',
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Padding(
                    padding: EdgeInsets.only(left: 20.0),
                    child: Text(
                      'Serach by: ',
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Padding(
                        padding: const EdgeInsets.only(left: 70.0),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                          children: [
                            Row(
                              children: [
                                Radio(
                                    value: 1,
                                    groupValue: _value,
                                    onChanged: (value) {
                                      setState(() {
                                        _value = value;
                                        searchBy = search[_value! - 1];
                                      });
                                    }),
                                const Text(
                                  "IATA",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                    value: 2,
                                    groupValue: _value,
                                    onChanged: (value) {
                                      setState(() {
                                        _value = value;
                                        searchBy = search[_value! - 1];
                                      });
                                    }),
                                const Text(
                                  "ICAO",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 50.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Radio(
                                    value: 3,
                                    groupValue: _value,
                                    onChanged: (value) {
                                      setState(() {
                                        _value = value;
                                        searchBy = search[_value! - 1];
                                      });
                                    }),
                                const Text(
                                  "Airport",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                            Row(
                              children: [
                                Radio(
                                    value: 4,
                                    groupValue: _value,
                                    onChanged: (value) {
                                      setState(() {
                                        _value = value;
                                        searchBy = search[_value! - 1];
                                      });
                                    }),
                                const Text(
                                  "Location",
                                  style: TextStyle(fontWeight: FontWeight.bold),
                                ),
                              ],
                            ),
                          ],
                        ),
                      )
                    ],
                  ),
                  const SizedBox(
                    height: 20,
                  ),
                  TextButton(
                    onPressed: () {
                      showModalBottomSheet(
                        isScrollControlled: true,
                        shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                                top: Radius.circular(20))),
                        context: context,
                        builder: (BuildContext context) {
                          return SizedBox(
                            height: 400,
                            child: Center(
                              child: FutureBuilder(
                                future:
                                    db.getApcode(searchBy, _controller.text),
                                builder: (BuildContext context,
                                    AsyncSnapshot<List<AP>> snapshot) {
                                  if (!snapshot.hasData ||
                                      _controller.text == '' ||
                                      snapshot.data!.isEmpty) {
                                    return const Center(
                                      child: Text('No data selected'),
                                    );
                                  } else {
                                    return ListView(
                                      children: snapshot.data!.map((ap) {
                                        return Padding(
                                          padding: const EdgeInsets.fromLTRB(
                                              10, 20, 10, 10),
                                          child: Center(
                                            child: Column(
                                              mainAxisAlignment:
                                                  MainAxisAlignment.spaceEvenly,
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Text('IATA: ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18)),
                                                    Text(ap.iata,
                                                        style: const TextStyle(
                                                            color: Colors.black,
                                                            fontSize: 16)),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Text('ICAO: ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18)),
                                                    Text(
                                                      ap.icao,
                                                      style: const TextStyle(
                                                        color: Colors.black,
                                                        fontSize: 16,
                                                      ),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Text('Airport: ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18)),
                                                    Flexible(
                                                      child: Text(ap.name,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      16)),
                                                    ),
                                                  ],
                                                ),
                                                const SizedBox(height: 10),
                                                Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.start,
                                                  children: [
                                                    const Text('Location: ',
                                                        style: TextStyle(
                                                            color: Colors.black,
                                                            fontWeight:
                                                                FontWeight.bold,
                                                            fontSize: 18)),
                                                    Flexible(
                                                      child: Text(ap.location,
                                                          style:
                                                              const TextStyle(
                                                                  color: Colors
                                                                      .black,
                                                                  fontSize:
                                                                      16)),
                                                    ),
                                                  ],
                                                ),
                                                const Text(
                                                    '---------------------------------------',
                                                    style: TextStyle(
                                                        color: Colors.black,
                                                        fontWeight:
                                                            FontWeight.bold,
                                                        fontSize: 18))
                                              ],
                                            ),
                                          ),
                                        );
                                      }).toList(),
                                    );
                                  }
                                },
                              ),
                            ),
                          );
                        },
                      );
                    },
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Container(
                        decoration: BoxDecoration(
                            color: Colors.deepPurple,
                            borderRadius: BorderRadius.circular(12)),
                        child: const Padding(
                          padding: EdgeInsets.all(20.0),
                          child: Center(
                            child: Text(
                              'Search',
                              style: TextStyle(
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                                fontSize: 18,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 40,
                  ),
                  Center(
                    child: TextButton(
                      onPressed: () {
                        showAboutDialog(
                            context: context,
                            applicationName: 'Airports Code',
                            applicationVersion: '1.0.0',
                            applicationIcon: Image.asset(
                              'assets/icon.png',
                              height: 60,
                              width: 60,
                            ),
                            applicationLegalese: '',
                            children: [
                              const Text('Created by: Mohamed Ibrahim'),
                              const SizedBox(
                                height: 10,
                              ),
                              Text('Version: $version'),
                            ]);
                      },
                      child: const Text(
                        'About',
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.deepPurple),
                      ),
                    ),
                  ),
                ],
              )
            ]),
          ),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:bursa_app/Constant.dart';
import 'package:bursa_app/Screens/BottomNavigation/MyEvents.dart';
import 'package:bursa_app/Services/URLlauncher.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:webview_flutter/webview_flutter.dart';

import 'AAArticle.dart';
import 'AATeamEvent.dart';
import 'AgentPanel/ChatScreen.dart';

import 'BottomNavigation/WatchList.dart';
import 'CaseStudyList.dart';
import 'Entitlement.dart';
import 'FutureReportScreen.dart';
import 'LearnScreen.dart';
import 'LogReg/LoginScreen.dart';
import 'NewsDetailScreen.dart';
import 'Profile.dart';
import 'ResearchScreen.dart';
import 'Screener.dart';
import 'package:http/http.dart' as http;

class Announcement extends StatefulWidget {
  static const id = 'Announcement';

  final userId;
  final agentId;
  final AccessToken;
  final email;
  final pic;
  final jDate;
  final userName;
  final password;

  Announcement(
      {this.userId,
      this.agentId,
      this.AccessToken,
      this.email,
      this.pic,
      this.jDate,
      this.userName,
      this.password});
  @override
  _AnnouncementState createState() => _AnnouncementState();
}

class _AnnouncementState extends State<Announcement> {
  List data;

  Future<void> loadShares() {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
    };

    String u = "$url" + "/stocks/GetFinance";
    print(u);
    http.get(u, headers: header).then((value) {
      print(value.statusCode);

      if (value.statusCode >= 200 && value.statusCode < 300) {
        setState(() {
          data = jsonDecode(value.body);
        });
      }
    });
  }

  String x;
  Future<void> getT() {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': '${widget.AccessToken}'
    };

    String u = "$url" + "/CaseStudy/TandC/2";
    http.get(u, headers: header).then((response) async {
      int StatusCode = response.statusCode;
      print(StatusCode);

      Map data = jsonDecode(response.body);
      List dataX = data.values.toList();
      setState(() {
        x = dataX[1];
      });
    });
  }

  var images;
  List banner;
  bool vis = false;

  loadbanner() {
    Map<String, String> header = {
      'Content-type': 'application/json',
      'Accept': 'application/json',
      'Authorization': '${widget.AccessToken}'
    };
    String u = "$url" + "/articles/GetBanners";
    return http.get(u, headers: header).then((response) {
      print("Status ${response.statusCode}");
      setState(() {
        List data = jsonDecode(response.body);

        banner = data.where((element) => element['link'] != null).toList();
        print(banner.length);
      });
      return [];
    });
  }

  @override
  void initState() {
    // TODO: implement initState

    loadShares();
    loadbanner();
    getT();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return DefaultTabController(
      length: 3,
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: black,
          centerTitle: true,
          title: Text(
            'Announcements',
            style: textStyle.copyWith(
                fontSize: 18, fontWeight: FontWeight.bold, color: white),
          ),
          bottom: TabBar(
              isScrollable: true,
              labelColor: amber,
              indicatorColor: Colors.transparent,
              labelStyle: TextStyle(fontSize: 12, color: amber),
              unselectedLabelColor: grey,
              unselectedLabelStyle: TextStyle(fontSize: 12, color: grey),
              tabs: [
                Container(
                  height: 20,
                  child: Text('Global Announcements'),
                ),
                Container(
                  height: 20,
                  child: Text('Malaysia Announcements'),
                ),
                Container(
                  height: 20,
                  child: Text('Financial Report'),
                ),
              ]),
        ),
        drawer: Container(
          width: media.width * 0.6,
          height: media.height,
          color: black,
          child: ListView(
            children: [
              Center(
                  child: Container(
                height: 180,
                width: 150,
                child: Image.asset(
                  'assets/images/AALOGO.png',
                  fit: BoxFit.cover,
                ),
              )),
              ListTile(
                leading: Icon(
                  Icons.person,
                  color: grey,
                  size: 20,
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return ProfileScreen(
                      AccessToken: widget.AccessToken,
                      username: widget.userName,
                      email: widget.email,
                      pic: widget.pic,
                      jDate: widget.jDate,
                      password: widget.password,
                    );
                  }));
                },
                title: Text(
                  'Profile',
                  style: textStyle.copyWith(color: grey, fontSize: 15),
                ),
              ),
              Divider(
                thickness: 1,
                color: amber,
              ),
              ListTile(
                leading: Icon(
                  Icons.remove_red_eye,
                  color: grey,
                  size: 20,
                ),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return WatchList(
                      userId: widget.userId,
                      agentId: widget.agentId,
                      AccessToken: widget.AccessToken,
                    );
                  }));
                },
                title: Text(
                  'WatchList',
                  style: textStyle.copyWith(color: grey, fontSize: 15),
                ),
              ),
              Divider(
                thickness: 1,
                color: amber,
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, Entitlement.id);
                },
                leading: Icon(Icons.announcement, color: grey, size: 20),
                title: Text(
                  'Entitlement',
                  style: textStyle.copyWith(color: grey, fontSize: 15),
                ),
              ),
              Divider(
                thickness: 1,
                color: amber,
              ),
              ListTile(
                onTap: () {
                  Navigator.pushNamed(context, ResearchScreen.id);
                },
                leading: Icon(Icons.find_in_page, color: grey, size: 20),
                title: Text(
                  'Research',
                  style: textStyle.copyWith(color: grey, fontSize: 15),
                ),
              ),
              Divider(
                thickness: 1,
                color: amber,
              ),
              ListTile(
                leading: Icon(Icons.settings_overscan, color: grey, size: 20),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return Screener(
                      AccessToken: widget.AccessToken,
                    );
                  }));
                },
                title: Text(
                  'Screener',
                  style: textStyle.copyWith(color: grey, fontSize: 15),
                ),
              ),
              Divider(
                thickness: 1,
                color: amber,
              ),
              ListTile(
                leading: Icon(Icons.receipt, color: grey, size: 20),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AAArticle(
                      AccessToken: widget.AccessToken,
                    );
                  }));
                },
                title: Text(
                  'AA Article',
                  style: textStyle.copyWith(color: grey, fontSize: 15),
                ),
              ),
              Divider(
                thickness: 1,
                color: amber,
              ),
              ListTile(
                leading: Icon(Icons.videocam, color: grey, size: 20),
                onTap: () {
                  Navigator.pushNamed(context, LearnScreen.id);
                },
                title: Text(
                  'Learn',
                  style: textStyle.copyWith(color: grey, fontSize: 15),
                ),
              ),
              Divider(
                thickness: 1,
                color: amber,
              ),
              ListTile(
                leading: Icon(Icons.announcement, color: grey, size: 20),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return AATeamEvent(
                        token: widget.AccessToken, email: widget.email);
                  }));
                },
                title: Text(
                  'AA Team Event',
                  style: textStyle.copyWith(color: grey, fontSize: 15),
                ),
              ),
              Divider(
                thickness: 1,
                color: amber,
              ),
              ListTile(
                onTap: () {
                  if (widget.agentId != null) {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                      return ChatScreen(
                        currentUser: widget.userId,
                        agentId: widget.agentId,
                        AccessToken: widget.AccessToken,
                      );
                    }));
                  } else {
                    Scaffold.of(context).showSnackBar(
                        SnackBar(content: Text('No Agent Assigned')));
                  }
                },
                leading: Icon(
                  EvaIcons.messageCircle,
                  color: grey,
                ),
                title: Text(
                  'Chat With Agent',
                  style: textStyle.copyWith(color: grey, fontSize: 15),
                ),
              ),
              Divider(
                thickness: 1,
                color: amber,
              ),
              ListTile(
                leading: Icon(Icons.contacts, color: grey, size: 20),
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return MyEvents(
                      email: widget.email,
                      token: widget.AccessToken,
                    );
                  }));
                },
                title: Text(
                  'My Events',
                  style: textStyle.copyWith(color: grey, fontSize: 15),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Container(
                width: media.width,
                height: 40,
                decoration: BoxDecoration(
                    color: Colors.lightBlueAccent,
                    borderRadius: BorderRadius.circular(10)),
                child: FlatButton(
                    onPressed: () {
                      showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              title: Text('Terms And Condition'),
                              titleTextStyle: textStyle.copyWith(
                                  fontSize: 18, color: black),
                              content: Text(x),
                              contentTextStyle:
                                  textStyle.copyWith(fontSize: 15, color: grey),
                              actions: <Widget>[
                                RaisedButton(
                                  color: amber,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  onPressed: () {
                                    print(widget.AccessToken);
                                    Navigator.push(context,
                                        MaterialPageRoute(builder: (_) {
                                      return AACaseStudy(
                                        accessToken: widget.AccessToken,
                                      );
                                    }));
                                  },
                                  child: Text('Accept'),
                                ),
                                RaisedButton(
                                  color: amber,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(10)),
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: Text('Close'),
                                )
                              ],
                            );
                          });
                    },
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.hammer,
                          color: white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'AA Case Study',
                          style: textStyle.copyWith(fontSize: 15, color: white),
                        )
                      ],
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: media.width,
                height: 40,
                decoration: BoxDecoration(
                    color: Color(0xee2F76DA),
                    borderRadius: BorderRadius.circular(10)),
                child: FlatButton(
                    onPressed: () {
                      launchURL(url: "https://www.facebook.com/AATeam.My");
                    },
                    child: Row(
                      children: [
                        Icon(
                          EvaIcons.facebook,
                          color: white,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Facebook',
                          style: textStyle.copyWith(fontSize: 15, color: white),
                        )
                      ],
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: media.width,
                height: 40,
                decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10), color: white),
                child: FlatButton(
                    onPressed: () {
                      launchURL(url: "https://www.instagram.com/aateammy/");
                    },
                    child: Row(
                      children: [
                        Icon(
                          FontAwesomeIcons.instagram,
                          color: Colors.red,
                        ),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Instagram',
                          style: textStyle.copyWith(
                              fontSize: 15, color: Colors.red),
                        )
                      ],
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              Container(
                width: media.width,
                height: 40,
                decoration: BoxDecoration(
                    color: Color(0xee76B9ED),
                    borderRadius: BorderRadius.circular(10)),
                child: FlatButton(
                    onPressed: () {
                      launchURL(url: "https://www.tiktok.com/@aateam96");
                    },
                    child: Row(
                      children: [
                        Container(
                            height: 24,
                            width: 24,
                            child: Image.asset('assets/images/tiktok.png')),
                        SizedBox(
                          width: 10,
                        ),
                        Text(
                          'Tiktok',
                          style: textStyle.copyWith(fontSize: 15, color: white),
                        ),
                      ],
                    )),
              ),
              SizedBox(
                height: 10,
              ),
              Divider(
                thickness: 1,
                color: amber,
              ),
              ListTile(
                onTap: () {
                  Navigator.popAndPushNamed(context, LoginScreen.id);
                },
                leading: Icon(
                  Icons.power_settings_new,
                  color: amber,
                ),
                title: Text(
                  'LOGOUT',
                  style: textStyle.copyWith(color: amber, fontSize: 15),
                ),
              ),
              SizedBox(
                height: 40,
              )
            ],
          ),
        ),
        body: Stack(
          children: [
            TabBarView(children: [
              Stack(
                children: [
                  WebView(
                    initialUrl: "https://www.investing.com/news/",
                    onWebViewCreated: (WebViewController webViewController) {
                      // _controller.complete(webViewController);
                    },
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          width: media.width,
                          color: Colors.black,
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                child: Image(
                                  image: AssetImage('assets/images/Logo.png'),
                                  fit: BoxFit.cover,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Stack(
                children: [
                  WebView(
                    initialUrl: "https://www.klsescreener.com/v2/news",
                    onWebViewCreated: (WebViewController webViewController) {
                      // _controller.complete(webViewController);
                    },
                  ),
                  SingleChildScrollView(
                    child: Column(
                      children: [
                        Container(
                          height: 50,
                          width: media.width,
                          color: Colors.black,
                          child: Row(
                            children: [
                              Container(
                                width: 50,
                                height: 50,
                                child: Image(
                                  image: AssetImage('assets/images/Logo.png'),
                                  fit: BoxFit.cover,
                                ),
                              )
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              Container(
                child: ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (BuildContext context, int index) {
                    List reve;

                    bool con = data[index]['revenuePercent'] == "0.0%";
                    if (con == false) {
                      Map rev = jsonDecode(data[index]['revenuePercent']);
                      reve = rev.values.toList();
                      print(reve);
                    }
                    ;
                    Map pro = jsonDecode(data[index]['profitPercent']);
                    List profit = pro.values.toList();

                    // var priceChange = double.parse(data[index]['price_change']);
                    return Container(
                      margin: EdgeInsets.symmetric(vertical: 10),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [BoxShadow(color: grey.withOpacity(0.1))]),
                      child: ListTile(
                        onTap: () {
                          Navigator.push(context,
                              MaterialPageRoute(builder: (context) {
                            return FutureReportScreen(
                              name: data[index]['name'],
                              webUrl: data[index]['link'],
                            );
                          }));
                        },
                        leading: Text(
                          '${data[index]['name']}',
                          style: textStyle.copyWith(fontSize: 12, color: white),
                        ),
                        title: Text(
                          'Revenue: ${data[index]['revenue']}',
                          style: textStyle.copyWith(fontSize: 12, color: amber),
                        ),
                        trailing: Container(
                          width: 50,
                          height: 30,
                          color: data[index]['revenuePercent'] == "0.0%"
                              ? Colors.white
                              : reve[0] == 'red'
                                  ? Colors.red
                                  : Colors.green,
                          child: Center(
                            child: Text(
                              '${data[index]['revenuePercent'] == "0.0%" ? data[index]['revenuePercent'] : reve[1]}',
                              style: textStyle.copyWith(
                                  fontSize: 12, color: white),
                            ),
                          ),
                        ),
                      ),
                    );
                  },
                ),
              )
            ]),
            Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Visibility(
                  visible: vis,
                  child: Container(
                    width: media.width * 0.8,
                    height: media.height * 0.6,
                    child: Column(
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: [
                            IconButton(
                                icon: Icon(
                                  Icons.close,
                                  color: white,
                                ),
                                onPressed: () {
                                  setState(() {
                                    vis = false;
                                  });
                                })
                          ],
                        ),
                        SizedBox(
                          width: 400,
                          height: 300,
                          child: Image.network(
                            'https://bursa.8mindsolutions.com/resources/banners/$images',
                            fit: BoxFit.cover,
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                CarouselSlider(
                  options: CarouselOptions(height: 50.0),
                  items: banner.map((i) {
                    return Builder(
                      builder: (BuildContext context) {
                        List img = i.values.toList();
                        return GestureDetector(
                          onTap: () {
                            setState(() {
                              images = img[3];
                            });
                            vis = true;
                          },
                          child: Container(
                            color: Colors.black,
                            width: MediaQuery.of(context).size.width,
                            margin: EdgeInsets.symmetric(horizontal: 5.0),
                            child: Image.network(
                              'https://bursa.8mindsolutions.com/resources/banners/${img[2]}',
                              fit: BoxFit.cover,
                            ),
                          ),
                        );
                      },
                    );
                  }).toList(),
                )
              ],
            )
          ],
        ),
      ),
    );
  }
}

class NewsFeedTile extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(vertical: 5),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [BoxShadow(color: Colors.grey.withOpacity(0.4))]),
      child: ListTile(
        onTap: () {
          Navigator.pushNamed(context, NewsDetailScreen.id);
        },
        isThreeLine: true,
        leading: Container(
          width: 100,
          height: MediaQuery.of(context).size.height,
          color: Colors.red,
        ),
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'News Heading',
              style:
                  textStyle.copyWith(fontWeight: FontWeight.bold, color: black),
            ),
            Text(
              'by Malaysia - 20 Minutes',
              style: textStyle.copyWith(
                  fontSize: 10, color: grey, fontWeight: FontWeight.bold),
            )
          ],
        ),
        subtitle: Text(
          'dsdsdsdsdsdsdsdscxcdhfsafouehfowhcohcewhcohowckclkzcldsdsdsdscxcckxkkkkkjzlclzcleocklxcldcldk',
          style: textStyle.copyWith(fontSize: 12, color: grey),
        ),
      ),
    );
  }
}

import 'dart:async';
import 'dart:convert';

import 'package:bursa_app/Constant.dart';
import 'package:bursa_app/Screens/AgentPanel/ChatScreen.dart';
import 'package:bursa_app/Screens/BottomNavigation/EtfCharts.dart';
import 'package:bursa_app/Screens/BottomNavigation/FutureChart.dart';
import 'package:bursa_app/Screens/BottomNavigation/LeapChart.dart';
import 'package:bursa_app/Screens/BottomNavigation/MarketPlace.dart';
import 'package:bursa_app/Screens/LogReg/LoginScreen.dart';
import 'package:bursa_app/Services/URLlauncher.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

import '../AAArticle.dart';
import '../AATeamEvent.dart';
import '../CaseStudyList.dart';
import '../Entitlement.dart';
import '../LearnScreen.dart';
import '../Profile.dart';
import '../ResearchScreen.dart';
import '../Screener.dart';
import 'MyEvents.dart';
import 'ReitChart.dart';
import 'WarrantChart.dart';
import 'WatchList.dart';
import 'package:http/http.dart' as http;

class SearchScreen extends StatefulWidget {
  final userId;
  final agentId;
  final AccessToken;
  final email;
  final pic;
  final jDate;
  final userName;
  final password;

  SearchScreen(
      {this.userId,
      this.agentId,
      this.AccessToken,
      this.email,
      this.pic,
      this.jDate,
      this.userName,
      this.password});

  @override
  _SearchScreenState createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  TextEditingController searchText = TextEditingController();

  List data;

  List<Map> type = [
    {'type': 'Stocks', 'id': 1},
    {'type': 'Warrants', 'id': 2},
    {'type': 'Future', 'id': 3},
    {'type': 'Etf', 'id': 4},
    {'type': 'Reit', 'id': 5},
    {'type': 'Leap', 'id': 6},
  ];

  String selectedValue;
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
    getT();
    loadbanner();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: black,
          centerTitle: true,
          title: Text(
            'Search',
            style: textStyle.copyWith(
                fontSize: 18, fontWeight: FontWeight.bold, color: white),
          ),
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
            ListView(
              children: [
                SizedBox(
                  height: 10,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: FormField<String>(
                    builder: (FormFieldState<String> state) {
                      return InputDecorator(
                        decoration: InputDecoration(
                          contentPadding: EdgeInsets.all(12),
                          labelStyle: textStyle,
                          errorStyle: TextStyle(
                              color: Colors.redAccent, fontSize: 16.0),
                          border: OutlineInputBorder(
                            borderSide: BorderSide(color: grey),
                          ),
                          enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(color: grey)),
                          hintText: 'Please select city',
                        ),
                        isEmpty: selectedValue == '',
                        child: DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            iconEnabledColor: amber,
                            hint: Text(
                              'Select Type',
                              style: textStyle.copyWith(
                                  fontSize: 16, color: amber),
                            ),
                            value: selectedValue,
                            isDense: true,
                            onChanged: (String newValue) async {
                              setState(() {
                                selectedValue = newValue;
                                state.didChange(newValue);
                              });
                            },
                            items: type.map((var value) {
                              return DropdownMenuItem<String>(
                                value: value['type'].toString(),
                                child: Text(
                                  value['type'],
                                  style: textStyle.copyWith(
                                      fontSize: 16, color: amber),
                                ),
                              );
                            }).toList(),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                Theme(
                  data: ThemeData(primaryColor: amber),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20),
                    child: TextField(
                      style: textStyle.copyWith(fontSize: 16, color: white),
                      controller: searchText,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                          borderSide: BorderSide(color: grey),
                        ),
                        enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(color: grey)),
                        prefixIcon: Icon(
                          Icons.search,
                          color: amber,
                        ),
                        hintText: 'Search',
                        hintStyle:
                            textStyle.copyWith(fontSize: 16, color: amber),
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.symmetric(horizontal: 100),
                  child: RaisedButton(
                    onPressed: () {
                      List<Map> Type = type.where((element) {
                        return element['type'] == selectedValue;
                      }).toList();
                      print(Type[0]['id']);

                      if (Type[0]['id'] == 1) {
                        Map<String, String> header = {
                          'Content-type': 'application/json',
                          'Accept': 'application/json',
                          //  'Authorization':'${widget.token}'
                        };

                        String lur = "$url" +
                            "/stocks/GetSearchStocks/${searchText.text}";

                        http.post(lur, headers: header).then((value) {
                          print(value.statusCode);

                          if (value.statusCode >= 200 &&
                              value.statusCode < 300) {
                            Map xyz = jsonDecode(value.body);

                            setState(() {
                              data = xyz.values.toList();
                            });
                          }
                        });
                      } else if (Type[0]['id'] == 2) {
                        Map<String, String> header = {
                          'Content-type': 'application/json',
                          'Accept': 'application/json',
                          //  'Authorization':'${widget.token}'
                        };

                        String lur = "$url" +
                            "/stocks/GetWarrantsSearch/${searchText.text}";

                        http.post(lur, headers: header).then((value) {
                          print(value.statusCode);

                          if (value.statusCode >= 200 &&
                              value.statusCode < 300) {
                            Map xyz = jsonDecode(value.body);

                            setState(() {
                              data = xyz.values.toList();
                            });
                          }
                        });
                      } else if (Type[0]['id'] == 3) {
                        print(Type[0]["id"]);

                        Map<String, String> header = {
                          'Content-type': 'application/json',
                          'Accept': 'application/json',
                          //  'Authorization':'${widget.token}'
                        };

                        String lur = "$url" +
                            "/stocks/GetFutureSearch/${searchText.text}";

                        http.post(lur, headers: header).then((value) {
                          print(value.statusCode);

                          if (value.statusCode >= 200 &&
                              value.statusCode < 300) {
                            Map xyz = jsonDecode(value.body);

                            setState(() {
                              data = xyz.values.toList();
                            });
                          }
                        });
                      } else if (Type[0]['id'] == 4) {
                        Map<String, String> header = {
                          'Content-type': 'application/json',
                          'Accept': 'application/json',
                          //  'Authorization':'${widget.token}'
                        };

                        String lur =
                            "$url" + "/stocks/GeETFStocks/${searchText.text}";

                        http.post(lur, headers: header).then((value) {
                          print(value.statusCode);

                          if (value.statusCode >= 200 &&
                              value.statusCode < 300) {
                            Map xyz = jsonDecode(value.body);

                            setState(() {
                              data = xyz.values.toList();
                            });
                          }
                        });
                      } else if (Type[0]['id'] == 5) {
                        Map<String, String> header = {
                          'Content-type': 'application/json',
                          'Accept': 'application/json',
                          //  'Authorization':'${widget.token}'
                        };

                        String lur =
                            "$url" + "/stocks/GetReitStocks/${searchText.text}";

                        http.post(lur, headers: header).then((value) {
                          print(value.statusCode);

                          if (value.statusCode >= 200 &&
                              value.statusCode < 300) {
                            Map xyz = jsonDecode(value.body);

                            setState(() {
                              data = xyz.values.toList();
                            });
                          }
                        });
                      } else if (Type[0]['id'] == 6) {
                        Map<String, String> header = {
                          'Content-type': 'application/json',
                          'Accept': 'application/json',
                          //  'Authorization':'${widget.token}'
                        };

                        String lur =
                            "$url" + "/stocks/GetLeapStocks/${searchText.text}";

                        http.post(lur, headers: header).then((value) {
                          print(value.statusCode);

                          if (value.statusCode >= 200 &&
                              value.statusCode < 300) {
                            Map xyz = jsonDecode(value.body);

                            setState(() {
                              data = xyz.values.toList();
                            });
                          }
                        });
                      }
                    },
                    color: amber,
                    child: Text(
                      'Search',
                      style: textStyle.copyWith(
                          fontSize: 15,
                          fontWeight: FontWeight.w400,
                          color: white),
                    ),
                  ),
                ),
                Container(
                  width: media.width,
                  child: ListView.builder(
                    shrinkWrap: true,
                    physics: NeverScrollableScrollPhysics(),
                    itemCount: data == null ? 0 : 1,
                    itemBuilder: (BuildContext context, int index) {
                      return Container(
                        margin:
                            EdgeInsets.symmetric(vertical: 5, horizontal: 10),
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(color: Colors.grey.withOpacity(0.4))
                            ]),
                        child: ListTile(
                          onTap: () {
                            List<Map> Type = type.where((element) {
                              return element['type'] == selectedValue;
                            }).toList();

                            print(Type[0]['id']);
                            print("${data[1]} ${data[2]}");

                            if (Type[0]['id'] == 1) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return MarketPlace(
                                  symbol: data[1],
                                  name: data[2],
                                  AccessToken: widget.AccessToken,
                                );
                              }));
                            } else if (Type[0]['id'] == 2) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return WarrantChart(
                                  symbol: data[1],
                                  name: data[2],
                                  AccessToken: widget.AccessToken,
                                );
                              }));
                            } else if (Type[0]['id'] == 3) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return FutureChart(
                                  symbol: data[1],
                                  name: data[2],
                                  AccessToken: widget.AccessToken,
                                );
                              }));
                            } else if (Type[0]['id'] == 4) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return EtfChart(
                                  symbol: data[1],
                                  name: data[2],
                                  AccessToken: widget.AccessToken,
                                );
                              }));
                            } else if (Type[0]['id'] == 5) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return ReitChart(
                                  symbol: data[1],
                                  name: data[2],
                                  AccessToken: widget.AccessToken,
                                );
                              }));
                            } else if (Type[0]['id'] == 6) {
                              Navigator.push(context,
                                  MaterialPageRoute(builder: (context) {
                                return LeapChart(
                                  symbol: data[1],
                                  name: data[2],
                                  AccessToken: widget.AccessToken,
                                );
                              }));
                            }
                          },
                          title: Text(
                            data[2],
                            style: textStyle.copyWith(
                                fontWeight: FontWeight.bold,
                                color: amber,
                                fontSize: 18),
                          ),
                          subtitle: Text(
                            data[1],
                            style:
                                textStyle.copyWith(fontSize: 12, color: white),
                          ),
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
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
                
              ],
            )
          ],
        ));
  }
}

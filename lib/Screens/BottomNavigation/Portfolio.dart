import 'package:bursa_app/Constant.dart';
import 'package:bursa_app/Screens/AnnouncementGlobal.dart';
import 'package:bursa_app/Screens/AnnouncementMalaysia.dart';
import 'package:bursa_app/Screens/Announcements.dart';
import 'package:bursa_app/Screens/Entitlement.dart';
import 'package:bursa_app/Screens/NewsFeedScreen.dart';
import 'package:bursa_app/Screens/ResearchScreen.dart';
import 'package:bursa_app/Screens/Screener.dart';
import 'package:bursa_app/Screens/StockDetailScreen.dart';
import 'package:eva_icons_flutter/eva_icons_flutter.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class Portfolio extends StatefulWidget {

  static const id = 'Portfolio';

  @override
  _PortfolioState createState() => _PortfolioState();
}

class _PortfolioState extends State<Portfolio> {

  bool val = false;
  bool switchValue = false;

  @override
  Widget build(BuildContext context) {

    var media = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: black,
        centerTitle: true,
        title: Text('Portfolio',
        style: textStyle.copyWith(
          fontWeight: FontWeight.bold,
          color: white,
          fontSize: 18
        ),),
      ),
      drawer: Container(
        width: media.width * 0.6,
        height: media.height,
        color: black,
        child: ListView(
          children: [
            Container(
              width: media.width,
              height: media.height * 0.25,
              color: black,
              child: Center(
                child: Text('Remisier',
                  style: textStyle.copyWith(
                      color: amber
                  ),),
              ),
            ),
            ListTile(
              leading: Icon(Icons.person,
                color: grey,
                size: 20,),
              title: Text('Profile',
                style: textStyle.copyWith(
                    color: grey,
                    fontSize: 15
                ),),
            ),
            Divider(
              thickness: 1,
              color: amber,
            ),
            ListTile(
              leading: Icon(Icons.notifications,
                  color: grey,
                  size: 20),
              title: Text('Alert',
                style: textStyle.copyWith(
                    color: grey,
                    fontSize: 15
                ),),
            ),
            Divider(
              thickness: 1,
              color: amber,
            ),
            ListTile(
              leading: Icon(Icons.remove_red_eye,
                  color: grey,
                  size: 20),
              title: Text('Watchlist',
                style: textStyle.copyWith(
                    color: grey,
                    fontSize: 15
                ),),
            ),
            Divider(
              thickness: 1,
              color: amber,
            ),
            ListTile(
              leading: Icon(Icons.settings_overscan,
                  color: grey,
                  size: 20),
              title: Text('Screener',
                style: textStyle.copyWith(
                    color: grey,
                    fontSize: 15
                ),),
            ),
            Divider(
              thickness: 1,
              color: amber,
            ),
            ListTile(
              onTap: (){
                Navigator.pushNamed(context, ResearchScreen.id);
              },
              leading: Icon(Icons.find_in_page,
                  color: grey,
                  size: 20),
              title: Text('Research',
                style: textStyle.copyWith(
                    color: grey,
                    fontSize: 15
                ),),
            ),
            Divider(
              thickness: 1,
              color: amber,
            ),
            ListTile(
              onTap: (){
                Navigator.pushNamed(context, Announcement.id);
              },
              leading: Icon(Icons.announcement,
                  color: grey,
                  size: 20),
              title: Text('Announcements',
                style: textStyle.copyWith(
                    color: grey,
                    fontSize: 15
                ),),
            ),
            Divider(
              thickness: 1,
              color: amber,
            ),
            ListTile(
              leading: Icon(Icons.receipt,
                  color: grey,
                  size: 20),
              title: Text('A A Article',
                style: textStyle.copyWith(
                    color: grey,
                    fontSize: 15
                ),),
            ),
            Divider(
              thickness: 1,
              color: amber,
            ),
            ListTile(
              leading: Icon(Icons.videocam,
                  color: grey,
                  size: 20),
              title: Text('Learn',
                style: textStyle.copyWith(
                    color: grey,
                    fontSize: 15
                ),),
            ),
            Divider(
              thickness: 1,
              color: amber,
            ),
            ListTile(
              leading: Icon(Icons.announcement,
                  color: grey,
                  size: 20),
              title: Text('AA Team Event',
                style: textStyle.copyWith(
                    color: grey,
                    fontSize: 15
                ),),
            ),
            Divider(
              thickness: 1,
              color: amber,
            ),
            ListTile(
              onTap: (){
                Navigator.pushNamed(context, Entitlement.id);
              },
              leading: Icon(Icons.announcement,
                  color: grey,
                  size: 20),
              title: Text('Entitlement',
                style: textStyle.copyWith(
                    color: grey,
                    fontSize: 15
                ),),
            ),
            Divider(
              thickness: 1,
              color: amber,
            ),
            ListTile(
              leading: Icon(EvaIcons.globe,
                  color: grey,
                  size: 20),
              title: Text('Latest News',
                style: textStyle.copyWith(
                    color: grey,
                    fontSize: 15
                ),),
              onTap: (){
                Navigator.pushNamed(context, NewsFeedScreen.id);
              },
            ),
            Divider(
              thickness: 1,
              color: amber,
            ),
            ListTile(
              leading: Icon(Icons.contacts,
                  color: grey,
                  size: 20),
              title: Text('Contact Us',
                style: textStyle.copyWith(
                    color: grey,
                    fontSize: 15
                ),),
            ),
            SizedBox(
              height: 20,
            ),
            Container(
              width: media.width,
              height: 40,
              decoration: BoxDecoration(
                  color: Color(0xee2F76DA),
                  borderRadius: BorderRadius.circular(10)
              ),
              child: FlatButton(onPressed: (){

              }, child: Row(
                children: [
                  Icon(EvaIcons.facebook,
                    color: white,),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Facebook',
                    style: textStyle.copyWith(
                        fontSize: 15,
                        color: white
                    ),)
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
                  borderRadius: BorderRadius.circular(10),
                  color: white
              ),
              child: FlatButton(onPressed: (){

              }, child: Row(
                children: [
                  Icon(EvaIcons.google,
                    color: Colors.red,),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Google',
                    style: textStyle.copyWith(
                        fontSize: 15,
                        color: Colors.red
                    ),)
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
                  borderRadius: BorderRadius.circular(10)
              ),
              child: FlatButton(onPressed: (){

              }, child: Row(
                children: [
                  Icon(EvaIcons.twitter,
                    color: white,),
                  SizedBox(
                    width: 10,
                  ),
                  Text('Twitter',
                    style: textStyle.copyWith(
                        fontSize: 15,
                        color: white
                    ),)
                ],
              )),
            ),
            SizedBox(
              height: 40,
            )
          ],
        ),
      ),
      body: DefaultTabController(
        length: 2,
        child: SingleChildScrollView(
          child: Column(
            children: [
              SizedBox(
                height: 20,
              ),
              TabBar(
                  isScrollable: true,
                  labelColor: amber,
                  indicatorColor: Colors.transparent,
                  labelStyle: TextStyle(
                      fontSize: 13,
                      color: amber
                  ),
                  unselectedLabelColor: grey,
                  unselectedLabelStyle: TextStyle(
                      fontSize: 12,
                      color: grey
                  ),
                  tabs: [
                    Container(
                      height: 20,
                      child: Text('Create New'),
                    ),
                    Container(
                      height: 20,
                      child: Text('Edit Portfolio'),
                    ),
                  ]),
              SizedBox(
                height: MediaQuery.of(context).size.height,
                child: TabBarView(
                    children: [
                      Container(
                        child: SingleChildScrollView(
                          child: Padding(
                            padding: EdgeInsets.symmetric(horizontal: 20),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                SizedBox(
                                  height: 20,
                                ),
                                Text('Portfolio Name',
                                style: textStyle.copyWith(
                                  fontSize: 15,
                                  color: amber
                                ),),
                                SizedBox(
                                  height: 10,
                                ),
                                Theme(
                                  data: ThemeData(
                                      primaryColor: amber
                                  ),
                                  child: TextField(
                                    style: textStyle.copyWith(
                                        fontSize: 16,
                                        color: white
                                    ),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: white
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: white
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text('Add Cash',
                                  style: textStyle.copyWith(
                                      fontSize: 15,
                                      color: amber
                                  ),),
                                SizedBox(
                                  height: 10,
                                ),
                                Theme(
                                  data: ThemeData(
                                      primaryColor: amber
                                  ),
                                  child: TextField(
                                    style: textStyle.copyWith(
                                        fontSize: 16,
                                        color: white
                                    ),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: white
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: white
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(10),
                                    color: white,
                                  ),
                                  child: SwitchListTile(
                                    activeColor: amber,
                                    inactiveThumbColor: white,
                                    activeTrackColor: amber,
                                    value: val,
                                      onChanged: (value){
                                      setState(() {
                                        val = value;
                                      });
                                      },
                                  title: Text('Set as App Default Portfolio',
                                  style: textStyle.copyWith(
                                    fontSize: 15,
                                    color: amber
                                  ),
                                  ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Text('Description',
                                style: textStyle.copyWith(
                                  fontSize: 16,
                                  color: amber,
                                ),
                                ),
                                SizedBox(
                                  height: 10,
                                ),
                                Theme(
                                  data: ThemeData(
                                      primaryColor: amber
                                  ),
                                  child: TextField(
                                    minLines: 4,
                                    maxLines: 6,
                                    style: textStyle.copyWith(
                                        fontSize: 16,
                                        color: white
                                    ),
                                    decoration: InputDecoration(
                                      border: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: white
                                        ),
                                        borderRadius: BorderRadius.circular(10),
                                      ),
                                      enabledBorder: OutlineInputBorder(
                                          borderRadius: BorderRadius.circular(10),
                                          borderSide: BorderSide(
                                              color: white
                                          )
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 20,
                                ),
                                Container(
                                  child: Row(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      RaisedButton(
                                        onPressed: (){
//                                          Navigator.pushNamed(context, routeName);
                                        },
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10)
                                        ),
                                        color: amber,
                                        child: Text('CANCEL',
                                        style: textStyle.copyWith(
                                          fontSize: 18,
                                          fontWeight: FontWeight.bold,
                                          color: white
                                        ),),
                                      ),
                                      SizedBox(
                                        width: 10,
                                      ),
                                      RaisedButton(
                                        shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(10)
                                        ),
                                        onPressed: (){

                                      },
                                        color: amber,
                                      child: Text('SAVE',
                                        style: textStyle.copyWith(
                                            fontSize: 18,
                                            fontWeight: FontWeight.bold,
                                            color: white
                                        ),),)
                                    ],
                                  )
                                ),
                              ],
                            ),
                          ),
                        )
                      ),
                      Container(
                        child: ListView(
                          children: [
                            PortfolioTile(),
                            PortfolioTile(),
                            PortfolioTile(),
                            PortfolioTile()
                          ],
                        ),
                      ),

                    ]),
              ),
            ],
          ),
        ),
      ),
    );
  }
}


class PortfolioTile extends StatefulWidget {
  @override
  _PortfolioTileState createState() => _PortfolioTileState();
}

class _PortfolioTileState extends State<PortfolioTile> {

  bool switchValue = false;
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
          vertical: 5
      ),
      decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(5),
          boxShadow: [
            BoxShadow(
                color: Colors.grey.withOpacity(0.4)
            )
          ]
      ),
      child: ListTile(
        onTap: (){
//          Navigator.pushNamed(context, NewsDetailScreen.id);
        },
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('Portfolio',
              style: textStyle.copyWith(
                  fontWeight: FontWeight.bold,
                  color: amber
              ),
            ),
          ],
        ),
        subtitle: Text('0.00%',
        style: textStyle.copyWith(
          fontSize: 22,
          fontWeight: FontWeight.bold,
          color: white
        ),),
        trailing: Column(
          children: [
            RichText(text: TextSpan(
                text: 'Cash:',
                style: textStyle.copyWith(
                    fontWeight: FontWeight.bold,
                    fontSize: 12,
                    color: white
                ),
                children: [
                  TextSpan(
                      text: '  599.00',
                      style: textStyle.copyWith(
                          fontSize: 12,
                          color: grey
                      )
                  )
                ]
            ),),
            Switch(
              activeColor: amber,
              inactiveThumbColor: white,
              activeTrackColor: amber,
              value: switchValue,
              onChanged: (value){
                setState(() {
                  switchValue = value;
                });
              },),
          ],
        ),
      ),
    );
  }
}



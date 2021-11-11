import 'dart:convert';
import 'dart:io';

import 'package:bursa_app/Screens/AdminPanel/UpdatePoster.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../Constant.dart';

class UpdateBanner extends StatefulWidget {

  static const id = 'UpdateBanner';

  final bannerTitle;
  final token;
  final bId;
  final img;
  final img2;

  UpdateBanner({this.bannerTitle, this.token, this.bId, this.img, this.img2});

  @override
  _UpdateBannerState createState() => _UpdateBannerState();
}

class _UpdateBannerState extends State<UpdateBanner> {


  TextEditingController eventName = TextEditingController();

  String startDate = 'Event Start Date & Time';
  String endDate = 'Event End Date & Time';

  @override
  void initState() {
    // TODO: implement initState
    setState(() {

      eventName.text = widget.bannerTitle;

    });

    super.initState();
  }


  File _pic;
  String _picPath = '';

  Future getImage() async {

    var img = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _picPath = img.path;
      _pic = img;
    });
  }

  File _img;
  String _imgPath = '';

  Future getImage1() async {

    var img = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _imgPath = img.path;
      _img = img;
    });
  }





  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: black,
        centerTitle: true,
        title: Text('Update Banner',
          style: textStyle.copyWith(
            fontSize: 18,
            color: amber,
          ),),
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
                  isScrollable: false,
                  labelColor: white,
                  indicatorColor: amber,
                  labelStyle: TextStyle(
                      fontSize: 13,
                      color: white
                  ),
                  indicator: BoxDecoration(
                      borderRadius: BorderRadius.circular(30),
                    color: amber
                  ),
                  unselectedLabelColor: grey,
                  unselectedLabelStyle: TextStyle(
                      fontSize: 12,
                      color: grey
                  ),
                  tabs: [
                    Container(
                      height: 30,
                      child: Center(child: Text('Banner')),
                    ),
                    Container(
                      height: 30,
                      child: Center(child: Text('Pop out ')),
                    ),
                  ]),
              SizedBox(
                height: 300,
                child: TabBarView(
                    children: [
                      widget.img == null ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        color: Colors.black,
                      ):Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child: Image.network("$imgUrl/resources/banners/${widget.img}"),
                      ),
                      widget.img2 == null ? Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        color: Colors.black,
                      ):Container(
                        width: MediaQuery.of(context).size.width,
                        height: 200,
                        child: Image.network("$imgUrl/resources/banners/${widget.img2}"),
                      ),
                    ]),
              ),

              Card(
                child: Container(
                  width: media.width,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: white
                  ),
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 10),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        SizedBox(
                          height: 10,
                        ),
                        Theme(
                          data: ThemeData(
                              primaryColor: amber
                          ),
                          child: TextField(
                            controller: eventName,
                            decoration: InputDecoration(
                              hintText: 'Event Name',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RaisedButton(onPressed: (){
                              getImage();
                            },
                              color: amber,
                              child: Icon(Icons.add_a_photo_outlined),)
                          ],
                        ),
                        Text('Pop Out Image'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RaisedButton(onPressed: (){
                              getImage1();
                            },
                              color: amber,
                              child: Icon(Icons.add_a_photo_outlined),)
                          ],
                        ),
                        SizedBox(
                          height: 20,
                        ),
                        Center(
                          child: Builder(
                            builder: (context){
                              return RaisedButton(onPressed: (){

                                String u = "$url"+"/articles/EditBanner";


                                Map<String,String> header ={
                                  'Content-type':'application/json',
                                  'Accept':'application/json',
                                  'Authorization':'${widget.token}'
                                };

                                Map data = {
                                  'id': widget.bId,
                                  'Name': eventName.text,
                                  'link': widget.img,
                                  'link2': widget.img2
                                };

                                var sb=jsonEncode(data);

                                http.put(u,headers: header, body: sb).then((value)async{
                                  print(value.statusCode);

                                  Map valu = jsonDecode(value.body);
                                  List val = valu.values.toList();

                                  if(_pic != null){

                                    print("XX");
                                    var headers = {
                                      'Authorization': 'Bearer ${widget.token}'
                                    };

                                    String fileName1 = _pic.path.split('/').last;

                                    var request = http.MultipartRequest('POST', Uri.parse('$url/articles/UploadBanner/${widget.bId}'));
                                    request.files.add(await http.MultipartFile.fromPath('file', '${_pic.path}'));
                                    request.headers.addAll(headers);

                                    http.StreamedResponse response = await request.send();

                                    print("IMAGE${response.statusCode}");
                                    if (response.statusCode == 200) {

                                    }
                                    else {
                                      print(response.reasonPhrase);
                                    }
                                  }

                                  if(_img != null){

                                    print(_img);

                                    var headers = {
                                      'Authorization': 'Bearer ${widget.token}'
                                    };
                                    var request = http.MultipartRequest('POST', Uri.parse('$url/articles/UploadBanner2/${widget.bId}'));
                                    request.files.add(await http.MultipartFile.fromPath('file', '${_img.path}'));
                                    request.headers.addAll(headers);

                                    http.StreamedResponse response = await request.send();


                                    print("IMAGE${response.statusCode}");
                                    if (response.statusCode == 200) {
                                      print(await response.stream.bytesToString());

                                    }
                                    else {
                                      print(response.reasonPhrase);
                                    }

                                  }

                                  Scaffold.of(context).showSnackBar(
                                      SnackBar(content: Text('Updated ')));


                                });
                              },
                                color: amber,
                                child: Text('Update Banner',
                                  style: textStyle.copyWith(
                                      fontSize: 18,
                                      color: black
                                  ),),);
                            },
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
            ],
          ),
        ),
      ),
    );
  }
}

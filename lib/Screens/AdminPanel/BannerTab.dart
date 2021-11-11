import 'dart:convert';
import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import '../../Constant.dart';
import 'UpdateBanner.dart';

class BannerTab extends StatefulWidget {

  static const id = 'BannerTab';

  final token;
  final currentId;
  BannerTab({this.token, this.currentId});
  @override
  _BannerTabState createState() => _BannerTabState();
}

class _BannerTabState extends State<BannerTab> {

  File _pic;
  String _picPath = '';

  Future getImage() async {

    var img = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      print("Image path ${img.path}");
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

  static JsonDecoder _decoder = JsonDecoder();
  // String Token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjQwIiwibmJmIjoxNjAxNjQxMDU4LCJleHAiOjE2MDIyNDU4NTgsImlhdCI6MTYwMTY0MTA1OH0.s16QedrZYTSzuy-I5qECCHpnR-plbw8lLLDEmR9uC94';
  static Dio dio = Dio();

  TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();


  List<dynamic> postNews;

  Future<List<String>> getData() {

    Map<String,String> header ={
      'Content-type':'application/json',
      'Accept':'application/json',
      'Authorization':'${widget.token}'
    };

    String u = "$url"+"/articles/GetBanners";
    return http.get(u,headers: header).then((response){
      int StatusCode = response.statusCode;
      print(StatusCode);
      setState(() {
        postNews= jsonDecode(response.body);
        print(postNews);
      });

      return [];
    });

  }

  @override
  void initState() {
    // TODO: implement initState
    getData();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {

    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        backgroundColor: black,
        centerTitle: true,
        title: Text('Manage\'s Banner',
          style: textStyle.copyWith(
            fontSize: 18,
            color: amber,
          ),),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Create Banner:',
                style: textStyle.copyWith(
                    fontSize: 18,
                    color: amber
                ),),
              SizedBox(
                height: 10,
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
                            controller: title,
                            decoration: InputDecoration(
                              hintText: 'Banner Link',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Text('Please upload images of size of 400x300',
                          style: textStyle.copyWith(
                              fontSize: 12,
                              color: amber
                          ),),
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
                              child: Icon(Icons.add_a_photo_outlined),),
                          ],
                        ),
                        Text('Select Pop Out Image'),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            RaisedButton(onPressed: (){
                              getImage1();
                            },
                              color: amber,
                              child: Icon(Icons.add_a_photo_outlined),),
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: RaisedButton(onPressed: (){

                            String u = "$url"+"/articles/PostBanner";


                            Map<String,String> header ={
                              'Content-type':'application/json',
                              'Accept':'application/json',
                              'Authorization':'${widget.token}'
                            };

                            Map data = {
                              'Name': title.text,
                              'Text': description.text
                            };

                            var sb= jsonEncode(data);

                            http.post(u,headers: header, body: sb).then((value)async{
                              print(value.statusCode);

                              if(value.statusCode >= 200 && value.statusCode < 300){

                                Map valu = _decoder.convert(value.body);
                                List val = valu.values.toList();

                                if(_pic != null){

                                  print("XX");
                                  var headers = {
                                    'Authorization': 'Bearer ${widget.token}'
                                  };

                                  String fileName1 = _pic.path.split('/').last;

                                  var request = http.MultipartRequest('POST', Uri.parse('$url/articles/UploadBanner/${val[0]}'));
                                  request.files.add(await http.MultipartFile.fromPath('file', '${_pic.path}'));
                                  request.headers.addAll(headers);

                                  http.StreamedResponse response = await request.send();

                                  print("IMAGE${response.statusCode}");
                                  if (response.statusCode == 200) {
                                    print(await response.stream.bytesToString());

                                      Scaffold.of(context).showSnackBar(
                                      SnackBar(content: Text('Image Uploaded ')));
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
                                  var request = http.MultipartRequest('POST', Uri.parse('$url/articles/UploadBanner2/${val[0]}'));
                                  request.files.add(await http.MultipartFile.fromPath('file', '${_img.path}'));
                                  request.headers.addAll(headers);

                                  http.StreamedResponse response = await request.send();


                                  print("IMAGE${response.statusCode}");
                                  if (response.statusCode == 200) {
                                    print(await response.stream.bytesToString());

                                    Scaffold.of(context).showSnackBar(
                                        SnackBar(content: Text('Image Uploaded ')));
                                  }
                                  else {
                                    print(response.reasonPhrase);
                                  }

                                }

                                getData();

                                Scaffold.of(context).showSnackBar(
                                    SnackBar(content: Text('Banner Created')));
                              }
                            });


                          },
                            color: amber,
                            child: Text('Create Banner',
                              style: textStyle.copyWith(
                                  fontSize: 18,
                                  color: black
                              ),),),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 20,
              ),
              Text('Recent Banner:',
                style: textStyle.copyWith(
                    fontSize: 18,
                    color: amber
                ),),
              SizedBox(
                height: 10,
              ),
              Container(
                width: media.width,
                child: ListView.builder(
                  shrinkWrap: true,
                  physics: NeverScrollableScrollPhysics(),
                  itemCount: postNews == null ? 0 : postNews.length,
                  itemBuilder: (BuildContext context, int index){

                    print(postNews);
                    return Container(
                      margin: EdgeInsets.symmetric(
                          vertical: 5
                      ),
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(10),
                          boxShadow: [
                            BoxShadow(
                                color: grey.withOpacity(0.2)
                            )
                          ]
                      ),
                      child: ListTile(
                        onTap: (){
                          // Navigator.pushNamed(context, NewsDetailScreen.id);
                        },
                        // isThreeLine: true,
                        title: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(postNews[index]["name"],
                              style: textStyle.copyWith(
                                  fontWeight: FontWeight.bold,
                                  color: amber,
                                  fontSize: 18
                              ),
                            ),
                          ],
                        ),
                        trailing: Container(
                          width: 70,
                          child: Row(
                            children: [

                              GestureDetector(
                                child: Icon(Icons.edit_outlined,
                                  color: amber,),
                                onTap: (){

                                  Navigator.push(context,
                                      MaterialPageRoute(builder: (BuildContext context) {
                                        return UpdateBanner(
                                          bannerTitle: postNews[index]['name'],
                                          bId: postNews[index]['id'],
                                          img: postNews[index]['link'],
                                          img2: postNews[index]['link2'],
                                          token: widget.token,
                                        );
                                      })).then((value) => getData());
                                },
                              ),
                              GestureDetector(
                                onTap: (){

                                  Map<String,String> header ={
                                    'Content-type':'application/json',
                                    'Accept':'application/json',
                                    'Authorization':'${widget.token}'
                                  };

                                  int id = postNews[index]["id"];
                                  print(id);
                                  String u = "$url"+"/articles/DeleteBanner/"+"$id";
                                  http.delete(u,headers: header).then((value) => {
                                    print(value.statusCode)
                                  });
                                },
                                child: Icon(Icons.delete_outline,
                                  color: amber,),
                              ),
                            ],
                          ),
                        ),
                      ),
                    );
                  },
                ),
              ),

            ],
          ),
        ),
      ),
    );
  }
}

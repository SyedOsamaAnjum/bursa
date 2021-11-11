import 'dart:convert';
import 'dart:io';

import 'package:bursa_app/Screens/AdminPanel/UpdatePoster.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'package:image_picker/image_picker.dart';
import '../../Constant.dart';

class UpdateCaseStudy extends StatefulWidget {

  static const id = 'UpdateCaseStudy';

  final bannerTitle;
  final token;
  final bId;
  final imgUrl;

  UpdateCaseStudy({this.bannerTitle, this.token, this.bId, this.imgUrl});

  @override
  _UpdateCaseStudyState createState() => _UpdateCaseStudyState();
}

class _UpdateCaseStudyState extends State<UpdateCaseStudy> {


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



  @override
  Widget build(BuildContext context) {
    var media = MediaQuery.of(context).size;

    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: true,
        backgroundColor: black,
        centerTitle: true,
        title: Text('Update Case Study',
          style: textStyle.copyWith(
            fontSize: 18,
            color: amber,
          ),),
      ),
      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              height: 20,
            ),
            widget.imgUrl == null ? Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              color: Colors.black,
            ):Container(
              width: MediaQuery.of(context).size.width,
              height: 200,
              child: Image.network("$imgUrl/resources/CaseStudy/${widget.imgUrl}"),
            ),
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
                          controller: eventName,
                          decoration: InputDecoration(
                            hintText: 'Event Name',
                          ),
                        ),
                      ),
                      SizedBox(
                        height: 10,
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
                      SizedBox(
                        height: 20,
                      ),
                      Center(
                        child: RaisedButton(onPressed: (){

                          String u = "$url"+"/CaseStudy/EditCaseStudy";


                          Map<String,String> header ={
                            'Content-type':'application/json',
                            'Accept':'application/json',
                            'Authorization':'${widget.token}'
                          };

                          Map data = {
                            'id': widget.bId,
                            'Link': eventName.text,
                          };

                          var sb=jsonEncode(data);

                          http.put(u,headers: header, body: sb).then((value)async{


                            Map valu = jsonDecode(value.body);
                            List val = valu.values.toList();

                            if(_pic != null){

                              print("XX");
                              var headers = {
                                'Authorization': 'Bearer ${widget.token}'
                              };

                              String fileName1 = _pic.path.split('/').last;

                              var request = http.MultipartRequest('POST', Uri.parse('$url/CaseStudy/UploadImage/${val[0]}'));
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


                          });
                        },
                          color: amber,
                          child: Text('Update Case Study',
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
              height: 10,
            ),
          ],
        ),
      ),
    );
  }
}
import 'dart:convert';
import 'dart:io';

import 'package:bursa_app/Screens/AdminPanel/UpdateBanner.dart';
import 'package:bursa_app/Screens/AdminPanel/UpdateCaseStudy.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:convert' as convert;
import 'package:http/http.dart' as http;
import '../../Constant.dart';


class CaseStudy extends StatefulWidget {

  final token;
  final currentId;

  CaseStudy({this.token, this.currentId});

  @override
  _CaseStudyState createState() => _CaseStudyState();
}

class _CaseStudyState extends State<CaseStudy> {
  File _pic;
  String _picPath = '';

  Future getImage() async {

    var img = await ImagePicker.pickImage(source: ImageSource.gallery);

    setState(() {
      _picPath = img.path;
      _pic = img;
    });
  }

  static JsonDecoder _decoder = JsonDecoder();
  // String Token = 'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpZCI6IjQwIiwibmJmIjoxNjAxNjQxMDU4LCJleHAiOjE2MDIyNDU4NTgsImlhdCI6MTYwMTY0MTA1OH0.s16QedrZYTSzuy-I5qECCHpnR-plbw8lLLDEmR9uC94';


 TextEditingController title = TextEditingController();
  TextEditingController description = TextEditingController();
  TextEditingController Tc = TextEditingController();



  List<dynamic> postNews ;

  Future<List<String>> getData() {

    print(widget.token);

    Map<String,String> header ={
      'Content-type':'application/json',
      'Accept':'application/json',
      'Authorization':'${widget.token}'
    };

    String u = "$url"+"/CaseStudy/GetCaseStudies";
    return http.get(u,headers: header).then((response){
      int StatusCode = response.statusCode;
      print(StatusCode);
      setState(() {
        postNews = jsonDecode(response.body);
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
        title: Text('Manage\'s Case Study',
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
              Text('Case Study:',
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
                  height: 280,
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
                          height: 20,
                        ),
                        Theme(
                          data: ThemeData(
                              primaryColor: amber
                          ),
                          child: TextField(
                            controller: title,
                            decoration: InputDecoration(
                              hintText: 'Case Study Title',
                            ),
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
                            controller: description,
                            decoration: InputDecoration(
                              hintText: 'Case Study Link',
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
                              child: Icon(Icons.add_a_photo_outlined),)
                          ],
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: RaisedButton(onPressed: (){

                            String u = "$url"+"/CaseStudy/CreateCaseStudy";


                            Map<String,String> header ={
                              'Content-type':'application/json',
                              'Accept':'application/json',
                              'Authorization':'${widget.token}'
                            };

                            Map data = {
                              "Link": description.text,
                              "Title":title.text,
                              "TermAndConditions":"many many terms"
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
                              }

                            });
                          },
                            color: amber,
                            child: Text('Create Case Study',
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
              Card(
                child: Container(
                  width: media.width,
                  height: 130,
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
                          height: 20,
                        ),
                        Theme(
                          data: ThemeData(
                              primaryColor: amber
                          ),
                          child: TextField(
                            controller: Tc,
                            decoration: InputDecoration(
                              hintText: 'Terms And Condition',
                            ),
                          ),
                        ),
                        SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: RaisedButton(onPressed: (){

                            String u = "$url"+"/CaseStudy/EditTandC";

                            print(widget.token);
                            Map<String,String> header ={
                              'Content-type':'application/json',
                              'Accept':'application/json',
                              'Authorization':'${widget.token}'
                            };

                            Map data = {
                              "id":2,
                              "TermAndCondition": Tc.text,
                            };

                            var sb= jsonEncode(data);

                            http.put(u,headers: header, body: sb).then((value)async{
                              print(value.statusCode);



                            });
                          },
                            color: amber,
                            child: Text('Terms And Conditions',
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
              Text('Recent Case Study:',
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
                            postNews[index]["title"]==null ? Container(child: CircularProgressIndicator(),)
                            :
                            Text(postNews[index]["title"],
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
                                        return UpdateCaseStudy(
                                          bannerTitle: postNews[index]['title'],
                                          bId: postNews[index]['id'],
                                          imgUrl: postNews[index]['image'],
                                        );
                                      }));
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
                                  String u = "$url"+"/CaseStudy/DeleteCaseStudy/"+"$id";
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


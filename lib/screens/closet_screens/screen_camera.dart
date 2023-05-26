import 'dart:io';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class CameraScreen extends StatefulWidget {
  const CameraScreen({Key? key}) : super(key: key);

  @override
  _CameraScreenState createState() => _CameraScreenState();


}

class _CameraScreenState extends State<CameraScreen> {
  File? _image;
  ImagePicker picker = ImagePicker();
  // 비동기 처리를 통해 카메라와 갤러리에서 이미지를 가져온다.
  Future getImage(ImageSource imageSource) async {
    var image = await picker.pickImage(source: imageSource);
    setState(() {
      _image = File(image!.path); // 가져온 이미지를 _image에 저장
    });
    showImage();
  }
  Future<Map<String, dynamic>> sendPictureToServer(String id) async {
    File imageFile = File(_image!.path);
    List<int> imageBytes = imageFile.readAsBytesSync();
    String image = base64Encode(imageBytes);

    var url = Uri.parse('http://34.170.39.54:6000/imgprocess');
    var data =  {'image': image, 'id': id};
    var body = json.encode(data);

    var response = await http.post(url,
      headers: <String, String>{
        'Content-Type': 'application/json; charset=UTF-8',
      },
      body: body
    );

    if (response.statusCode == 200) {
      Map<String, dynamic> responseData = jsonDecode(response.body);
      String imageUrl = responseData['imageurl'];
      String category = responseData['category'];
      print('받은이미지'+imageUrl);
      print('카테고리'+category);
      return {'imageurl': imageUrl, 'category': category};
    } else {
      throw Exception('Failed to send image value to server');
    }
  }
  void showImageDialog(String imageUrl, String category) {
    var auth = FirebaseAuth.instance;
    var user = auth.currentUser;
    var id  =user!.email;
    print("ㄷㄻㄴㅇㄹ");
    showDialog(
      context: context,
      builder: (context) {
        String selectedCategory = category;
        return StatefulBuilder(builder: (context, setState) {
          return AlertDialog(
            content: SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: MediaQuery.of(context).size.width,
                ),
                child: IntrinsicWidth(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Image.network(
                        imageUrl,
                        fit: BoxFit.cover,
                      ),
                      SizedBox(height: 16),
                      Text(
                        'If you like the category and image, click OK. To retake, click Cancel. To edit the category, select from the dropdown and press OK.',
                      ),
                      SizedBox(height: 16),
                      DropdownButton<String>(
                        value: selectedCategory,
                        onChanged: (String? newValue) {
                          setState(() {
                            selectedCategory = newValue!;
                          });
                        },
                        items: <String>[
                          'Outer',
                          'Top',
                          'Bottom',
                          'Shoes',
                          'Acc',
                          'NoLabel',
                        ].map<DropdownMenuItem<String>>((String value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        // Set dropdown button's width to match the image width
                        // by using an IntrinsicWidth widget
                        dropdownColor: Colors.white,
                        isExpanded: true,
                      ),
                    ],
                  ),
                ),
              ),
            ),
            actions: <Widget>[
              TextButton(
                child: Text('Cancel'),
                onPressed: () {
                  sendCancelSignToServer(id!,imageUrl);
                  Navigator.of(context).pop();
                },
              ),
              TextButton(
                child: Text('OK'),
                onPressed: () {
                  print('선택된카테고리'+selectedCategory);
                  sendOkSignToServer(id!,selectedCategory, imageUrl);
                  Navigator.of(context).pop();
                  Navigator.of(context).pushNamed('/closet');
                },
              ),
            ],
          );
        });
      },
    );
  }

  // 이미지를 보여주는 위젯
  Widget showImage() {
    return Container(
        color: const Color(0xffd0cece),
        width: MediaQuery.of(context).size.width,
        height: MediaQuery.of(context).size.width,
        child: Center(
            child: _image == null
                ? Text('No image selected.')
                : Image.file(File(_image!.path))));
  }

  @override
  Widget build(BuildContext context) {
    var auth = FirebaseAuth.instance;
    var user = auth.currentUser;
    var id  =user!.email;
    // 화면 세로 고정
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);

    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color.fromARGB(255, 6, 67, 117),
        title: Text('옷 촬영'),
      ),
      backgroundColor: const Color(0xfff4f3f9),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 25.0),
          showImage(),
          SizedBox(
            height: 50.0,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: <Widget>[
              // 카메라 촬영 버튼
              FloatingActionButton(
                child: Icon(Icons.add_a_photo),
                tooltip: 'Pick Image',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('TIP'),
                        content: Text('Please make the whole picture of the clothes come out :)'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              getImage(ImageSource.camera);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              // 갤러리에서 이미지를 가져오는 버튼
              FloatingActionButton(
                child: Icon(Icons.wallpaper),
                tooltip: 'pick Image',
                onPressed: () {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text('TIP'),
                        content: Text('Please make the whole picture of the clothes come out :)'),
                        actions: <Widget>[
                          TextButton(
                            child: Text('OK'),
                            onPressed: () {
                              Navigator.of(context).pop();
                              getImage(ImageSource.gallery);
                            },
                          ),
                        ],
                      );
                    },
                  );
                },
              ),
              FloatingActionButton(
                child: Icon(Icons.navigate_next),//다음버튼
                onPressed: () async {
                  if (_image == null) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('No image')),
                    );
                  } else {//이미지가 비어있지 않으면
                    // Display a progress indicator indicating that it is being analyzed
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          content: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              CircularProgressIndicator(),
                              SizedBox(width: 16),
                              Text('analyzing image...'),
                            ],
                          ),
                        );
                      },
                    );

                    Map<String, dynamic> result = await sendPictureToServer(id!);
                    Navigator.of(context).pop();//이미지처리가 완료되면 로딩팝업 닫기.

                    String imageUrl = result['imageurl'];
                    String category = result['category']; //여기까지 완료
                    print(imageUrl);
                    print(category);
                    // Close the progress indicator
                    showImageDialog(imageUrl, category);
                  }
                },
              ),



            ],
          )
        ],
      ),
    );
  }
}

// function to send image to Flask server
Future<void> sendOkSignToServer(String id, String category, String imgurl) async {
  print("함수들어간카테고리"+category);
  print('아이디'+id);
  print('uURLRLR'+imgurl);
  var url = Uri.parse('http://34.170.39.54:6000/convert');
  var data = {'id': id, 'category': category, 'url': imgurl};
  var body = json.encode(data);
  var response = await http.post(url, headers: {"Content-Type": "application/json"}, body: body);

  if (response.statusCode == 200) {
    return ;
  } else {
    throw Exception("Fail to send ok sign to server");;
  }
}
Future<void> sendCancelSignToServer(String id,String imgurl) async {
  var url = Uri.parse('http://34.66.37.198:5000/delete');
  var data = {'id': id, 'url': imgurl};
  var body = json.encode(data);
  var response = await http.post(url, headers: {"Content-Type": "application/json"}, body: body);

  if (response.statusCode == 200) {
    return ;
  } else {
    throw Exception("Fail to send Cancel sign to server");
  }
}

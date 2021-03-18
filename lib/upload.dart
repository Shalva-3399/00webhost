import 'package:flutter/material.dart';
import 'package:file_picker/file_picker.dart';
import 'dart:convert';
import 'dart:io';
import 'package:flushbar/flushbar.dart';
import 'package:http/http.dart' as http;
import 'package:path/path.dart';
import 'constant.dart' as constant;

import 'main.dart';

class UploadClass extends StatefulWidget {
  @override
  _UploadClassState createState() => _UploadClassState();
}

class _UploadClassState extends State<UploadClass> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: Upload(),
    );
  }
}

class Upload extends StatefulWidget {
  @override
  UploadState createState() => UploadState();

  Upload();
}

class UploadState extends State<Upload> {
  // variable section

  UploadState createState() => UploadState();

  List<Widget> fileListThumb;
  List<File> fileList = new List<File>();
  List<Widget> thumbs;

  Future pickFiles() async {
    thumbs = new List<Widget>();
    fileListThumb.forEach((element) {
      thumbs.add(element);
    });

    await FilePicker.getMultiFile(
      type: FileType.custom,
      allowedExtensions: ['jpg', 'jpeg', 'bmp', 'pdf', 'doc', 'docx', 'png'],
    ).then((files) {
      if (files != null && files.length > 0) {
        files.forEach((element) {
          List<String> picExt = ['.jpg', '.jpeg', '.bmp'];

          if (picExt.contains(extension(element.path))) {
            thumbs.add(Padding(
                padding: EdgeInsets.all(1), child: new Image.file(element)));
          } else
            thumbs.add(Container(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                  Icon(Icons.insert_drive_file),
                  Text(extension(element.path))
                ])));
          fileList.add(element);
        });
        setState(() {
          fileListThumb = thumbs;
        });
      }
    });
  }

  List<Map> toBase64(List<File> fileList) {
    List<Map> s = new List<Map>();
    if (fileList.length > 0)
      fileList.forEach((element) {
        Map a = {
          'fileName': basename(element.path),
          'encoded': base64Encode(element.readAsBytesSync())
        };
        s.add(a);
      });
    return s;
  }

  Future<bool> httpSend(Map params) async {
    String endpoint = 'https://harshr.000webhostapp.com/FYP/upload.php';
    return await http.post(endpoint, body: params).then((response) {
      print(response.body);
      if (response.statusCode == 201) {
        Map<String, dynamic> body = jsonDecode(response.body);
        if (body['status'] == 'OK') print("heelo");
        return true;
      } else
      return true;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (fileListThumb == null)
      fileListThumb = [
        InkWell(
          onTap: pickFiles,
          child: Container(child: Icon(Icons.add)),
        )
      ];
    final Map params = new Map();
    return Scaffold(
      appBar: AppBar(
        title: Text("Uploader test"),
        actions: [
          Padding(
              padding: EdgeInsets.all(8.0),
              child: IconButton(
                icon: Icon(IconData(62404, fontFamily: 'MaterialIcons')),
                onPressed: () => _displayDialog(context),
              ))
        ],
      ),
      body: Center(
          child: Padding(
        padding: EdgeInsets.all(5),
        child: GridView.count(
          crossAxisCount: 4,
          children: fileListThumb,
        ),
      )),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          var xyz = Flushbar(
            message: "please wait :)",
            backgroundColor: Colors.red,
            icon: Icon(
              Icons.check,
              size: 28.0,
              color: Colors.blue[300],
            ),
            leftBarIndicatorColor: Colors.red,
          );
          xyz.show(context);
          List<Map> attch = toBase64(fileList);
          params["attachment"] = jsonEncode(attch);
          params['user_id'] = jsonEncode(constant.userId);
          print(constant.userId);
          httpSend(params).then((sukses) {
            if (sukses == true) {
              xyz.dismiss();
              Flushbar(
                message: "success :)",
                icon: Icon(
                  Icons.check,
                  size: 28.0,
                  color: Colors.blue[300],
                ),
                duration: Duration(seconds: 3),
                leftBarIndicatorColor: Colors.blue[300],
              ).show(context);
              initState();
            } else
              Flushbar(
                message: "fail :(",
                icon: Icon(
                  Icons.error_outline,
                  size: 28.0,
                  color: Colors.blue[300],
                ),
                duration: Duration(seconds: 3),
                leftBarIndicatorColor: Colors.red[300],
              ).show(context);
          });
        },
        tooltip: 'Upload File',
        child: const Icon(Icons.cloud_upload),
      ),
    );
  }

  _displayDialog(BuildContext context) async {
    return showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            title: Text('Do you want to logout!'),
            actions: <Widget>[
              new FlatButton(
                child: new Text('No'),
                onPressed: () {
                  Navigator.of(context).pop();
                },
              ),
              new FlatButton(
                child: new Text('Yes'),
                onPressed: () {
                  Navigator.of(context).pop();
                  Navigator.pushReplacement(context,
                      MaterialPageRoute(builder: (context) => new MyApp()));
                },
              )
            ],
          );
        });
  }
}
//
//class TextFieldAlertDialog extends StatefulWidget {
//  @override
//  _TextFieldAlertDialogState createState() => _TextFieldAlertDialogState();
//}
//
//class _TextFieldAlertDialogState extends State<TextFieldAlertDialog> {
//  TextEditingController _textFieldController = TextEditingController();
//
//  _displayDialog(BuildContext context) async {
//    return showDialog(
//        context: context,
//        builder: (context) {
//          return AlertDialog(
//            title: Text('TextField AlertDemo'),
//            content: TextField(
//              controller: _textFieldController,
//              decoration: InputDecoration(hintText: "TextField in Dialog"),
//            ),
//            actions: <Widget>[
//              new FlatButton(
//                child: new Text('SUBMIT'),
//                onPressed: () {
//                  Navigator.of(context).pop();
//                },
//              )
//            ],
//          );
//        });
//  }
//
//  @override
//  Widget build(BuildContext context) {
//    return Scaffold(
//      appBar: AppBar(
//        title: Text('TextField AlertDialog Demo'),
//      ),
//      body: Center(
//        child: FlatButton(
//          child: Text(
//            'Show Alert',
//            style: TextStyle(fontSize: 20.0),),
//          padding: EdgeInsets.fromLTRB(20.0, 12.0, 20.0, 12.0),
//          shape: RoundedRectangleBorder(
//              borderRadius: BorderRadius.circular(8.0)
//          ),
//          color: Colors.green,
//          onPressed: () => _displayDialog(context),
//        ),
//      ),
//    );
//  }
//}

import 'dart:async';
import 'dart:io';
import 'package:custom_progress_dialog/custom_progress_dialog.dart';
import 'package:ephysicsapp/globals/colors.dart';
import 'package:ephysicsapp/widgets/pdfViewer.dart';
import 'package:ephysicsapp/widgets/popUps.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:firebase_storage/firebase_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:uuid/uuid.dart';
import 'package:flutter/foundation.dart';
import 'package:path_provider/path_provider.dart';

addDoc({String section, String moduleID, String docName, File doc}) async {
  var uuid = Uuid();
  String uniqueID = uuid.v1();
  String downloadUrl;
  try {
    var storageReference =
        FirebaseStorage.instance.ref().child("$section/$moduleID/" + uniqueID);
    var uploadTask = storageReference.putFile(doc);
    await uploadTask.whenComplete(() async {
      await storageReference.getDownloadURL().then((fileURL) {
        downloadUrl = fileURL;
      });
    });

    final databaseReference = FirebaseDatabase.instance.reference();
    await databaseReference
        .child(section)
        .child(moduleID)
        .child("documents")
        .child(uniqueID)
        .set({
      "docName": docName,
      "docID": uniqueID,
      "downloadUrl": downloadUrl,
    });
    showToast("Added Sucessfully");
  } catch (e) {
    print(e);
    showToast("Failed");
  }
}

deleteDoc({String docID, String moduleID, String section}) async {
  var storageReference =
      FirebaseStorage.instance.ref().child("$section/$moduleID/" + docID);
  var uploadTask = storageReference.delete();
  await uploadTask.whenComplete(() async {
    await FirebaseDatabase.instance
        .reference()
        .child(section)
        .child(moduleID)
        .child("documents")
        .child(docID)
        .remove();
    showToast("Removed Successfully");
  });
}

Future<void> openFile(String url, BuildContext context) async {

  ProgressDialog _progressDialog = ProgressDialog(); 
  _progressDialog.showProgressDialog(
    context,textToBeDisplayed: 'Opening...',
    
    dismissAfter: Duration(seconds: 5));

  String remotePDFpath = "";
  createFileOfPdfUrl(url).then((f) {
    remotePDFpath = f.path;

    if (remotePDFpath != null || remotePDFpath.isNotEmpty) {
       _progressDialog.dismissProgressDialog(context);
      Navigator.push(
        context,
        MaterialPageRoute(
          builder: (context) => PDFScreen(path: remotePDFpath),
        ),
      );
    }
   
  });
}

Future<File> createFileOfPdfUrl(String pdfUrl) async {
  Completer<File> completer = Completer();
  print("Start download file from internet!");
  try {
    // "https://berlin2017.droidcon.cod.newthinking.net/sites/global.droidcon.cod.newthinking.net/files/media/documents/Flutter%20-%2060FPS%20UI%20of%20the%20future%20%20-%20DroidconDE%2017.pdf";
    // final url = "https://pdfkit.org/docs/guide.pdf";
    final url = pdfUrl;
    final filename = url.substring(url.lastIndexOf("/") + 1);
    var request = await HttpClient().getUrl(Uri.parse(url));
    var response = await request.close();
    var bytes = await consolidateHttpClientResponseBytes(response);
    var dir = await getApplicationDocumentsDirectory();
    print("Download files");
    print("${dir.path}/$filename");
    File file = File("${dir.path}/$filename");

    await file.writeAsBytes(bytes, flush: true);
    completer.complete(file);
  } catch (e) {
    throw Exception('Error parsing asset file!');
  }

  return completer.future;
}

//  Future getFuture(String url,BuildContext context) {
//     return Future(() async {
//       await openFile( url,context);
//       return 'Read File';
//     });
//   }

// Future<void> openDocProgressIndicator(BuildContext context,String url) async {
//     var result = await showDialog(
//         context: context,
//         child: FutureProgressDialog(getFuture(url,context), message: Text('Opening File...')));
//     showResultDialog(context, result);
//   }

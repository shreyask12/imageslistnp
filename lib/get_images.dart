import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'list_item_model.dart';


const _imageurl = 'http://test.chatongo.in/testdata.json'; 


class GetImages {


// GetImages(this.data);
List <dynamic> images = [];
List <ListItems<dynamic>> list = [];
// = List<ListItems<Map>>();
List<File> files = List<File>();
bool iscSelected = false;


Future getImages() async {

  
  try {

    http.Response response = await http.get(_imageurl);
      
    if(response.statusCode == 200){

      var decodedData = jsonDecode(response.body);
      
      images = decodedData['data']['Records'];

      
    for(var i=0; i < images.length;i++){
       
      images[i].putIfAbsent('isSelected', () => false);
      
      http.Response resp = await http.get(images[i]['mainImageURL']);
      saveImage('shr','fund-$i',resp.bodyBytes);
    
    }
    saveObject('shr', 'fundslist', images);
     
    // print(images);

      return images;
    }

  }catch(e){
     print(e);

  }
}



  String _generateKey(String userId, String key) {
    return '$userId/$key';
  }

  // @override/
Future<String> saveImage(String userId, String key, Uint8List image) async {
  // 1
  final base64Image = Base64Encoder().convert(image);
  final prefs = await SharedPreferences.getInstance();
  // 2
  await prefs.setString(_generateKey(userId, key), base64Image);
  // 3
  return key;
}

// @override
Future<Uint8List> getImage(String userId, String key) async {
  final prefs = await SharedPreferences.getInstance();
  // 4
  final base64Image = prefs.getString(_generateKey(userId, key));
  // 5
  if (base64Image != null) return Base64Decoder().convert(base64Image);
  // 6
  return null;
}

// @override
void saveObject(String userId, String key, List<dynamic> object) async {
  final prefs = await SharedPreferences.getInstance();
  // 1
  final string = JsonEncoder().convert(object);
  // 2
  await prefs.setString(_generateKey(userId, key), string);
}

// @override
Future<List<dynamic>> getObject(String userId, String key) async {
  final prefs = await SharedPreferences.getInstance();
  // 3
  final objectString = prefs.getString(_generateKey(userId, key));
  // 4
  if (objectString != null)
    return JsonDecoder().convert(objectString) as List<dynamic>;
  return null;
}

// @override
Future<void> removeObject(String userId, String key) async {
  final prefs = await SharedPreferences.getInstance();
  // 5
  prefs.remove(_generateKey(userId, key));
}




}





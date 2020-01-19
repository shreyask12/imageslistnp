import 'dart:async';
import 'package:flutter/material.dart';
import 'get_images.dart';
import 'pledge_button.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
// import 'package:like_button/like_button.dart';


class ImageList extends StatefulWidget {
  @override
  _ImageListState createState() => _ImageListState();
}

class _ImageListState extends State<ImageList> {
  
List<dynamic> imageitems = List<dynamic>();
List<dynamic> infoItems = List<dynamic>();
List<dynamic> images = List<dynamic>();
List<dynamic> allImages = List<dynamic>();

bool isInternetOn = true;

GetImages getimg; 

Connectivity connectivity;
StreamSubscription<ConnectivityResult> subscription;


  @override
  void initState() {
    
    super.initState();

    getimg = GetImages();

    connectivity = new Connectivity();
    subscription = connectivity.onConnectivityChanged.listen((ConnectivityResult result){
        
        if(result == ConnectivityResult.wifi || result == ConnectivityResult.mobile){
          
          setState(() {
            isInternetOn = true;
            _getData();
          });
          
        }else {

          setState(() {

            isInternetOn = false;
            _getData();
          });
          
        }
    });
    
  }

  @override
  void dispose(){
    subscription.cancel();
    super.dispose();
  }

  Future _getData() async {

      images.clear();
      allImages.clear();
      infoItems.clear();

    if(isInternetOn){

      return imageitems = await getimg.getImages();
    
    }else {

        for(var j=0;j<10;j++){ 

          images.add(await getimg.getImage('shr', 'fund-$j'));
        
        }
        allImages.addAll(images);
      
        infoItems = await getimg.getObject('shr', 'fundslist');

      return infoItems;

    }
  
  }

 

  Widget _renderImages(BuildContext context,int index){
  //  print(MediaQuery.of(context).size.width);
  
    return Stack(
      children : <Widget> [
        Container(
          // padding: EdgeInsets.only(right:ScreenUtil().setWidth(5.0)),
          width: ScreenUtil().setWidth(360),
          height: ScreenUtil().setWidth(350),
           color: Color(0xFF3983a3),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
                 isInternetOn ?
                Image.network(
                  imageitems[index]['mainImageURL'],
                  filterQuality: FilterQuality.high,
                  fit: BoxFit.fitWidth,
                  
                ) : imageMemory(images[index]),
                  SizedBox(
                    height: ScreenUtil().setHeight(70),
                    width: MediaQuery.of(context).size.width,

                  ),
                    Padding(
                      padding: EdgeInsets.only(bottom: ScreenUtil().setWidth(8),right:ScreenUtil().setWidth(5)),
                      child: Row(
                        children: <Widget>[
                          Textdisplay(
                            value: isInternetOn ? imageitems[index]['collectedValue'].toString() : 
                             infoItems[index]['collectedValue'].toString() ,
                            text: 'FUNDED'),
                          Textdisplay(value:isInternetOn ? imageitems[index]['totalValue'].toString() : 
                          infoItems[index]['totalValue'].toString() ,
                          text: 'GOALS'),
                          Textdisplay(text:'ENDS IN',
                          value: differenceCheck(isInternetOn ? imageitems[index]['startDate'] : infoItems[index]['startDate'],
                          isInternetOn ? imageitems[index]['endDate']: infoItems[index]['endDate']),),
                          PledgeButton(
                            onPressed: () {
                              
                            },
                          ),
                          ],
                        ),
                    ),
                // ),
      
              ],
            ),
          ),
          Positioned(
            left: ScreenUtil().setWidth(10),
            top: ScreenUtil().setWidth(175),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children:<Widget>[ 
                Container(
                  height: ScreenUtil().setWidth(100),
                  width: ScreenUtil().setWidth(280),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      shape: BoxShape.rectangle,
                      border: Border.all(color: Colors.white,width: ScreenUtil().setWidth(1.0)),
                      borderRadius: BorderRadius.circular(ScreenUtil().setWidth(10)),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: <Widget>[
                        Row( 
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: <Widget>[
                            Padding(
                              padding: EdgeInsets.only(top:ScreenUtil().setWidth(5),left:ScreenUtil().setWidth(8)),
                              child: Text(isInternetOn ? imageitems[index]['title'] : infoItems[index]['title'],
                                style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: ScreenUtil().setSp(15),
                                ),
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.only(top:ScreenUtil().setWidth(5),right:ScreenUtil().setWidth(8)),
                              child: IconButton(
                               icon: Icon(Icons.favorite,
                                color: Colors.pink,
                                size : ScreenUtil().setWidth(24),
                                
                               ),
                               onPressed: () {
                                  
                                  setState(() {
                                    if(imageitems[index]['isSelected']){
                                        imageitems[index]['isSelected'] = false;
                                    }else {
                                      imageitems[index]['isSelected'] = true;
                                    }
                                      });
                               },
                                
                              ),
                            ),
                          ],
                        ),
                        Padding(
                          padding: EdgeInsets.only(top:ScreenUtil().setWidth(22),left:ScreenUtil().setWidth(8)),
                          child: Text(isInternetOn ? imageitems[index]['shortDescription'] : infoItems[index]['shortDescription'],
                            style: TextStyle(
                                fontSize: ScreenUtil().setSp(15),
                      
                            ),
                          ),
                        ),
                      ],
                    ),
                ),
                Padding(
                  padding: EdgeInsets.only(left:ScreenUtil().setWidth(8)),
                  child: Container(
                    height:  ScreenUtil().setWidth(50),
                    width: ScreenUtil().setWidth(50),
                    decoration: BoxDecoration(
                      color: Color(0xff0a4b5d),
                      shape: BoxShape.circle,
                    ),
                    child: Center(
                      child: Text('100 %',
                        style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: ScreenUtil().setSp(12),
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
        ),
      ],
    );
  }


  @override
  Widget build(BuildContext context) {

    ScreenUtil.init(context, width: 360, height: 720, allowFontScaling: true);
    return Scaffold(
      backgroundColor: Colors.black12,
      body: SafeArea(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            SizedBox(
              height: ScreenUtil().setHeight(30),
              width: ScreenUtil().setWidth(360),
            ),
            Padding(
              padding: EdgeInsets.all(ScreenUtil().setWidth(10.0)),
              child: Text(
                'Record List',
                style: TextStyle(
                  fontStyle: FontStyle.normal,
                  fontWeight: FontWeight.bold,
                  fontSize: ScreenUtil().setSp(40),
                  color: Colors.white,
                ),
              ),
            ),
            Flexible(
              child: FutureBuilder(
               future: _getData(),
              builder: (cntxt,snapshot){
                  // print(snapshot);
                  if(snapshot.hasData){

                    return ListView.builder(
                    itemCount: isInternetOn ? imageitems.length : allImages.length,
                    itemBuilder: (BuildContext context,int index) {
                      return Container(
                        height: ScreenUtil().setWidth(350),
                        width: ScreenUtil().setWidth(360),
                        // constraints: BoxConstraints(maxHeight: ScreenUtil().setHeight(350)),
                        child: horizontalList(),
                      );
                    },
                    shrinkWrap: true,
                    
                  );

                }
                else{
                     return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Color(0xFF3983a3),
                    ),
                     );
                  }
                }, 
              ),
            ),
          ],
        ),
      ),
    );

  }

 Widget horizontalList() {
   return Container(
     height: ScreenUtil().setWidth(350),
     width: ScreenUtil().setWidth(360),
      // constraints: BoxConstraints(maxHeight: ScreenUtil().setHeight(350)),
      child: FutureBuilder(
          builder: (cntxt,snapshot){
            // print(snapshot);
            if(snapshot.hasData){
              return ListView.builder(
            
            scrollDirection: Axis.horizontal,
            // shrinkWrap: true,
            // physics: ScrollPhysics(),
            itemCount: isInternetOn ? imageitems.length : allImages.length,
            itemBuilder: (BuildContext context,int index) => _renderImages(context,index),
            );
          }else {
            return Center(
                      child: CircularProgressIndicator(
                        backgroundColor: Color(0xFF3983a3),
                    ),
                  );
          } 
        },
        future: _getData(),
      )
          ,
    );



 }

 Widget imageMemory(bytes) {
   return Image.memory(bytes,
              filterQuality: FilterQuality.high,
              fit: BoxFit.fitWidth,
          );
     

 }

  

  String differenceCheck(String startdt, String enddt) {

    List<String> split1 = startdt.split('/');
    List<String> split2 = enddt.split('/');

    final startdate = DateTime(int.parse(split1[2]),int.parse(split1[1]),int.parse(split1[0]));
    final enddate = DateTime(int.parse(split2[2]),int.parse(split2[1]),int.parse(split2[0]));

    return (enddate.difference(startdate).inDays.toString());
    
  }

 
}

class Textdisplay extends StatelessWidget {

  const Textdisplay({this.value,@required this.text});

  final String value;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Text(text != 'ENDS IN' ? "\u20B9 " + value : value,
          style: TextStyle(
              fontSize: ScreenUtil().setSp(12.0),
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          Padding(
            padding: EdgeInsets.only(top:ScreenUtil().setWidth(15.0)),
            child: Text(text,
            style: TextStyle(
                fontSize: ScreenUtil().setSp(12.0),
                color: Colors.white54,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}


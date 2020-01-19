import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class PledgeButton extends StatelessWidget {

  PledgeButton({this.onPressed});

  final Function onPressed;

  @override
  Widget build(BuildContext context) {
    // var height = MediaQuery.of(context).size.height;
    // var width = MediaQuery.of(context).size.width;
    // ScreenUtil.init(context, width: width, height: height, allowFontScaling: true);
    return Container(
       width: ScreenUtil().setWidth(100),
       height: ScreenUtil().setWidth(30),
        decoration: BoxDecoration(
          color: Colors.white,
            border: Border.all(color: Colors.white,width: ScreenUtil().setWidth(1.0)),
            borderRadius: new BorderRadius.circular(ScreenUtil().setWidth(10.0)),
          ),
            child: Material(
              color: Colors.transparent,
              child: InkWell(
                splashColor: Colors.black12,
                child: Center(
                  child: Text(
                    'PLEDGE',
                    style: TextStyle(
                      color: Color(0xFF3983a3),
                      fontSize: ScreenUtil().setSp(12),
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                onTap: onPressed,
              ),
            ),
      
    );
  }
}
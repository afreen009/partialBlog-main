import 'package:flutter/material.dart';
import 'package:google_signin_example/services/theme_changer.dart';
import 'package:provider/provider.dart';

class ThemePage extends StatefulWidget {
  @override
  _ThemePageState createState() => _ThemePageState();
}

class _ThemePageState extends State<ThemePage> {
  TextEditingController nameController = TextEditingController();
  int _radioValue = 0;
  // Color primaryColor = Color(0xff18203d);
  @override
  Widget build(BuildContext context) {
    final themeChanger = Provider.of<ThemeChanger>(context);
    void _handleRadioValueChange(int value) {
      setState(() {
        _radioValue = value;
        switch (_radioValue) {
          case 0:
            themeChanger.toggle();
            break;
          case 1:
            themeChanger.toggle();
            break;
        }
      });
    }

    return Scaffold(
      appBar: AppBar(
        backgroundColor: Color(0xff18203d),
        iconTheme: IconThemeData(
          color: Colors.white, //change your color here
        ),
        title: Text('Set Theme'),
      ),
      body: Column(
        children: [
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Text('Light',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    // color: Colors.black,
                  )),
              Spacer(),
              new Radio(
                value: 0,
                groupValue: _radioValue,
                onChanged: _handleRadioValueChange,
              ),
            ],
          ),
          Row(
            children: [
              SizedBox(
                width: 20,
              ),
              Text('Dark',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    // color: Colors.black,
                  )),
              Spacer(),
              Radio(
                value: 1,
                groupValue: _radioValue,
                onChanged: _handleRadioValueChange,
              ),
            ],
          )
        ],
      ),
    );
  }
}

// Transform.scale(
//     scale: .7,
//     child: InkWell(
//       onTap: () {
//         setState(() {
//           _switchValue = !_switchValue;
//         });
//       },
//       child: CupertinoSwitch(
//         trackColor: Colors.grey,
//         value: _switchValue,
//         onChanged: (bool value) {
//           setState(() {
//             _switchValue = value;
//             themeChanger.toggle();
//           });
//         },
//       ),
//     )),

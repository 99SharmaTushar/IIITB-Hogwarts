import 'package:app/models/user_auth.dart';
import 'package:app/screens/home.dart';
import 'package:app/screens/register.dart';
import 'package:app/services/user_auth.dart';
import 'package:app/widgets/CustomWidgets.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:fluttertoast/fluttertoast.dart';

class LoginPage extends StatefulWidget {
  @override
  _LoginPageState createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {

  //Parameters
  String _email;
  String _password;
  final _formKey = GlobalKey<FormState>();
  final _textStyle = TextStyle(fontSize: 15);

  //Build each form field
  Widget _buildEmail(){
    return TextFormField(
      keyboardType: TextInputType.emailAddress,
      style: _textStyle,
      decoration: InputDecoration(
          prefixIcon: Container(margin: EdgeInsets.fromLTRB(4,4,8,4) ,child: CircleAvatar(
              backgroundColor: Color(0xFFFFFFFF),
              backgroundImage: AssetImage('images/cat.jpg'),
            )),
          hintText: 'Email address',
          contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 10),
          filled: true,
          fillColor: Color(0xFFFFFFFF).withOpacity(0.40),
          border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none)
      ),
      validator: (value){
        if(value.isEmpty)
          return 'Email is required';
        return null;
      },
      onSaved: (value){
        _email = value;
      },
    );
  }
  Widget _buildPassword(){
    return TextFormField(
        obscureText: true,
        style: _textStyle,
        decoration: InputDecoration(
            prefixIcon: Container(margin: EdgeInsets.fromLTRB(4,4,8,4) ,child: CircleAvatar(
                backgroundColor: Color(0xFFFFFFFF),
                child: Padding(padding: EdgeInsets.all(6),
                  child:SvgPicture.asset('images/ic_key.svg', fit: BoxFit.cover,),
              ))),
            hintText: 'Password',
            contentPadding: EdgeInsets.symmetric(vertical: 0, horizontal: 20),
            filled: true,
            fillColor: Color(0xFFFFFFFF).withOpacity(0.40),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(25),
                borderSide: BorderSide.none)
        ),
        validator: (value){
          if(value.isEmpty)
            return 'Password is required';
          return null;
        },
        onSaved: (value){
          _password = value;
        },
      );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BackgroundImage(
        child: Container(
          width: MediaQuery.of(context).size.width,
          margin: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
          child: Column(
            children: <Widget>[
              Expanded(child: SizedBox()),
              Column(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text('Login',
                    textScaleFactor: 2,
                    style: Theme.of(context).textTheme.body2,
                  ),
                  SizedBox(height: 25),
                  Form(
                    key: _formKey,
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: <Widget>[
                        _buildEmail(),
                        SizedBox(height: 10),
                        _buildPassword(),
                        SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.end,
                          children: <Widget>[
                            Text('Not a member?', textScaleFactor: 1,),
                            SizedBox(width: 5),
                            FlatButton(
                              textColor: Theme.of(context).accentColor,
                              child: Text('Register', textScaleFactor: 1,),
                              onPressed: () { navigateTo(RegisterPage(), context); },
                            )
                          ],
                        ),
                        SizedBox(height: 15),
                        Container(
                          width: MediaQuery.of(context).size.width,
                          child: RaisedButton(
                            padding: EdgeInsets.symmetric(vertical: 10),
                            color: Color(0xFFFFFFFF).withOpacity(0.50),
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25)
                            ),
                            child: Text('Login', textScaleFactor: 1.5,),
                            onPressed: (){
                              if(!_formKey.currentState.validate()) {
                                return;
                              }
                              _formKey.currentState.save();
                              onLoginClick();
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                ],
              ),
              Expanded(child: SizedBox()),
              Text('TEAM  HOGWARTS')
            ],
          ),
        ),
      ),
    );
  }

  void onLoginClick() async{
    Users user = Users(_email, _password);
    try {
      var data = await loginStatus(user);
      if (data == 200) {
        navigateTo(HomePage(), context);
        Fluttertoast.showToast(msg: 'Auth successful!',
            toastLength: Toast.LENGTH_SHORT);
      } else {
        Fluttertoast.showToast(msg: 'Auth failed!',
            toastLength: Toast.LENGTH_SHORT);
      }
    } catch(error) {
      Fluttertoast.showToast(msg: error.toString(),
          toastLength: Toast.LENGTH_SHORT);
    }
  }

}

void navigateTo(Widget widget, BuildContext context){
  Navigator.push(context, MaterialPageRoute(builder: (context){
    return widget;
  }));
}

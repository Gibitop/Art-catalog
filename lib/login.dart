import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Login extends StatelessWidget {
  final String title;
  final bool mustLogin;
  Login({Key key, @required this.title, @required this.mustLogin})
      : super(key: key);
  @override
  Widget build(BuildContext context) {
    String newID = '';
    return WillPopScope(
      onWillPop: () => Future.value(!mustLogin),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          automaticallyImplyLeading: !mustLogin,
          actions: <Widget>[
            IconButton(
              padding: EdgeInsets.all(0),
              iconSize: 32,
              icon: Icon(Icons.help),
              onPressed: () {
                print('SHOW "ABOUT" PAGE');
              },
            )
          ],
        ),
        body: Column(
          children: <Widget>[
            Text(
              'Login',
              textAlign: TextAlign.right,
              style: TextStyle(
                fontSize: 40,
              ),
            ),
            Text(
                'Your artchive ID is a 5 digit number that you can obtain form your artchive page URL.\nFor example, for "artchive.ru/artists/83618~Ol\'ga_Dejkova" the ID is 83618'),
            TextField(
              onChanged: (id) {
                newID = id;
              },
            ),
            Builder(
                builder: (context) => FlatButton(
                      onPressed: () {
                        if (newID.isEmpty) {
                          Scaffold.of(context).showSnackBar(SnackBar(
                            content:
                                Text('You have to fill in you artchive ID'),
                          ));
                        } else {
                          Navigator.pop(context, newID);
                        }
                      },
                      child: Text('AAA'),
                    ))
          ],
        ),
      ),
    );
  }
}

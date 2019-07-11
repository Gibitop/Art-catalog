import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';

class Login extends StatelessWidget {
  final String title;
  final bool mustLogin;
  Login({Key key, @required this.title, @required this.mustLogin})
      : super(key: key);

  _onSubmit(newID, context) {
    if (newID.isEmpty) {
      Scaffold.of(context).showSnackBar(SnackBar(
        content: Text('You have to fill in you artchive ID'),
      ));
    } else {
      Navigator.pop(context, newID);
    }
  }

  @override
  Widget build(BuildContext context) {
    String newID = '';
    return WillPopScope(
      onWillPop: () => Future.value(!mustLogin),
      child: Scaffold(
        appBar: AppBar(
          title: Text(title),
          automaticallyImplyLeading: !mustLogin,
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
            Builder(
              builder: (context) => TextField(
                onChanged: (id) {
                  newID = id;
                },
                onSubmitted: (text) => _onSubmit(newID, context),
              ),
            ),
            Builder(
                builder: (context) => FlatButton(
                      onPressed: () => _onSubmit(newID, context),
                      child: Text('Submit'),
                    ))
          ],
        ),
      ),
    );
  }
}

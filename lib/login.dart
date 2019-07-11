import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/widgets.dart';

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
        body: Padding(
          padding: const EdgeInsets.all(10),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Text(
                'Login',
                style: Theme.of(context).textTheme.display1,
              ),
              SizedBox(height: 10),
              Text(
                'Your artchive ID is a number that you can obtain form your artchive page URL. For example, for URL',
                style: Theme.of(context).textTheme.body1,
                textAlign: TextAlign.left,
              ),
              Text('artchive.ru/artists/83618~Ol\'ga_Dejkova',
                  style: Theme.of(context).textTheme.body2,
                  textAlign: TextAlign.left),
              Text('the ID is 83618',
                  style: Theme.of(context).textTheme.body1,
                  textAlign: TextAlign.left),
              Builder(
                builder: (context) => TextField(
                  autofocus: true,
                  autocorrect: false,
                  decoration: InputDecoration(
                      prefixIcon: Icon(Icons.account_circle),
                      labelText: 'Artchive ID'),
                  onChanged: (id) {
                    newID = id;
                  },
                  onSubmitted: (text) => _onSubmit(newID, context),
                ),
              ),
              Center(
                child: Container(
                  width: 200,
                  padding: EdgeInsets.all(10),
                  child: Builder(
                      builder: (context) => FlatButton(
                            onPressed: () => _onSubmit(newID, context),
                            child: Text('Submit'),
                            textTheme: ButtonTextTheme.primary,
                            color: Theme.of(context).accentColor,
                          )),
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';

class Backdrop extends StatefulWidget {
  @override
  _BackdropState createState() => _BackdropState();
}

class _BackdropState extends State<Backdrop>
    with SingleTickerProviderStateMixin {
  AnimationController controller;

  final GlobalKey<FormState> _formKeyLogin = GlobalKey<FormState>();
  final GlobalKey<FormState> _formKeySignup = GlobalKey<FormState>();
  final TextEditingController _passwordController = TextEditingController();

  Map<String, dynamic> _userData = {
    'phoneNumber ': '',
    'username': '',
    'password': '',
    'firstName ': '',
    'lastName ': '',
    'address ': ''
  };

  double _opacitySignup = 1.0, _opacityLogin = 0.0, _opacityHamb = 0.0;

  @override
  void initState() {
    super.initState();
    controller = AnimationController(
        vsync: this, duration: Duration(seconds: 1), value: 1.0);
  }

  @override
  void dispose() {
    super.dispose();
    controller.dispose();
  }

  bool get isPanelVisible {
    final AnimationStatus status = controller.status;
    return status == AnimationStatus.completed ||
        status == AnimationStatus.forward;
  }

  static const header_height = 50.0;
  Animation<RelativeRect> backDropAnimation(BoxConstraints constraints) {
    final height = constraints.biggest.height;
    final backPanelHeight = height - header_height;
    final frontPanelHeight = -header_height;

    return RelativeRectTween(
      begin: RelativeRect.fromLTRB(0.0, 70.0, 0.0, 0.0),
      end: RelativeRect.fromLTRB(0.0, backPanelHeight, 0.0, frontPanelHeight),
    ).animate(CurvedAnimation(parent: controller, curve: Curves.linear));
  }

  void changeBackdrop() {
    FocusScope.of(context).requestFocus(new FocusNode());
    controller.fling(velocity: isPanelVisible ? -1.0 : 1.0);
    setState(() {
      this._opacitySignup = 1.0 - this._opacitySignup;
      this._opacityLogin = 1.0 - this._opacityLogin;
      this._opacityHamb = 1.0 - this._opacityHamb;
    });
  }

  void _submitLogin(Function login) async {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (!_formKeyLogin.currentState.validate()) return;
    _formKeyLogin.currentState.save();
    int result = await login(_userData);
    if (result == 2) {
      print('LoggedIn');
      Navigator.pushReplacementNamed(context, '/');
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Error'),
        content: Text(
            '${result == 0 ? 'somthing went worng!' : 'Usernam/phoneNumber  or password is Wrong!'}'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Dissmiss'),
          ),
        ],
      ),
    );
  }

  void _submitSignup(Function signup) async {
    FocusScope.of(context).requestFocus(new FocusNode());
    if (!_formKeySignup.currentState.validate()) return;
    _formKeySignup.currentState.save();
    int result = await signup(_userData);
    if (result == 2) {
      print('LoggedIn');
      Navigator.pushReplacementNamed(context, '/');
      return;
    }
    showDialog(
      context: context,
      builder: (BuildContext context) => AlertDialog(
        title: Text('Error'),
        content: Text(
            '${result == 0 ? 'somthing went worng!' : 'Username/phoneNumber  already exist'}'),
        actions: <Widget>[
          FlatButton(
            onPressed: () => Navigator.of(context).pop(),
            child: Text('Dissmiss'),
          ),
        ],
      ),
    );
  }

  Widget panels(BuildContext context, BoxConstraints constraints) {
    final deviceWidth = MediaQuery.of(context).size.width;
    final ThemeData theme = Theme.of(context);
    var validator2 = (String value) {
      if (value.isEmpty || value.length < 5) {
        return 'password must be at least 5 characters';
      }
    };
    return Material(
      type: MaterialType.transparency,
      child: Container(
        child: Stack(
          children: <Widget>[
            Container(
                color: Colors.white,
                child: Column(
                  children: <Widget>[
                    Container(
                      child: Image.asset('assets/image/vegt.png'),
                      alignment: Alignment(1.0, -1.0),
                    ),
                    Center(
                      child: SingleChildScrollView(
                        padding: EdgeInsets.only(left: 45, right: 35),
                        child: Container(
                          width: deviceWidth,
                          child: Form(
                            key: _formKeyLogin,
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: <Widget>[
                                SizedBox(
                                  height: 15,
                                ),
                                SizedBox(
                                  height: 45,
                                ),
                                TextFormField(
                                  validator: (String value) {
                                    if (value.isEmpty || value.length < 5) {
                                      return 'username/phoneNumber  is not valid';
                                    }
                                  },
                                  onSaved: (String value) {
                                    _userData['phoneNumber '] = value;
                                    _userData['username'] = value;
                                  },
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blueGrey[200])),
                                    border: OutlineInputBorder(),
                                    labelText: 'Username or phoneNumber ',
                                    suffixIcon: Icon(Icons.mail_outline),
                                  ),
                                ),
                                SizedBox(
                                  height: 15,
                                ),
                                TextFormField(
                                  validator: (String value) {
                                    if (value.isEmpty || value.length < 5) {
                                      return 'password must be at least 5 characters!';
                                    }
                                  },
                                  onSaved: (String value) {
                                    _userData['password'] = value;
                                  },
                                  obscureText: true,
                                  decoration: InputDecoration(
                                    enabledBorder: OutlineInputBorder(
                                        borderSide: BorderSide(
                                            color: Colors.blueGrey[200])),
                                    border: OutlineInputBorder(),
                                    labelText: 'Password',
                                    suffixIcon: Icon(Icons.lock_outline),
                                  ),
                                ),
                                SizedBox(
                                  height: 13.0,
                                ),
                                GestureDetector(
                                  onTap: () {
                                    print('Forgot Function');
                                  },
                                  child: Text('Forgot your password ?'),
                                ),
                                SizedBox(
                                  height: 35.0,
                                ),
                                RaisedButton(
                                  color: Colors.blueGrey[800],
                                  padding: EdgeInsets.symmetric(
                                      vertical: 12, horizontal: 30),
                                  onPressed: () {},
                                  child: Text("Login"),
                                ),
                                SizedBox(
                                  height: 60.0,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                )),
            PositionedTransition(
              rect: backDropAnimation(constraints),
              child: Container(
                padding: EdgeInsets.only(left: 45),
                child: Material(
                  color: theme.primaryColor,
                  elevation: 10.0,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(16.0),
                  ),
                  child: Column(
                    children: <Widget>[
                      GestureDetector(
                        onTap: changeBackdrop,
                        child: Container(
                          height: header_height,
                          color: Colors.transparent,
                          padding: EdgeInsets.only(left: 10),
                          width: deviceWidth - 30,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: <Widget>[
                              IconButton(
                                icon: AnimatedIcon(
                                  icon: AnimatedIcons.arrow_menu,
                                  progress: controller.view,
                                ),
                                onPressed: changeBackdrop,
                              ),
                              Stack(
                                children: <Widget>[
                                  AnimatedOpacity(
                                    opacity: _opacitySignup,
                                    duration: Duration(milliseconds: 500),
                                    child: Text(
                                      'Signup',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey[800],
                                      ),
                                    ),
                                  ),
                                  AnimatedOpacity(
                                    opacity: _opacityLogin,
                                    duration: Duration(milliseconds: 500),
                                    child: Text(
                                      'Login',
                                      style: TextStyle(
                                        fontSize: 18,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.blueGrey[800],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                      Expanded(
                        child: Stack(
                          alignment: Alignment.centerRight,
                          children: <Widget>[
                            Container(
                              alignment: Alignment.bottomRight,
                              child: AnimatedOpacity(
                                opacity: _opacityHamb,
                                duration: Duration(milliseconds: 300),
                                child: Image.asset('assets/image/hamb.png'),
                              ),
                              width: 150,
                              color: Colors.transparent,
                            ),
                            SingleChildScrollView(
                              padding: EdgeInsets.symmetric(horizontal: 35),
                              child: Form(
                                key: _formKeySignup,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    SizedBox(
                                      height: 5.0,
                                    ),
                                    SizedBox(
                                      height: 10,
                                    ),
                                    SizedBox(
                                      height: 45.0,
                                    ),
                                    TextFormField(
                                      validator: (String value) {
                                        if (value.isEmpty || value.length < 5) {
                                          return 'username must be at least 5 characters';
                                        }
                                      },
                                      onSaved: (String value) {
                                        _userData['username'] = value;
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blueGrey[200])),
                                        border: UnderlineInputBorder(),
                                        labelText: 'Username',
                                        suffixIcon: Icon(Icons.person_outline),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      validator: (String value) {
                                        if (value.isEmpty || value.length < 5) {
                                          return 'username must be at least 5 characters';
                                        }
                                      },
                                      onSaved: (String value) {
                                        _userData['username'] = value;
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blueGrey[200])),
                                        border: UnderlineInputBorder(),
                                        labelText: 'firstName',
                                        suffixIcon: Icon(Icons.person_outline),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      validator: (String value) {
                                        if (value.isEmpty ||
                                            value.length < 5 ||
                                            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                                .hasMatch(value)) {
                                          return 'username must be at least 5 characters';
                                        }
                                      },
                                      onSaved: (String value) {
                                        _userData['username'] = value;
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blueGrey[200])),
                                        border: UnderlineInputBorder(),
                                        labelText: 'lastName',
                                        suffixIcon: Icon(Icons.person_outline),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      validator: (String value) {
                                        if (value.isEmpty ||
                                            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                                .hasMatch(value)) {
                                          return 'username/phoneNumber  is not valid';
                                        }
                                      },
                                      onSaved: (String value) {
                                        _userData['phoneNumber '] = value;
                                      },
                                      keyboardType: TextInputType.emailAddress,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blueGrey[200])),
                                        border: UnderlineInputBorder(),
                                        labelText: 'phoneNumber ',
                                        suffixIcon: Icon(Icons.mail_outline),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      validator: validator2,
                                      onSaved: (String value) {
                                        _userData['password'] = value;
                                      },
                                      controller: _passwordController,
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blueGrey[200])),
                                        border: UnderlineInputBorder(),
                                        labelText: 'Password',
                                        suffixIcon: Icon(Icons.lock_outline),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      validator: (String value) {
                                        if (value.isEmpty ||
                                            value != _passwordController.text) {
                                          return 'Passwords does not match!';
                                        }
                                      },
                                      obscureText: true,
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blueGrey[200])),
                                        border: UnderlineInputBorder(),
                                        labelText: 'Confirm password',
                                        suffixIcon: Icon(Icons.done_outline),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 15,
                                    ),
                                    TextFormField(
                                      validator: (String value) {
                                        if (value.isEmpty ||
                                            value.length < 10 ||
                                            value.length > 300 ||
                                            !RegExp(r"[a-z0-9!#$%&'*+/=?^_`{|}~-]+(?:\.[a-z0-9!#$%&'*+/=?^_`{|}~-]+)*@(?:[a-z0-9](?:[a-z0-9-]*[a-z0-9])?\.)+[a-z0-9](?:[a-z0-9-]*[a-z0-9])?")
                                                .hasMatch(value)) {
                                          return 'adress must be between 10  and 300 characters';
                                        }
                                      },
                                      onSaved: (String value) {
                                        _userData['address'] = value;
                                      },
                                      decoration: InputDecoration(
                                        filled: true,
                                        fillColor: Colors.white,
                                        enabledBorder: UnderlineInputBorder(
                                            borderSide: BorderSide(
                                                color: Colors.blueGrey[200])),
                                        border: UnderlineInputBorder(),
                                        labelText: 'address',
                                        suffixIcon: Icon(Icons.location_on),
                                      ),
                                    ),
                                    SizedBox(
                                      height: 35.0,
                                    ),
                                    RaisedButton(
                                      color: Colors.blueGrey[800],
                                      padding: EdgeInsets.symmetric(
                                          vertical: 12, horizontal: 30),
                                      onPressed: () {},
                                      child: Text("Signup"),
                                    ),
                                    SizedBox(height: 15.0),
                                  ],
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: panels,
    );
  }
}

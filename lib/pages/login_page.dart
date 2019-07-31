import 'package:book_shelf/bloc_helpers/bloc_provider.dart';
import 'package:book_shelf/bloc_helpers/bloc_state_builder.dart';
import 'package:book_shelf/blocs/login/login_bloc.dart';
import 'package:book_shelf/blocs/login/login_event.dart';
import 'package:book_shelf/blocs/login/login_form_bloc.dart';
import 'package:book_shelf/blocs/login/login_state.dart';
import 'package:book_shelf/blocs/session/session_bloc.dart';
import 'package:book_shelf/pages/registration_page.dart';
import 'package:book_shelf/utils/utils.dart';
import 'package:book_shelf/widgets/pending_action.dart';
import 'package:flutter/material.dart';

class LoginPage extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return new LoginPageState();
  }
}

class LoginPageState extends State<LoginPage> {
  SessionBloc _sessionBloc;
  LoginBloc _loginBloc;
  LoginFormBloc _loginFormBloc;
  TextEditingController _nameController;
  TextEditingController _pwdController;
  GlobalKey<ScaffoldState> scaffoldKey;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    scaffoldKey = new GlobalKey<ScaffoldState>();
    _sessionBloc = BlocProvider.of<SessionBloc>(context);
    _loginBloc = LoginBloc(_sessionBloc);
    _loginFormBloc = LoginFormBloc();
    _nameController = new TextEditingController(text: '');
    _pwdController = new TextEditingController(text: '');
  }

  @override
  Widget build(BuildContext context) {
    return BlocEventStateBuilder<LoginState>(
        bloc: _loginBloc,
        builder: (BuildContext context, LoginState state) {
          if (state is LoginLoading) {
            return PendingAction();
          }

          if (state is LoginForm || state is LoginFailure) {
            if (state is LoginFailure) {
              Utils.onWidgetDidBuild(() {
                scaffoldKey.currentState
                    .showSnackBar(new SnackBar(content: new Text(state.error)));
              });
            }

            return Form(key: _formKey, child: _loginView(context));
          }

          return Container();
        });
  }

  Widget _loginView(BuildContext context) {
    return SafeArea(
      child: Scaffold(
        key: scaffoldKey,
        appBar: new AppBar(
          title: new Text('登录'),
        ),
        body: new Padding(
          padding: EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 0.0),
          child: new ListView(
            children: <Widget>[
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  new Icon(
                    Icons.account_circle,
                    color: Theme.of(context).accentColor,
                    size: 80.0,
                  ),
                ],
              ),
              SizedBox(
                height: 20.0,
              ),
              StreamBuilder<String>(
                  stream: _loginFormBloc.name,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    return TextField(
                      autofocus: true,
                      decoration: new InputDecoration(
                        hintText: "姓名",
                        errorText: snapshot.error,
                        contentPadding:
                            EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(32.0)),
                      ),
                      obscureText: true,
                      controller: _nameController,
                      onChanged: _loginFormBloc.onNameChanged,
                    );
                  }),
              SizedBox(
                height: 20.0,
              ),
              StreamBuilder<String>(
                  stream: _loginFormBloc.password,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    return TextField(
                      decoration: new InputDecoration(
                          hintText: "密码",
                          errorText: snapshot.error,
                          contentPadding:
                              EdgeInsets.fromLTRB(20.0, 10.0, 20.0, 10.0),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(32.0))),
                      obscureText: true,
                      controller: _pwdController,
                      onChanged: _loginFormBloc.onPasswordChanged,
                    );
                  }),
              new Padding(
                padding: EdgeInsets.fromLTRB(40.0, 10.0, 40.0, 0.0),
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: <Widget>[
                  StreamBuilder<bool>(
                      stream: _loginFormBloc.registerValid,
                      builder:
                          (BuildContext context, AsyncSnapshot<bool> snapshot) {
                        return RaisedButton(
                          child: new Text("登录",
                              style: new TextStyle(color: Colors.white)),
                          color: Theme.of(context).accentColor,
                          disabledColor: Colors.blue,
                          textColor: Colors.white,
                          onPressed: (snapshot.hasData && snapshot.data == true)
                              ? () {
                                  _loginBloc.emitEvent(LoginRequest(
                                      _nameController.text,
                                      _pwdController.text));
                                }
                              : null,
                        );
                      }),
                  new RaisedButton(
                    child: new Text("注册",
                        style: new TextStyle(color: Colors.white)),
                    color: Theme.of(context).accentColor,
                    disabledColor: Colors.blue,
                    textColor: Colors.white,
                    onPressed: () {
                      Navigator.push(
                          context,
                          new MaterialPageRoute(
                              builder: (context) => new RegistrationPage()));
                    },
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _loginBloc.dispose();
    _loginFormBloc?.dispose();
    _nameController?.dispose();
    _pwdController?.dispose();
    super.dispose();
  }
}

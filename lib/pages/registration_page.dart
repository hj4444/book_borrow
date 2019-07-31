import 'package:book_shelf/bloc_helpers/bloc_provider.dart';
import 'package:book_shelf/bloc_helpers/bloc_state_builder.dart';
import 'package:book_shelf/blocs/basket_bloc.dart';
import 'package:book_shelf/blocs/home_bloc.dart';
import 'package:book_shelf/blocs/registration/registration_bloc.dart';
import 'package:book_shelf/blocs/registration/registration_event.dart';
import 'package:book_shelf/blocs/registration/registration_form_bloc.dart';
import 'package:book_shelf/blocs/registration/registration_state.dart';
import 'package:book_shelf/pages/main_page.dart';
import 'package:book_shelf/utils/utils.dart';
import 'package:book_shelf/widgets/pending_action.dart';
import 'package:flutter/material.dart';

class RegistrationPage extends StatefulWidget {
  @override
  _RegistrationFormState createState() => _RegistrationFormState();
}

class _RegistrationFormState extends State<RegistrationPage> {
  TextEditingController _nameController;
  TextEditingController _passwordController;
  TextEditingController _actualNameController;
  RegistrationFormBloc _registrationFormBloc;
  RegistrationBloc _registrationBloc;
  final _formKey = GlobalKey<FormState>();
  GlobalKey<ScaffoldState> scaffoldKey;
  @override
  void initState() {
    super.initState();
    scaffoldKey = new GlobalKey<ScaffoldState>();
    _nameController = TextEditingController();
    _passwordController = TextEditingController();
    _actualNameController = TextEditingController();
    _registrationFormBloc = RegistrationFormBloc();
    _registrationBloc = RegistrationBloc();
  }

  @override
  void dispose() {
    _registrationBloc?.dispose();
    _registrationFormBloc?.dispose();
    _nameController?.dispose();
    _actualNameController?.dispose();
    _passwordController?.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocEventStateBuilder<RegistrationState>(
        bloc: _registrationBloc,
        builder: (BuildContext context, RegistrationState state) {
          if (state is RegistrationLoading) {
            return PendingAction();
          } else if (state is RegistrationFailure) {
            Utils.onWidgetDidBuild(() {
              scaffoldKey.currentState
                  .showSnackBar(new SnackBar(content: new Text(state.error)));
            });
          } else if (state is RegistrationForm) {
            return _buildForm();
          } else if (state is RegistrationSuccess) {
            return BlocProvider<HomeBloc>(
              bloc: HomeBloc(),
              child: BlocProvider<BasketBloc>(
                  bloc: BasketBloc(), child: MainPage()),
            );
          }
          return Container();
        });
  }

  Widget _buildForm() {
    return SafeArea(
        child: Scaffold(
      key: scaffoldKey,
      appBar: AppBar(
        title: Text('注册'),
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: <Widget>[
              StreamBuilder<String>(
                  stream: _registrationFormBloc.name,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    return TextField(
                      decoration: InputDecoration(
                        labelText: '名称',
                        errorText: snapshot.error,
                      ),
                      controller: _nameController,
                      onChanged: _registrationFormBloc.onNameChanged,
                    );
                  }),
              StreamBuilder<String>(
                  stream: _registrationFormBloc.password,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    return TextField(
                      decoration: InputDecoration(
                        labelText: '密码',
                        errorText: snapshot.error,
                      ),
                      controller: _passwordController,
                      obscureText: false,
                      onChanged: _registrationFormBloc.onPasswordChanged,
                    );
                  }),
              StreamBuilder<String>(
                  stream: _registrationFormBloc.actualName,
                  builder:
                      (BuildContext context, AsyncSnapshot<String> snapshot) {
                    return TextField(
                      decoration: InputDecoration(
                        labelText: '真实姓名',
                        errorText: snapshot.error,
                      ),
                      controller: _actualNameController,
                      obscureText: false,
                      onChanged: _registrationFormBloc.onActualNameChanged,
                    );
                  }),
              StreamBuilder<bool>(
                  stream: _registrationFormBloc.registerValid,
                  builder:
                      (BuildContext context, AsyncSnapshot<bool> snapshot) {
                    return RaisedButton(
                      child: Text('提交'),
                      onPressed: (snapshot.hasData && snapshot.data == true)
                          ? () {
                              _registrationBloc.emitEvent(RegistrationEvent(
                                  event: RegistrationEventType.working,
                                  name: _nameController.text,
                                  password: _passwordController.text,
                                  actualName: _actualNameController.text));
                            }
                          : null,
                    );
                  }),
            ],
          ),
        ),
      ),
    ));
  }
}

import 'package:book_shelf/bloc_helpers/bloc_provider.dart';
import 'package:book_shelf/bloc_helpers/bloc_state_builder.dart';
import 'package:book_shelf/blocs/basket_bloc.dart';
import 'package:book_shelf/blocs/home_bloc.dart';
import 'package:book_shelf/blocs/session/session_bloc.dart';
import 'package:book_shelf/blocs/session/session_event.dart';
import 'package:book_shelf/blocs/session/session_state.dart';
import 'package:book_shelf/config/application.dart';
import 'package:book_shelf/consts/consts.dart';
import 'package:book_shelf/pages/login_page.dart';
import 'package:book_shelf/pages/main_page.dart';
import 'package:book_shelf/pages/splash.dart';
import 'package:book_shelf/route/routes.dart';
import 'package:book_shelf/utils/api_client_util.dart';
import 'package:dio/dio.dart';
import 'package:event_bus/event_bus.dart';
import 'package:fluro/fluro.dart';
import 'package:flustars/flustars.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

Future<void> main() async {
  return runApp(new MyApp());
}

class MyApp extends StatefulWidget {
  @override
  State<StatefulWidget> createState() {
    return MyAppState();
  }
}

class MyAppState extends State<MyApp> {
  final SessionBloc _sessionBloc = SessionBloc();
  @override
  void initState() {
    super.initState();
    _init();
    _sessionBloc.emitEvent(SessionStarted());
  }

  @override
  void dispose() {
    super.dispose();
    _sessionBloc.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider<SessionBloc>(
        bloc: _sessionBloc,
        child: MaterialApp(
            onGenerateRoute: Application.router.generator,
            localizationsDelegates: [
              GlobalMaterialLocalizations.delegate,
              GlobalWidgetsLocalizations.delegate,
            ],
            supportedLocales: [
              const Locale('en'), // English
              const Locale.fromSubtags(
                  languageCode: 'zh'), // Chinese *See Advanced Locales below*
            ],
            debugShowCheckedModeBanner: false,
            home: BlocEventStateBuilder<SessionState>(
                bloc: _sessionBloc,
                builder: (BuildContext context, SessionState state) {
                  if (state is SessionUninitialized) {
                    return SplashScreen();
                  }

                  if (state is SessionUnAuthenticated) {
                    return LoginPage();
                  }

                  if (state is SessionAuthenticated) {
                    return BlocProvider<HomeBloc>(
                      bloc: HomeBloc(),
                      child: BlocProvider<BasketBloc>(
                          bloc: BasketBloc(), child: MainPage()),
                    );
                  }
                  return Container();
                })));
  }

  Future _init() async {
    Options options = HttpManager.getDefOptions();
    options.baseUrl = Consts.SERVER_ADDRESS;
    HttpConfig config = new HttpConfig(options: options);
    HttpManager().setConfig(config);
    Application.eventBus = EventBus();
    final Router router = Router();
    Routes.configureRoutes(router);
    Application.router = router;
    await SpUtil.getInstance();
  }
}

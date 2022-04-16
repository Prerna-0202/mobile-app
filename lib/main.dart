import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_keyboard_visibility/flutter_keyboard_visibility.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:get/get.dart';
import 'package:mobile_app/cv_theme.dart';
import 'package:mobile_app/locator.dart';
import 'package:mobile_app/services/database_service.dart';
import 'package:mobile_app/utils/router.dart';
import 'package:theme_provider/theme_provider.dart';
import 'package:mobile_app/ui/views/startup_view.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Register all the models and services before the app starts
  await setupLocator();

  // Init Hive
  await locator<DatabaseService>().init();

  runApp(const CircuitVerseMobile());
}

class CircuitVerseMobile extends StatelessWidget {
  const CircuitVerseMobile({Key? key}) : super(key: key);

  // This widget is the root of CircuitVerse Mobile.
  @override
  Widget build(BuildContext context) {
    SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
      DeviceOrientation.portraitDown,
    ]);

    return KeyboardDismissOnTap(
      child: ThemeProvider(
        saveThemesOnChange: true,
        loadThemeOnInit: true,
        themes: [
          AppTheme(
            id: 'light',
            data: ThemeData(
              fontFamily: 'Poppins',
              brightness: Brightness.light,
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: CVTheme.primaryColor,
              ),
              appBarTheme: AppBarTheme(
                foregroundColor: CVTheme.drawerIcon(context),
              ),
              colorScheme: Theme.of(context).colorScheme.copyWith(
                    primary: CVTheme.primaryColor,
                    brightness: Brightness.light,
                  ),
            ),
            description: 'LightTheme',
          ),
          AppTheme(
            id: 'dark',
            data: ThemeData(
              fontFamily: 'Poppins',
              brightness: Brightness.dark,
              textSelectionTheme: const TextSelectionThemeData(
                cursorColor: CVTheme.primaryColor,
              ),
            ),
            description: 'DarkTheme',
          ),
        ],
        child: ThemeConsumer(
          child: Builder(
            builder: (themeContext) => GetMaterialApp(
              title: 'CircuitVerse Mobile',
              localizationsDelegates: AppLocalizations.localizationsDelegates,
              supportedLocales: AppLocalizations.supportedLocales,
              onGenerateTitle: (BuildContext context) =>
                  AppLocalizations.of(context)!.title,
              debugShowCheckedModeBanner: false,
              onGenerateRoute: CVRouter.generateRoute,
              theme: ThemeProvider.themeOf(themeContext).data,
              home: const StartUpView(),
            ),
          ),
        ),
      ),
    );
    return MaterialApp(
      home: NotificationApp()
    );
  }
}

class NotificationAppApp extends StatefulWidget {
  @override
  _NotificationAppState createState() => NotificationAppState();
}

class _NotificationAppState extends State<NotificationApp> {

  FlutterLocalNotificationsPlugin localNotification;
  void initState(){
    super.initState();
    var androidInitialize = newAndroidInitializationSettings('ic_launcher')//This function is to initialize android setting, 

    var ioSInitialize = newIOSInitializationSettings();
    var initializationSettings = new InitializationSettings(android: androidInitialize , ioS: ioSInitialize)
    localNotification = new FlutterLocalNotificationsPlugin();
    localNotification.initialize(initializationSettings);
  }
  Future _showNotification() async{
    var androidDetails = new AndroidNotificationDetails("channelId",
     "Local Notification", 
     "This is the description of the Notification, you can write anything", importance: Importance.high );
     var iosDetails = new IOSNotificationDetails();
     var generalNotificationDetails = new AndroidNotificationDetails(android: androidDetails, iOS: iosDetails);
     await localNotification.show(0,"Hello, From CircuitVerse","The Body of the Notification",generalNotificationDetails)
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text("Click the button to receive a notification"),
      )
      floatingActionButton: floatingActionButton(
        onPressed: _showNotification,
        child: Icon(Icons.notifications),
      ),
    );
  }
}
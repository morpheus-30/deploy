import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:provider/provider.dart';
// import 'dart:js' as js;

import 'package:seeds_ai_callmate_web_app/models/customers_model.dart';
import 'package:seeds_ai_callmate_web_app/providers/allocations_provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/auth_provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/call_log_provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/category_provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/crm_fields_provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/customers_provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/dashboard_provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/default_provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/employee_provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/followups_provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/history_provider.dart';
import 'package:seeds_ai_callmate_web_app/providers/organization_provider.dart';
import 'package:seeds_ai_callmate_web_app/screens/home_screen.dart';
import 'package:seeds_ai_callmate_web_app/screens/login_screen.dart';
import 'package:seeds_ai_callmate_web_app/services/firestore_service.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await dotenv.load(fileName: "dotenv");

  // final firebaseConfig = js.context['firebaseConfig'];
  await Firebase.initializeApp(
    options: FirebaseOptions(
      apiKey: dotenv.env['API_KEY'] ?? '',
      projectId: dotenv.env['PROJECT_ID'] ?? '',
      messagingSenderId: dotenv.env['MESSAGING_SENDER_ID'] ?? '',
      appId: dotenv.env['APP_ID'] ?? '',
    ),
    // options: DefaultFirebaseOptions.currentPlatform,
  );

  await Hive.initFlutter();
  // Hive.registerAdapter(CustomerAdapter());
  await Hive.openBox<Customer>('customers');

  print('Initializing CustomerHistoryService');
  final customerHistoryService = FirestoreService();
  customerHistoryService.listenToCustomerChanges();

  // Enable offline persistence
  FirebaseFirestore.instance.settings =
      const Settings(persistenceEnabled: true);
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final firestoreService = FirestoreService();
    return MultiProvider(
      providers: [
        Provider<FirestoreService>(
          create: (_) => FirestoreService(),
        ),
        ChangeNotifierProvider(create: (context) => DefaultProvider()),
        ChangeNotifierProvider(
            create: (context) => OrganizationProvider(firestoreService)),
        ChangeNotifierProvider(create: (context) => HistoryProvider()),
        ChangeNotifierProvider(create: (context) => AllocationProvider()),
        ChangeNotifierProvider(create: (context) => FollowupsProvider()),
        ChangeNotifierProvider(create: (context) => CustomerProvider()),
        ChangeNotifierProvider(
            create: (_) => CategoryProvider(firestoreService)),
        ChangeNotifierProvider(
            create: (context) => CallLogsProvider(firestoreService)),
        ChangeNotifierProvider(create: (context) => CRMFieldsProvider()),
        ChangeNotifierProvider(create: (context) => EmployeeDetailsProvider()),
        ChangeNotifierProvider(create: (context) => AuthenticationProvider()),
        ChangeNotifierProvider(
            create: (context) => DashboardProvider(
                  Provider.of<FirestoreService>(context, listen: false),
                )),
      ],
      // create: (context) => DefaultProvider(),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        // home: const MyHomePage(), // Ensure LoginBuild is properly defined
        home: const LoginBuild(), // Ensure LoginBuild is properly defined
      ),
    );
  }
}

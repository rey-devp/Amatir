import 'package:flutter/material.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:provider/provider.dart';

// Import Config
import 'config/theme.dart';
import 'config/routes.dart';
import 'config/app_constants.dart';
import 'firebase_options.dart'; 

// Import Providers
import 'providers/auth_provider.dart';
import 'providers/order_provider.dart';
import 'providers/product_provider.dart';

void main() async {
  // Inisialisasi untuk Flutter & Firebase
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(
    options: DefaultFirebaseOptions.currentPlatform,
  );

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    // MultiProvider: Menyuntikkan semua Logic ke Aplikasi
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthProvider()),
        ChangeNotifierProvider(create: (_) => OrderProvider()),
        ChangeNotifierProvider(create: (_) => ProductProvider()),
      ],
      child: MaterialApp(
        title: AppConstants.appName,
        debugShowCheckedModeBanner: false,
        
        // 3. Gunakan Tema yang sudah kita buat
        theme: AppTheme.lightTheme,
        
        // 4. Gunakan Rute yang sudah kita buat
        initialRoute: AppRoutes.splash, // Mulai dari Splash Screen
        routes: AppRoutes.routes,
      ),
    );
  }
}
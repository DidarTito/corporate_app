import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'login_screen.dart';
import '../utils/constants.dart';
import '../utils/localization.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      Future.delayed(const Duration(seconds: 2), () {
        if (mounted) {
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => const LoginScreen()),
          );
        }
      });
    });
  }

//   @override
//   Widget build(BuildContext context) {
//     final theme = Theme.of(context);
//     return Scaffold(
//       backgroundColor: theme.colorScheme.primary,
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             // Логотип
//             Container(
//               width: 120,
//               height: 120,
//               decoration: BoxDecoration(
//                 color: theme.colorScheme.onPrimary,
//                 borderRadius: BorderRadius.circular(20),
//               ),
//               child: Icon(
//                 Icons.business,
//                 size: 60,
//                 color: theme.colorScheme.primary,
//               ),
//             ),
//             const SizedBox(height: 20),
//             // Название приложения
//             Text(
//               AppStrings.appName,
//               style: TextStyle(
//                 fontSize: 28,
//                 fontWeight: FontWeight.bold,
//                 color: theme.colorScheme.onPrimary,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Scaffold(
      backgroundColor: theme.colorScheme.primary,
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            // Логотип
            Container(
              width: 120,
              height: 120,
              decoration: BoxDecoration(
                color: theme.colorScheme.onPrimary,
                borderRadius: BorderRadius.circular(20),
              ),
              child: Icon(
                Icons.business,
                size: 60,
                color: theme.colorScheme.primary,
              ),
            ),
            const SizedBox(height: 20),
            // Название приложения
            Text(
              AppStrings.appName,
              style: TextStyle(
                fontSize: 28,
                fontWeight: FontWeight.bold,
                color: theme.colorScheme.onPrimary,
              ),
            ),

            const SizedBox(height: 40),
            // 🔹 Кнопка для теста Firebase
            ElevatedButton(
              onPressed: () async {
                // Анонимный вход
                await FirebaseAuth.instance.signInAnonymously();

                // Запись в Firestore
                await FirebaseFirestore.instance.collection('test').add({
                  'message': 'Hello Firebase!',
                  'timestamp': Timestamp.now(),
                });
              },
              child: Text(AppLocalizations.of(context).testFirebase),
            ),
          ],
        ),
      ),
    );
  }
}

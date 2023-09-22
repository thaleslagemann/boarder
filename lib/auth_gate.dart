import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart';
import 'package:firebase_ui_auth/firebase_ui_auth.dart' as prefix;
import 'package:kanban_flt/app_body.dart';

class AuthGate extends StatelessWidget {
  const AuthGate({super.key});

  @override
  Widget build(BuildContext context) {
    final providers = [prefix.EmailAuthProvider()];
    return StreamBuilder<User?>(
      stream: FirebaseAuth.instance.authStateChanges(),
      builder: (context, snapshot) {
        if (!snapshot.hasData) {
          return SignInScreen(
            providers: providers,
            headerBuilder: (context, constraints, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'KANBAN FLT',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 40),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              );
            },
            sideBuilder: (context, shrinkOffset) {
              return Padding(
                padding: const EdgeInsets.all(20),
                child: AspectRatio(
                  aspectRatio: 1,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        'KANBAN FLT',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 40),
                        textAlign: TextAlign.center,
                      )
                    ],
                  ),
                ),
              );
            },
          );
        }
        return AppBody();
      },
    );
  }
}

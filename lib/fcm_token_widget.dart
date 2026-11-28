import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class MyFcmToken extends StatelessWidget {
  const MyFcmToken({super.key});

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<String?>(
      // ignore: deprecated_member_use
      future: FirebaseMessaging.instance.getToken(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const CircularProgressIndicator();
        }
        final token = snapshot.data ?? "Token tidak ditemukan lagi";

        return Card(
          elevation: 3,
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text(
                  "FCM Token",
                  style: Theme.of(context).textTheme.headlineLarge
                      ?.copyWith(fontWeight: FontWeight.bold),
                  textAlign: TextAlign.center,
                ),

                const SizedBox(height: 7),

                SelectableText(
                  token,
                  style: Theme.of(context).textTheme.headlineMedium,
                ),

                const SizedBox(height: 7),

                ElevatedButton(
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: token));
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text("Token telah disalin"),
                        behavior: SnackBarBehavior.floating,
                      ),
                    );
                  },
                  child: Row(
                    children: [
                      Icon(Icons.copy),

                      const SizedBox(width: 3),

                      Text(
                        "Salin Token",
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

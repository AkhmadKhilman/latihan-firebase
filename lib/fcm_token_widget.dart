import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';

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
          child: Padding(
            padding: EdgeInsets.all(20),
            child: Column(
              children: [
                Text("FCM Token"),

                const SizedBox(height: 7),

                Text("Isi Token"),

                ElevatedButton(
                  onPressed: () {
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(
                        content: Text(
                          "Tombol Menyalin token dalam proses pembuatan",
                        ),
                      ),
                    );
                  },
                  child: Text("Salin Token"),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

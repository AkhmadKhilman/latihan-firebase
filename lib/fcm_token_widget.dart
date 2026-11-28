import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class MyFcmToken extends StatelessWidget {
  const MyFcmToken({super.key});

  @override
  Widget build(BuildContext context) {
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
  }
}

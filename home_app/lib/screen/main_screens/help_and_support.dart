import 'package:flutter/material.dart';

class HelpAndSupport extends StatelessWidget {
  const HelpAndSupport({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text(
          "Help & Support",
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const Align(
                alignment: Alignment.center,
                child: Text("Tell us how we can be of help",
                    style: TextStyle(
                        fontWeight: FontWeight.bold, color: Colors.black))),
            const SizedBox(height: 5),
            const SizedBox(
              width: 240,
              child: Text(
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 11, color: Colors.black),
                  "Our team of superheroes is ready and waiting to provide service and support"),
            ),
            const SizedBox(
              height: 30,
            ),
            Container(
                decoration: BoxDecoration(
                  color: Colors.white, // Background color
                  borderRadius:
                      BorderRadius.circular(4), // Rounded corners (optional)
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.3),
                      // Greyish shadow color
                      spreadRadius: 1, // Spread of the shadow
                      blurRadius: 1, // Blur intensity of the shadow
                      offset: const Offset(0, 1), // Shadow direction (x, y)
                    ),
                  ],
                ),
                child: const ListTile(
                  title: Text(
                    "Phone",
                    style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                        color: Colors.black),
                  ),
                  subtitle: Text("Give us a phone call",
                      style: TextStyle(fontSize: 13, color: Colors.black)),
                  trailing: Icon(Icons.keyboard_arrow_right_outlined),
                )),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(4), // Rounded corners (optional)
                boxShadow: [
                  BoxShadow(
                    color: Colors.grey.withOpacity(0.3),
                    spreadRadius: 1, // Spread of the shadow
                    blurRadius: 1, // Blur intensity of the shadow
                    offset: const Offset(0, 1), // Shadow direction (x, y)
                  ),
                ],
              ),
              child: const ListTile(
                title: Text(
                  "Email",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black),
                ),
                subtitle: Text(
                  "Receive a solution directly to your inbox.",
                  style: TextStyle(fontSize: 13, color: Colors.black),
                ),
                trailing: Icon(Icons.keyboard_arrow_right_outlined),
              ),
            )
          ],
        ),
      ),
    );
  }
}

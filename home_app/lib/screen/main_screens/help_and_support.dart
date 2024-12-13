import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HelpAndSupport extends StatelessWidget {
  const HelpAndSupport({super.key});

  // Function to launch phone dialer
  void _launchPhoneDialer() async {
    final Uri phoneUri = Uri(scheme: 'tel', path: '0969827560');
    if (await canLaunchUrl(phoneUri)) {
      await launchUrl(phoneUri);
    } else {
      throw 'Could not launch $phoneUri';
    }
  }

  // Function to launch email client
  void _launchEmailClient() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'ephremmamo555@gmail.com',
      query: 'subject=Help%20and%20Support&body=Hello%20Support%20Team,',
    );
    if (await canLaunchUrl(emailUri)) {
      await launchUrl(emailUri);
    } else {
      throw 'Could not launch $emailUri';
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
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
            Align(
              alignment: Alignment.center,
              child: Text(
                "Tell us how we can be of help",
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: Colors.grey.shade600,
                ),
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: 240,
              child: Text(
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 11, color: Colors.grey.shade600),
                "Our team of superheroes is ready and waiting to provide service and support",
              ),
            ),
            const SizedBox(height: 30),
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
              child: ListTile(
                title: const Text(
                  "Phone",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black),
                ),
                subtitle: const Text("Give us a phone call",
                    style: TextStyle(fontSize: 13, color: Colors.black)),
                trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                onTap: _launchPhoneDialer,
              ),
            ),
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
              child: ListTile(
                title: const Text(
                  "Email",
                  style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.black),
                ),
                subtitle: const Text(
                  "Receive a solution directly to your inbox.",
                  style: TextStyle(fontSize: 13, color: Colors.black),
                ),
                trailing: const Icon(Icons.keyboard_arrow_right_outlined),
                onTap: _launchEmailClient,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

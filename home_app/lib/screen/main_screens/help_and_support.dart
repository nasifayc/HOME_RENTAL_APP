import 'package:flutter/material.dart';
import 'package:home_app/core/theme/app_theme.dart';
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
    AppTheme theme = AppTheme.of(context);
    return Scaffold(
      appBar: AppBar(
        elevation: 1,
        title: Text(
          "Help & Support",
          style: theme.typography.bodyMedium,
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
                style: theme.typography.bodyLarge,
              ),
            ),
            const SizedBox(height: 5),
            SizedBox(
              width: 240,
              child: Text(
                textAlign: TextAlign.center,
                maxLines: 10,
                style: theme.typography.bodySmall,
                "Our team of superheroes is ready and waiting to provide service and support",
              ),
            ),
            const SizedBox(height: 30),
            Container(
              decoration: BoxDecoration(
                color: theme.primary, // Background color
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
                title: Text(
                  "Phone",
                  style: theme.typography.labelSmall,
                ),
                subtitle: Text("Give us a phone call",
                    style: theme.typography.labelSmall),
                trailing: Icon(
                  Icons.keyboard_arrow_right_outlined,
                  color: theme.secondary,
                ),
                onTap: _launchPhoneDialer,
              ),
            ),
            const SizedBox(height: 20),
            Container(
              decoration: BoxDecoration(
                color: theme.primary,
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
                title: Text(
                  "Email",
                  style: theme.typography.labelSmall,
                ),
                subtitle: Text(
                  "Receive a solution directly to your inbox.",
                  style: theme.typography.labelSmall,
                ),
                trailing: Icon(
                  Icons.keyboard_arrow_right_outlined,
                  color: theme.secondary,
                ),
                onTap: _launchEmailClient,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

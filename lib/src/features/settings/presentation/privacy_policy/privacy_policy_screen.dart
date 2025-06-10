import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../l10n/app_localizations.dart';

class PrivacyPolicyScreen extends StatelessWidget {
  const PrivacyPolicyScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.privacyPolicy),
      ),
      body: SafeArea(
        child: Markdown(
          data: _privacyPolicyText,
          onTapLink: (text, href, title) {
            if (href != null) {
              launchUrl(Uri.parse(href));
            }
          },
        ),
      ),
    );
  }

  static const String _privacyPolicyText = """
Privacy Policy for Pixel Flip
Effective Date: June 10, 2025

This Privacy Policy describes how [Your Name/Company Name] ("we," "us," or "our") handles information in connection with your use of the Pixel Flip mobile application (the "App").

1. Information We Collect
We designed Pixel Flip to be a privacy-focused application. We collect very limited information:

Search Queries You Provide: When you use the online mode of the App, you provide a word or phrase (a "Query") to search for images. This Query is sent directly to the Pixabay API to retrieve images for the game. We do not store or log these queries on our servers.

Cached Game Data: To provide the "Play Again" feature, the App saves the most recent Query and the corresponding list of image URLs received from Pixabay. This data is stored only locally on your device. It is not transmitted to us or any other third party by us. This cache is automatically overwritten each time you start a new online game.

Third-Party Data Collection (Pixabay): When your device communicates with the Pixabay API, Pixabay may collect data as described in its own privacy policy. This may include your IP address and other request-related data. We do not control how Pixabay collects or uses this information. We encourage you to review the Pixabay Privacy Policy.

We do not collect personal information like your name, email address, location, or contacts.

2. How We Use Information
We use the information collected solely for the following purposes:

To Provide Core App Functionality: Your Query is used to fetch images from Pixabay to create the online game board.

To Enable the Caching Feature: The locally stored Query and image URLs are used to allow you to quickly restart your most recent game.

3. Data Sharing and Third Parties
We do not share any information with third parties, with one exception:

Pixabay: Your Search Query is sent to the Pixabay API to fulfill your image request. Your use of this feature is subject to the Pixabay Terms of Service.

The App does not use any third-party analytics or advertising services.

4. Data Storage and Security
All cached game data is stored in the App's private storage on your device. You can clear this cache at any time by either starting a new online game or by clearing the App's data through your device's system settings.

5. Children's Privacy
The App is not directed to children under the age of 13 (or the equivalent minimum age in the relevant jurisdiction). We do not knowingly collect any personal information from children. If we become aware that a child has provided us with information without parental consent, we will take steps to delete it.

6. Changes to This Privacy Policy
We may update this Privacy Policy from time to time. We will notify you of any changes by posting the new policy within the App. You are advised to review this Privacy Policy periodically for any changes.

7. Contact Us
If you have any questions about this Privacy Policy, please contact us at: [Your Contact Email]
""";
}

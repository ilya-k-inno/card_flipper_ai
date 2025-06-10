import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../../../l10n/app_localizations.dart';

class TermsOfServiceScreen extends StatelessWidget {
  const TermsOfServiceScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.termsOfService),
      ),
      body: SafeArea(
        child: Markdown(
          data: _termsOfServiceText,
          onTapLink: (text, href, title) {
            if (href != null) {
              launchUrl(Uri.parse(href));
            }
          },
        ),
      ),
    );
  }

  static const String _termsOfServiceText = """
# Terms of Service for Pixel Flip
**Effective Date: June 10, 2025**

Please read these Terms of Service ("Terms") carefully before using the Pixel Flip mobile application (the "App") operated by [Your Name/Company Name] ("we," "us," or "our").

Your access to and use of the App is conditioned on your acceptance of and compliance with these Terms. These Terms apply to all users and others who access or use the App.

## 1. Use of the App
We grant you a limited, non-exclusive, non-transferable, revocable license to use the App for your personal, non-commercial entertainment purposes, subject to these Terms.

## 2. User Conduct
You agree not to use the App to:

- Submit any Search Query that is unlawful, harmful, threatening, abusive, harassing, defamatory, vulgar, obscene, invasive of another's privacy, hateful, or racially, ethnically, or otherwise objectionable.
- Interfere with or disrupt the App or servers or networks connected to the App, or disobey any requirements, procedures, policies, or regulations of networks connected to the App.

## 3. Third-Party Content
The images displayed in the online mode of the App are sourced from the Pixabay API and are provided by third-party creators.

**Content Responsibility:** We are not responsible for the content, accuracy, or nature of the images returned by the Pixabay API. You acknowledge that the images are the sole responsibility of the entity from which such content originated.

**Pixabay License:** All images are subject to the [Pixabay License](https://pixabay.com/service/terms/). You agree to respect the terms of this license.

## 4. Intellectual Property
The App and its original content (excluding content from Pixabay), features, and functionality are and will remain the exclusive property of [Your Name/Company Name] and its licensors. The App is protected by copyright, trademark, and other laws of Poland and foreign countries.

## 5. Offline Mode
The App provides an offline mode that does not require an internet connection and does not interact with any third-party services. This mode uses numbers instead of images for gameplay.

## 6. Termination
We may terminate or suspend your access to our App immediately, without prior notice or liability, for any reason whatsoever, including without limitation if you breach the Terms.

## 7. Disclaimer of Warranties
The App is provided to you "AS IS" and "AS AVAILABLE" and with all faults and defects without warranty of any kind. We provide no warranty that the App will meet your requirements, achieve any intended results, be compatible or work with any other software, applications, systems or services, operate without interruption, meet any performance or reliability standards or be error-free.

## 8. Limitation of Liability
To the fullest extent permitted by applicable law, in no event shall we or our suppliers be liable for any special, incidental, indirect, or consequential damages whatsoever arising out of or in any way related to the use of or inability to use the App.

## 9. Governing Law
The laws of the Republic of Poland, excluding its conflicts of law rules, shall govern these Terms and your use of the App.

## 10. Changes to These Terms
We reserve the right, at our sole discretion, to modify or replace these Terms at any time. We will provide notice of any changes by posting the new Terms within the App.

## 11. Contact Us
If you have any questions about these Terms, please contact us at: [Your Contact Email]
""";
}

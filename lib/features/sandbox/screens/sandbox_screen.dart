import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter/foundation.dart';

class SandboxScreen extends StatelessWidget {
  const SandboxScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Placeholder(); // just content
  }
}

class SandBoxAutoDrawer extends StatelessWidget {
  const SandBoxAutoDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(surfaceTintColor: Colors.blue, width: 240);
  }
}

class SandboxInfoDrawer extends StatelessWidget {
  const SandboxInfoDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      surfaceTintColor: Colors.blue,
      child: ListView(
        children: <Widget>[
          DrawerHeader(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: 'fortetude.',
                        style: GoogleFonts.alike(
                          textStyle: const TextStyle(
                            fontWeight: FontWeight.w900,
                            fontSize: 50,
                          ),
                        ),
                      ),
                      WidgetSpan(
                        alignment: PlaceholderAlignment.baseline,
                        baseline: TextBaseline.alphabetic,
                        child: Transform.translate(
                          offset: const Offset(0, 6),
                          child: Text(
                            ' v0.0.1',
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),

                Text('by kawing-ho', style: TextStyle()),
              ],
            ),
          ),
          // Quick Guide Link
          ListTile(
            leading: Icon(Icons.menu_book),
            title: Text("User Guide"),
            subtitle: Text("How best to use the app"),
            onTap: () {
              final mode = kIsWeb
                  ? LaunchMode.platformDefault
                  : LaunchMode.externalApplication;

              launchUrl(Uri.parse('https://example.com'), mode: mode);
            },
          ),
          Divider(height: 0),
          // Donate!
          ListTile(
            leading: Icon(Icons.volunteer_activism_outlined),
            title: Text("Donate"),
            subtitle: Text("Enjoyed the app? Show some love!"),
            onTap: () {
              final mode = kIsWeb
                  ? LaunchMode.platformDefault
                  : LaunchMode.externalApplication;

              launchUrl(Uri.parse('https://example.com'), mode: mode);
            },
          ),
          Divider(height: 0),
          // Light/Dark toggle
          ListTile(
            leading: Icon(Icons.light_mode_outlined), // settings_display
            title: Text("Toggle Light/Dark Mode"),
            subtitle: Text(
              "[Work In Progress]",
              style: TextStyle(color: Colors.red),
            ),
            trailing: Icon(Icons.dark_mode_outlined), // settings_display_rounded
            onTap: () {},
          ),
          Divider(height: 0),
        ],
      ),
    );
  }
}

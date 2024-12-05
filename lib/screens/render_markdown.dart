import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';

class RenderMarkdown extends StatelessWidget {
  final String markdownContent;

  const RenderMarkdown({
    super.key,
    required this.markdownContent,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Recommendations'),
        elevation: 0,
      ),
      body: Container(
        padding: const EdgeInsets.all(16.0),
        decoration: BoxDecoration(
          color: Theme.of(context).scaffoldBackgroundColor,
          borderRadius: BorderRadius.circular(8.0),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Card(
                elevation: 4,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: MarkdownBody(
                    data: markdownContent,
                    styleSheet: MarkdownStyleSheet(
                      h1: const TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                      h2: const TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w600,
                      ),
                      p: const TextStyle(
                        fontSize: 16,
                        height: 1.5,
                      ),
                      listBullet: const TextStyle(
                        color: Colors.blue,
                      ),
                      blockquote: const TextStyle(
                        color: Colors.grey,
                        fontStyle: FontStyle.italic,
                      ),
                      code: TextStyle(
                        backgroundColor: Colors.grey[200],
                        fontFamily: 'monospace',
                      ),
                    ),
                    // onTapLink: (text, href, title) {
                    //   if (href != null) {
                    //     launchUrl(Uri.parse(href));
                    //   }
                    // },
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

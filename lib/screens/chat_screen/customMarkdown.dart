import 'package:flutter/material.dart';
import 'package:flutter_markdown/flutter_markdown.dart';
import 'package:url_launcher/url_launcher.dart';


class CustomMarkdown extends StatelessWidget {
  const CustomMarkdown(
      {super.key,
      required this.data,
      required this.textColor,
      required this.secondaryColor,
      required this.backgroundColor,
      required this.isDarkMode});
  final String data;
  final Color textColor;
  final Color secondaryColor;
  final Color backgroundColor;
  final bool isDarkMode;
  @override
  Widget build(BuildContext context) {
    return MarkdownBody(
      data: data,
      selectable: true,
      imageBuilder: (uri, title, alt) {
        return ClipRRect(
          borderRadius: BorderRadius.circular(12),
          child: Image.network(
            uri.toString(),
            fit: BoxFit.contain,
            errorBuilder: (context, error, stackTrace) {
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(8.0),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      Icons.error_outline,
                      color: Colors.grey[600],
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      'Failed to load image',
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              );
            },
            loadingBuilder: (context, child, loadingProgress) {
              if (loadingProgress == null) return child;
              return Container(
                width: double.infinity,
                padding: const EdgeInsets.all(16.0),
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Center(
                  child: CircularProgressIndicator(
                    value: loadingProgress.expectedTotalBytes !=
                        null
                        ? loadingProgress
                        .cumulativeBytesLoaded /
                        loadingProgress.expectedTotalBytes!
                        : null,
                    strokeWidth: 2,
                    color: Colors.grey[600],
                  ),
                ),
              );
            },
          ),
        );
      },
      styleSheet: MarkdownStyleSheet(
        p: TextStyle(color: textColor, fontSize: 13),
        strong: TextStyle(
            color: textColor, fontSize: 13, fontWeight: FontWeight.w600),
        em: TextStyle(
            color: textColor, fontSize: 13, fontStyle: FontStyle.italic),
        h1: TextStyle(
            color: textColor,
            fontSize: 22,
            fontWeight: FontWeight.bold,
        ),
        h2: TextStyle(
            color: textColor,
            fontSize: 18,
            fontWeight: FontWeight.bold,
            ),
        h3: TextStyle(
            color: textColor,
            fontSize: 16,
            fontWeight: FontWeight.bold,
           ),
        code: TextStyle(
            color: textColor,
            backgroundColor: backgroundColor,
            fontSize: 12,
            fontFamily: 'monospace'),
        codeblockDecoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(8),
        ),
        codeblockPadding: const EdgeInsets.all(12),

        blockquote: TextStyle(color: secondaryColor, fontSize: 13),
        blockquoteDecoration: BoxDecoration(
          border: Border(
              left:
                  BorderSide(color: secondaryColor.withOpacity(0.5), width: 4)),
        ),
        blockquotePadding: const EdgeInsets.only(left: 16),

        a: TextStyle(
            color: isDarkMode ? Colors.lightBlue[300] : Colors.blue,
            decoration: TextDecoration.underline),
        tableHead: TextStyle(
          color: textColor,
          fontWeight: FontWeight.bold,
        ),
        tableBorder:
            TableBorder.all(color: secondaryColor.withOpacity(0.3), width: 1),
        tableCellsPadding: const EdgeInsets.all(8),

        // Horizontal Rule
        horizontalRuleDecoration: BoxDecoration(
          border: Border(
            top: BorderSide(
              color: secondaryColor.withOpacity(0.3),
              width: 1,
            ),
          ),
        ),
        // h1Padding: const EdgeInsets.only(top: 16, bottom: 8),
        // h2Padding: const EdgeInsets.only(top: 16, bottom: 8),
        // h3Padding: const EdgeInsets.only(top: 16, bottom: 8),
        // blockSpacing: 8.0,
        textAlign: WrapAlignment.start,

      ),
      onTapLink: (text, href, title) async {
        if (href != null) {
          final Uri url = Uri.parse(href);
          if (await canLaunchUrl(url)) {
            await launchUrl(url);
          }
        }
      },
    );
  }

  MarkdownStyleSheet markdownStyleSheet(bool isUser) {
    return MarkdownStyleSheet(
      // Text styling
      p: TextStyle(
        color: isUser ? Colors.white : Colors.black87,
        fontSize: 14,
      ),
      // Heading styles
      h1: TextStyle(
        color: isUser ? Colors.white : Colors.black87,
        fontSize: 20,
        fontWeight: FontWeight.bold,
      ),
      h2: TextStyle(
        color: isUser ? Colors.white : Colors.black87,
        fontSize: 18,
        fontWeight: FontWeight.bold,

      ),
      h3: TextStyle(
        color: isUser ? Colors.white : Colors.black87,
        fontSize: 16,
        fontWeight: FontWeight.bold,
      ),
      // List styling
      listBullet: TextStyle(
        color: isUser ? Colors.white : Colors.black87,
        fontSize: 14,
      ),
      // Code block styling
      code: TextStyle(
        color: isUser ? Colors.white70 : Colors.black87,
        backgroundColor: isUser
            ? Colors.white.withOpacity(0.1)
            : Colors.black.withOpacity(0.05),
        fontSize: 13,
        fontFamily: 'monospace',
      ),
      codeblockDecoration: BoxDecoration(
        color: isUser
            ? Colors.white.withOpacity(0.1)
            : Colors.black.withOpacity(0.05),
        borderRadius: BorderRadius.circular(8),
      ),
      // Link styling
      a: TextStyle(
        color: isUser ? Colors.white : Colors.blue,
        decoration: TextDecoration.underline,
      ),
      // Emphasis styling
      em: TextStyle(
        color: isUser ? Colors.white : Colors.black87,
        fontStyle: FontStyle.italic,
      ),
      strong: TextStyle(
        color: isUser ? Colors.white : Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      // Blockquote styling
      blockquote: TextStyle(
        color: isUser ? Colors.white70 : Colors.black54,
        fontSize: 14,
        height: 1.4,
      ),
      img: TextStyle(
        color: isUser ? Colors.white70 : Colors.black54,
        fontSize: 14,
      ),
      blockquoteDecoration: BoxDecoration(
        border: Border(
          left: BorderSide(
            color: isUser ? Colors.white.withOpacity(0.3) : Colors.grey[400]!,
            width: 4,
          ),
        ),
      ),
      // Table styling
      tableHead: TextStyle(
        color: isUser ? Colors.white : Colors.black87,
        fontWeight: FontWeight.bold,
      ),
      tableBody: TextStyle(
        color: isUser ? Colors.white : Colors.black87,
      ),
      // Paragraph spacing
      blockSpacing: 8.0,
      listIndent: 20.0,
    );
  }
}

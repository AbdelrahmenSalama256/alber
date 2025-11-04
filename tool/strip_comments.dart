// Run: dart run tool/strip_comments.dart [--apply] [--root lib]
// Removes all comments except ones starting with //! (kept verbatim).
// Handles //, ///, /* */. Tries to respect strings (single/double/triple/raw).

import 'dart:io';

void main(List<String> args) async {
  final apply = args.contains('--apply');
  final rootArgIndex = args.indexOf('--root');
  final rootPath = rootArgIndex != -1 && rootArgIndex + 1 < args.length
      ? args[rootArgIndex + 1]
      : 'lib';

  final root = Directory(rootPath);
  if (!await root.exists()) {
    stderr.writeln('Root not found: $rootPath');
    exit(2);
  }

  int filesSeen = 0;
  int filesChanged = 0;

  await for (final entity
      in root.list(recursive: true, followLinks: false)) {
    if (entity is! File) continue;
    if (!entity.path.endsWith('.dart')) continue;
    final path = entity.path;
    final orig = await entity.readAsString();
    final stripped = stripComments(orig);
    filesSeen++;
    if (orig != stripped) {
      filesChanged++;
      stdout.writeln('${apply ? 'Updating' : 'Would update'}: $path');
      if (apply) {
        await entity.writeAsString(stripped);
      }
    }
  }

  stdout.writeln(
      'Processed $filesSeen Dart files. ${apply ? 'Updated' : 'Would update'} $filesChanged.');
}

String stripComments(String src) {
  final out = StringBuffer();
  final len = src.length;
  var i = 0;
  var inLine = false;
  var inBlock = false;
  var inSq = false; // '\''
  var inDq = false; // '"'
  var inTqSq = false; // "'''
  var inTqDq = false; // '"""'

  while (i < len) {
    final ch = src[i];
    final ch1 = i + 1 < len ? src[i + 1] : null;
    final ch2 = i + 2 < len ? src[i + 2] : null;

    // End of single-line comment
    if (inLine) {
      if (ch == '\n') {
        inLine = false;
        out.write(ch);
      }
      i++;
      continue;
    }

    // End of block comment
    if (inBlock) {
      if (ch == '*' && ch1 == '/') {
        inBlock = false;
        i += 2;
      } else {
        i++;
      }
      continue;
    }

    // Inside triple/single/double strings
    if (inTqSq) {
      if (ch == "'" && ch1 == "'" && ch2 == "'") {
        inTqSq = false;
        out.write("'''");
        i += 3;
      } else {
        out.write(ch);
        i++;
      }
      continue;
    }
    if (inTqDq) {
      if (ch == '"' && ch1 == '"' && ch2 == '"') {
        inTqDq = false;
        out.write('"""');
        i += 3;
      } else {
        out.write(ch);
        i++;
      }
      continue;
    }
    if (inSq) {
      out.write(ch);
      if (ch == '\\' && i + 1 < len) {
        out.write(src[i + 1]);
        i += 2;
        continue;
      }
      if (ch == "'") inSq = false;
      i++;
      continue;
    }
    if (inDq) {
      out.write(ch);
      if (ch == '\\' && i + 1 < len) {
        out.write(src[i + 1]);
        i += 2;
        continue;
      }
      if (ch == '"') inDq = false;
      i++;
      continue;
    }

    // Not in string/comment
    // Raw string prefix handling: r'...' or r"..."
    if (ch == 'r' && (ch1 == '"' || ch1 == "'")) {
      out.write(ch);
      // fall through to treat next as string opener in next loop
      i++;
      continue;
    }

    // Start of comments
    if (ch == '/' && ch1 == '/') {
      // Keep only //! comments
      if (ch2 == '!') {
        // preserve until EOL
        out.write('//!');
        i += 3;
        while (i < len && src[i] != '\n') {
          out.write(src[i]);
          i++;
        }
        if (i < len && src[i] == '\n') {
          out.write('\n');
        }
      } else {
        // skip until newline
        i += 2;
        while (i < len && src[i] != '\n') {
          i++;
        }
        if (i < len && src[i] == '\n') {
          out.write('\n');
        }
      }
      continue;
    }
    if (ch == '/' && ch1 == '*') {
      inBlock = true;
      i += 2;
      continue;
    }

    // Start of strings
    if (ch == "'" && ch1 == "'" && ch2 == "'") {
      inTqSq = true;
      out.write("'''");
      i += 3;
      continue;
    }
    if (ch == '"' && ch1 == '"' && ch2 == '"') {
      inTqDq = true;
      out.write('"""');
      i += 3;
      continue;
    }
    if (ch == "'") {
      inSq = true;
      out.write(ch);
      i++;
      continue;
    }
    if (ch == '"') {
      inDq = true;
      out.write(ch);
      i++;
      continue;
    }

    out.write(ch);
    i++;
  }

  // Compress excessive blank lines (max 2 consecutive)
  final lines = out.toString().split('\n');
  final buf = StringBuffer();
  var blank = 0;
  for (final line in lines) {
    final isBlank = line.trim().isEmpty;
    if (isBlank) {
      blank++;
      if (blank <= 2) buf.writeln();
    } else {
      blank = 0;
      buf.writeln(line);
    }
  }
  return buf.toString();
}


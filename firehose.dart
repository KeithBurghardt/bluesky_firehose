import 'dart:io';
import 'dart:math';
import 'dart:core';
import 'package:bluesky/bluesky.dart';

//import "package:path/path.dart" show dirname, join;
//import 'dart:io' show Platform;


Future<String> get _localPath async {
  // this is an alternative if you do not want to hard code the path
  //String dir = dirname(Platform.script.path);
  return '/Users/keith/Downloads/';//directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  //var rng = Random();
  String time_str = DateTime.now().millisecondsSinceEpoch.toString();
  //String rng_str = rng.nextInt(1000000000).toString();
  return File('$path/bluesky_firehose_'+time_str+'.txt');
}



Future<void> main() async {
  // Authentication is not required.
  final bluesky = Bluesky.anonymous();
  final file = await _localFile;
  final subscription = await bluesky.sync.subscribeRepoUpdates();
  // Get events in real time.
  try {
  await for (final event in subscription.data.stream) {
    try {
    event.when(
      // Occurs when account committed records, such as Post and Like in Bluesky.
      commit: (data) {
        // A single commit may contain multiple records.
        try{
        for (final op in data.ops) {
          switch (op.action) {
            case RepoAction.create:
            case RepoAction.update:
              // Created/Updated AT URI and specific record.
              String uri_str = op.uri.toString();
              String record_str = op.record.toString();
              file.writeAsString(uri_str+'\n', mode: FileMode.append);
              file.writeAsString(record_str+'\n', mode: FileMode.append);
              break;
            case RepoAction.delete:
              // Deleted AT URI.
              String uri_str = op.uri.toString();
              file.writeAsString(uri_str+'\n', mode: FileMode.append);
              break;
          }
        }
        } catch (e) {
            // No specified type, handles all
            print('Something really unknown: $e');
        }
      },

      // Occurs when account changed handle.
      handle: (data) {
        // Updated handle.
        String handle_str = data.handle.toString();
        String did_str = data.did.toString();
        file.writeAsString(handle_str+'\n', mode: FileMode.append);
        file.writeAsString(did_str+'\n', mode: FileMode.append);

      },

      migrate: print,
      tombstone: print,
      info: print,
      unknown: print,
    );
    } catch(e){
    }
  }
  } catch (e) {
  // No specified type, handles all
  }
}

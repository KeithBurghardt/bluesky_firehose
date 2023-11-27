import 'dart:io';
import 'dart:math';
import 'dart:core';
import 'package:bluesky/bluesky.dart';

Future<String> get _localPath async {
  return '/data/keith/firehose_code_updated/bluesky_data/';//directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  String time_str = DateTime.now().millisecondsSinceEpoch.toString();
  return File(path+'bluesky_firehose_'+time_str+'.txt');
}



Future<void> main() async {
  // Authentication is not required.
  final bluesky = Bluesky.anonymous();
  final file = await _localFile;
  final subscription = await bluesky.sync.subscribeRepoUpdates();
  // save 50 records at a time
  int max_len = 50;
  // Get events in real time.
  List stream_data = []; //blank initially

  // Get events in real time.
  await for (final event in subscription.data.stream) {
    event.when(
      // Occurs when account committed records, such as Post and Like in Bluesky.
      commit: (data) {
        // A single commit may contain multiple records.
        for (final op in data.ops) {
          switch (op.action) {
            case RepoAction.create:
            case RepoAction.update:
              // Created/Updated AT URI and specific record.
              String uri_str = op.uri.toString();
              String record_str = op.record.toString();
              if (!record_str.contains('type: app.bsky.feed.like')){
                  stream_data.add(uri_str);
                  stream_data.add(record_str);
              }
              break;
            case RepoAction.delete:
              // Deleted AT URI.
              String uri_str = op.uri.toString();
              //file.writeAsString(uri_str+'\n', mode: FileMode.append);
              stream_data.add(uri_str);
              break;
          }
        }
      },

      // Occurs when account changed handle.
      handle: (data) {
        // Updated handle.
        String handle_str = data.handle.toString();
        String did_str = data.did.toString();
        stream_data.add(handle_str);
        stream_data.add(did_str);
      },
      tombstone: (data) {
        // tombstone (deleted DID - deleted accounts).
        // record in the future
        print;
      },
      migrate: (data) {
        // migrated accounts
        print;
      },
      info: (data) {
        // info object (future?)
        print;
      },
      // other (ignore for now)
      unknown: print,
    );
    if (stream_data.length > max_len){
        String write_data = stream_data.join('\n');
        file.writeAsString(write_data+'\n', mode: FileMode.append);
    }
  }
}

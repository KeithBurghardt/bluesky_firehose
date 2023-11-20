import 'dart:io';
import 'dart:math';
import 'dart:core';
import 'package:bluesky/bluesky.dart';

Future<String> get _localPath async {
  return '/Users/keith/Downloads/';//directory.path;
}

Future<File> get _localFile async {
  final path = await _localPath;
  //var rng = Random();
  String time_str = DateTime.now().millisecondsSinceEpoch.toString();
  //String rng_str = rng.nextInt(1000000000).toString();
  return File(path+'bluesky_firehose_'+time_str+'.txt');
}



Future<void> main() async {
  // Authentication is not required.
  final bluesky = Bluesky.anonymous();
  final file = await _localFile;
  final subscription = await bluesky.sync.subscribeRepoUpdates();
  // save 100 records before writing
  int max_len = 50;
  // Get events in real time.
  List stream_data = []; //blank initially
  await for (final event in subscription.data.stream) {    
        String ev = event.toString();
        stream_data.add(ev);
        if (stream_data.length > max_len){
            String write_data = stream_data.join('\n');
            //var sink = file.openWrite();
            //for(int i = 0; i < stream_data.length; i++){
            file.writeAsString(write_data+'\n', mode: FileMode.append);
            //}
            //sink.close();
        }
  }
}

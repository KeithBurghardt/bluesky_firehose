Code to download data from Bluesky firehose
---
Bluesky has 2M users, so not small but not huge. It can't replace Facebook and Twitter data, but it may augment your other data collections, especially if users leave Twitter and move to Bluesky.
### Data Rate: ~0.5-1GB/min (added/removed posts, profile updates)
### Data Rate: 2GB/min+ (full data, including +likes, etc.)
---
## --> How to run <--
````
dart run firehose.dart
````
---
## Requirements
- Dart: [Here is how to install dart](https://dart.dev/get-dart). [Here is a tutorial for dart](https://dart.dev/tutorials/server/get-started).
Note: this appears to require root permission to install
- Bluesky Firehose API for Dart. [Here is how to download/install the bluesky Firehose API package](https://dev.to/shinyakato/easily-use-firehose-api-on-bluesky-social-with-dart-and-flutter-mdk)

### environment:
  sdk: '>=2.19.5 <3.0.0'

### dependencies:
- bluesky: ^0.10.1
- github: ^9.12.0
- http: ^1.1.0
- pub_api_client: ^2.4.0
- pubspec: ^2.3.0

### dev_dependencies:
- lints: ^2.0.1
- test: ^1.24.2
- melos: ^3.0.1

---
## Documentation
- [Dart documentation](https://dart.dev/guides)
- [Here is the AT protocol](https://atproto.com/specs/atp), which one will have to reference to decode what is being saved to these files.
**Important information**: you can collect firehose without needing an account (at least for now).
---
## Code
- firehose.dart: collect posts, account updates. Not likes (to save space). You will need to update hard-coded directory
- firehose_simple.dart: collect all data. You will need to update hard-coded directory
- pubspec.lock: keep this when running dart
- pubspec.yaml: keep this when running firehose.dart. It lists dependencies/requirements mentioned above
- run_firehose.bash: robustly run firehose.dart/firehose_simple.dart, in case you run into errors.
I found in earlier code that there is an error that, as far as I can tell, is in the API itself: "RangeError (index): Index out of range: no indices are valid: 0". This will kill the DART program, but that's not a huge issue (while true: dart run firehose.dart in Python or Bash would easily solve this) 

The second issue is that the API appears to hang at random. You won't get an error and the program will not quit. I therefore check every second to see if a file is being updated. If not, I kill the program, if it has not been killed, and restart

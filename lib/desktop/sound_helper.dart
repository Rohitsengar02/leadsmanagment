import 'sound_helper_stub.dart'
    if (dart.library.js) 'sound_helper_web.dart' as helper;

void playTukTukSound() {
  helper.playTukTuk();
}
